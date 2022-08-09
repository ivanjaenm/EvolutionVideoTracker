function vecClas = CondensarImagen( imagen, xStart, yStart, ancho, alto, NBins)

    xEnd = xStart + ancho - 1;
    yEnd = yStart + alto - 1;

    lonW = 256/NBins; % 256: It avoids error...

    % Each row = Each pixel
    vecImg = double( [reshape(imagen(yStart:yEnd, xStart:xEnd,1), alto*ancho,1)...
        reshape(imagen(yStart:yEnd, xStart:xEnd,2), alto*ancho,1)...
        reshape(imagen(yStart:yEnd, xStart:xEnd,3), alto*ancho,1)] );

    vecInt = floor(vecImg ./ lonW); % It convers to 0 2 0, 1 0 2, 2 1 1, etc...

    vecClas = vecInt(:,1) + vecInt(:,2).*NBins + vecInt(:,3).*(NBins^2); % It converts to [0 (NBins^3)-1]

end

