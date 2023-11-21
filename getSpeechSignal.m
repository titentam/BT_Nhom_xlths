function [feature_vector,fs] = getSpeechSignal(filename, N_FFT)
    % ??c t?p tin �m thanh
    [audio, fs] = audioread(filename);

    % Chuy?n ??i �m thanh th�nh bi?u di?n t?n s? b?ng FFT
    audio_freq = abs(fft(audio, N_FFT));

    % X�c ??nh c�c v�ng c� n?ng l??ng t?n s? cao
    [~, peaks] = findpeaks(audio_freq);

    % L?c c�c v�ng c� n?ng l??ng t?n s? cao thu?c ph?m vi nguy�n �m
    vowel_range = [100 800];  % Ph?m vi t?n s? nguy�n �m (c� th? ?i?u ch?nh theo nhu c?u)
    vowel_peaks = peaks(peaks >= vowel_range(1) & peaks <= vowel_range(2));

    % Tr�ch xu?t vector ??c tr?ng c?a nguy�n �m
    feature_vector = vowel_peaks;

    % Chu?n h�a vector ??c tr?ng v? ?? d�i c? ??nh (n?u c?n thi?t)
    desired_length = 20;  % ?? d�i mong mu?n c?a vector ??c tr?ng (c� th? ?i?u ch?nh theo nhu c?u)
    if length(feature_vector) < desired_length
        feature_vector = padarray(feature_vector, [0 desired_length - length(feature_vector)], 'post');
    elseif length(feature_vector) > desired_length
        feature_vector = feature_vector(1:desired_length);
    end
end