function imagen = asegurarEscalaGrises(imagen)

    % Comprobamos que la imagen está en escala de grises.
    [~, ~, numeroDeCanalesDeColor] = size(imagen);
    if numeroDeCanalesDeColor > 1
        promptMessage = sprintf('La imagen tiene %d canales de color.\nEste programa está preparado solamente para imagenes en tonos de grisess.\nQuieres convertir la imagen a escala de grises?', numeroDeCanalesDeColor);
        boton = questdlg(promptMessage, 'Continuar', 'Convertir y continuar', 'Cancelar', 'Convertir y continuar');
        if strcmp(boton, 'Cancelar')
            fprintf(1, 'Saliendo del programa.\n');
            return;
        end
        % Convertir la imagen a escala de grises
        imagen = rgb2gray(imagen);
    end
end