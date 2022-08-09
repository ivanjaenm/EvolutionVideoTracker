function pintar( x1, x2, y1, y2, color)            
    plot([x1 x2], [y1, y1], color, 'Linewidth', 1);
    plot([x1 x1], [y1, y2], color, 'Linewidth', 1);
    plot([x1 x2], [y2, y2], color, 'Linewidth', 1);
    plot([x2 x2], [y1, y2], color, 'Linewidth', 1);           
end

