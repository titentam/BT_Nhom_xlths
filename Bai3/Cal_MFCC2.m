function averageMFCC = Cal_MFCC2(fileName, N_MFCC, k)
    % ??c file âm thanh
    [x, fs] = STE3(fileName);
    x = x / max(abs(x));

    % Chia thành 3 ph?n và ch? l?y ph?n gi?a
    segmentLength = floor(length(x) / 3);
    audio = x(segmentLength + 1:2 * segmentLength);

    FRAME_DURATION = 0.022;  % in seconds
    HOP_DURATION = 0.014;    % in seconds

    % Extract frames
    frame_length = round(FRAME_DURATION * fs);
    hop_size = round(HOP_DURATION * fs);
    
    frames = buffer(audio, frame_length, frame_length - hop_size, 'nodelay');
    num_frames = size(frames, 2);
    
    % Compute MFCC for all frames
    mfcc_result = melcepst(frames, fs, 'M', N_MFCC);
    
  
    averageMFCC =transpose(mfcc_result);
end