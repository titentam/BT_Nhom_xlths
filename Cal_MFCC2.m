function averageMFCC = Cal_MFCC2(fileName, N_MFCC, k)
    % ??c file âm thanh
    [x, fs] = STE(fileName);
    x = x / max(abs(x));

    % Chia thành 3 ph?n và ch? l?y ph?n gi?a
    segmentLength = floor(length(x) / 3);
    audio = x(segmentLength + 1:2 * segmentLength);

    FRAME_DURATION = 0.02;  % in seconds
    HOP_DURATION = 0.01;    % in seconds

    % Extract frames
    frame_length = round(FRAME_DURATION * fs);
    hop_size = round(HOP_DURATION * fs);
    
    frames = buffer(audio, frame_length, frame_length - hop_size, 'nodelay');
    num_frames = size(frames, 2);
    
    % Compute MFCC for all frames
    mfcc_result = melcepst(frames, fs, 'M', N_MFCC);
    
    nums = size(mfcc_result,1);
    shift = floor(nums/(k+1));
    fixedCentroids =zeros(k,N_MFCC);
    for i = 1:k
        fixedCentroids(i,:) = mfcc_result(i*shift,:);
    end
    
    % Cluster MFCC using K-means
    [x, ~, idx, ~] = v_kmeans(mfcc_result, k,fixedCentroids,5000);

    % Compute average MFCC for each cluster
    clusterCentroids = zeros(k, N_MFCC);
    for i = 1:k
        clusterPoints = mfcc_result(idx == i, :);
        clusterCentroids(i, :) = mean(clusterPoints);
    end
  
    averageMFCC =transpose(x);
end