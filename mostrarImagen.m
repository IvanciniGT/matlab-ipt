function mostrarImagen(fila,columna,posicion,imagen,titulo)
    % Mostrar la imagen 
    subplot(fila, columna, posicion); % Preparamos una rejilla de columnaxfila para mostrar imagenes, y seleccionamos la posición posicion, como posición de trabajo actual
    imshow(imagen,[]); % Mostramos nuestra imagen
    % Mostrar la imagen a tamaño real.
    % gfc : Apuntador a la imagen actual
    % Units: [ inches | centimeters | normalized | points | {pixels} | characters ]
    set(gcf, 'units','normalized','outerposition',[0 0 1 1]);
    % Forzar que se mueestre la imagen ahora mismo. De lo contrario no se
    % mostraría hasta que haya un breakpoint o se acabe el programa
    drawnow;
    titulo = sprintf(titulo);
    title(titulo, 'FontSize', 12);
    axis image; %Asegurarse que la imagen no se vea distorsionada por el ratio de aspecto de la pantalla.
end