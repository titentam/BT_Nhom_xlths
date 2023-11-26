function feature_vector_db = feature_vector_DB(fileName, N_FFT,frame_length,frame_shift)
    % Check if the file exists
    if ~exist(fileName, 'file')
        error('File not found: %s', fileName);
    end

    % Load the audio file and get the signal and sampling rate
    [x, fs] = STE(fileName);
    x = x / max(abs(x));

    % Define constants
    NUM_SEGMENTS = 3;
    
    % Segment the signal
    segment_length = floor(length(x) / NUM_SEGMENTS);
    start_index = floor((NUM_SEGMENTS - 1) * segment_length / 2) + 1;
    end_index = start_index + segment_length - 1;
    segment_x = x(start_index:end_index);

    % Extract frames
    frame_overlap = (frame_length-frame_shift) * fs*0.001;
    frame_length = frame_length * fs*0.001;
    
    frames = buffer(segment_x, frame_length, frame_overlap, 'nodelay');
    
    num_frames = size(frames, 2);
    feature_vector = zeros(N_FFT, 1);
    
    window = hamming(frame_length);
    for i = 1:num_frames
        frame = frames(:, i);
        frame_windowed = frame .* window;
        fft_result = fft(frame_windowed, N_FFT);

        feature_vector = feature_vector + abs(fft_result);
    end

    % Tính trung bình c?ng
    feature_vector = feature_vector / num_frames;

    % Convert to decibels
    feature_vector_db = 20 * log10(feature_vector);
end
