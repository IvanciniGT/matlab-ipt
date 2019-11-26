% Comprueba que tenemos la licencia adecuada.
% Si no, aborta la ejecución del programa

function comprobarLicencia(paquete)
    % Comprobar que está instalado el paquete
    hasIPT = license('test', paquete);
    if ~hasIPT
        % El paquete no está instalado.
        mensaje = sprintf('El paquete %s no está instalado. Desea continuar de todos modos?',paquete);
        respuesta = questdlg(mensaje, 'Paquete no instalado', 'Si', 'No', 'Si');
        if strcmpi(respuesta, 'No')
            % Abortamos la ejecución.
            error('Las licencias requeridas no se han encontrado')
        end
    end
    
end