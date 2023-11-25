function distance = euclideanDistance(vector1, vector2)
    % Ki?m tra kích th??c c?a hai vector
    if numel(vector1) ~= numel(vector2)
        error('Hai vector ph?i có cùng kích th??c');
    end

    % Tính kho?ng cách Euclidean
    distance = sqrt(sum((vector1 - vector2).^2));
end