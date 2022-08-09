function mejores_particulas( Par, porc, wT, hT, color )
    peso = 5;
    nPar = length(Par);
    %Obtiene los indices del % de las mejores particulas
    [~, indx] = sort(Par(:, peso), 'descend');
    indBest = indx(1:round(nPar * porc));
    
    %Pinta las particulas con MAYOR peso = MEJORES
    for i=1:length(indBest)
        val = indx(i);
        x1 = Par(val, 1);
        x2 = x1 + wT;
        y1 = Par(val, 2);
        y2 = y1 + hT;
        pintar(x1, x2, y1, y2, color);
    end
end

