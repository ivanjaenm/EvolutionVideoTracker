%folder = 'coca'; nFrames = 500;
%folder = 'bolita15x15_fast'; nFrames = 867;
%folder = 'bolita15x15_low'; nFrames = 982;
%folder = 'mb'; nFrames = 500;
%folder = 'libro'; nFrames = 200;
%folder = 'ball'; nFrames = 599;
%folder = 'motinas_toni'; nFrames = 429;
%folder = 'cup'; nFrames = 624;
%folder = 'sb'; nFrames = 500;
folder = 'ball_cimat'; nFrames = 500;

nPar = 15;      %Numero de particulas del algoritmo.
maxIter = 100;  %Numero maximo de iteraciones del algoritmo
nBins = 3;     %Numero de intervalos del histograma
howDraw = 2;    %0=Nada, 1=Todas, 2=mejores y peores, 3=solo mejores, 4=Promedio de las mejores,               
compGT = false;  %Comparar contra el Ground Truth?? false=NO, true=SI

corridas=1;

method = 'BUMDA';
varia = 8;      %Ruido para la nueva posicion, 
outSpace = 1;   %0:Colocar en limites, 1: Modo espejo
porc = 1;       %porcentaje de mejores particulas usadas.
for iter=1:corridas
    Tracker(nPar, folder, nFrames, compGT, [howDraw, porc], ...
        {method, maxIter}, {'HSV', nBins}, [varia, outSpace], iter);
end
% % 
% method = 'PF-BUMDA';
% varia = 8;      %Ruido para la nueva posicion, 
% outSpace = 0;   %0:Colocar en limites, 1: Modo espejo
% porc = 0.15;    %porcentaje de mejores particulas usadas.
% for iter=1:corridas
%     Tracker(nPar, folder, nFrames, compGT, [howDraw, porc], ...
%         {method, maxIter}, {'HS', nBins}, [varia, outSpace], iter);
% end

corridas=1;
% 
% method = 'PSO';
% varia = 8;      %Ruido para la nueva posicion, 
% outSpace = 0;   %0:Colocar en limites, 1: Modo espejo
% porc = 0.35;    %porcentaje de mejores particulas usadas.
% for iter=1:corridas
%     Tracker(nPar, folder, nFrames, compGT, [howDraw, porc], ...
%         {method, maxIter}, {'HS', nBins}, [varia, outSpace], iter);
% end
% corridas=30;
% 
% method = 'PF-PSO';
% varia = 8;      %Ruido para la nueva posicion, 
% outSpace = 0;   %0:Colocar en limites, 1: Modo espejo
% porc = 0.30;    %porcentaje de mejores particulas usadas.
% for iter=1:corridas
%     Tracker(nPar, folder, nFrames, compGT, [howDraw, porc], ...
%         {method, maxIter}, {'HS', nBins}, [varia, outSpace], iter);
% end

% method = 'PF';
% varia = 1;      %Ruido para la nueva posicion, 
% outSpace = 0;   %0:Colocar en limites, 1: Modo espejo
% porc = 0.25;    %porcentaje de mejores particulas usadas.
% for iter=1:corridas
%     Tracker(nPar, folder, nFrames, compGT, [howDraw, porc], ...
%         {method, maxIter}, {'hs', nBins}, [varia, outSpace], iter);
% end

