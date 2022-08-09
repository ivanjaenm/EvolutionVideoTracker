function [P, it] = PSO( opc_evol, Par, hisTarget, opc_obser, imgFrame, wT, wF, hT, hF, outLimits)    
    %% Tamaño de la poblacion del swarm
    [poblacion, col] = size(Par);
    dim = 2; %Variables(posX y posY)   
    P = Par; %Inicializar particula a regresar

    %% Inicializacion de variables    
    Cs = 1.49618; %Parametro social
    Cc = 1.49618; %Parametro cognitivo
    w = 0.72984;  %Coeficiente de inercia
    
    %% Inicializacion de vectores poblacion, velocidades y fitness
    fitness_pBest = P(:, 5);
    pBest = P;
    vel = rand(poblacion, dim);

    [fitness_gBest, index] = max(P(:, 5));
    gBest = P(index,:);
    
    %% Iteraciones del algoritmo
    Sx = inf;
    Sy = inf;
    it = 0;	%Contador de iteraciones
    while ( it < opc_evol{2} && Sx > 1 && Sy > 1)
        it = it + 1;
        %% Actualizar posicion y velocidad
        for i=1:poblacion

            vel(i, :) = vel(i, :)*w + Cs*rand(1, 2).*( gBest(1, 1:2)-P(i, 1:2) ) + Cc*rand(1, 2).*( pBest(i, 1:2)-P(i, 1:2) );
            P(i, 1:2) = round(P(i, 1:2) + vel(i, :));
            
            %% Revisa los valores que se salieron del espacio de busqueda
            P(i, 1) = RevisarLimites(P(i, 1), wF, wT, outLimits);
            P(i, 2) = RevisarLimites(P(i, 2), hF, hT, outLimits);

            %% Actualizar fitness
            hisParticula = GetDescriptor(imgFrame, P(i, 1), P(i, 2), wT, hT, opc_obser);
            P(i, 5) =  ComparaImagenes(hisTarget, hisParticula, opc_obser);
        end

        for i=1:poblacion
            %% Actualizar la mejor posicion personal (pBest)
            if(P(i, 5) > fitness_pBest(i))
                pBest(i,:) = P(i,:);
                fitness_pBest(i) = P(i, 5);
            end
            %% Actualizar la mejor posicion de toda la poblacion (gBest)
            if(P(i, 5) > fitness_gBest)
                gBest = P(i,:);
                fitness_gBest = P(i, 5);
            end
        end
        %% Calcular la varianza de la nueva poblacion
        Sx = var(P(:, 1));
        Sy = var(P(:, 2));
    end %while   
end
