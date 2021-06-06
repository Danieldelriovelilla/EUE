%% --------------------PARTE 1----------------------%%
clear all; clc; close all

load('Data/Vigas')

masa_viga1 = viga_1.M;
masa_viga2 = viga_2.M;

rigidez_viga1 = viga_1.K;
rigidez_viga2 = viga_2.K;

%======================= ENSAMBLAJE FEM COMPLETO =====================%

L1 = length(masa_viga1);
L2 = length(masa_viga2);

% MODELO COMPLETO

MASAS_completo = [masa_viga1(1:L1-1,1:L1) , zeros(L1-1,L2-1);...
                  masa_viga1(L1,1:L1-1), masa_viga1(L1,L1) + masa_viga2(1,1), masa_viga2(1,2:end);...
                  zeros(L2-1,L1-1), masa_viga2(2:L2,1:L2)];
              
RIGIDEZ_completo = [rigidez_viga1(1:L1-1,1:L1) , zeros(L1-1,L2-1);...
                    rigidez_viga1(L1,1:L1-1), rigidez_viga1(L1,L1) + rigidez_viga2(1,1), rigidez_viga2(1,2:end);...
                    zeros(L2-1,L1-1), rigidez_viga2(2:L2,1:L2)];
           
% IMPOSICION CC - EMPOTRAMIENTO EN AMBAS VIGAS Y CARGAS

M_FEM = MASAS_completo(2:end-1,2:end-1);
K_FEM = RIGIDEZ_completo(2:end-1,2:end-1);
F = zeros(length(M_FEM),1);
F(25) = -1;

% RESPUESTA

omega = linspace(0,2000,2001)*(2*pi);

Qd_completo = zeros(length(MASAS_completo),1);
Qv_completo = zeros(length(MASAS_completo),1);
Qa_completo = zeros(length(MASAS_completo),1);

for i = 1:length(omega)

    Qd_completo(:,i)   = [0;(-omega(i)^2.*M_FEM + K_FEM)\F;0];
    Qd_RMS_completo(i) = sqrt(sum(Qd_completo(:,i).^2)/length(MASAS_completo));
    
    Qv_completo(:,i)   = omega(i)*Qd_completo(:,i);
    Qv_RMS_completo(i) = sqrt(sum(Qv_completo(:,i).^2)/length(MASAS_completo));
    
    Qa_completo(:,i)   = -omega(i)^2*Qd_completo(:,i);
    Qa_RMS_completo(i) = sqrt(sum(Qa_completo(:,i).^2)/length(MASAS_completo));

end

% FRECUENCIAS Y MODOS PROPIOS

[MODOS_FEM,omega_FEM] = eig(K_FEM,M_FEM,'vector');
[omega_FEM, ind]      = sort(sqrt(omega_FEM)/(2*pi));
MODOS_FEM             = MODOS_FEM(:,ind);

% FIGURAS

figure()
loglog(omega/(2*pi),Qd_RMS_completo)
grid on
box on
xlabel('f [Hz]')
ylabel('q_d RMS [m]')

figure()
loglog(omega/(2*pi),Qv_RMS_completo)
grid on
box on
xlabel('f [Hz]')
ylabel('q_v RMS [m/s]')

figure()
loglog(omega/(2*pi),Qa_RMS_completo)
grid on
box on
xlabel('f [Hz]')
ylabel('q_a RMS [m/s^2]')

figure()
hold on
grid on
box on
plot(linspace(0,1.1,floor(L1+L2-1)),Qd_completo(:,1))


%=================== ENSAMBLAJE CRAIG-BAMPTON ======================%

%clear all; clc; close all

masa_viga1 = viga_1.M;
masa_viga2 = viga_2.M;

rigidez_viga1 = viga_1.K;
rigidez_viga2 = viga_2.K;

%------------VIGA 1------------------%

% Separación en GDL de frontera (f) e interiores (i)

masa_viga1_ff  = [masa_viga1(1,1), masa_viga1(1,51);...
                  masa_viga1(51,1),masa_viga1(51,51)];
masa_viga1_fi  = [masa_viga1(1,2:end-1);...
                  masa_viga1(51,2:end-1)];
masa_viga1_if  = [masa_viga1(2:end-1,1),masa_viga1(2:end-1,51)];
masa_viga1_ii  = [masa_viga1(2:end-1,2:end-1)];

masa_viga1     = [masa_viga1_ff , masa_viga1_fi;...
                  masa_viga1_if , masa_viga1_ii];

