function [ x1Avg, y1Avg ] = promedio_pesado( Par, porcentaje)
    %Obtiene los indices del 25% de las mejores particulas
    peso = 5;        
    nPar = length(Par);
    [~, indx] = sort(Par(:, peso), 'descend');
    indBest = indx(1:round(nPar*porcentaje));    
    
    x1Avg = sum(Par(indBest, 1) .* Par(indBest, peso)) / sum(Par(indBest, peso));
    y1Avg = sum(Par(indBest, 2) .* Par(indBest, peso)) / sum(Par(indBest, peso));    
end