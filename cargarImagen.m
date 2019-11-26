% Carga una imagen
% Si no está en la misma carpeta que el fichero que ejecutamos la busca en el path

function imagen = cargarImagen(nombreFichero)
    carpeta = fileparts(which(nombreFichero)); % Busca el fichero y se queda con la carpeta
    fichero = fullfile(carpeta, nombreFichero); % Creamos la ruta completa del fichero
    if ~exist(fichero, 'file')
        % No hemos encontrado el fichero en la carpeta actual.
        % Buscamos en el path.
        if ~exist(nombreFichero, 'file')
            % Tampoco existe en el path.
            % Avisamos que no ha sido posible localizar la imagen.
            mensajeDeAviso = sprintf('Error: El fichero con la imagen\n%s\nno se ha encontrado.\Pulsa para salir del programa.', fichero);
            uiwait(warndlg(mensajeDeAviso));
            fprintf(1, 'Saliendo del programa.\n'); 
            error('Imagen no encontrada: %s',nombreFichero);
        end
        % Se ha encontrado en el path.
    end
    imagen=imread(nombreFichero);
end