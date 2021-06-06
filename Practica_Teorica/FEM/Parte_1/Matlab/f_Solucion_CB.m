function [z, z1, z2] = f_Solucion_CB(M, K, F, cc, f, red_1, red_2)
    
    % Condiciones de contorno
    M(cc(1:end),:) = []; M(:,cc(1:end)) = [];
    K(cc(1:end),:) = []; K(:,cc(1:end)) = [];
    F(cc(1:end)) = [];

    % Reduccion modos
    red = [1 2:50-red_1 51:109-red_2];
    
    M = M(red, red);
    K= K(red, red);
    F = F(red);
    
    red_1 = [1 2:50-red_1];
    red_2 = [1 (red_1(end)+1):length(F)];

    % Resolver sistema
    w = 2*pi*f;

    % Respuesta permanente
    z = (K - w^2*M)\F;

    z1 = z(red_1);
    z2 = z(red_2);
end