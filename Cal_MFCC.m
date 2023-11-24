function averageMFCC = Cal_MFCC(fileName, N_MFCC)
    % ??c file âm thanh
    [x, fs] = STE(fileName);
    x = x / max(abs(x));

    % Chia thành 3 ph?n và ch? l?y ph?n gi?a
    segmentLength = floor(length(x) / 3);
    startIndex = segmentLength + 1;
    endIndex = 2 * segmentLength;
    audio = x(startIndex:endIndex);

    FRAME_DURATION = 0.02;  % in seconds
    HOP_DURATION = 0.01;    % in seconds

    % Extract frames
    frame_length = round(FRAME_DURATION * fs);
    hop_size = round(HOP_DURATION * fs);
    
    frames = buffer(audio, frame_length, frame_length - hop_size, 'nodelay');
    
    num_frames = size(frames, 2);
    mfcc_result = zeros(N_MFCC,1);
    for i = 1:num_frames
       frameTmp = frames(:,i);
       tmp = melcepst(frameTmp, fs, 'M', N_MFCC);
       mfcc_result = mfcc_result+ transpose(tmp);
    end
  
    averageMFCC = mfcc_result/num_frames;
end
