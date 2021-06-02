clc
clear all
close all

%filename = '../BB_G1_I.xlsx';
filename = '../BB_G1_I_latex2.xlsx';
resultados = xlsread(filename,'L3:P9');


col = [1, 2, 4, 5];
ref = resultados(1, col);
it = resultados(2:end, col);

for i = 1:size(it,1)
    it(i,:) = ( it(i,:) - ref)./abs(ref);
       
end
it = it*100;
save('Data/Data_I2.mat', 'ref', 'it')