clc
clear
close all

%% EXTRAER LAS MATRICES DE MASA Y RIGIDEZ

try 
    % Cargas las matrices pre-extraidas
    load('Data/Vigas')
    load('Data/Bandas')
catch
    load('Data/Bandas')
    % Path de los archivos .pch
    path_v1 = "../Viga_1/Analisis/viga_1.pch";
    path_v2 = "../Viga_2/Analisis/viga_2.pch";
    path_v3 = "../Vigas/Analisis/parte_1.pch";

    % Estraer las matrices de la viga 1
    [M1,K1,N1] = ReadPunchFile_nD(path_v1,[3]);
    gdl1 = 1:length(N1);
    
    % Struct de la viga 1
    viga_1.M = M1;
    viga_1.K = K1;
    viga_1.nodes = N1;
    viga_1.gdl = gdl1;
    viga_1.F = zeros(length(viga_1.gdl),1);
    viga_1.F(26) = -1;
    
    % Estraer las matrices de la viga 2
    [M2,K2,N2] = ReadPunchFile_nD(path_v2,[3]);
    gdl2 = 1:length(N2);
    
    % Struct de la viga 2
    viga_2.M = M2;
    viga_2.K = K2;
    viga_2.nodes = N2;
    viga_2.gdl = gdl2;
    viga_2.F = zeros(length(viga_2.gdl),1);
    
    % Estraer las matrices de la viga 2
    [M3,K3,N3] = ReadPunchFile_nD(path_v3,[3]);
    gdl3 = 1:length(N3);
    
    % Struct de la viga 3
    viga_3.M = M3;
    viga_3.K = K3;
    viga_3.nodes = N3;
    viga_3.gdl = gdl3;
    viga_3.F = zeros(length(viga_3.gdl),1);
    viga_3.F(26) = -1;
    
    % Save data
    save('Data/Vigas', 'viga_1', 'viga_2', 'viga_3')
end


%% VIGAS SIN CB

% Ensamblaje de matrices
Ni = [viga_1.gdl(end), viga_2.gdl(1)];
[vigas.M, vigas.K, vigas.F] = ...
    f_Ensamblar(viga_1.M, viga_1.K, viga_1.F, viga_2.M, viga_2.K, viga_2.F, Ni);

% Matrices de Masa 
h = figure();
    heatmap(vigas.M);
    snapnow
    colormap default
    Ax = gca;
    Ax.XDisplayLabels = nan(size(Ax.XDisplayData));
    Ax.YDisplayLabels = nan(size(Ax.YDisplayData));
    set(h,'Units','Inches');
    pos = get(h,'Position');
    set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
    print(h, 'Figures/Vigas_M','-dpdf','-r0','-painters')
    
% Matriz de Rigidez
h = figure();
    heatmap(vigas.K);
    snapnow
    colormap default
    Ax = gca;
    Ax.XDisplayLabels = nan(size(Ax.XDisplayData));
    Ax.YDisplayLabels = nan(size(Ax.YDisplayData));
    set(h,'Units','Inches');
    pos = get(h,'Position');
    set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
    print(h, 'Figures/Vigas_K','-dpdf','-r0','-painters')


% Solucion
cc = [1, length(vigas.M)];
[vigas.modos, vigas.frecuencias] = f_Modos(vigas.M, vigas.K, cc);

f = 1:2000;
len = 0:0.01:1.1;

% Inicializar variables
z = zeros(length(len), length(f));
rms_z = zeros(length(f), 3);
rms_z1 = zeros(51, 3);
rms_z2 = zeros(61, 3);

tic
for i = 1:length(f)
    [z(:,i)] = f_Solucion(vigas.M, vigas.K, vigas.F, [1,length(vigas.F)], f(i));
    z_1 = z(1:51,i);
    z_2 = z(51:end,i);
    [rms_z(i,:)] = f_RMS(z(:,i), f(i));
    [rms_z1(i,:)] = f_RMS(z_1, f(i));
    [rms_z2(i,:)] = f_RMS(z_2, f(i));
