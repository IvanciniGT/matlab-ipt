function iniciarProgramaIPT()
    clearvars; % Eliminar los valores de las variables de la ejecución anterior.
    tic; % Start timer.
    clc; % Borrar la pantalla.
    fprintf('Iniciando programa...\n'); % Mostrar un mensaje en la consola.
    workspace; % Asegurarse que se muestra el panel de Workspace , donde aparecen todas las variables.
    close all;  % Cierra todas la imagenes abiertas en el imtool del toolbox IPT.
    format long g; % Mostrar los numeros con máximo número de decimales y sin utilizar notación científica
    format compact; % No muestra espacios en blanco entre la salida de sentencias en la pantalla de comandos
    
    comprobarLicencia('image_toolbox');
    
end