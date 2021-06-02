clc
clear
close all

%% ABRIR LAS MATRICES

path_v1 = "../Viga_1/Analisis/viga_1.pch";
path_v2 = "../Viga_2/Analisis/viga_2.pch";

[m1,s1,n1] = ReadPunchFile_nD(path_v1,[1:6]);
gdl1 = length(n1)*6;
[m2,s2,n2] = ReadPunchFile_nD(path_v2,[1:6]);
gdl2 = length(n2)*6;


