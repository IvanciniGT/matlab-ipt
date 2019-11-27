% ------------------------------------------------- -----------------------------------------------
% Idenfiticación de bordes y localización de objetos
% -------------------------------------------------------------------------------------------------

% echo on;

iniciarProgramaIPT();
filasGrid=4;
columnasGrid=4;

nombreFichero = 'cell.tif';
imagenOriginal=cargarImagen(nombreFichero);


% Visualice la imagen original.
figure;
mostrarImagen(filasGrid,columnasGrid,1,imagenOriginal,'ImagenOriginal');
mostrarHistograma(filasGrid,columnasGrid,2,imagenOriginal,'Histograma');

%Calculo de bordes, con threadshold automatico
bordes = edge(imagenOriginal,'sobel');
mostrarImagen(filasGrid,columnasGrid,3,labeloverlay(imagenOriginal,bordes),'Bordes Umbral AUTO');

%Calculo de bordes, afinamos threadshold
[~,umbral] = edge(imagenOriginal,'sobel');
bordes=edge(imagenOriginal,'sobel', umbral*0.5);
mostrarImagen(filasGrid,columnasGrid,4,labeloverlay(imagenOriginal,bordes),'Bordes Umbral AUTO');

%Engrosamos los bordes
engrosado = [strel('line',3,90) strel('line',3,0)];
bordesEngrosados = imdilate(bordes,engrosado); 
mostrarImagen(filasGrid,columnasGrid,8,labeloverlay(imagenOriginal,bordesEngrosados),'Bordes Engrosados');

% Rellenamos huecos
sinHuecos = imfill(bordesEngrosados,'holes'); 
mostrarImagen(filasGrid,columnasGrid,7,labeloverlay(imagenOriginal,sinHuecos),'Bordes Engrosados');

%Eliminamos los pegados al borde
sinTocarBordes = imclearborder(sinHuecos,4);
mostrarImagen(filasGrid,columnasGrid,6,labeloverlay(imagenOriginal,sinTocarBordes),'Centrados');

% Suavizamos
suavizadorDeBordes = strel('diamond',1); 
final = imerode(sinTocarBordes,suavizadorDeBordes); 
final = imerode(final,suavizadorDeBordes); 
mostrarImagen(filasGrid,columnasGrid,5,labeloverlay(imagenOriginal,final),'Suavizado');


% Pintamos contorno
contorno = bwperim(final); 
mostrarImagen(filasGrid,columnasGrid,9,contorno,'Contorno');

% Pintamos contorno
imagenContorneada=imagenOriginal;
imagenContorneada(contorno)=255;
mostrarImagen(filasGrid,columnasGrid,10,imagenContorneada,'Celula contorneada');
mostrarImagen(filasGrid,columnasGrid,11,imagenContorneada,'Medida mínimas');
mostrarImagen(filasGrid,columnasGrid,12,imagenContorneada,'Medidas máximas');

%Calculamos dimensiones
propiedades=regionprops(final,imagenOriginal,'All');

soloLasCelulas=imagenOriginal;
soloLasCelulas(~final)=0;

%Vemos si las guardamos
mensaje = sprintf('Quieres guardar las celulas ?');
respuesta = questdlg(mensaje, 'Guardar celulas?', 'Si', 'No', 'No');
guardar=false;

if strcmpi(respuesta, 'Si')
	% Ask user for a filename.
	filtrosParaFicheros = {'*.PNG', 'PNG Images (*.png)'; '*.tif', 'TIFF images (*.tif)'; '*.*', 'All Files (*.*)'};
	tituloVentanaGuardar = 'Fichero';
	esteFichero = mfilename('fullpath');
	[carpetaActual, nombreFichero, extension] = fileparts(esteFichero);
	nombrePorDefecto = sprintf('%s/%s.tif', carpetaActual, nombreFichero);
	[nombreImagen, carpetaImagen] = uiputfile(filtrosParaFicheros, tituloVentanaGuardar, nombrePorDefecto);
	if nombreImagen ~= 0
		[carpeta, nombreFichero, extension] = fileparts(nombreImagen);
    end
    guardar=true;
end




fprintf(1,'Célula        Área         Diámetro mínimo       Diámetro máximo\n');
for i=1 : length(propiedades)
    area=propiedades(i).Area;
    min=propiedades(i).MinFeretDiameter;
    max=propiedades(i).MaxFeretDiameter;
    fprintf(1,'%d: %17.1f %21.1f %21.1f\n',i,area,min,max);
    
    subplot(filasGrid,columnasGrid,11);
    xmin = [propiedades(i).MinFeretCoordinates(1,1) propiedades(i).MinFeretCoordinates(2,1)];     
    ymin = [propiedades(i).MinFeretCoordinates(1,2) propiedades(i).MinFeretCoordinates(2,2)];     
    imdistline(gca,xmin,ymin); 

    subplot(filasGrid,columnasGrid,12);
    xmax = [propiedades(i).MaxFeretCoordinates(1,1) propiedades(i).MaxFeretCoordinates(2,1)];     
    ymax = [propiedades(i).MaxFeretCoordinates(1,2) propiedades(i).MaxFeretCoordinates(2,2)];     
    imdistline(gca,xmax,ymax); 
    
    if i<5
        
		% Extraemnos la celula
        ubicacion = propiedades(i).BoundingBox; 
        borde=20;
        ubicacion=[ ubicacion(1)-borde ubicacion(2)-borde ubicacion(3)+borde*2 ubicacion(4)+borde*2 ];
		celula = imcrop(soloLasCelulas, ubicacion);
        imagenRotada=imrotate(celula,propiedades(i).MaxFeretAngle,'crop');

        mostrarImagen(filasGrid,columnasGrid,12+i,imagenRotada,sprintf('Celula %d',i));
        if guardar
            ficheroImagenCompleto = fullfile(carpetaImagen, [nombreFichero sprintf('%d.tif',i)]);
            imwrite(uint8(imagenRotada), ficheroImagenCompleto);
        end
    end
end




