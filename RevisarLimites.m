function posValida = RevisarLimites( pos, limiteFrame, limiteTarget, outSpace)
%REVISARLIMITES: Verifica que los nuevos valores de las posiciones de las
%particulas (en X y Y) caigan dentro del espacio de busqueda. Si no es asi 
%realiza unas modificaciones en su posicion para asegurar que esto suceda.

    %Selecciona los indices de aquellos valores que se salieron de su dimension
    %(ya sea en X o en Y)        
    
    condicion = true;
    while condicion
        %Selecciona los indices de los valores que se salen del limite por la izquierda
        bad_index = find(pos <= 0);
            if(outSpace==1)
                pos(bad_index) = 1 - pos(bad_index); %Como un espejo
            else
                pos(bad_index) = 1;%se pone en el limite izquierdo
            end

        %Selecciona los indices de los valores que se salen del limite por la derecha
        bad_index = find(pos > limiteFrame);
            if(outSpace==1)
                pos(bad_index) = limiteFrame - (pos(bad_index) - limiteFrame); %ancho frame menos lo que se salio       
            else
                pos(bad_index) = limiteFrame - limiteTarget; %se pone en el limite derecho
            end

        bad_index = find(pos + limiteTarget > limiteFrame);            
            pos(bad_index) = limiteFrame - (pos(bad_index) + limiteTarget - limiteFrame) - normrnd(0,1);
                                    
        %bad_index = find((pos <= 0) | (pos > (limiteFrame - limiteTarget)));
        bad_index = (pos <= 0) | (pos > (limiteFrame - limiteTarget)); %MAS RAPIDO!!
        condicion = not(isempty(pos(bad_index)));
    end
    posValida = round(pos);
end