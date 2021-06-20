function [sigma] = f_Eficiencia_Radiacion(panel, aire, f)

    % Frecuencia critica
    fc = ( aire.a^2/(2*pi) )*sqrt(panel.m/panel.D);
    % Primera modo superficial de la placa
    f11 = ( aire.a^2/(4*fc) )*( 1/panel.Lx^2 + 1/panel.Ly^2 );
    
    lam = sqrt(f/fc);

    % Eficiencia
    sigma = [];
    if f11 <= fc/2
        
        % f < f11
        idx = find(f<f11);
        sigma = cat(1,sigma,...
            4*panel.A^2*( f(idx)/aire.a ).^2);
        
        % f11 < f < fc/2
        idx = find(f11<f&f<fc/2);
        sigma = cat(1,sigma,...
            aire.a*panel.P/(panel.A*fc).*...
            ( (1-lam(idx).^2).*log((1+lam(idx))./(1-lam(idx))) + 2*lam(idx) )./...
            ( 4*pi^2*(1-lam(idx).^2).^(3/2) ) +...
            2*( 2*aire.a/(fc*pi^2) ).^2.*(1-2*lam(idx).^2)./...
            ( panel.A*lam(idx).*sqrt(1-lam(idx).^2) ));
         
         % fc/2 < f < fc
         idx = find(fc/2<f&f<fc);
         sigma = cat(1,sigma,...
            aire.a*panel.P/(panel.A*fc).*...
            ( (1-lam(idx).^2).*log((1+lam(idx))./(1-lam(idx))) + 2*lam(idx) )./...
            ( 4*pi^2*(1-lam(idx).^2).^(3/2) ));
        
         % f >= fc
         idx = find(f>=fc);
         sigma = cat(1,sigma,...
             1./sqrt( 1 - fc./f(idx) ) );
        
    else
        % f < fc
        idx = find(f<fc);
        sigma = cat(1,sigma,...
            4*panel.A^2*( f(idx)/aire.a ).^2);
        
         % f >= fc
         idx = find(f>=fc);
         sigma = cat(1,sigma,...
             1./sqrt( 1 - fc./f(idx) ) );
        
    end

end

