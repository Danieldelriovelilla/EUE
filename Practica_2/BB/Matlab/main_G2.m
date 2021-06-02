clc
clear all
close all

load('Data/Data_G2.mat')


h = figure();
    bar(it)
    legend('Masa','Frec','MoS$_Y$','MoS$_U$',...
           'Location', 'northwest','Interpreter', 'Latex')
    xlabel("N\'umero de iteraci\'on", 'Interpreter', 'Latex')
    ylabel("Variaci\'on porcentual", 'Interpreter', 'Latex')
    grid on; box on
    ylim([-10, 100])
    Save_as_PDF(h, 'G2','vertical')
       