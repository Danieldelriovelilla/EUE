function [mod_prop, frec_prop] = f_Modos(M, K, cc)

    % Condiciones de contorno
    M(cc,:) = []; M(:,cc) = [];
    K(cc,:) = []; K(:,cc) = [];

    % Obtencion de los modos y frecuencias propias^2
    [mod_prop, frec_matrix] = eig( M\K );
    frec_matrix = sqrt(frec_matrix);
    
    frec_matrix = frec_matrix(sub2ind(size(frec_matrix),...
            1:size(frec_matrix,1),1:size(frec_matrix,2)));
    
    [frec_prop,idx] = sort(frec_matrix);
    frec_prop = frec_prop/(2*pi);
    mod_prop = mod_prop(:,idx);

end

