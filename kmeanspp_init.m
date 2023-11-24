function centroids = kmeanspp_init(data, k)
    % Kh?i t?o ma tr?n centroids v?i kích th??c (k, N_FFT)
    centroids = zeros(k, size(data, 2));
    
    % Ch?n ng?u nhiên m?t ?i?m t? t?p d? li?u làm ?i?m trung tâm ban ??u (b??c 1)
    centroids(1, :) = data(randi(size(data, 1)), :);
    
    % L?p l?i quá trình ch?n ?i?m trung tâm cho ?? k l?n (b??c 2 và 3)
    for i = 2:k
        % Tính kho?ng cách t? m?i ?i?m d? li?u ??n ?i?m trung tâm g?n nh?t ?ã ch?n
        distances = pdist2(data, centroids(1:i-1, :), 'squaredeuclidean');
        minDistances = min(distances, [], 2);
        
        % Ch?n m?t ?i?m m?i t? t?p d? li?u v?i xác su?t t? l? thu?n v?i kho?ng cách
        probabilities = minDistances / sum(minDistances);
        selectedIdx = randsample(size(data, 1), 1, true, probabilities);
        centroids(i, :) = data(selectedIdx, :);
    end
end