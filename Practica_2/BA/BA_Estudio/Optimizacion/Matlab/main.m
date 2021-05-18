clc
clear all
close all

filename = '../BA_Optimizacion.xlsx';
resultados = xlsread(filename,'N3:T6');

% col = [1, 2, 6, 7];
col = [1, 2, 6];
ref = resultados(1, col);
it = resultados(2:end, col);

for i = 1:size(it,1)
    it(i,:) = ( it(i,:) - ref)./abs(ref);
       
end
it = it*100;

MoSy_frec = it(:,3)./it(:,2)
mass_frec = it(:,1)./it(:,2)


h = figure();
    bar(it)
    legend('Masa','Frec','MoS$_Y$','MoS$_U$',...
           'Location', 'Best','Interpreter', 'Latex')
    xlabel("N\'umero de iteraci\'on", 'Interpreter', 'Latex')
    ylabel("Variaci\'on porcentual", 'Interpreter', 'Latex')
    grid on; box on
    %ylim([-10, 360])
    Save_as_PDF(h, 'Estudio_Optimizacion','vertical')
       
    
    
    
    
    