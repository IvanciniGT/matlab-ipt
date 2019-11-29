% ------------------------------------------------- -----------------------------------------------
% Identificación de círculos
% -------------------------------------------------------------------------------------------------

% echo on;

iniciarProgramaIPT();
filasGrid=           4;
columnasGrid=        3;

nombreFichero = 'coloredChips.png';
imagenOriginal=cargarImagen(nombreFichero);
imagenOriginalGris=asegurarEscalaGrises(imagenOriginal);

% Visualice la imagen original con las versiones binarizadas, en paralelo.
figure;
mostrarImagen    (filasGrid,columnasGrid,1,  imagenOriginal      ,'ImagenOriginal');
mostrarHistograma(filasGrid,columnasGrid,2,  imagenOriginal      ,'Histograma');
mostrarImagen    (filasGrid,columnasGrid,3,  imagenOriginalGris      ,'ImagenOriginal');


[centros,radios] = imfindcircles(imagenOriginal,[20 25],'ObjectPolarity','dark');
mostrarImagen    (filasGrid,columnasGrid,4,  imagenOriginal      ,'ImagenOriginal');
circulosIdentificados=viscircles(centros,radios);

delete(circulosIdentificados)
[centros,radios] = imfindcircles(imagenOriginal,[20 25],'ObjectPolarity','dark', 'Sensitivity',0.9);
mostrarImagen    (filasGrid,columnasGrid,5,  imagenOriginal      ,'ImagenOriginal'); 
viscircles(centros,radios);


[centros,radios] = imfindcircles(imagenOriginal,[20 25],'ObjectPolarity','dark', 'Sensitivity',0.92); 
mostrarImagen    (filasGrid,columnasGrid,6,  imagenOriginal      ,'ImagenOriginal'); 
viscircles(centros,radios);


[centros,radios] = imfindcircles(imagenOriginal,[20 25],'ObjectPolarity','dark', 'Sensitivity',0.92,'Method','twostage');  
mostrarImagen    (filasGrid,columnasGrid,7,  imagenOriginal      ,'ImagenOriginal'); 
viscircles(centros,radios);


[centros,radios] = imfindcircles(imagenOriginal,[20 25],'ObjectPolarity','dark', 'Sensitivity',0.95);  
mostrarImagen    (filasGrid,columnasGrid,8,  imagenOriginal      ,'ImagenOriginal'); 
viscircles(centros,radios);


[centros2,radios2] = imfindcircles(imagenOriginal,[20 25],  'ObjectPolarity','bright','Sensitivity',0.92);
mostrarImagen    (filasGrid,columnasGrid,9,  imagenOriginal      ,'ImagenOriginal');   
viscircles(centros2, radios2,'Color','b');


[centros2,radios2,metricBright] = imfindcircles(imagenOriginal,[20 25],  'ObjectPolarity','bright','Sensitivity',0.92,'EdgeThreshold',0.1);  
mostrarImagen    (filasGrid,columnasGrid,10,  imagenOriginal      ,'ImagenOriginal'); 
viscircles(centros2, radios2,'Color','b');
viscircles(centros,radios);
