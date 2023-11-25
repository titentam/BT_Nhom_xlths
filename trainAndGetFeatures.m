function trained_vectors = trainAndGetFeatures(N_FFT)
    % Th? m?c ch?a d? li?u hu?n luy?n
    dataTrainDir = 'DataTrain';

    % L?y danh sách các th? m?c con c?p 1
    subDirs = dir(dataTrainDir);
    subDirs = subDirs([subDirs.isdir]);  % L?c ch? l?y các th? m?c con
    subDirs = subDirs(3:end);  % B? qua '.' và '..'

%     N_FFT = 512;
    filename = ["a.wav"; "e.wav";"i.wav";"o.wav";"u.wav"];
    % Bi?n l?u tr? 5 vector ??c tr?ng
    trained_vectors = zeros(5, N_FFT);

    % Duy?t qua t?ng file âm thanh 'a.wav', 'e.wav',...
    for j = 1:5
        result = zeros(N_FFT, 1);

        for i = 1:length(subDirs)
            currentDir = fullfile(dataTrainDir, subDirs(i).name);
            audioFile = fullfile(currentDir, filename(j));

            % Ki?m tra xem file âm thanh có t?n t?i không
            if exist(audioFile, 'file')
                fprintf('Thông tin file: %s\n', audioFile);

                y = feature_vector_DB(audioFile,N_FFT);
                result = result + y;
            else
                fprintf('File %s không t?n t?i.\n', audioFile);
            end 
        end

        % L?u tr? vector ??c tr?ng sau khi trích xu?t t? d? li?u hu?n luy?n
        trained_vectors(j, :) = result / length(subDirs);
    end
end