rigidez_viga1_ff  = [rigidez_viga1(1,1), rigidez_viga1(1,51);...
                     rigidez_viga1(51,1),rigidez_viga1(51,51)];
rigidez_viga1_fi  = [rigidez_viga1(1,2:end-1);...
                     rigidez_viga1(51,2:end-1)];
rigidez_viga1_if  = [rigidez_viga1(2:end-1,1),rigidez_viga1(2:end-1,51)];
rigidez_viga1_ii  = [rigidez_viga1(2:end-1,2:end-1)];

rigidez_viga1     = [rigidez_viga1_ff , rigidez_viga1_fi;...
                     rigidez_viga1_if , rigidez_viga1_ii];

% Matrices de transformación

phi_s_V1            = [eye(2);...
                       -inv(rigidez_viga1_ii)*rigidez_viga1_if];
        
[MODOS_V1,omega_V1] = eig(rigidez_viga1_ii,masa_viga1_ii,'vector');
[omega_V1, ind]     = sort(sqrt(omega_V1)/(2*pi));
MODOS_V1            = MODOS_V1(:,ind);

phi_i_V1            = [zeros(2,length(MODOS_V1));...
                       MODOS_V1]; 

% REDUCCION V2                   
n_V1                = 19;
phi_i_V1_red        = phi_i_V1(:,n_V1); 

psi_V1              = [phi_s_V1, phi_i_V1];

% Cambio al espacio de Craig-Bampton

M_CB_V1             = psi_V1'*masa_viga1*psi_V1;
K_CB_V1             = psi_V1'*rigidez_viga1*psi_V1;

%------------VIGA 2------------------%

% Separación en GDL de frontera (f) e interiores (i)

masa_viga2_ff  = [masa_viga2(61,61), masa_viga2(61,1);...
                  masa_viga2(1,61),masa_viga2(1,1)];
masa_viga2_fi  = [masa_viga2(61,2:end-1);...
                  masa_viga2(1,2:end-1)];
masa_viga2_if  = [masa_viga2(2:end-1,61),masa_viga2(2:end-1,1)];
masa_viga2_ii  = [masa_viga2(2:end-1,2:end-1)];

masa_viga2     = [masa_viga2_ff , masa_viga2_fi;...
                  masa_viga2_if , masa_viga2_ii];

rigidez_viga2_ff  = [rigidez_viga2(61,61), rigidez_viga2(61,1);...
                     rigidez_viga2(1,61),rigidez_viga2(1,1)];
rigidez_viga2_fi  = [rigidez_viga2(61,2:end-1);...
                     rigidez_viga2(1,2:end-1)];
rigidez_viga2_if  = [rigidez_viga2(2:end-1,61),rigidez_viga2(2:end-1,1)];
rigidez_viga2_ii  = [rigidez_viga2(2:end-1,2:end-1)];

rigidez_viga2     = [rigidez_viga2_ff , rigidez_viga2_fi;...
                     rigidez_viga2_if , rigidez_viga2_ii];


% Matrices de transformación

phi_s_V2            = [eye(2);...
                       -inv(rigidez_viga2_ii)*rigidez_viga2_if];
        
[MODOS_V2,omega_V2] = eig(rigidez_viga2_ii,masa_viga2_ii,'vector');
[omega_V2, ind]     = sort(sqrt(omega_V2)/(2*pi));
MODOS_V2            = MODOS_V2(:,ind);

phi_i_V2            = [zeros(2,length(MODOS_V2));...
                       MODOS_V2];
%REDUCCION V2                   
n_V2                = 29;
phi_i_V2_red        = phi_i_V2(:,n_V2);                   
        
psi_V2              = [phi_s_V2, phi_i_V2];

% Cambio al espacio de Craig-Bampton

M_CB_V2             = psi_V2'*masa_viga2*psi_V2;
K_CB_V2             = psi_V2'*rigidez_viga2*psi_V2;

%------------SISTEMA------------------%

% Cambio de local a sistema

T1 = [1 , zeros(1,length(MODOS_V1)+1);...
      zeros(1,length(MODOS_V1)+2);...
      0 , 1 , zeros(1,length(MODOS_V1));...
      zeros(length(MODOS_V1),2), eye(length(MODOS_V1));...
      zeros(length(MODOS_V2),length(MODOS_V1)+2)];
  
T2 = [zeros(1,length(MODOS_V2)+2);...
      1 , zeros(1,length(MODOS_V2)+1);... 
      0 , 1 , zeros(1,length(MODOS_V2));... 
      zeros(length(MODOS_V1),length(MODOS_V2)+2);...
      zeros(length(MODOS_V2),2) , eye(length(MODOS_V2))];
  
