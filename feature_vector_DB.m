function feature_vector_db = feature_vector_DB(fileName, N_FFT)

    [x, fs] = STE(fileName);
    
    x= x/ max(abs(x));

    % a. Chia vùng ch?a nguyên âm thành 3 ?o?n có ?? dài b?ng nhau
    len_x = length(x);
    M = 3; % S? ?o?n c?n chia
    segment_length = floor(len_x / M);

    % L?y ?o?n n?m gi?a (gi? s? g?m M khung)
    start_index = floor((M - 1) * segment_length / 2) + 1;
    end_index = start_index + segment_length - 1;

    segment_x = x(start_index:end_index);


    % ?? dài c?a m?i frame (20ms)
    frame_length = 0.025 * fs;

    % B??c nh?y gi?a các frame (10ms)
    hop_size = 0.01 * fs;

    frames = buffer(segment_x, frame_length, hop_size, 'nodelay');

    % S? l??ng frame M
    num_frames = size(frames, 2);

    % b. Trích xu?t vector FFT c?a M khung tín hi?u v?i s? chi?u là N_FFT
%     N_FFT = 512; % Ch?n s? chi?u FFT

    % Kh?i t?o vector ??c tr?ng
    feature_vector = zeros(N_FFT, 1);
    for i = 1:num_frames

        % Trích xu?t vector FFT c?a khung
        fft_result = fft(frames(:, i), N_FFT);

        % C?ng d?n vào vector ??c tr?ng
        feature_vector = feature_vector + abs(fft_result);
    end

    % Tính trung bình c?ng
    feature_vector = feature_vector / num_frames;


   feature_vector_db = 20 * log10(abs(feature_vector));
    
    % return 
    feature_vector_db = feature_vector_db;

end

