
% ------------------------------------------------- -----------------------------------------------
% Aplicacion de umbrales multiples e identificacion de objetos
% -------------------------------------------------------------------------------------------------

% echo on;

iniciarProgramaIPT();
filasGrid=4;
columnasGrid=4;

%nombreFichero = 'hotcoffee.tif';
nombreFichero = 'cafes.tif';
imagenOriginal=cargarImagen(nombreFichero);
imagenOriginalBorrosa = imgaussfilt(imagenOriginal, 2,'FilterSize',5,'FilterDomain', 'spatial');

% Umbrales que se usará en la operación de quantizado
umbrales = [15 140];
% Convierte la imagen a la imagen quantizada, especificando unos umbrales específicos.
imagenQuantizada = grayslice(imagenOriginalBorrosa,umbrales);
%Quitamos huecos 


%Colorea la imagen para verla mejor
imagenColoreada=label2rgb(imagenQuantizada);

% Visualice la imagen original con las versiones binarizadas, en paralelo.
figure;

mostrarImagen(filasGrid,columnasGrid,1,imagenOriginal,'ImagenOriginal');
colormap(gca,hot) 
mostrarHistograma(filasGrid,columnasGrid,2,uint8(imagenOriginal),'Histograma');
mostrarImagen(filasGrid,columnasGrid,3,imagenQuantizada,'Quantizada');
mostrarImagen(filasGrid,columnasGrid,4,imagenColoreada,'Quantizada Coloreada');


%Buscamos objetos en las capas intermedias
capas=[1 2];

for indiceCapa=min(capas(:)) : max(capas(:))

    capaActual=imagenQuantizada == indiceCapa;

    mostrarImagen(filasGrid,columnasGrid,4*(indiceCapa)+1,capaActual,sprintf('Area Capa %d',indiceCapa));
    
    imagenOriginalCapaActual=double(imagenOriginal).*capaActual;
    mostrarImagen(filasGrid,columnasGrid,4*(indiceCapa)+2,imagenOriginalCapaActual,sprintf('Area Original Capa %d',indiceCapa));

    objetosIdentificados=bwlabel(capaActual,8);
    objetosIdentificadosColoreados=label2rgb(objetosIdentificados);
    mostrarImagen(filasGrid,columnasGrid,4*(indiceCapa)+3,objetosIdentificadosColoreados,sprintf('Objetos Capa %d',indiceCapa));

    
    propiedades = regionprops(objetosIdentificados,imagenOriginal,{'Area','BoundingBox','MeanIntensity','Centroid'}); 

    for n = 1:numel(propiedades)    
       
        subplot(filasGrid,columnasGrid,4*(indiceCapa)+3);
        % Calculamos su temperatura
        temperatura = [num2str(propiedades(n).MeanIntensity,3) ' \circ C'];     
        % Pintamos un rectangulo alrededor del objeto
        rectangle('Position',propiedades(n).BoundingBox,'EdgeColor','b')    
        % Ponemos su temperatura
        text(propiedades(n).Centroid(1),propiedades(n).Centroid(2),temperatura,'Color','b','FontSize',12)  

        % También en la imagen original
        subplot(filasGrid,columnasGrid,1);
        rectangle('Position',propiedades(n).BoundingBox,'EdgeColor','c')    
        text(propiedades(n).Centroid(1),propiedades(n).Centroid(2),temperatura,'Color','w','FontSize',12)  

    end




end



