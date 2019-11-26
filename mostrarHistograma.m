function imagen=mostrarHistograma(fila,columna,posicion,imagen,titulo)
    % Mostramos el histograma.
    [numeroDePixels, niveles] = imhist(imagen);
    subplot(fila,columna,posicion);
    bar(numeroDePixels);
    title(sprintf(titulo), 'FontSize', 12);
    xlim([0 niveles(end)]); % Establecemos los límites del eje X.
    grid on;    
end