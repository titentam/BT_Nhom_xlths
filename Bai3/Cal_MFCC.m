function averageMFCC = Cal_MFCC(fileName, N_MFCC,frame_length,frame_shift)
    % ??c file âm thanh
    [x, fs] = STE3(fileName);
    x = x / max(abs(x));

    % Chia thành 3 ph?n và ch? l?y ph?n gi?a
    segmentLength = floor(length(x) / 3);
    startIndex = segmentLength + 1;
    endIndex = 2 * segmentLength;
    audio = x(startIndex:endIndex);

    % Extract frames
    frame_overlap = (frame_length-frame_shift) * fs*0.001;
    frame_length = frame_length * fs*0.001;
    
    frames = buffer(audio, frame_length, frame_overlap, 'nodelay');
    
    num_frames = size(frames, 2);
    
    mfcc_result = zeros(N_MFCC,1);
    for i = 1:num_frames
        
       frameTmp = frames(:,i);
       tmp = melcepst(frameTmp, fs, 'M', N_MFCC);
       mfcc_result = mfcc_result+ transpose(tmp);
    end
  
    averageMFCC = mfcc_result/num_frames;
end
