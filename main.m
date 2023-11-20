% Th? m?c ch?a d? li?u
dataTrainDir = 'DataTrain';

% L?y danh s�ch c�c th? m?c con c?p 1
subDirs = dir(dataTrainDir);
subDirs = subDirs([subDirs.isdir]);  % L?c ch? l?y c�c th? m?c
subDirs = subDirs(3:end);  % B? qua '.' v� '..'

N_FFT = 512;

result = zeros(N_FFT, 1);
% Duy?t qua t?ng th? m?c v� ??c file 'a.wav'
for i = 1:length(subDirs)
    currentDir = fullfile(dataTrainDir, subDirs(i).name);
    audioFile = fullfile(currentDir, 'u.wav');
    
    % Ki?m tra xem file 'a.wav' c� t?n t?i kh�ng
    if exist(audioFile, 'file')
        fprintf('Th�ng tin file: %s\n', audioFile);
        y = feature_vector_DB(audioFile);
        result = result + y;
    else
        fprintf('File %s kh�ng t?n t?i.\n', audioFile);
    end
end

aaa = result / length(subDirs);

N = length(aaa);
figure;
plot(aaa(1:floor(N/2)));
title('Feature vector spectrum (dB)');
xlabel('Frequency');
ylabel('Magnitude (dB)');
