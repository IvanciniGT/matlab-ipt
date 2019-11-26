
% ------------------------------------------------- -----------------------------------------------
% Aplicacion de umbrales adaptativos y dinamicos
% Util cuando tenemos una diferencia entre fondo y frente que no es
% homogenea o constante
% -------------------------------------------------------------------------------------------------

% echo on;

iniciarProgramaIPT();
filasGrid=3;
columnasGrid=4;

nombreFichero = 'rice.png';
imagenOriginal=cargarImagen(nombreFichero);

% Convierte la imagen a la imagen binaria, especificando el valor del umbral.
imagenBinarizadaNormal = imagenOriginal > 125 ;

% Se usa para determinar el umbral que se usará en la operación de binarización.adaptthresh
umbralAdaptativo = adaptthresh(imagenOriginal, 0.35);
% Convierte la imagen a la imagen binaria, especificando un umbral adaptativo.
imagenBinarizadaAdaptativa = imbinarize(imagenOriginal,umbralAdaptativo);

% Visualice la imagen original con las versiones binarizadas, en paralelo.
figure;
mostrarImagen(filasGrid,columnasGrid,1,imagenOriginal,'ImagenOriginal');
mostrarHistograma(filasGrid,columnasGrid,2,imagenOriginal,'Histograma');
mostrarImagen(filasGrid,columnasGrid,3,imagenBinarizadaNormal,'Binarizado simple');
mostrarImagen(filasGrid,columnasGrid,4,imagenBinarizadaAdaptativa,'Binarizado adaptativo');





nombreFichero = 'printedtext.png';
imagenOriginal=cargarImagen(nombreFichero);

% Convierte la imagen a la imagen binaria, especificando el valor del umbral.
imagenBinarizadaNormal = imagenOriginal > 125 ;

% Se usa para determinar el umbral que se usará en la operación de binarización.adaptthresh
                                                  % En este caso, lo que nos interesa es la parte oscura
                                                                              % Preramos una rejilla de gran tamaño
umbralAdaptativo = adaptthresh(imagenOriginal,0.4,'ForegroundPolarity','dark','NeighborhoodSize',81,'Statistic','mean'); 
% Convierte la imagen a la imagen binaria, especificando un umbral adaptativo.
imagenBinarizadaAdaptativa = imbinarize(imagenOriginal,umbralAdaptativo);

% Visualice la imagen original con las versiones binarizadas, en paralelo.
mostrarImagen(filasGrid,columnasGrid,5,imagenOriginal,'ImagenOriginal');
mostrarHistograma(filasGrid,columnasGrid,6,imagenOriginal,'Histograma');
% Le damos la vueltaa las imágenes para que contengan lo que nos interesa
mostrarImagen(filasGrid,columnasGrid,7,~imagenBinarizadaNormal,'Binarizado simple');
mostrarImagen(filasGrid,columnasGrid,8,~imagenBinarizadaAdaptativa,'Binarizado adaptativo');








nombreFichero = 'coins.png';
imagenOriginal=cargarImagen(nombreFichero);

% Convierte la imagen a la imagen binaria, especificando el valor del umbral.
imagenBinarizadaNormal = imagenOriginal > 100 ;

% Se usa para determinar un umbral fijo dinámicamente
[histograma,niveles] = imhist(imagenOriginal,256); 
umbralDinamico = otsuthresh(histograma);

% Convierte la imagen a la imagen binaria, especificando un umbral adaptativo.
imagenBinarizadaAdaptativa = imbinarize(imagenOriginal,umbralDinamico);

% Visualice la imagen original con las versiones binarizadas, en paralelo.
mostrarImagen(filasGrid,columnasGrid,9,imagenOriginal,'ImagenOriginal');
mostrarHistograma(filasGrid,columnasGrid,10,imagenOriginal,'Histograma');
mostrarImagen(filasGrid,columnasGrid,11,imagenBinarizadaNormal,'Binarizado simple');
mostrarImagen(filasGrid,columnasGrid,12,imagenBinarizadaAdaptativa,'Binarizado dinámico');

