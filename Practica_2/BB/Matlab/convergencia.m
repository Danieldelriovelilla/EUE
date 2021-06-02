clear all
clc

masa = [5.77,4.67,4.30,4.30,4.12,4.68,4.15];
frecuencia = [156,154,150.28,153.96,150.03,150.1,150.92];
mosy = [ 1.38, 1.05, 0.70,0.69,0.49, 0.45,0.53];
mosu = [1.44, 1.10,0.75,0.74,0.53,0.49,0.57];
it = [1,2,3,4,5,6,7];
% ylabels = {"Masa [kg]";"Frecuencia [Hz]";"MoSy";"MoSu"};
%ylables = string('Masa [kg]';'Frecuencia [Hz]';'MoSy';'MoSu');
% ylabels = {['Masa [kg]'];['Frecuencia [Hz]'];['MoSy'];['MoSu']};
ylabels{1} = 'Masa [kg]';
ylabels{2} = 'Frecuencia [Hz]';
ylabels{3} = 'MoSy';
ylabels{4} = 'MoSu';
[ax,hlines] = ploty4(it,masa,it,frecuencia,it,mosy,it,mosu,ylabels)

 h = figure(1);
 
 [ax,hlines] = ploty4(it,masa,it,frecuencia,it,mosy,it,mosu,ylabels)

 Save_as_PDF(h, 'convergencia','vertical')