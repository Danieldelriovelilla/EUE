clc
clear all
close all

load('Data/Data.mat')


h = figure();
    bar(it)
    legend('Masa','Frec','MoS$_Y$','MoS$_U$',...
           'Location', 'NorthEast','Interpreter', 'Latex')
    xlabel("N\'umero de iteraci\'on", 'Interpreter', 'Latex')
    ylabel("Variaci\'on porcentual", 'Interpreter', 'Latex')
    grid on; box on
    ylim([-10, 260])
    Save_as_PDF(h, 'Estudio_Parametrico','vertical')
       