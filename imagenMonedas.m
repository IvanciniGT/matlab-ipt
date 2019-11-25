

% ------------------------------------------------- -----------------------------------------------
% Detección, medición y filtrado simples de objetos.
% Requiere el toolbox IPT: Image Processing Toolbox 
% Utiliza la imagen de demostración "coins" suministrada con el toolbox IPT.
% Para sber si está instalado el toolbox IPT, basta con ejecutar ver en la linea de comandos.
% Para ejecutar el códdigo, simplemente hay que pulsar en el triángulo
% verde de RUN.
% -------------------------------------------------------------------------------------------------

% echo on;

tic; % Start timer.
clc; % Borrar la pantalla.
clearvars; % Eliminar los valores de las variables de la ejecución anterior.
fprintf('Ejecutando demo de procesamiento de imagenes 1...\n'); % Mostrar un mensaje en la consola.
workspace; % Asegurarse que se muestra el panel de Workspace , donde aparecen todas las variables.
imtool close all;  % Cierra todas la imagenes abiertas en el imtool del toolbox IPT.
format long g; % Mostrar los numeros con máximo número de decimales y sin utilizar notación científica
format compact; % No muestra espacios en blanco entre la salida de sentencias en la pantalla de comandos
tamanoTitulo = 14;

% Comprobar que está instalado el toolbox IPT.
hasIPT = license('test', 'image_toolbox');
if ~hasIPT
	% El toolbox IPT no está instalado.
	mensaje = sprintf('El toolbox Image Processing Toolbox no está instalado. Desea continuar de todos modos?');
	respuesta = questdlg(mensaje, 'Image Processing Toolbox no instalado', 'Si', 'No', 'Si');
	if strcmpi(respuesta, 'No')
		% Abortamos la ejecución.
		return;
	end
end

% Leer el fichero de ejemplo 'coins.png' (Contiene monedas de 5 y 10 centavos)
nombreFichero = 'coins.png';
carpeta = fileparts(which(nombreFichero)); % Busca el fichero y se queda con la carpeta
fichero = fullfile(carpeta, nombreFichero); % Creamos la ruta completa del fichero
if ~exist(fichero, 'file')
	% No hemos encontrado el fichero en la carpeta actual.
	% Buscamos en el path.
	if ~exist(nombreFichero, 'file')
		% Tampoco existe en el path.
		% Avisamos que no ha sido posible localizar la imagen.
		mensajeDeAviso = sprintf('Error: El fichero con la imagen\n%s\nno se ha encontrado.\Pulsa para salir del programa.', fichero);
		uiwait(warndlg(mensajeDeAviso));
		fprintf(1, 'Saliendo del programa.\n'); 
		return;
	end
	% Se ha encontrado en el path.
	fichero = nombreFichero; % Nota: No hace falta ponerle la carpeta.
end

% Tenemos la imagen.
imagenOriginal = imread(fichero);
% Comprobamos que la imagen está en escala de grises.
[alto, ancho, numeroDeCanalesDeColor] = size(imagenOriginal);
if numeroDeCanalesDeColor > 1
	promptMessage = sprintf('La imagen tiene %d canales de color.\nEste programa está preparado solamente para imagenes en tonos de grisess.\nQuieres convertir la imagen a escala de grises?', numeroDeCanalesDeColor);
	boton = questdlg(promptMessage, 'Continuar', 'Convertir y continuar', 'Cancelar', 'Convertir y continuar');
	if strcmp(boton, 'Cancelar')
		fprintf(1, 'Saliendo del programa.\n');
		return;
	end
	% Convertir la imagen a escala de grises
	imagenOriginal = rgb2gray(imagenOriginal);
end

% Mostrar la imagen en escala de grises.
subplot(3, 3, 1); % Preparamos una rejilla de 3x3 para mostrar imagenes, y seleccionamos la primera posición, como posición de trabajo actual
imshow(imagenOriginal); % Mostramos nuestra imagen
% Mostrar la imagen a tamaño real.
% gfc : Apuntador a la imagen actual
% Units: [ inches | centimeters | normalized | points | {pixels} | characters ]
set(gcf, 'units','normalized','outerposition',[0 0 1 1]);
% Forzar que se mueestre la imagen ahora mismo. De lo contrario no se
% mostraría hasta que haya un breakpoint o se acabe el programa
drawnow;
titulo = sprintf('Imagen original\n6 monedas de 5 y 4 de 10.');
title(titulo, 'FontSize', tamanoTitulo);
axis image; %Asegurarse que la imagen no se vea distorsionada por el ratio de aspecto de la pantalla.

