function distance = euclideanDistance(vector1, vector2)
    % Ki?m tra k�ch th??c c?a hai vector
    if numel(vector1) ~= numel(vector2)
        error('Hai vector ph?i c� c�ng k�ch th??c');
    end

    % T�nh kho?ng c�ch Euclidean
    distance = sqrt(sum((vector1 - vector2).^2));
end