end
toc

h = figure();
    loglog(f,rms_z(:,2), 'LineWidth', 1.)
    xlabel('$f$ [Hz]', 'Interpreter', 'Latex')
    ylabel('$\dot q_{\mathrm{rms}}$ [Hz]', 'Interpreter', 'Latex')
    grid on; box on
    Save_as_PDF(h, 'Figures/Clasico_vigas','')
   
h = figure();
    loglog(f,rms_z1(:,2), 'LineWidth', 1.)
    xlabel('$f$ [Hz]', 'Interpreter', 'Latex')
    ylabel('$\dot q_{\mathrm{rms}}$ [Hz]', 'Interpreter', 'Latex')    
    grid on; box on
    Save_as_PDF(h, 'Figures/Clasico_viga_1','')
    
h = figure();
    loglog(f,rms_z2(:,2), 'LineWidth', 1.)
    xlabel('$f$ [Hz]', 'Interpreter', 'Latex')
    ylabel('$\dot q_{\mathrm{rms}}$ [Hz]', 'Interpreter', 'Latex')
    grid on; box on
    Save_as_PDF(h, 'Figures/Clasico_viga_2','')
    

%% MODOS DE VIGAS INDEPENDIENTES

cc = [1];
[viga_1.modos, viga_1.frecuencias] = f_Modos(viga_1.M, viga_1.K, cc);
    
cc = [61];
[viga_2.modos, viga_2.frecuencias] = f_Modos(viga_2.M, viga_2.K, cc);
    

%% CRAIIG-BAMPTON

% Viga 1
Nb_1 = 1;
NI_1 = viga_1.gdl(end);

[viga_1.M_CB, viga_1.K_CB, viga_1.F_CB, viga_1.psi] = ...
    f_CB(viga_1.M, viga_1.K, viga_1.F, Nb_1, NI_1);

% Viga 2
Nb_2 = viga_2.gdl(end);
NI_2 = 1;

[viga_2.M_CB, viga_2.K_CB, viga_2.F_CB, viga_2.psi] = ...
    f_CB(viga_2.M, viga_2.K, viga_2.F, Nb_2, NI_2);


% Ensamblar matrices en el espacio CB
Ni = [2, 2];
[vigas_CB.M, vigas_CB.K, vigas_CB.F, vigas_CB.psi] = ...
    f_Ensamblar_CB(viga_1.M_CB, viga_1.K_CB, viga_1.F_CB, viga_1.psi,...
    viga_2.M_CB, viga_2.K_CB, viga_2.F_CB, viga_2.psi);


%% TODOS GDL

cc = [1,2];
rms_z_f = zeros(length(f), 3);
rms_z1_f = zeros(length(f), 3);
rms_z2_f = zeros(length(f), 3);
red_1 = 0;
red_2 = 0;

tic
for i = 1:length(f)
    [z, z1, z2] = f_Solucion_CB(vigas_CB.M, vigas_CB.K, vigas_CB.F, vigas_CB.psi, cc, f(i), red_1, red_2);
    [rms_z_f(i,:)] = f_RMS(z, f(i));
    [rms_z1_f(i,:)] = f_RMS(z1, f(i));
    [rms_z2_f(i,:)] = f_RMS(z2, f(i));
end
toc

%% CG REDUCIDO
close all

cc = [1,2];
rms_z_r = zeros(length(f), 3);
rms_z1_r = zeros(length(f), 3);
rms_z2_r = zeros(length(f), 3);
red_1 = f_Num_Reducir(viga_1.frecuencias, Bandas, 5);
red_2 = f_Num_Reducir(viga_2.frecuencias, Bandas, 5);

tic
for i = 1:length(f)
    [z, z1, z2] = f_Solucion_CB(vigas_CB.M, vigas_CB.K, vigas_CB.F, vigas_CB.psi, cc, f(i), red_1, red_2);
    [rms_z_r(i,:)] = f_RMS(z, f(i));
    [rms_z1_r(i,:)] = f_RMS(z1, f(i));
    [rms_z2_r(i,:)] = f_RMS(z2, f(i));
