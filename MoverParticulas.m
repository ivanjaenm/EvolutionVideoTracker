function Par = MoverParticulas( P, wT, wF, hT, hF, opc_motion)
    %% Inicializa particulas a regresar
    [fil, col] = size(P);
    Par = zeros(fil, col);
    
    %% Obtiene los valores que trae la Particula en el instante T
    posX = P(:, 1); %Posicion X anterior
    posY = P(:, 2); %Posicion Y anterior    
    velX = P(:, 3); %Velocidad X anterior
    velY = P(:, 4); %Velocidad Y anterior
    
    %% Calcula las nuevas posiciones
    posNuevaX = round( posX + velX + normrnd(0, opc_motion(1), [fil, 1]) ); %Posicion X nueva
    posNuevaY = round( posY + velY + normrnd(0, opc_motion(1), [fil, 1]) ); %Posicion Y nueva
    
%     posNuevaX = round( posX + velX + normrnd(0, 2, [fil, 1]) ); %Posicion X nueva
%     posNuevaY = round( posY + velY + normrnd(0, 2, [fil, 1]) ); %Posicion Y nueva
    
    %% Revisa que los valores de las nuevas posiciones se encuentren dentro
    %%del espacio de busqueda.    
    Par(:, 1) = RevisarLimites(posNuevaX, wF, wT, opc_motion(2));
    Par(:, 2) = RevisarLimites(posNuevaY, hF, hT, opc_motion(2));

    %% Actualiza las demas propiedades de la particula
    Par(:, 3) = Par(:, 1) - posX; %Velocidad X nueva
    Par(:, 4) = Par(:, 2) - posY; %Velocidad Y nueva
    Par(:, 5) = P(:, 5); %El peso no se modifica    
end