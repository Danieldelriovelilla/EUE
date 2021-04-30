clc
clear all
close all

load('Data/Data.mat')


figure()
    bar(it)
    legend('Masa [kg]','Frec [Hz]','MoS$_Y$','MoS$_U$',...
           'Location', 'Best','Interpreter', 'Latex')
    ylim([-10, 260])
       