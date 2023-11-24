function feature_vector_db = feature_vector_DB(fileName, N_FFT)
    % Check if the file exists
    if ~exist(fileName, 'file')
        error('File not found: %s', fileName);
    end

    % Load the audio file and get the signal and sampling rate
    [x, fs] = removeSilence(fileName);
    x = x / max(abs(x));

    % Define constants
    NUM_SEGMENTS = 3;
    FRAME_DURATION = 0.025;  % in seconds
    HOP_DURATION = 0.01;    % in seconds

    % Segment the signal
    segment_length = floor(length(x) / NUM_SEGMENTS);
    start_index = floor((NUM_SEGMENTS - 1) * segment_length / 2) + 1;
    end_index = start_index + segment_length - 1;
    segment_x = x(start_index:end_index);

    % Extract frames
    frame_length = FRAME_DURATION * fs;
    hop_size = HOP_DURATION * fs;
    frames = buffer(segment_x, frame_length, hop_size, 'nodelay');
    
    num_frames = size(frames, 2);
    feature_vector = zeros(N_FFT, 1);
    for i = 1:num_frames

        fft_result = fft(frames(:, i), N_FFT);

        feature_vector = feature_vector + abs(fft_result);
    end

    % Tính trung bình c?ng
    feature_vector = feature_vector / num_frames;

    % Convert to decibels
    feature_vector_db = 20 * log10(feature_vector);
end
