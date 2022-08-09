% BUMDA
function [Par, it] = BUMDA(opc_evol, Par, vecTarget, opc_obser, imgFrame, wT, wF, hT, hF)
    nPar = length(Par);
    
    %Para la seleccion por truncamiento, teta0 se inicializa con el peor valor de apt.  
    teta0 = min(Par(:, 5));
    
    %varianzas de tolerancia
    Sx = inf;
    Sy = inf;
    it = 0;
    
    while(it < opc_evol{2} && Sx > 1 && Sy > 1)
        it = it + 1;
        
        %% Selecciona la cuarta parte de los mejores
         %Obtiene los indices del 25% de las mejores particulas
%         [~, indx] = sort(Par(:, 5), 'descend');
%         indBest = indx(1:round(nPar*0.25));
%         nSelect = Par(indBest, :);

        %% Seleccion por truncamiento
        aptitudes = Par(:, 5);
        greatThanTeta0 = aptitudes(aptitudes >= teta0);
        tetaT = max(teta0, min(greatThanTeta0));
        
        [~, idxSorted] = sort(Par(:, 5), 'descend');
        valMedio = Par(idxSorted(round(nPar/2)), 5);

        if ( valMedio >= tetaT )
            tetaT = valMedio;
        end        
        mejoresApt = aptitudes >= tetaT;   %Selecciona los indices de las apt. mayores o iguales a TetaT        
        nSelect = Par(mejoresApt, :);
        % nSelect(:, 2) = aptitudes(aptitudes >= tetaT)
        % Selecciona el individuo elite
        [~, posElite] = max(Par(mejoresApt, 5));
        elite = nSelect(posElite, :);
        teta0 = tetaT;

        %% Calcular parametros de una normal
        %media
        MU_x = sum(nSelect(:, 5) .* nSelect(:, 1)) / sum(nSelect(:, 5));
        MU_y = sum(nSelect(:, 5) .* nSelect(:, 2)) / sum(nSelect(:, 5));
        %varianza
        S_x =  ( sum(nSelect(:, 5) .* ((nSelect(:, 1) - MU_x)) .* (nSelect(:, 1) - MU_x)) ) ./ sum(Par(:, 5) + 1) ;
        S_y =  ( sum(nSelect(:, 5) .* ((nSelect(:, 2) - MU_y)) .* (nSelect(:, 2) - MU_y)) ) ./ sum(Par(:, 5) + 1) ;
        
        %% Muestrear datos de la normal bivariada(posX, posY)
        NewSamples = round(mvnrnd([MU_x, MU_y], [S_x, 0 ; 0, S_y], nPar-1));
        for i=1:nPar-1
            % Revisar los limites en los puntos generados
            while( NewSamples(i, 1) <= 0 || NewSamples(i, 1) > (wF - wT) || ...
                    NewSamples(i, 2) <= 0 || NewSamples(i, 2) > (hF - hT))
                NewSamples(i, :) = round(mvnrnd([MU_x, MU_y], [S_x, 0 ; 0, S_y], 1));
            end
            %% Actualizar posiciones          
            Par(i, 1) = NewSamples(i, 1);
            Par(i, 2) = NewSamples(i, 2);
            %% Actualiza los pesos de acuerdo a la posicion de cada una
            vecParticula = GetDescriptor(imgFrame, Par(i, 1), Par(i, 2), wT, hT, opc_obser);
            Par(i, 5) = ComparaImagenes(vecTarget, vecParticula, wT, hT, opc_obser);
        end
        %% Insertar el elite
        Par(nPar, :) = elite;
        %% Calcular la varianza de la nueva poblacion                
        Sx = var(Par(:, 1));
        Sy = var(Par(:, 2));
    end
end
