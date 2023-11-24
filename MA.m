function [voiceSound, fs] = MA(fileName)
    [sound, fs] = audioread(fileName);
    
    % Th�ng s? c?u h�nh
    frameDuration = 0.025; % ?? d�i khung (25ms)
    frameLength = round(frameDuration * fs); % S? m?u trong m?i khung
    
    % T�nh to�n MA c?a m?i khung �m thanh
    magnitudes = sum((abs(reshape(sound(1:frameLength * floor(length(sound) / frameLength)), frameLength, []))));

    % X�c ??nh ng??ng MA
    maThreshold = mean(magnitudes);

    % X�c ??nh c�c kho?ng l?ng v� nguy�n �m d?a tr�n ng??ng MA
    isVoiced = magnitudes > maThreshold;

    % L?y ph?n gi?ng n�i
    voicedSound = [];
    for i = 1:length(isVoiced)
        if isVoiced(i)
            startSample = (i - 1) * frameLength + 1;
            endSample = i * frameLength;
            voicedSound = [voicedSound; sound(startSample:endSample)];
        end
    end

    % Tr? v? ph?n gi?ng n�i v� t?n s? l?y m?u
    voiceSound = voicedSound;
end