% Th? m?c ch?a d? li?u
dataTrainDir = 'DataTrain';

% L?y danh sách các th? m?c con c?p 1
subDirs = dir(dataTrainDir);
subDirs = subDirs([subDirs.isdir]);  % L?c ch? l?y các th? m?c
subDirs = subDirs(3:end);  % B? qua '.' và '..'

N_FFT = 512;

result = zeros(N_FFT, 1);
% Duy?t qua t?ng th? m?c và ??c file 'a.wav'
for i = 1:length(subDirs)
    currentDir = fullfile(dataTrainDir, subDirs(i).name);
    audioFile = fullfile(currentDir, 'u.wav');
    
    % Ki?m tra xem file 'a.wav' có t?n t?i không
    if exist(audioFile, 'file')
        fprintf('Thông tin file: %s\n', audioFile);
        y = feature_vector_DB(audioFile);
        result = result + y;
    else
        fprintf('File %s không t?n t?i.\n', audioFile);
    end
end

aaa = result / length(subDirs);

N = length(aaa);
figure;
plot(aaa(1:floor(N/2)));
title('Feature vector spectrum (dB)');
xlabel('Frequency');
ylabel('Magnitude (dB)');