M_CB_V1_S = T1*M_CB_V1*T1';
K_CB_V1_S = T1*K_CB_V1*T1';

M_CB_V2_S = T2*M_CB_V2*T2';
K_CB_V2_S = T2*K_CB_V2*T2';

M_CB = M_CB_V1_S + M_CB_V2_S;
K_CB = K_CB_V1_S + K_CB_V2_S;  

psi  = T1*psi_V1*T1' + T2*psi_V2*T2';

% APLICACION DE LA CARGA

F_B     = zeros(size(psi_V1,2),1);
F_B(27) = -1;
F_CB    = T1*psi_V1'*F_B;
 
% IMPOSICION CC - EMPOTRAMIENTO EN AMBAS VIGAS Y CARGAS

M_CB = M_CB(3:end,3:end);
K_CB = K_CB(3:end,3:end);
psi  = psi(3:end,3:end);
F_CB = F_CB(3:size(psi,2));

% REDUCCION de C-B

modos1 = 20;
modos2 = 20;

ind_k = [1 2:2+modos1-1 51:51+modos2-1];

M_CB    = M_CB(ind_k,ind_k);
K_CB    = K_CB(ind_k,ind_k);
F_CB    = F_CB(ind_k);
psi     = psi(:,ind_k);

% RESPUESTA

omega = linspace(0,2000,2001)*(2*pi);

Qd_CB = zeros(size(psi,1)+2,1);
Qv_CB = zeros(size(psi,1)+2,1);
Qa_CB = zeros(size(psi,1)+2,1);

for i = 1:length(omega)
     
    Qd_CB(:,i)   = [0; 0; psi*((-omega(i)^2.*M_CB + K_CB)\F_CB);];
    Qd_RMS_CB(i) = sqrt(sum(Qd_CB(:,i).^2)/(length(psi)+2));
    
    Qv_CB(:,i)   = omega(i)*Qd_CB(:,i);
    Qv_RMS_CB(i) = sqrt(sum(Qv_CB(:,i).^2)/(length(psi)+2));
    
    Qa_CB(:,i)   = -omega(i)^2*Qd_CB(:,i);
    Qa_RMS_CB(i) = sqrt(sum(Qa_CB(:,i).^2)/(length(psi)+2));

end

% FRECUENCIAS Y MODOS PROPIOS

[MODOS_CB,omega_CB]  = eig(K_CB,M_CB,'vector');
[omega_CB, ind]      = sort(sqrt(omega_CB)/(2*pi));
MODOS_CB             = MODOS_CB(:,ind);

% FIGURAS

figure()
loglog(omega/(2*pi),Qd_RMS_completo)
hold on
loglog(omega/(2*pi),Qd_RMS_CB)
grid on
box on
xlabel('f [Hz]')
ylabel('q_d RMS [m]')

figure()
loglog(omega/(2*pi),Qv_RMS_completo)
hold on
loglog(omega/(2*pi),Qv_RMS_CB)
grid on
box on
xlabel('f [Hz]')
ylabel('q_v RMS [m/s]')

figure()
loglog(omega/(2*pi),Qa_RMS_completo)
hold on
loglog(omega/(2*pi),Qa_RMS_CB)
grid on
box on
xlabel('f [Hz]')
ylabel('q_a RMS [m/s^2]')

% %% --------------------PARTE 2----------------------%%
% clear all; clc; close all
% 
% % DATOS
% % Paneles
% rho_p = 2700;  %kg/m3
% E     = 70e9;  %Pa
% nu    = 0.3;
% A     = 1.25;  %m2
% t     = 5e-3;  %m
% dpp   = 50e-3; %m
% D     = (E*t^3)/(12*(1-nu^2)); %Nm
% m     = rho_p*(A*t)/A; %kg/m2
% % Capas de aire
% rho_a = 1.225; %kg/m3
% c     = 343;   %m/s
% V     = A*dpp; %m3
% A_c   = 2*A;   %m2
% L_c   = 2*1 + 2*1.25; %m
% 
% % Densidad modal
% 
% n_p = (A/(4*pi))*sqrt(rho_p*t/D);
% n_a = (V/(pi*c))*(omega/c)^2 + (A_c/(4*c))*(omega/c) + (L_c/(8*c));
% 
% % Potencia radiada
% 
% fc  = (c^2/(2*pi))*(sqrt(m/D));
% f11 = (c^2/(4*fc))*(1+1/(1.25^2));
% 
% if f11 =< fc/2
%     sigma







