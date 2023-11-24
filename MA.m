function [voiceSound, fs] = MA(fileName)
    [sound, fs] = audioread(fileName);
    
    % Thông s? c?u hình
    frameDuration = 0.025; % ?? dài khung (25ms)
    frameLength = round(frameDuration * fs); % S? m?u trong m?i khung
    
    % Tính toán MA c?a m?i khung âm thanh
    magnitudes = sum((abs(reshape(sound(1:frameLength * floor(length(sound) / frameLength)), frameLength, []))));

    % Xác ??nh ng??ng MA
    maThreshold = mean(magnitudes);

    % Xác ??nh các kho?ng l?ng và nguyên âm d?a trên ng??ng MA
    isVoiced = magnitudes > maThreshold;

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