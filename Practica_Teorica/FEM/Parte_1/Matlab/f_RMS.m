function [rms_z] = f_RMS(z, f)
    
    % Resolver sistema
    w = 2*pi*f;

    % Valor RMS de posicion, velocidad y aceleracion
    rms_z = [rms(z), rms(w*z), rms(w^2*z)];

end