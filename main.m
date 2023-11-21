% Th? m?c ch?a d? li?u
dataTrainDir = 'DataTrain';

% L?y danh sách các th? m?c con c?p 1
subDirs = dir(dataTrainDir);
subDirs = subDirs([subDirs.isdir]);  % L?c ch? l?y các th? m?c
subDirs = subDirs(3:end);  % B? qua '.' và '..'

N_FFT = 2048;


% Duy?t qua t?ng th? m?c và ??c file 'a.wav'
filename = ["a.wav"; "e.wav";"i.wav";"o.wav";"u.wav"];

dataDB = []; % export file excel
figure;
for j = 1:5
    result = zeros(N_FFT, 1);
    
    for i = 1:length(subDirs)
      
        currentDir = fullfile(dataTrainDir, subDirs(i).name);
        audioFile = fullfile(currentDir, filename(j));

        % Ki?m tra xem file 'a.wav' có t?n t?i không
        if exist(audioFile, 'file')
            fprintf('Thông tin file: %s\n', audioFile);

            y = feature_vector_DB(audioFile,N_FFT);
            result = result + y;

%             y = feature_vector_DB(audioFile);
%             subplot(5,5,i);
%             plot(y(1:floor(length(y)/2)));
        else
            fprintf('File %s không t?n t?i.\n', audioFile);
        end 
        
    end
    
    trungbinh = result / length(subDirs);
    N = length(trungbinh);  
    
    dataDB = [dataDB,trungbinh(1:floor(N/2))];

    
    subplot(5,1,j);
    plot(trungbinh(1:floor(N/2)));
    title('Feature vector spectrum (dB) ' + filename(j) );
    xlabel('Frequency');
    ylabel('Magnitude (dB)');
end

dlmwrite('data.csv', dataDB, 'delimiter', ',');  % Ghi ma tr?n vector3 vào file CSV v?i d?u ph?y làm d?u phân cách