
filas=1;
columnas=4;
close all;

%imagenOriginal=imread('board.tif');
imagenOriginal=imread('board2.jpg');

canalRojo=im2int16(imagenOriginal(:,:,1));
canalVerde=im2int16(imagenOriginal(:,:,2));
canalAzul=im2int16(imagenOriginal(:,:,3));

rojoSinVerde=abs(canalRojo-canalVerde);
azulSinVerde=abs(canalAzul-canalVerde);
grises=255-(azulSinVerde+rojoSinVerde);

figure;
mostrarImagen(filas,columnas,1,imagenOriginal,'Original');
mostrarImagen(filas,columnas,2,grises,'Grises');

grisesSeparados=grayslice(grises,5);
grisesSeparadosColoreados=label2rgb(grisesSeparados,'hsv','k','shuffle');
mostrarImagen(filas,columnas,3,grisesSeparados,'Grises');
mostrarImagen(filas,columnas,4,grisesSeparadosColoreados,'Capas');

waitforbuttonpress;


canalRojo=medfilt2(canalRojo,[ 5 5 ]);
canalVerde=medfilt2(canalVerde,[ 5 5 ]);
canalAzul=medfilt2(canalAzul,[ 5 5 ]);

canalRojo(canalRojo>80)=255;
rojoSinVerde=abs(canalRojo-canalVerde);
azulSinVerde=abs(canalAzul-canalVerde);
grises=255-(azulSinVerde+rojoSinVerde);

grises=medfilt2(grises,[ 20 20 ],'symmetric');

mostrarImagen(filas,columnas,2,grises,'Grises');
grises=imadjust(grises);
grisesSeparados=grayslice(grises,5);

grisesSeparadosColoreados=label2rgb(grisesSeparados,'hsv','k','shuffle');
mostrarImagen(filas,columnas,3,grisesSeparados,'Grises');
mostrarImagen(filas,columnas,4,grisesSeparadosColoreados,'Capas');

waitforbuttonpress;

mostrarImagen(filas,columnas,2,grisesSeparados,'Capas');
mascara=grisesSeparados==max(grisesSeparados(:));
mostrarImagen(filas,columnas,3,mascara,'Capas');
mostrarImagen(filas,columnas,4,labeloverlay(imagenOriginal,mascara),'Capas');


waitforbuttonpress;
microchips=bwlabel(mascara);
propiedades=regionprops(microchips,imagenOriginal(:,:,1),'All');
filas=4;
columnas=5

actual=0;
for k=1 : length(propiedades)
    p=propiedades(k);
    area=p.Area;
    if area>250
        
        actual=actual+1;
        
            microchip=imcrop(imagenOriginal,p.BoundingBox);
            microchip=255-rgb2gray(microchip);
            microchip=imadjust(microchip);

            s=size(microchip);
            mostrarImagen(filas,columnas,actual,microchip,'');


            textos   = ocr(microchip)
            fprintf(1,textos.Text);
    end
end
%ocrResults   = ocr(imagenOriginal)


