clc
close all
clear all




%% OFFSET





%% MARGIN OF SECURITY

Kp = 1.1;
Km = 1.2;
Kld = 1.1;
FOSY = 1.1;
FOSU = 1.25;

% Titanium
mat = 1;
switch mat
    case 1
        sigmay = 448e6;    % Pa
        sigmau = 523e6;    % Pa
    case 2
        sigmay = 1000e6;    % Pa
        sigmau = 1170e6;    % Pa
end

sigmavm = 9.70e7;   % Pa


MoSy = sigmay /( sigmavm*Kp*Km*Kld*FOSY ) - 1
MoSu = sigmau /( sigmavm*Kp*Km*Kld*FOSU ) - 1


