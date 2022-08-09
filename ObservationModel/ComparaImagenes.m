%% Calcula las distancias entre histogramas usando diferentes metricas    

function D = ComparaImagenes( vec1, vec2, ancho, alto, opc_obser )
    %Usando producto punto y normas
     %D = sum(h1.*h2) / ( norm(h1)*norm(h2) );
    
    %Usando solo productos punto ("Tanimoto" coefficient)
     %D = sum(h1.*h2) / ( sum(h1.*h1) + sum(h2.*h2) - sum(h1.*h2) );
    
%      if(strcmpi(opc_obser{1}, 'imn'))
%          %Usando Informacion Mutua Normalizada
%          D = GetIMN(vec1, vec2, ancho, alto, opc_obser{2});
%      else
         %Usando la interseccion de histogramas
         Z = [vec1; vec2];
         D = sum(min(Z));   % / min(sum(h1), sum(h2));
%      end
  end