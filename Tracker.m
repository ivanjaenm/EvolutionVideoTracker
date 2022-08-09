%% Version del tracker basado en color
function Tracker(nPar, folder, nFrames, compGT, opc_draw, opc_evol, opc_obser, opc_motion, iter)
    clc
    ruta_seq = sprintf('../secuencias_img/seq_%s/', folder);
    
    %% Leer target
    imgTarget = imread(strcat(ruta_seq, 'imgTarget.bmp'));
    [hT wT cT] = size(imgTarget);               
    %hisTarget = GetColorHistogram(imgTarget, 1, 1, wT, hT, opc_obser);    
    %vecimg1 = CondensarImagen(imgTarget, 1, 1, wT, hT, opc_obser{2});
    vecTarget = GetDescriptor(imgTarget, 1, 1, wT, hT, opc_obser);
    
    %% Leer el primer frame
    imgFrame = LeerFrame(0, ruta_seq);
    [hF wF cF] = size(imgFrame);
    M = nPar/2;
    
    %% Inicializar particulas
    Par = zeros(nPar, 5);
    %Genera posiciones aleatorias
    Par(:, 1) = ceil((wF - wT) .* rand(nPar, 1)); %posX en t
    Par(:, 2) = ceil((hF - hT) .* rand(nPar, 1)); %posY en t
    %Inicializar la velocidad de las particulas a cero
    Par(:, 3) = 0; %Vx
    Par(:, 4) = 0; %Vy
    %Inicializar pesos
    Par(:, 5) = 1/nPar; %Peso uniforme

    if (compGT)
        nameGT = sprintf('GT_seq_%s.txt', folder);
        %Leer el Ground Truth (posiciones optimas del objetivo)
        GT = load(strcat(ruta_seq, nameGT));
        %Almacena las diferencias entre el GT y la posicion de la particula promedio
        res = zeros(nFrames, 5);
        method = upper(opc_evol{1});
        %crea el folder donde se guardaran los resultados de las corridas        
        folder_res = sprintf('res_%s_%s_%d_%s', folder, method, nPar, opc_obser{1});
        if(not(exist('testresults','dir')==7))
            mkdir(folder_res)
        end        
        toFileResult = fopen(sprintf('%s/%s_%s_%d_%d.txt', folder_res, folder, method, nPar, iter), 'w');
    end

    %% Recorre todos los frames de la secuencia
    for t=0:nFrames
    	%% Carga el frame actual
        imgFrame = LeerFrame(t, ruta_seq);
                
        if(not(strcmpi(opc_evol{1}, 'bumda')) &&  not(strcmpi(opc_evol{1}, 'pso')))
            %% Modelo de Transicion (movimiento)      //Lo hace en PF, PF-PSO, PF-BUMDA
            Par = MoverParticulas(Par, wT, wF, hT, hF, opc_motion);
        end
        
        for i=1:nPar
            %% Modelo de Observacion (histograma)
            %hisParticula = GetColorHistogram(imgFrame, Par(i, 1), Par(i, 2), wT, hT, opc_obser);
            %D = ComparaHistogramas(hisTarget, hisParticula);
            
            vecParticula = GetDescriptor(imgFrame, Par(i, 1), Par(i, 2), wT, hT, opc_obser);
            D = ComparaImagenes(vecTarget, vecParticula, wT, hT, opc_obser);                        
         	if(strcmpi(opc_evol{1}, 'bumda') || strcmpi(opc_evol{1}, 'pso'))
             	%Actualizar pesos solo con la distancia entre histogramas
             	Par(i, 5) = D;
            else
%                Actualizar pesos usando el peso anterior
	            Par(i, 5) = Par(i, 5) * D;
            end
        end
        
        if(not( strcmpi(opc_evol{1}, 'pf') ))
            %% Optimiza las posiciones de las particulas
            switch(lower(opc_evol{1}))
                case 'pf-pso'
                    [ParPSO, it] = PSO( opc_evol, Par, vecTarget, opc_obser, imgFrame, wT, wF, hT, hF, opc_motion(2));
                    Par = UnirPoblacionPar(Par, ParPSO, M);
                    
                case 'pf-bumda'
                    [ParBUMDA, it] = BUMDA( opc_evol, Par, vecTarget, opc_obser, imgFrame, wT, wF, hT, hF);
                    Par = UnirPoblacionPar(Par, ParBUMDA, M);
                    
                case 'bumda'
                    [Par, it] = BUMDA( opc_evol, Par, vecTarget, opc_obser, imgFrame, wT, wF, hT, hF);
                    
                case 'pso'
                    [Par, it] = PSO( opc_evol, Par, vecTarget, opc_obser, imgFrame, wT, wF, hT, hF, opc_motion(2));                    

            end
        end
        
        %% Normalizar pesos
        sumaPesos = sum(Par(:, 5));     
        if(sumaPesos == 0)
            Par(:, 5) = 1/nPar;
        else
            Par(:, 5) = Par(:, 5)/ sumaPesos;
        end
        
        %% Dibuja rectangulo del promedio de las particulas de PF y guarda su punto medio
        [xMid, yMid] = DibujarParticulas(imgFrame, Par, wT, hT, opc_draw);
