clc
clear
close all


%% DATOS DEL PROBLEMA

% Propiedades del panel
panel.Lx = 1;                                                              
panel.Ly = 1.25;
panel.P = 2*(panel.Lx+panel.Ly);
panel.A = panel.Lx*panel.Ly;
panel.t = 0.005;
panel.rho = 2700;
panel.m = panel.rho*panel.t;
panel.M = panel.rho*panel.A*panel.t;
panel.E = 70e9;
panel.nu = 0.3;
panel.D = ( panel.E*panel.t^3 )/( 12*(1-panel.nu^2) );
panel.eta_11 = 0.015;

% Propiedades del aire
aire.rho = 1.225;
aire.a = 343;
aire.eta_22 = 0.01;
aire.h = 0.050;
aire.A = 2*( panel.A + panel.Lx*aire.h + panel.Ly*aire.h );
aire.L = 2*2*(panel.Lx+panel.Ly) + 4*aire.h;
aire.V = panel.A*aire.h;

% Cargar bandas de tercios de octaba
load('Data/Bandas')
bandas = [[Bandas(1:29).lower]', [Bandas(1:29).center]', [Bandas(1:29).upper]'];

% Cargar matriz con potencias
load('Data/Potencia')


%% ESTUDIO MODAL (a)

% Panel
panel.n = panel.A*sqrt(panel.rho*panel.t/panel.D)/( 4*pi );
panel.modos = panel.n.*( bandas(:,3)-bandas(:,1) );

% Aire
aire.n = aire.V*(frec2omega(bandas(:,2))/aire.a).^2/(pi*aire.a) +...
         aire.A*(frec2omega(bandas(:,2))/aire.a)/(4*aire.a) + ...
         aire.L/(8*aire.a);
aire.modos = aire.n.*( bandas(:,3)-bandas(:,1) );

% Representacion numero de modos
h = figure();
    loglog(bandas(:,2), panel.modos, 'LineWidth', 1.5, 'DisplayName', 'Panel')
    hold on
    loglog(bandas(:,2), aire.modos, 'LineWidth', 1.5, 'DisplayName', 'Aire')
    legend('Location', 'NorthWest', 'Interpreter', 'Latex')
    grid on; box on;
    xlabel('$f$ [Hz]', 'Interpreter', 'Latex')
    ylabel("N\'umero de modos", 'Interpreter', 'Latex')
    %Save_as_PDF(h, 'Figures/Modos_Frecuencia','')
    
% Modos por banda
Np = find(panel.modos > 5); Np = Np(1);
Na = find(aire.modos > 5); Na = Na(1);

% Pintar numero de modos por bandas
h = figure();
    bp = bar(panel.modos(1:Np+1), 'FaceColor', [77, 153, 230]/255);
    bp.FaceColor = 'flat';
    bp.CData(Np,:) = [121, 131, 140]/255;
    grid on
    box on
    xlabel('Banda', 'Interpreter', 'Latex')
    ylabel("N\'umero de frecuencias", 'Interpreter', 'Latex')
    %Save_as_PDF(h, ['Figures/Modos_Bandas_Panel'], '')

h = figure();
    ba = bar(aire.modos(1:Na+1), 'FaceColor', [230, 93, 77]/255);
    ba.FaceColor = 'flat';
    ba.CData(Na,:) = [140, 123, 121]/255;
    grid on
    box on
    xlabel('Banda', 'Interpreter', 'Latex')
    ylabel("N\'umero de frecuencias", 'Interpreter', 'Latex')
    %Save_as_PDF(h, ['Figures/Modos_Bandas_Aire'], '')

    
%% FACTOR DE PERDIDAS DE ACOPLAMIENTO

% Panel
sigma = f_Eficiencia_Radiacion(panel, aire, bandas(:,2));
panel.eta_12 = panel.A*aire.rho*aire.a*sigma./(panel.M*frec2omega(bandas(:,2)));

% Aire: relacionados por el numero de modos
aire.eta_21 = panel.eta_12.*panel.n./aire.n;

% Factor de perdidas
h = figure();
    loglog(bandas(:,2), panel.eta_12, 'LineWidth', 1.5, 'DisplayName', '$\eta_{pa}$')
    hold on
    loglog(bandas(:,2), aire.eta_21, 'LineWidth', 1.5, 'DisplayName', '$\eta_{ap}$')
    legend('Location', 'NorthWest', 'Interpreter', 'Latex')
    grid on; box on;
    xlabel('$f$ [Hz]', 'Interpreter', 'Latex')
    ylabel("$\eta$", 'Interpreter', 'Latex')
    %Save_as_PDF(h, 'Figures/Eta','')

    
%% ENERGIA DE SUBSISTEMAS

for i = Np:length(potencia)
    e11 = panel.eta_11;
    e12 = panel.eta_12(i);
    e21 = aire.eta_21(i);
    e22 = aire.eta_22;
    
    % Matriz de acoplamiento
    L = [e11+e12, -e21, 0, 0, 0;
         -e12, e22 + 2*e21, -e12, 0, 0;
         0, -e12, e11+2*e12, -e21, 0;
         0, 0, -e12, e22+2*e21, -e12;
         0, 0, 0, -e21, e11+e12];
    
    % Vector de potencias
    P = [potencia(i,1), 0, potencia(i,2), 0, potencia(i,3)]';
    
    % Energia
    E(:,i) = L\P/frec2omega(bandas(i,2));
    
end

h = figure();
for i = 1:5
    loglog(bandas(Np:end,2),E(i,Np:end), 'LineWidth', 1.5, 'DisplayName', ['Subsistema ' num2str(i)])
    hold on
end
    grid on; box on;
    legend('Location', 'NorthEast', 'Interpreter', 'Latex')
    xlabel('$f$ [Hz]', 'Interpreter', 'Latex')
    ylabel("$E$ [J]", 'Interpreter', 'Latex')
    %Save_as_PDF(h, 'Figures/E','')
    



%% VELOCIDAD DE LOS PANELES Y PRESION DEL AIRE

colors = [0, 0.4470, 0.7410;
          0.8500, 0.3250, 0.0980;
          0.4660, 0.6740, 0.1880;
          0.4940, 0.1840, 0.5560]; 

% Velocidad RMS
qp = sqrt(E([1,3,5],:)/panel.M);


h = figure();
for i = 1:3
    loglog(bandas(Np:end,2),qp(i,Np:end), 'Color', colors(i,:),...
        'LineWidth', 1.5, 'DisplayName', ['Panel ' num2str(i)])
    hold on
end
    grid on; box on;
    legend('Location', 'NorthEast', 'Interpreter', 'Latex')
    xlabel('$f$ [Hz]', 'Interpreter', 'Latex')
    ylabel("$\dot q$ [m/s]", 'Interpreter', 'Latex')
    %Save_as_PDF(h, 'Figures/qp','')

% Presion RMS
P = sqrt(E([2,4],:)*aire.rho*aire.a^2/aire.V);

h = figure();
for i = 1:2
    loglog(bandas(Np:end,2),P(i,Np:end), 'Color', colors(i,:),...
        'LineWidth', 1.5, 'DisplayName', ['Aire ' num2str(i)])
    hold on
end
    grid on; box on;
    legend('Location', 'NorthEast', 'Interpreter', 'Latex')
    xlabel('$f$ [Hz]', 'Interpreter', 'Latex')
    ylabel("$P_{RMS}$ [Pa]", 'Interpreter', 'Latex')
    %Save_as_PDF(h, 'Figures/P','')
