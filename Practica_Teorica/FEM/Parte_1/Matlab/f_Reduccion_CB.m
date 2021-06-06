function [viga_r] = f_Reduccion_CB(vigas, N1, N2)

    M = vigas.M;
    K = vigas.K;
    F = vigas.F;
    
    if not(N1) && not(N2)
    else
        % Reduccion de modos
        if not(N1) && N2>0
            gdl_r = [(111-(N2-1)):111];
        elseif N1>0 && not(N2) 
            gdl_r = [(52-(N1-1)):52];
        else
            gdl_r = [(52-(N1-1)):52 (111-(N2-1)):111];
        end
        M(gdl_r,:) = []; M(:,gdl_r) = [];
        K(gdl_r,:) = []; K(:,gdl_r) = [];
        F(gdl_r) = [];
    end
    
    viga_r.M = M;
    viga_r.K = K;
    viga_r.F = F;

end

