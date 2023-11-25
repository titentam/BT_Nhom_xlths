function [voiceSound, fs] = STE(fileName)
    [sound, fs] = audioread(fileName);
    
    sound = sound/ max(abs(sound));
    
    
    % Thông s? c?u hình
    frameDuration = 0.02;
    frameLength = round(frameDuration * fs); % S? m?u trong m?i khung
    
    % Tính toán n?ng l??ng c?a m?i khung âm thanh
    energy = sum(reshape(sound(1:frameLength * floor(length(sound) / frameLength)), frameLength, []).^2);

    % Xác ??nh ng??ng n?ng l??ng
   
    %energyThreshold = mean(energy)*0.3; %bai 3
    energyThreshold = mean(energy); %bai 2

    % Xác ??nh các kho?ng l?ng và nguyên âm d?a trên ng??ng n?ng l??ng
    isVoiced = energy > energyThreshold;

    % L?y ph?n gi?ng nói
    voicedSound = [];
    for i = 1:length(isVoiced)
        if isVoiced(i)
            startSample = (i - 1) * frameLength + 1;
            endSample = i * frameLength;
            voicedSound = [voicedSound; sound(startSample:endSample)];
        end
    end

    % Tr? v? ph?n gi?ng nói và t?n s? l?y m?u
    voiceSound = voicedSound;
end