end
toc

h = figure();
    loglog(f,rms_z_f(:,2), 'LineWidth', 1., 'DisplayName','No reducido')
    hold on
    loglog(f, rms_z_r(:,2), 'LineWidth', 1., 'DisplayName','Reducido')
    grid on; box on;
    legend('Interpreter', 'Latex', 'Location', 'NorthWest')
    xlabel('$f$ [Hz]', 'Interpreter', 'Latex')
    ylabel('$\dot q_{\mathrm{rms}}$ [Hz]', 'Interpreter', 'Latex')
    grid on; box on
    Save_as_PDF(h, 'Figures/CB_vigas_25','') 

h = figure();
    loglog(f,rms_z1_f(:,2), 'LineWidth', 1., 'DisplayName','No reducido')
    hold on
    loglog(f, rms_z1_r(:,2), 'LineWidth', 1., 'DisplayName','Reducido')
    grid on; box on;
    legend('Interpreter', 'Latex', 'Location', 'NorthWest')
    xlabel('$f$ [Hz]', 'Interpreter', 'Latex')
    ylabel('$\dot q_{\mathrm{rms}}$ [Hz]', 'Interpreter', 'Latex')
    grid on; box on
    Save_as_PDF(h, 'Figures/CB_viga_1_25','')

    
h = figure();
    loglog(f,rms_z2_f(:,2), 'LineWidth', 1., 'DisplayName','No reducido')
    hold on
    loglog(f, rms_z2_r(:,2), 'LineWidth', 1., 'DisplayName','Reducido')
    grid on; box on;
    legend('Interpreter', 'Latex', 'Location', 'NorthWest')
    xlabel('$f$ [Hz]', 'Interpreter', 'Latex')
    ylabel('$\dot q_{\mathrm{rms}}$ [Hz]', 'Interpreter', 'Latex')
    grid on; box on
    Save_as_PDF(h, 'Figures/CB_viga_2_25','')    
    
rms(log10(rms_z_r(:,2))-log10(rms_z_f(:,2)))
    
%% REPRESENTACION MATRICES

% Masa viga 1
h = figure();
    heatmap(viga_1.M);
    snapnow
    colormap default
    Ax = gca;
    Ax.XDisplayLabels = nan(size(Ax.XDisplayData));
    Ax.YDisplayLabels = nan(size(Ax.YDisplayData));
    set(h,'Units','Inches');
    pos = get(h,'Position');
    set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
    print(h, 'Figures/VIga_1_M','-dpdf','-r0','-painters')
    
% Rigidez viga 1
h = figure();
    heatmap(viga_1.K);
    snapnow
    colormap default
    Ax = gca;
    Ax.XDisplayLabels = nan(size(Ax.XDisplayData));
    Ax.YDisplayLabels = nan(size(Ax.YDisplayData));
    % save figure as PDF
    set(h,'Units','Inches');
    pos = get(h,'Position');
    set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
    print(h, 'Figures/VIga_1_K','-dpdf','-r0','-painters')
    
% Masa viga 2
h = figure();
    heatmap(viga_2.M);
    snapnow
    colormap default
    Ax = gca;
    Ax.XDisplayLabels = nan(size(Ax.XDisplayData));
    Ax.YDisplayLabels = nan(size(Ax.YDisplayData));
    set(h,'Units','Inches');
    pos = get(h,'Position');
    set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
    print(h, 'Figures/VIga_2_M','-dpdf','-r0','-painters')
    
% Rigidez viga 1
h = figure();
    heatmap(viga_2.K);
    snapnow
    colormap default
    Ax = gca;
    Ax.XDisplayLabels = nan(size(Ax.XDisplayData));
    Ax.YDisplayLabels = nan(size(Ax.YDisplayData));
    set(h,'Units','Inches');
    pos = get(h,'Position');
    set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
    print(h, 'Figures/VIga_2_K','-dpdf','-r0','-painters')