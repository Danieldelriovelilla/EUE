clc
clear all
close all

filename = '../BA_Optimizacion.xlsx';
resultados = xlsread(filename,'N3:T8');

% col = [1, 2, 6, 7];
col = [1, 2, 6];
optim = resultados(:, col);

h = figure();
    plot(optim(:,1), 'k-*', 'MarkerSize', 6, 'LineWidth', 2)
    xlabel("I", 'Interpreter', 'Latex')
    ylabel({'Masa [kg]'}, 'Interpreter', 'Latex')
    grid on; box on
    %ylim([-10, 360])
    Save_as_PDF(h, 'Optimizacion_Masa', 'v')
    
h = figure();
    plot(optim(:,2), 'k-*', 'MarkerSize', 6, 'LineWidth', 2)
    xlabel("Iteraci\'on", 'Interpreter', 'Latex')
    ylabel({'Frecuencia [Hz]'}, 'Interpreter', 'Latex')
    grid on; box on
    %ylim([-10, 360])
    Save_as_PDF(h, 'Optimizacion_Frec','v')
    
h = figure();
    plot(optim(:,3), 'k-*', 'MarkerSize', 6, 'LineWidth', 2)
    xlabel("Iteraci\'on", 'Interpreter', 'Latex')
    ylabel('MOS$_y$', 'Interpreter', 'Latex')
    grid on; box on
    %ylim([-10, 360])
    Save_as_PDF(h, 'Optimizacion_MOSY', 'v')
%{
h = figure();
    %h.Position = [100 100 540 400];
    h.Position = [680   558   1.5*560   420]
    bar(it)
    legend('Masa','Frec','MoS$_Y$','MoS$_U$',...
           'Location', 'Best','Interpreter', 'Latex')
    xlabel("N\'umero de iteraci\'on", 'Interpreter', 'Latex')
    ylabel("Variaci\'on porcentual", 'Interpreter', 'Latex')
    grid on; box on
    %ylim([-10, 360])
    Save_as_PDF(h, 'Estudio_Optimizacion','vertical')
%}       
    
    