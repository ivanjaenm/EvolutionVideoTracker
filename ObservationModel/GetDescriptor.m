function  vector = GetDescriptor(imgRGB, xStart, yStart, ancho, alto, opc_obser)

    xEnd = xStart + ancho - 1;
    yEnd = yStart + alto - 1;
    NBins = opc_obser{2};

    switch lower(opc_obser{1})        
        case 'rgb'
            %% Histograma RGB
            imagen = imgRGB;
            lonW = 256/NBins; % 256: It avoids error...
            % Each row = Each pixel
            vecImg = double( [reshape(imagen(yStart:yEnd, xStart:xEnd, 1), alto*ancho, 1)...
                              reshape(imagen(yStart:yEnd, xStart:xEnd, 2), alto*ancho, 1)...
                              reshape(imagen(yStart:yEnd, xStart:xEnd, 3), alto*ancho, 1)] );                  

            vecInt = floor(vecImg ./ lonW); % It convers to 0 2 0, 1 0 2, 2 1 1, etc...
            vecClas = vecInt(:,1) + vecInt(:,2).*NBins + vecInt(:,3).*(NBins^2); % It converts to [0 (NBins^3)-1]
            
            vecLimits = (0:(NBins^3))-0.5; % Limits
            vecHistAux = histc(vecClas, vecLimits); % Counting values
            H = vecHistAux(1:(end-1)); % Final histogram *****            
            
            vector = H'/sum(H);
                    
        case 'hsv'
            %% Histograma HSV
            %convierte el espacio de color RGB to HSV
            imagen = rgb2hsv(imgRGB);
            lonH = 1/18;
            lonS = 1/3;
            lonV = 1/3;
            % Each row = Each pixel
            vecImg = double( [reshape(imagen(yStart:yEnd, xStart:xEnd, 1), alto*ancho, 1)...
                reshape(imagen(yStart:yEnd, xStart:xEnd, 2), alto*ancho, 1)...
                reshape(imagen(yStart:yEnd, xStart:xEnd, 3), alto*ancho, 1)] );

            vecHue = floor(vecImg(:,1) ./ lonH);
            vecSat = floor(vecImg(:,2) ./ lonS);
            vecVal = floor(vecImg(:,3) ./ lonV);

            vecClas = vecHue.*9 + vecSat.*3 + vecVal; % It converts to [0 (NBins^3)-1]

            H = hist(vecClas, 162); % Counting values
            vector = H/sum(H);
                    
        case 'hs'
            %% Histograma HS
            imagen = rgb2hsv(imgRGB);
            
            lonH = 1/NBins;
            lonS = 1/NBins;            
            % Each row = Each pixel
            vecImg = double( [reshape(imagen(yStart:yEnd, xStart:xEnd, 1), alto*ancho, 1)...
                reshape(imagen(yStart:yEnd, xStart:xEnd, 2), alto*ancho, 1)] );

            vecHue = floor(vecImg(:,1) ./ lonH);
            vecSat = floor(vecImg(:,2) ./ lonS);
            
            vecClas = vecHue.*10 + vecSat; % It converts to [0 (NBins^3)-1]

            H = hist(vecClas, NBins*NBins); % Counting values
            vector = H/sum(H);
            
        case 'imn'                      
            %% Coeficiente de Informacion Mutua Normalizada            
            imagen = imgRGB;
            lonW = 256/NBins; % 256: It avoids error...
            vecImg = double( [reshape(imagen(yStart:yEnd, xStart:xEnd, 1), alto*ancho, 1)...
                              reshape(imagen(yStart:yEnd, xStart:xEnd, 2), alto*ancho, 1)...
                              reshape(imagen(yStart:yEnd, xStart:xEnd, 3), alto*ancho, 1)] );
            vecInt = floor(vecImg ./ lonW); % It convers to 0 2 0, 1 0 2, 2 1 1, etc...
            vector = vecInt(:,1) + vecInt(:,2).*NBins + vecInt(:,3).*(NBins^2); % It converts to [0 (NBins^3)-1]
            
        otherwise
    end    
end