function red = f_Num_Reducir(frecs, Bandas, Nmin)

    n = zeros(size(Bandas));
    for b = 1:length(Bandas)
        n(b) = length(frecs(frecs>Bandas(b).lower & frecs<Bandas(b).upper));
    end

    N = find(n>=Nmin);
    N = N(1)+1;

    red = length((find(frecs>Bandas(N).lower)));

end