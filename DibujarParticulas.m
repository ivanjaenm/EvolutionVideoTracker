function [xMidPoint yMidPoint] = DibujarParticulas(imgFrame, Par, wT, hT, howToDraw)
    porc = howToDraw(2);
    if(howToDraw(1)==0)
        %% NO DIBUJAR PARTICULAS
        [x1Avg, y1Avg] = promedio_pesado(Par, porc);
    
    else
        figure (1)
        %% MOSTRAR LAS PARTICULAS
        imshow(imgFrame)
        hold on
        switch(howToDraw(1))
            case 1
                %% PINTAR TODAS LAS PARTICULAS
                nPar = length(Par);
                for i=1:nPar
                    x1 = Par(i, 1);
                    x2 = x1 + wT;
                    y1 = Par(i, 2);
                    y2 = y1 + hT;
                    pintar(x1, x2, y1, y2, '-r')
                end
            case 2
                %% MEJORES Y PEORES PARTICULAS
                peores_particulas(Par, porc, wT, hT, '-r');
                mejores_particulas(Par, porc, wT, hT, '-y');
            case 3
                %% SOLO MEJORES
                mejores_particulas(Par, porc, wT, hT, '-y');
            case 4
                %% SOLO EL PROMEDIO DE LAS MEJORES
        end
        %Pinta la particula promedio del % de las mejores
        [x1Avg, y1Avg] = promedio_pesado(Par, porc);
         pintar(x1Avg, x1Avg+wT, y1Avg, y1Avg+hT, '-b')
        hold off;
    end    
    xMidPoint = round(x1Avg + (wT/2));
    yMidPoint = round(y1Avg + (hT/2));
    
    %fig(1);
    %set(gcf, 'Position', [0 0 300 300])        
    
    %export_fig(sprintf('video%d/plot%d', descriptor, t), '-jpg', '-m1.0');    
end