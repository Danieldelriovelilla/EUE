function [M_CB, K_CB, F_CB, psi] = f_CB(M, K, F, Nb, NI)

    % Orden de los gdl
    Ni = 1:length(M);
    Ni([Nb, NI]) = [];
    gdl_CB = [Nb, NI, Ni];

    % Matrices de masa y rigidez ordenadas
    M = M(gdl_CB,gdl_CB);
    Mff = M(1:2,1:2);
    Mii = M(3:end,3:end);
    
    K = K(gdl_CB,gdl_CB);
    Kif = K(3:end,1:2);
    Kii = K(3:end,3:end);
    
    F = F(gdl_CB);
    
    % Matriz de transformacion CB
    phi_s = [eye(size(Mff));...
             -inv(Kii)*Kif];

    cc = [];
    [mod_prop, ~] = f_Modos(Mii, Kii, cc);
    phi_i = [zeros(length(Mff),size(mod_prop,1)); mod_prop];

    psi = [phi_s, phi_i];

    M_CB = psi'*M*psi;
    K_CB = psi'*K*psi;
    F_CB = psi'*F;
end