%        fprintf(toFile, '%d\t%d\t%d\n', t, xMid, yMid);

        %% Imprime los resultados obtenidos por el tracker
        if (compGT)
            i = t + 1;
            %fprintf(toArchivo, '%d\t%d\t%d \n', t, xMid, yMid);  
            %Compara posiciones del tracker con el Ground Truth  y Guarda los resultados en archivo
            res(i, 1) = abs(GT(i, 2) - xMid); %Posiciones en X
            res(i, 2) = abs(GT(i, 3) - yMid); %Posiciones en Y

            res(i, 3) = res(i, 1) + res(i, 2);          %Norma L1
            res(i, 5) = (res(i, 1)^2) + (res(i, 2)^2);  %Sum of Squared Error
            %res(i, 5) = sum((Par(:, 1)-GT(i, 2)).^2) + sum((Par(:, 2)-GT(i, 3)).^2);  %Sum of Squared Error del los brasilenos
            res(i, 4) = sqrt(res(i, 1)^2 + res(i, 2)^2);                %Norma L2 o Distancia Euclidea

            if( strcmpi(opc_evol{1}, 'pf') )
                fprintf(toFileResult, '%d\t%d\t%d\t%d\t%.2f\t%.2f\n', i, xMid, yMid, res(i, 3), res(i, 4), res(i, 5));
                fprintf(1, '%d\t%d\t%d\t%d\t%.2f\t%.2f\n', i, xMid, yMid, res(i, 3), res(i, 4), res(i, 5));            
            else
                fprintf(toFileResult, '%d\t%d\t%d\t%d\t%.2f\t%.2f\t%d\n', i, xMid, yMid, res(i, 3), res(i, 4), res(i, 5), it);
                fprintf(1, '%d\t%d\t%d\t%d\t%.2f\t%.2f\t%d\n', i, xMid, yMid, res(i, 3), res(i, 4), res(i, 5), it);
            end            
            
        else
            if( strcmpi(opc_evol{1}, 'pf') )
                fprintf(1, '%d\t%d\t%d \n', t, xMid, yMid);
            else
                fprintf(1, '%d\t%d\t%d\t%d \n', t, xMid, yMid, it);
            end
        end
        
        if(not(strcmpi(opc_evol{1}, 'bumda')) &&  not(strcmpi(opc_evol{1}, 'pso')))
            %% Resampling: solo lo hace para PF, PF-PSO, PF-BUMDA
            Neff = 1 / sum(Par(:, 5) .^ 2);
            umbral = 0.3*nPar;
            if(Neff < umbral)
                Par = Resampling(Par);
                fprintf('Se hizo resampling\n')
            end
        end
        
        if(strcmpi(opc_evol{1}, 'bumda') || strcmpi(opc_evol{1}, 'pso'))
            %Para la siguiente iteracion
            %% Agrega variabilidad a dichas posiciones
            Par(:, 1) = round( Par(:, 1) + normrnd(0, opc_motion(1), [nPar, 1]) );
            Par(:, 2) = round( Par(:, 2) + normrnd(0, opc_motion(1), [nPar, 1]) );
            
            %% Revisa que las nuevas posiciones esten dentro del espacio de busqueda
            Par(:, 1) = RevisarLimites(Par(:, 1), wF, wT, opc_motion(2));
            Par(:, 2) = RevisarLimites(Par(:, 2), hF, hT, opc_motion(2));
        end
        
        %% Pausa
        %pause
    end
    vecMean = [0,0,0]; %Si no se compara vs GT se devuelve el vector vacio
    if(compGT)
        fprintf(1, 'NORMA L1:\n \t\tMedia=%.4f\n \t\tMediana=%.4f\n \t\tMinimo=%.4f\n', mean( res(:, 3) ), median( res(:, 3) ), min( res(:, 3) ));
        fprintf(1, 'NORMA L2:\n \t\tMedia=%.4f\n \t\tMediana=%.4f\n \t\tMinimo=%.4f\n', mean( res(:, 4) ), median( res(:, 4) ), min( res(:, 4) ));
        fprintf(1, 'SSE:\n \t\tMedia=%.4f\n \t\tMediana=%.4f\n \t\tMinimo=%.4f\n', mean( res(:, 5) ), median( res(:, 5) ), min( res(:, 5) ));
        fclose(toFileResult);
        %vecMean = [mean(res(:, 3)), mean(res(:, 4)), mean(res(:, 5))]; % Media de la Norma L1, L2, y SSE de esta corrida
    end
end
