function P = UnirPoblacionPar( Par, ParOpt, M)
    %% Unir ambos grupos de particulas
    nPar = length(Par);
    [~, popPF] = sort(Par(:, 5), 'ascend');
    [~, popOpt] = sort(ParOpt(:, 5), 'descend');
    P1 = Par(popPF, :);
    P2 = ParOpt(popOpt, :);
    P(1:round(M), :) = P2(1:round(M), :);
    P(round(M)+1:nPar, :) = P1(round(M)+1:nPar, :);   

end

