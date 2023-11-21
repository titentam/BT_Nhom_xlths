function [feature_vector,fs] = getSpeechSignal(filename, N_FFT)
    % ??c t?p tin âm thanh
    [audio, fs] = audioread(filename);

    % Chuy?n ??i âm thanh thành bi?u di?n t?n s? b?ng FFT
    audio_freq = abs(fft(audio, N_FFT));

    % Xác ??nh các vùng có n?ng l??ng t?n s? cao
    [~, peaks] = findpeaks(audio_freq);

    % L?c các vùng có n?ng l??ng t?n s? cao thu?c ph?m vi nguyên âm
    vowel_range = [100 800];  % Ph?m vi t?n s? nguyên âm (có th? ?i?u ch?nh theo nhu c?u)
    vowel_peaks = peaks(peaks >= vowel_range(1) & peaks <= vowel_range(2));

    % Trích xu?t vector ??c tr?ng c?a nguyên âm
    feature_vector = vowel_peaks;

    % Chu?n hóa vector ??c tr?ng v? ?? dài c? ??nh (n?u c?n thi?t)
    desired_length = 20;  % ?? dài mong mu?n c?a vector ??c tr?ng (có th? ?i?u ch?nh theo nhu c?u)
    if length(feature_vector) < desired_length
        feature_vector = padarray(feature_vector, [0 desired_length - length(feature_vector)], 'post');
    elseif length(feature_vector) > desired_length
        feature_vector = feature_vector(1:desired_length);
    end
end