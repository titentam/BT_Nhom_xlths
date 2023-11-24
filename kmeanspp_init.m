function centroids = kmeanspp_init(data, k)
    % Kh?i t?o ma tr?n centroids v?i k�ch th??c (k, N_FFT)
    centroids = zeros(k, size(data, 2));
    
    % Ch?n ng?u nhi�n m?t ?i?m t? t?p d? li?u l�m ?i?m trung t�m ban ??u (b??c 1)
    centroids(1, :) = data(randi(size(data, 1)), :);
    
    % L?p l?i qu� tr�nh ch?n ?i?m trung t�m cho ?? k l?n (b??c 2 v� 3)
    for i = 2:k
        % T�nh kho?ng c�ch t? m?i ?i?m d? li?u ??n ?i?m trung t�m g?n nh?t ?� ch?n
        distances = pdist2(data, centroids(1:i-1, :), 'squaredeuclidean');
        minDistances = min(distances, [], 2);
        
        % Ch?n m?t ?i?m m?i t? t?p d? li?u v?i x�c su?t t? l? thu?n v?i kho?ng c�ch
        probabilities = minDistances / sum(minDistances);
        selectedIdx = randsample(size(data, 1), 1, true, probabilities);
        centroids(i, :) = data(selectedIdx, :);
    end
end