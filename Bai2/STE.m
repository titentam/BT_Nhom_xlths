function [voiceSound, fs] = STE(fileName)
    [sound, fs] = audioread(fileName);
    
    sound = sound/ max(abs(sound));
    
    
    % Th�ng s? c?u h�nh
    frameDuration = 0.02;
    frameLength = round(frameDuration * fs); % S? m?u trong m?i khung
    
    % T�nh to�n n?ng l??ng c?a m?i khung �m thanh
    energy = sum(reshape(sound(1:frameLength * floor(length(sound) / frameLength)), frameLength, []).^2);

    % X�c ??nh ng??ng n?ng l??ng
   
    %energyThreshold = mean(energy)*0.3; %bai 3
    energyThreshold = mean(energy); %bai 2

    % X�c ??nh c�c kho?ng l?ng v� nguy�n �m d?a tr�n ng??ng n?ng l??ng
    isVoiced = energy > energyThreshold;

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