% Mostramos el histograma.
[numeroDePixels, nivelesDeGris] = imhist(imagenOriginal);
subplot(3, 3, 2);
bar(numeroDePixels);
title('Histograma', 'FontSize', tamanoTitulo);
xlim([0 nivelesDeGris(end)]); % Establecemos los límites del eje X.
grid on;

% Aplicamos un umbral a la imagen para quedarnos con una imagen en 2 colores (binaria: solo 0 y 1)
% Método  #1: utilizando im2bw()
umbralNormalizado = 0.4; % In range 0 to 1.
umbral = umbralNormalizado * max(max(imagenOriginal)); % Nivel de gris que sirve de corte.
imagenBinarizada = im2bw(imagenOriginal, umbralNormalizado);       % One way to threshold to binary

% Method #2: Usando un operador lógico sobre la matriz de nuestra imagen.
umbral = 100;
% Vamos a coger los objetos más brillantes. Por eso usamos el operador >.
imagenBinarizada = imagenOriginal > umbral; 
% Si quisieramos los objetos menos brillantes usariamos el operador <.
% imagenBinarizada = imagenOriginal < umbral; 

% Realizamos in "hole fill" para eliminar cualquier pixel del fondo en forma de huecos que quedasen dentro de nuestros objetos
imagenBinarizada = imfill(imagenBinarizada, 'holes');

% Mostramos el umbral como una linea en el histograma.
hold on;
valorMaximoDelEjeY = ylim;
line([umbral, umbral], valorMaximoDelEjeY, 'Color', 'r');
% Mostramos un texto en el gráfico donde se situa el humbral.
textoDelUmbral = sprintf('Umbral: %d', umbral);
% Para la función text(), las coordenadas x e y deben ser de tipo "double". HAcemos una conversión de tipos
text(double(umbral + 5), double(0.5 * valorMaximoDelEjeY(2)), textoDelUmbral, 'FontSize', 10, 'Color', [0 .5 0]);
text(double(umbral - 70), double(0.94 * valorMaximoDelEjeY(2)), 'Fondo', 'FontSize', 10, 'Color', [0 0 .5]);
text(double(umbral + 50), double(0.94 * valorMaximoDelEjeY(2)), 'Primer plano', 'FontSize', 10, 'Color', [0 0 .5]);

% Mostramos la imagen binarizada.
subplot(3, 3, 3);
imshow(imagenBinarizada); 
titulo=sprintf('Imagen binarizada\nAplicando el umbral: %d', umbral);
title(titulo, 'FontSize', tamanoTitulo); 

% Identificamos los objetos individuales viendo que píxeles están conectados entre sí.
% Cada grupo de píxeles conectados recibirá un número, para identificarlo y distinguirlo de los demás.
% Realizamos el etiquetado de los componentes conectados con bwlabel ().
imagenEtiquetada = bwlabel(imagenBinarizada, 8);
% La imagen etiquetada es un una imagen con valores enteros, donde los pixel en los objetos tienen valores: 1, 2, 3...
subplot(3, 3, 4);
imshow(imagenEtiquetada, []);  % Mostramos la imagen .
title('Imagen etiquetada', 'FontSize', tamanoTitulo);

% Vamos a asignar a cada objeto un color diferente. 
imagenEtiquetadaEnColores = label2rgb (imagenEtiquetada, 'hsv', 'k', 'shuffle'); % generar colores aleatorios
% coloredLabels is an RGB image.  We could have applied a colormap instead (but only with R2014b and later)
subplot(3, 3, 5);
imshow(imagenEtiquetadaEnColores);
axis image; 
titulo = sprintf('Objetos coloreados\nNumerados de arriba a abajo\nLuego de izquierda a derecha.');
title(titulo, 'FontSize', tamanoTitulo);

% Obtener las propiedades de cada objeto.  Desde la versión R2008a podríamos pasar el objeto imagenBinarizada.

          
medicionesEnLosObjetos = regionprops(imagenEtiquetada, imagenOriginal, 'all');
numeroDeObjetos = size(medicionesEnLosObjetos, 1);

% bwboundaries() Devuelve un array de celdas, Donde cada celda contiene las coordenadas de los limites de cada objeto.
% Mostramos los límites de los objetos sobre la imagen original

subplot(3, 3, 6);
imshow(imagenOriginal);
title('Contornos', 'FontSize', tamanoTitulo); 
axis image; 
hold on;
pixelesDeLaMoneda = bwboundaries(imagenBinarizada);
numeroDeLimites = size(pixelesDeLaMoneda, 1);

for k = 1 : numeroDeLimites
	limite = pixelesDeLaMoneda{k};
	plot(limite(:,2), limite(:,1), 'g', 'LineWidth', 2);
