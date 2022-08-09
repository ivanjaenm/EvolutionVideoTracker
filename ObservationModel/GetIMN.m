function IMN = GetIMN(vecClasA, vecClasB, ancho, alto, NBins)
    
    Hxy = zeros(NBins^3, NBins^3);

    for i=1:length(vecClasA)
        x = vecClasA(i) + 1;
        y = vecClasB(i) + 1;
        Hxy(x, y) = Hxy(x, y) + 1;
    end

    Hxy = Hxy ./ (ancho*alto);      %Matriz de entropia conjunta

    tam = length(Hxy);
    H = 0;
    IM = 0;

    vecLimits = (0:(NBins^3))-0.5; % Limits
    
    vecHistA = histc(vecClasA, vecLimits); % Histograma 1
    vecHistB = histc(vecClasB, vecLimits); % Histograma 2

    Px = vecHistA(1:(end-1)); % 
    Py = vecHistB(1:(end-1)); % Final histograms *****

    Px = Px/sum(Px); % Histogramas normalizados
    Py = Py/sum(Py);
       
    %% Calcular la Informacion Mutua (IM)
    for i=1:tam
        for j=1:tam
            if ( Hxy(i, j) ~= 0 )
                H = H + Hxy(i,j) * log( Hxy(i,j) );
                if ( Px(i)~= 0 && Py(i)~= 0 )
                    IM = IM + Hxy(i,j) * log(Hxy(i,j)/ ( Px(i) * Py(j) ));
                end
            end
        end
    end
        
    IMN = IM/-H;
%     fprintf('IM(X, Y) = %f\n', IM);
%     fprintf('H(X, Y) = %f\n', -H);
%     % Calcular la Informacion Mutua Normalizada (NMI)
%     fprintf('IMN(X, Y) = %f\n', IMN);
    
end