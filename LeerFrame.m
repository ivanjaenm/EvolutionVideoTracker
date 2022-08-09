%% Lee el frame actual (en el tiempo t)
%t: numero de frame de la secuencia
%seq_folder: nombre de la carpeta de la secuencia

function imgFrame = LeerFrame( t, ruta_seq )
    
    if(t < 10)
        str = strcat(ruta_seq, sprintf('img00%d.bmp',t));
    elseif(t < 100)
        str = strcat(ruta_seq, sprintf('img0%d.bmp',t));
        %     elseif(t < 1000)
        %         str = sprintf('./seq_%s/img0%d.bmp', folder, t);      
    else
        str = strcat(ruta_seq, sprintf('img%d.bmp',t));
    end
    imgFrame = imread(str);
end