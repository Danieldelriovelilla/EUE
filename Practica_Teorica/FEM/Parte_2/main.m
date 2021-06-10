clc
clear
close all


%% DATOS DEL PROBLEMA

% Propiedades del panel
panel.Lx = 1;                                                              
panel.Ly = 1.25;
panel.A = panel.Lx*panel.Ly;
panel.t = 0.005;
panel.rho = 2700;
panel.E = 70e9;
panel.nu = 0.3;
panel.D = ( panel.E*panel.t^3 )/( 12*(1-panel.nu^2) );
panel.F = 0.015;

% Propiedades del aire
aire.rho = 1.225;
aire.a = 343;
aire.F = 0.01;
aire.h = 0.050;
aire.A = 2*( panel.A + panel.Lx*aire.h + panel.Ly*aire.h );
aire.L = 2*2*(panel.Lx+panel.Ly) + 4*aire.h;
aire.V = panel.A*aire.h;

% Cargar bandas de tercios de octaba
load('Data/Bandas')
bandas = [[Bandas(1:29).lower]', [Bandas(1:29).center]', [Bandas(1:29).upper]'];


%% ESTUDIO MODAL (a)

% Panel
panel.n = panel.A*sqrt(panel.rho*panel.t/panel.D)/( 4*pi );
panel.modos = panel.n.*frec2omega(bandas(:,3)-bandas(:,1));

% Aire
aire.n = aire.V*(frec2omega(bandas(:,2))/aire.a).^2/(pi*aire.a) +...
         aire.A*(frec2omega(bandas(:,2))/aire.a)/(4*aire.a) + ...
         aire.L/(8*aire.a);
aire.modos = aire.n.*frec2omega(bandas(:,3)-bandas(:,1));

% Representacion numero de modos
h = figure();
    loglog(bandas(:,2), panel.modos, 'LineWidth', 1.5, 'DisplayName', 'Panel')
    hold on
    loglog(bandas(:,2), aire.modos, 'LineWidth', 1.5, 'DisplayName', 'Aire')
    legend('Location', 'NorthWest', 'Interpreter', 'Latex')
    grid on; box on;
    xlabel('$f$ Hz', 'Interpreter', 'Latex')
    ylabel("N\'umero de modos", 'Interpreter', 'Latex')
    Save_as_PDF(h, 'Figures/Modos_Frecuencia','')
    
% Modos por banda
Np = find(panel.modos > 5); Np = Np(1);
Na = find(aire.modos > 5); Na = Na(1);

% Pintar bandas
h = figure();
    bp = bar(panel.modos(1:Np+1), 'FaceColor', [77, 153, 230]/255);
    bp.FaceColor = 'flat';
    bp.CData(Np,:) = [121, 131, 140]/255;
    grid on
    box on
    xlabel('Banda', 'Interpreter', 'Latex')
    ylabel("N\'umero de frecuencias", 'Interpreter', 'Latex')
    Save_as_PDF(h, ['Figures/Modos_Bandas_Panel'], '')

h = figure();
    ba = bar(aire.modos(1:Na+1), 'FaceColor', [230, 93, 77]/255);
    ba.FaceColor = 'flat';
    ba.CData(Na,:) = [140, 123, 121]/255;
    grid on
    box on
    xlabel('Banda', 'Interpreter', 'Latex')
    ylabel("N\'umero de frecuencias", 'Interpreter', 'Latex')
    Save_as_PDF(h, ['Figures/Modos_Bandas_Aire'], '')

