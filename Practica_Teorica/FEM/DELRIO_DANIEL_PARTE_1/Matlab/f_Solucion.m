function [z, rms_z] = f_Solucion(M, K, F, cc, f)
    
    % Condiciones de contorno
    M(cc(1:end),:) = []; M(:,cc(1:end)) = [];
    K(cc(1:end),:) = []; K(:,cc(1:end)) = [];
    F(cc(1:end)) = [];

    % Resolver sistema
    w = 2*pi*f;

    % Respuesta permanente
    z = (K - w^2*M)\F;
    z = [zeros(1,1); z; zeros(1,1)];
    
    rms_z = [rms(z), rms(w*z), rms(w^2*z)];

end