clc
clear all
close all

filename = '../BB_G1_R.xlsx';
resultados = xlsread(filename,'O3:U8');


col = [1, 2, 6, 7];
ref = resultados(1, col);
it = resultados(2:end, col);

for i = 1:size(it,1)
    it(i,:) = ( it(i,:) - ref)./abs(ref);
       
end
it = it*100;
save('Data/Data_R.mat', 'ref', 'it')