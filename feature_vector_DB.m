function feature_vector_db = feature_vector_DB(fileName, N_FFT)
    [x, fs] = STE(fileName);
    x = x / max(abs(x));
    
    M = 3; % S? ?o?n c?n chia
    segment_length = floor(length(x) / M);
    
    start_index = floor((M - 1) * segment_length / 2) + 1;
    end_index = start_index + segment_length - 1;
    
    segment_x = x(start_index:end_index);
    
    frame_length = 0.02 * fs;
    hop_size = 0.01 * fs;
    
    frames = buffer(segment_x, frame_length, hop_size, 'nodelay');
    
    num_frames = size(frames, 2);
    
    fft_result = fft(frames, N_FFT);
    feature_vector = sum(abs(fft_result), 2) / num_frames;
    
    feature_vector_db = 20 * log10(abs(feature_vector));
end