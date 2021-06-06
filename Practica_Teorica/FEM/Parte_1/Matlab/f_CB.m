function [viga] = f_CB(viga, Nb, NI)

    % Orden de los gdl
    Ni = viga.gdl;
    Ni([Nb, NI]) = [];
    gdl_CB = [Nb, NI, Ni];

    % Matrices de masa y rigidez ordenadas
    M = viga.M(gdl_CB,gdl_CB);
    Mff = M(1:3,1:3);
    Mif = M(4:end,1:3);
    Mii = M(4:end,4:end);
    
    K = viga.K(gdl_CB,gdl_CB);
    Kff = M(1:3,1:3);
    Kif = M(4:end,1:3);
    Kii = M(4:end,4:end);
    
    F = viga.F(gdl_CB);
    
    % Matriz de transformacion CB
    phi_s = [eye(size(Mff));...
             -Kii\Kif];

    cc = [];
    [mod_prop, ~] = f_Modos(Mii, Kii, cc);
    phi_i = [zeros(length(Mff),size(mod_prop,1)); mod_prop];

    psi = [phi_s, phi_i];

    M_CB = psi'*M*psi;
    K_CB = psi'*K*psi;
    F_CB = psi'*F;
    
    viga.psi = psi;
    viga.M_CB = M_CB;
    viga.K_CB = K_CB;
    viga.F_CB = F_CB;

end

