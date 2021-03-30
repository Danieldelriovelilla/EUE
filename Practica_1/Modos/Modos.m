clc
close all
clear all


%% PRACTICA 1

% Cono
H = 50e-2;
D = 2;
d = 1;
t = 2e-3;
% Satelite
Mt = 2500;
h = 0.25;
% Material
E = 200e9;
rho = 7900;
nu = 0.3;

% %% EJEMPLO LIBRO -> 15.2
% 
% % Cono
% H = 1.5;
% D = 3;
% d = 1.2;
% t = 5e-3;
% % Satelite
% Mt = 2500;
% h = 1.5;
% % Material
% E = 120e9;
% nu = 0.3;


% Geometria cono
L = D/(D-d)*H;
s1 = sqrt( (L-H)^2 + (d/2)^2 );
s2 = sqrt( L^2 + (D/2)^2 );
alfa = asin(D/2/s2);

% Matriz de rigidez
Gdd = ( 1-s1/s2 )/( pi*E*t*sin(alfa)^3 )*...
    (log(s2/s1)/(1-s1/s2) - 2 + (1+s1/s2)*( 1/2 + (1+nu)*sin(alfa)^2 ));


Gdt = ( 1-s1/s2 )/(pi*E*t*sin(alfa)^3*s1*cos(alfa) )*...
    (1 - (1+s1/s2)*( 1/2 + (1+nu)*sin(alfa)^2 ));

Gtd = ( 1-s1/s2 )/( pi*E*t*sin(alfa)^3*s1*cos(alfa) )*...
    (1 - (1+s1/s2)*( 1/2 + (1+nu)*sin(alfa)^2 ));

Gtt = ( 1-s1/s2 )/( pi*E*t*sin(alfa)^3 )*...
    ((1+s1/s2)*( 1/2 + (1+nu)*sin(alfa)^2 ))/(s1*cos(alfa))^2;

D = Mt*1;           % [N]
M = h*Mt*1;         % [Nm]

delta = Gdd*D + Gdt*M;
teta = Gdt*D + Gtt*M;

desplazamiento = delta + h*teta;

f_lat = sqrt(1/desplazamiento)/(2*pi)

f_long = sqrt( ( 2*pi*sin(alfa)*cos(alfa)^2*E*t )/( log(s2/s1)*Mt ) )/(2*pi)


%% CON MATRICES
K = inv([Gdd Gdt; 
         Gtd Gtt]);

M = [Mt 0;
     0 h^2*Mt];

% Obtencion de los modos y frecuencias propias^2
[mod_prop,frec_matrix] = eig( M\K );
frec_matrix = sqrt(frec_matrix)/(2*pi);

frec_matrix = frec_matrix(sub2ind(size(frec_matrix),...
        1:size(frec_matrix,1),1:size(frec_matrix,2)));

[frec_n,idx] = sort(sort(frec_matrix));

frec_n

