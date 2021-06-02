clc
clear
close all

%% EXTRAER LAS MATRICES DE MASA Y RIGIDEZ

try 
    % Cargas las matrices pre-extraidas
    load('Data/Vigas')
catch
    % Path de los archivos .pch
    path_v1 = "../Viga_1/Analisis/viga_1.pch";
    path_v2 = "../Viga_2/Analisis/viga_2.pch";

    % Estraer las matrices de la viga 1
    [m1,s1,n1] = ReadPunchFile_nD(path_v1,[1:6]);
    gdl1 = 1:length(n1)*6;
    
    % Struct de la viga 1
    viga_1.mass = m1;
    viga_1.stiff = s1;
    viga_1.nodes = n1;
    viga_1.gdl = gdl1;
    
    % Estraer las matrices de la viga 2
    [m2,s2,n2] = ReadPunchFile_nD(path_v2,[1:6]);
    gdl2 = 1:length(n2)*6;
    
    % Struct de la viga 2
    viga_2.mass = m2;
    viga_2.stiff = s2;
    viga_2.nodes = n2;
    viga_2.gdl = gdl2;
    
    save('Data/Vigas', 'viga_1', 'viga_2')
end


%% ENSAMBLAR LAS MATRICES

% Inicializar struct
vigas = struct('mass', [], 'stiff', [],'nodes', [], 'gdl', []);

% Nodos y gdl del sistema ensamblado
vigas.nodes = 1:(length(viga_1.nodes) + length(viga_2.nodes) - 1);
vigas.gdl = 1:vigas.nodes(end)*6;

% Construir matrices de rigidez
gdl_1 = viga_1.gdl;
gdl_2 = gdl_1(end)-5:vigas.gdl(end);

vigas.mass = zeros(length(vigas.gdl));
vigas.mass(gdl_1, gdl_1) = vigas.mass(gdl_1, gdl_1) + viga_1.mass;
mesh(vigas.mass)
vigas.mass(gdl_2, gdl_2) = vigas.mass(gdl_2, gdl_2) + viga_2.mass;
mesh(vigas.mass)

vigas.stiff = zeros(length(vigas.gdl));
vigas.stiff(gdl_1, gdl_1) = vigas.stiff(gdl_1, gdl_1) + viga_1.stiff;
mesh(vigas.stiff)
vigas.stiff(gdl_2, gdl_2) = vigas.stiff(gdl_2, gdl_2) + viga_2.stiff;
mesh(vigas.stiff)


%% SOLUCION SIN REDUCCION

M = vigas.mass;
M(1:6,:) = []; M(:,1:6) = [];
M(end-5:end,:) = []; M(:,end-5:end) = [];

K = vigas.stiff;
K(1:6,:) = []; K(:,1:6) = [];
K(end-5:end,:) = []; K(:,end-5:end) = [];

F = zeros(size(K,1),1);
F(25*6+5) = -1;

% Resolver sistema
f = 1;
w = 2*pi*f;

% Respuesta permanente
H = inv(K - w^2*M);
Q = (H*F);

theta = Q(2:6:end);
z = Q(6:6:end);

figure()
    plot([0;z;0])
    title('Z')
    
figure()
    plot([0;theta;0])
    title('\theta')