function [z, z1, z2] = f_Solucion_CB(M, K, F, psi, cc, f, red_1, red_2)
    
    % Condiciones de contorno
    M(cc,:) = []; M(:,cc) = [];
    K(cc,:) = []; K(:,cc) = [];
    F(cc) = [];
    psi(cc(1:end),:) = []; psi(:,cc(1:end)) = [];
    
    % Reduccion modos
    if not(red_1) && not(red_2)
        red = [];
    elseif not(red_1>1) && not(red_2)
        red = (50-red_1):50;
    elseif not(red_1) && not(red_2>1)
        red = (109-red_2):109;
    else
        red = [(50-red_1):50 (109-red_2):109];
    end
    
    M(red,:) = []; M(:,red) = [];
    K(red,:) = []; K(:,red) = [];
    F(red) = [];
    psi(:,red) = [];
    
    % Resolver sistema
    w = 2*pi*f;

    % Respuesta permanente
    z = [0; 0; psi*((K - w^2*M)\F)];

    z1 = z([1 3:52]);
    z2 = z([2:3 53:111]);
    
end