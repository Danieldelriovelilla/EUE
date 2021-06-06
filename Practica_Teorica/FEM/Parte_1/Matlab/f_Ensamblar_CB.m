function [vigas] = f_Ensamblar_CB(M1, K1, F1, psi1, M2, K2, F2, psi2, Ni)

    gdl_1 = length(M1);
    gdl_2 = length(M2);
    % Inicializar matrices
    M = zeros(gdl_1 + gdl_2 - 1);
    K = zeros(gdl_1 + gdl_2 - 1);
    psi = zeros(gdl_1 + gdl_2 - 1);
    F = zeros(gdl_1 + gdl_2 - 1, 1);
    
    % Construir vector de posiciones
    pos_1 = [1, 3:(gdl_1+1)];    
    pos_2 = [2:3, (pos_1(end)+1):length(M)];

    
    % Ensamblar matrices
    M(pos_1,pos_1) = M(pos_1,pos_1) + M1;
    M(pos_2,pos_2) = M(pos_2,pos_2) + M2;
    
    K(pos_1,pos_1) = K(gdl_1,gdl_1) + K1;
    K(pos_2,pos_2) = K(pos_2,pos_2) + K2;
    
    F(pos_1) = F(pos_1) + F1;
    F(pos_2) = F(pos_2) + F2;
    
    psi(pos_1,pos_1) = psi(gdl_1,gdl_1) + psi1;
    psi(pos_2,pos_2) = psi(pos_2,pos_2) + psi2;
    
    % Crear Struct del sistema ensamblado
    vigas = struct('M', M, 'K', K, 'F', F, 'psi', psi, 'gdl', 1:length(M));
    
end