end
hold off;

fuenteEtiquetas = 14;	
compensacionEjeXEtiquetas = -7;	% Para alinear el texto de las etiquetas en el centro de su objeto.
diametrosEquivalentes = zeros(1, numeroDeObjetos);
% Mostramos una tabla con las mediciones de cada objeto.
fprintf(1,'Objeto #      Intensidad media      Area      Perimetro       Centroide       Diametro\n');
% Iteramos sobre cada objeto.
for k = 1 : numeroDeObjetos           
	% Buscamos la media de cada objeto.
    pixelesEnElObjeto = medicionesEnLosObjetos(k).PixelIdxList;  % Sacamos los pixeles del objeto.
	media = mean(imagenOriginal(pixelesEnElObjeto)); % Buscamos la media en la imagen original
	mediaDesdeR2008 = medicionesEnLosObjetos(k).MeanIntensity; % La media para versiones posteriores a la R2008a
	
	area = medicionesEnLosObjetos(k).Area;		
	perimetro = medicionesEnLosObjetos(k).Perimeter;
	centroide = medicionesEnLosObjetos(k).Centroid;	
	diametrosEquivalentes(k) = sqrt(4 * area / pi);					% Calcular el ECD - Equivalent Circular Diameter.
   	% Mostramos el objeto en la tabla.
	fprintf(1,'#%2d %15.1f %22.1f %8.1f %12.1f %8.1f % 8.1f\n', k, media, area, perimetro, centroide, diametrosEquivalentes(k));
    % Mostramos el número del objeto en la imagen
    compensacionActual=compensacionEjeXEtiquetas;
    if k>9
        compensacionActual=compensacionEjeXEtiquetas*3;
    end
	text(centroide(1) + compensacionActual, centroide(2), num2str(k), 'FontSize', fuenteEtiquetas, 'FontWeight', 'Bold');
end

% Obtenemos los centroides por otro procedimiento.
% Todos los centroides van en 2 arrays, uno para las x y otro para las y.
centroides = [medicionesEnLosObjetos.Centroid];
centroides_x = centroides(1:2:end-1);
centroides_y = centroides(2:2:end);
% Ponemos los textos en la imagen coloreada.
subplot(3, 3, 5);
for k = 1 : numeroDeObjetos           % Iteramos sobre cada objeto
    compensacionActual=compensacionEjeXEtiquetas;
    if k>9
        compensacionActual=compensacionEjeXEtiquetas*3;
    end
	text(centroides_x(k) + compensacionActual, centroides_y(k), num2str(k), 'FontSize', fuenteEtiquetas, 'FontWeight', 'Bold');
end

% Ahora vamos a sacar algunos objetos.
% Cojamos solamente los que tienen una intensidad media entre 150 y 220 y
% un area menor de 2000 pixeles
% Nos quedarán 3 monedas de 10 centavos.
intensidades = [medicionesEnLosObjetos.MeanIntensity];
areas = [medicionesEnLosObjetos.Area];
% Filtramos
objetosConIntensidadValida = (intensidades > 150) & (intensidades < 220);
objetosConAreaValida = areas < 2000; % Take the small objects.
objetosValidos = find(objetosConIntensidadValida & objetosConAreaValida);
% Nos quedamos solamente con los pixeles que pertenexcan a uno de estos
% objetos
objetosSeleccionados = ismember(imagenEtiquetada, objetosValidos);
% Los etiquetamos d enuevo.
objetosSeleccionadosEtiquetados = bwlabel(objetosSeleccionados, 8);     
% Now we're done.  We have a labeled image of blobs that meet our specified criteria.
subplot(3, 3, 7);
imshow(objetosSeleccionadosEtiquetados, []);
axis image;
title(sprintf('Objetos seleccionados\npor area e intensidad'), 'FontSize', tamanoTitulo);

% Dibujamos los centroides en la imagen inicial.
% Las monedas de diez tendrán el signo más en rojo. Las de 5, una X en azul.
mensaje = sprintf('Vamos a pintar los centroides en la imagen original.\nMira la imagen de la izquierda en la primera fila.');
respuesta = questdlg(mensaje, 'Imprimir centroides?', 'Si', 'No', 'Si');
if strcmpi(respuesta, 'No')
	return;
end
subplot(3, 3, 1);
hold on; % No borres la imagen
for k = 1 : numeroDeObjetos           % Iteramos por los objetos identificados
	% Miramos si el objeto es una moneda de 10 o de 5.
	esDe10 = areas(k) < 2200; % Las de 10 son las pequeñas.
	if esDe10
		% Signo + en rojo
		plot(centroides_x(k), centroides_y(k), 'r+', 'MarkerSize', 10, 'LineWidth', 2);
	else
		% X en azul.
		plot(centroides_x(k), centroides_y(k), 'bx', 'MarkerSize', 10, 'LineWidth', 2);
	end
