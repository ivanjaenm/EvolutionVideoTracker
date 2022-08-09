function Par = Resampling( P )
    [nPar, nAtrib] = size(P);          %Calcula el numero de particulas
    r = (1.0/nPar)*rand(1);    %Genera un aleatorio entre 0 y 1/N    
    peso = 5; %posicion de los pesos en la matriz
    c = P(1, peso); %Carga en C el primer peso
    i = 1;
    
    %Inicializa particula a regresar
    Par = zeros(nPar, nAtrib);
    
    for j=1:nPar
        u = r + (j - 1)*(1.0/nPar);
        while(u > c)
            i = i + 1;
            c = c + P(i, peso);
        end
        
        Par(j, :) = P(i, :); %Llena el array de particulas 
        %
        Par(j, nAtrib) = 1/nPar;
    end
end