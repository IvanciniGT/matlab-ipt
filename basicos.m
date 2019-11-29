clearvars;
[X,map] = imread('corn.tif');

if ~isempty(map)
    Im = ind2rgb(X,map);
end

whos Im

%gray2ind	Convierta la imagen en escala de grises o binaria en imagen indexada
%ind2gray	Convierta la imagen indexada a imagen en escala de grises
%rgb2gray	Convertir imagen RGB o colores a escala de grises
%rgb2ind	Convert RGB image to indexed image
%ind2rgb	Convert indexed image to RGB image
%label2rgb	Convierta la matriz de etiquetas en una imagen RGB
%imsplit	Divida la imagen multicanal en sus canales individuales

%imbinarize	Binarize imagen en escala de grises en 2-D o volumen 3-D por umbral
%adaptthresh	Umbral de imagen adaptable mediante estadísticas locales de primer orden
%otsuthresh	Umbral de histograma global utilizando el método de Otsu
%graythresh	Umbral de imagen global utilizando el método de Otsu

I = imread('rice.png');
%Se usa para determinar el umbral que se usará en la operación de binarización.adaptthresh
T = adaptthresh(I, 0.35);
%Convierta la imagen a la imagen binaria, especificando el valor del umbral.
BW = imbinarize(I,T);
%Visualice la imagen original con la versión binaria, en paralelo.
figure 
imshowpair(I, BW, 'montage')



I = imread('printedtext.png');
figure 
imshow(I);
T = adaptthresh(I,0.4,'ForegroundPolarity','dark','NeighborhoodSize',41,'Statistic','mean'); 
figure 
imshow(T);
BW = imbinarize(I,T); 
figure 
imshow(BW)




I = imread('coins.png');
%Calcule un histograma de 16 bin para la imagen.

[counts,x] = imhist(I,16); 
stem(x,counts)

T = otsuthresh(counts);
%Cree una imagen binaria utilizando el umbral calculado y visualice la imagen.

BW = imbinarize(I,T); 
figure 
imshow(BW)


I = imread('coins.png');
figure 
imshow(I);
T = adaptthresh(I,0.7,'ForegroundPolarity','dark','NeighborhoodSize',401,'Statistic','mean'); 
figure 
imshow(T);
BW = imbinarize(I,T); 
figure 
imshow(BW)


I = imread('circlesBrightDark.png'); 
imshow(I) 
axis off 
title('Original Image')
%Calcule dos niveles de umbral.

thresh = multithresh(I,2);
%Segmenta la imagen en tres niveles usando.imquantize

seg_I = imquantize(I,thresh);
%Convierta la imagen segmentada en imagen en color usando y mostrarla.label2rgb

RGB = label2rgb(seg_I);    
figure; 
imshow(RGB) 
axis off 
title('RGB Segmented Image')



I = imread('coins.png'); imshow(I)


%Especifique los valores de umbral para la triada multinivel.

thresholds = [45 65 84 108 134 157 174 189 206 228];
%Convierta la imagen de escala de grises de entrada en una imagen indexada.

X = grayslice(I,thresholds);
%Visualice la imagen indexada. Establezca el mapa de colores de la imagen indexada.jet La longitud de color Map, es el valor de intensidad máxima en la imagen indexada.m

m = double(max(X(:)));  
figure 
imshow(X,colormap(jet(m)))



%im2double	Convert image to double precision
%im2int16	Convierta la imagen en enteros con signo de 16 bits
%im2single	Convierta la imagen a una precisión única
%im2uint16	Convierta la imagen en enteros de 16 bits sin signo
%im2uint8	Convierta la imagen en enteros de 8 bits sin signo



rgb = imread('coloredChips.png');
imshow(rgb)

gray_image = rgb2gray(rgb); 
imshow(gray_image)


[centers,radii] = imfindcircles(rgb,[20 25],'ObjectPolarity','dark');


imshow(rgb)
h=viscircles(centers,radii);
delete(h)
[centers,radii] = imfindcircles(rgb,[20 25],'ObjectPolarity','dark', ...  
    'Sensitivity',0.9);


imshow(rgb)
h = viscircles(centers,radii);


[centers,radii] = imfindcircles(rgb,[20 25],'ObjectPolarity','dark', ...  
    'Sensitivity',0.92); 
length(centers)


delete(h)  % Delete previously drawn circles 
h = viscircles(centers,radii);


[centers,radii] = imfindcircles(rgb,[20 25],'ObjectPolarity','dark', ...        
    'Sensitivity',0.92,'Method','twostage');  
    delete(h) 
h = viscircles(centers,radii);


[centers,radii] = imfindcircles(rgb,[20 25],'ObjectPolarity','dark', ...      
    'Sensitivity',0.95);  
delete(h) 
viscircles(centers,radii);

imshow(gray_image)


[centersBright,radiiBright] = imfindcircles(rgb,[20 25], ...  
    'ObjectPolarity','bright','Sensitivity',0.92);


imshow(rgb)  
hBright = viscircles(centersBright, radiiBright,'Color','b');


[centersBright,radiiBright,metricBright] = imfindcircles(rgb,[20 25], ...  
    'ObjectPolarity','bright','Sensitivity',0.92,'EdgeThreshold',0.1);  
delete(hBright)
hBright = viscircles(centersBright, radiiBright,'Color','b');


h = viscircles(centers,radii);






I = imread('rice.png'); 
imshow(I)

se = strel('disk',15);
background = imopen(I,se); 
imshow(background)

I2 = I - background; 
imshow(I2)
I3 = imadjust(I2);
imshow(I3)


bw = imbinarize(I3);
bw = bwareaopen(bw,50); 
imshow(bw)


I = imread('coins.png'); 
imshow(I)

se = strel('disk',40);
background = imopen(I,se); 
imshow(background)

I2 = I - background; 
imshow(I2)
I3 = imadjust(I2);
imshow(I3)

bw = imbinarize(I3);
bw = bwareaopen(bw,2400); 
imshow(bw)