end


% Vamos a coger los 3 objetos seleccionados y a usarlos como mascara sobre la imagen original.
% Pintaremos solamente las tres monedas seleccionadas.
soloLas3MonedasSeleccionadas = imagenOriginal; % Hacemos una copia.
soloLas3MonedasSeleccionadas(~objetosSeleccionados) = 0;  % Todos los objetos no seleccionados los dejamos a 0.
subplot(3, 3, 8);
imshow(soloLas3MonedasSeleccionadas);
axis image;
title(sprintf('Solo las 3 monedas de 10\nmás brillantes'), 'FontSize', tamanoTitulo);

% Ahora sacamos las monedas grandes (las de 5)
objetosValidos = find(areas > 2000);  % Sacamos las monedas grandes.
monedasDe5 = ismember(imagenEtiquetada, objetosValidos);
monedasDe5Mascaradas = imagenOriginal; % Simply a copy at first.
monedasDe5Mascaradas(~monedasDe5) = 0;  % Set all non-nickel pixels to zero.
subplot(3, 3, 9);
imshow(monedasDe5Mascaradas, []);
axis image;
title('Solo las monedas de 5', 'FontSize', tamanoTitulo);

tiempoEmpleado = toc;
% Hemos acabado. Scamos los tiempos y pedimos si se desean guardar las imágenes.
mensaje = sprintf('Hemos acabado.\n\nTiempo empleado = %.2f segundos.', tiempoEmpleado);
mensaje = sprintf('%s\n\nMira las imágenes en la ventana de imágenes.\nMira los resultados en la ventana de comandos.', mensaje);
mensaje = sprintf('%s\n\nQuieres guardar la imagen con los objetos coloreados?', mensaje);
respuesta = questdlg(mensaje, 'Guardar imagen?', 'Si', 'No', 'No');
if strcmpi(respuesta, 'Si')
	% Ask user for a filename.
	filtrosParaFicheros = {'*.PNG', 'PNG Images (*.png)'; '*.tif', 'TIFF images (*.tif)'; '*.*', 'All Files (*.*)'};
	tituloVentanaGuardar = 'Save image file name';
	esteFichero = mfilename('fullpath');
	[carpetaActual, nombreFichero, extension] = fileparts(esteFichero);
	nombrePorDefecto = sprintf('%s/%s.tif', carpetaActual, nombreFichero);
	[nombreImagen, carpetaImagen] = uiputfile(filtrosParaFicheros, tituloVentanaGuardar, nombrePorDefecto);
	if nombreImagen ~= 0
		[carpeta, nombreFichero, extension] = fileparts(nombreImagen);
		ficheroImagenCompleto = fullfile(carpetaImagen, [nombreFichero '.tif']);
		imwrite(uint8(imagenEtiquetadaEnColores), ficheroImagenCompleto);
		% Recargamos la imagen guardada.
		imagenTifLeida = imread(ficheroImagenCompleto);
		imtool(imagenTifLeida, []);
	end
end

mensaje = sprintf('Deseas sacar cada moneda a una imagen?');
respuesta = questdlg(mensaje, 'Extraer monedas?', 'Si', 'No', 'Si');
if strcmpi(respuesta, 'Si')
	figure;	% Creamos una ventana nueva.
	% La maximizamos.
	set(gcf, 'Units','Normalized','OuterPosition',[0 0 1 1]);
	for k = 1 : numeroDeObjetos           % Para cada moneda.
		% Obtenemos los pixeles de la moneda.
		pixelesDeLaMoneda = medicionesEnLosObjetos(k).BoundingBox; 
		% Extraemnos la moneda.
		moneda = imcrop(imagenOriginal, pixelesDeLaMoneda);
		% Miramos si es de 10 (pequeña) o de 5 (grande).
		if medicionesEnLosObjetos(k).Area > 2200
			tipoMoneda = 'de 5';
		else
			tipoMoneda = 'de 10';
		end
		% Mostramos la imagen con su título.
		subplot(3, 4, k);
		imshow(moneda);
		titulo = sprintf('Moneda #%d: Es %s.\nDiametro = %.1f pixels\nArea = %d pixels', ...
			k, tipoMoneda, diametrosEquivalentes(k), medicionesEnLosObjetos(k).Area);
		title(titulo, 'FontSize', fuenteEtiquetas);
	end

end
