clc
clear all
close all

filename = '../BA_Optimizacion.xlsx';
resultados = xlsread(filename,'N3:T6');


col = [1, 2, 6, 7];
ref = resultados(1, col);
it = resultados(2:end, col);

for i = 1:size(it,1)
    it(i,:) = ( it(i,:) - ref)./abs(ref);
       
end
it = it*100;
save('Data/Data.mat', 'ref', 'it')