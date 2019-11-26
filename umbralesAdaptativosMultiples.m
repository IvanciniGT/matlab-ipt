
% ------------------------------------------------- -----------------------------------------------
% Aplicacion de umbrales multiples
% Util cuando tenemos una diferencia entre fondo y frente que no es homogenea
% -------------------------------------------------------------------------------------------------

% echo on;

iniciarProgramaIPT();
filasGrid=           2;
columnasGrid=        4;

nombreFichero = 'circlesBrightDark.png';
imagenOriginal=cargarImagen(nombreFichero);


% Se usa para determinar el umbral que se usará en la operación de binarización.adaptthresh
umbrales = multithresh(imagenOriginal,2);
% Convierte la imagen a la imagen binaria, especificando un umbral adaptativo.
imagenQuantizada = imquantize(imagenOriginal,umbrales);

% Cambiamos las etiquetas por colores para verlo mejor
imagenColoreada = label2rgb(imagenQuantizada);    

% Visualice la imagen original con las versiones binarizadas, en paralelo.
figure;
mostrarImagen    (filasGrid,columnasGrid,1,  imagenOriginal      ,'ImagenOriginal');
mostrarHistograma(filasGrid,columnasGrid,2,  imagenOriginal      ,'Histograma');
mostrarImagen    (filasGrid,columnasGrid,3,  imagenQuantizada    ,'Quantizado 2 umbrales');
mostrarImagen    (filasGrid,columnasGrid,4,  imagenColoreada     ,'Zonas coloreadas');











nombreFichero = 'coins.png';
imagenOriginal=cargarImagen(nombreFichero);


% Se usa para determinar el umbral que se usará en la operación de binarización.adaptthresh
umbrales = [45 65 84 108 134 157 174 189 206 228];
% Convierte la imagen a la imagen binaria, especificando un umbral adaptativo.
imagenQuantizada = grayslice(imagenOriginal,umbrales);

% Cambiamos las etiquetas por colores para verlo mejor
maximo = double(max(imagenQuantizada(:)));  

% Visualice la imagen original con las versiones binarizadas, en paralelo.
mostrarImagen    (filasGrid,columnasGrid,5,  imagenOriginal      ,'ImagenOriginal');
mostrarHistograma(filasGrid,columnasGrid,6,  imagenOriginal      ,'Histograma');
mostrarImagen    (filasGrid,columnasGrid,7,  imagenQuantizada    ,'Quantizado 2 umbrales');
mostrarImagen    (filasGrid,columnasGrid,8,  imagenQuantizada     ,'Zonas coloreadas');
colormap(gca,jet(maximo))






