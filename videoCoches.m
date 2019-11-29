
iniciarProgramaIPT();
filasGrid=           3;
columnasGrid=        2;



ficheroVideo='traffic.mj2';
cochesEnVideo = VideoReader(ficheroVideo);

get(cochesEnVideo)

implay(ficheroVideo);

umbralCochesOscuros = 50;
frameCochesOscuros = rgb2gray(read(cochesEnVideo,70));
sinCochesOscuros = imextendedmax(frameCochesOscuros, umbralCochesOscuros);


figure;
mostrarImagen    (filasGrid,columnasGrid,1,  frameCochesOscuros      ,'ImagenOriginal');
mostrarHistograma(filasGrid,columnasGrid,2,  frameCochesOscuros      ,'Histograma');
mostrarImagen    (filasGrid,columnasGrid,3,  sinCochesOscuros      ,'ImagenOriginal');

buscadorObjetosPequenos = strel('disk',2);
sinObjetosPequenos = imopen(sinCochesOscuros, buscadorObjetosPequenos);
sinObjetosPequenos2 = bwareaopen(sinObjetosPequenos, 100);

mostrarImagen    (filasGrid,columnasGrid,4,  sinObjetosPequenos      ,'ImagenOriginal');
mostrarImagen    (filasGrid,columnasGrid,5,  sinObjetosPequenos2      ,'ImagenOriginal');

numeroDeFrames = cochesEnVideo.NumFrames;
unFrame = read(cochesEnVideo, 1);
videoConCochesLocalizados = zeros([size(unFrame,1) size(unFrame,2) 3 numeroDeFrames], class(unFrame));

for k = 1 : numeroDeFrames
    unFrameOriginal = read(cochesEnVideo, k);
    
    unFrame = rgb2gray(unFrameOriginal);
    sinCochesOscuros = imextendedmax(unFrame, umbralCochesOscuros); 
    sinObjetosPequenos = imopen(sinCochesOscuros, buscadorObjetosPequenos);

    sinObjetosPequenosBinarizada = bwareaopen(sinObjetosPequenos, 100);
   
   
    videoConCochesLocalizados(:,:,:,k) = unFrameOriginal;
   
    propiedades = regionprops(sinObjetosPequenosBinarizada, {'Centroid','Area'});
    if ~isempty([propiedades.Area])
        areaArray = [propiedades.Area];
        [~,elementoMayor] = max(areaArray);
        centroides = propiedades(elementoMayor).Centroid;
        centroide = fliplr(floor(centroides));
        ancho = 2;
        fila = centroide(1)-ancho:centroide(1)+ancho;
        columna = centroide(2)-ancho:centroide(2)+ancho;
        videoConCochesLocalizados(fila,columna,1,k) = 255;
        videoConCochesLocalizados(fila,columna,2,k) = 0;
        videoConCochesLocalizados(fila,columna,3,k) = 0;
    end
end


frameRate = cochesEnVideo.FrameRate;
implay(videoConCochesLocalizados,frameRate);

