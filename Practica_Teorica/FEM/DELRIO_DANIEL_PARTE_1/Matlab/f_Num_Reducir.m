function red = f_Num_Reducir(frecs, Bandas, Nmin)

    n = zeros(size(Bandas));
    for b = 1:length(Bandas)
        n(b) = length(frecs(frecs>Bandas(b).lower & frecs<Bandas(b).upper));
    end

    N = find(n>=Nmin);
    N = N(1)+1;

    red = length((find(frecs>Bandas(N).lower)));
    h = figure();
        b = bar(n, 'FaceColor', [77, 153, 230]/255);
        b.FaceColor = 'flat';
        b.CData(N-1,:) = [121, 131, 140]/255;
        grid on
        box on
        xlabel('Banda', 'Interpreter', 'Latex')
        ylabel('Numero de frecuencias', 'Interpreter', 'Latex')
        Save_as_PDF(h, ['Figures/Bandas_' num2str(red)], '')
end