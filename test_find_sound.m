% Th? m?c ch?a d? li?u
dataTrainDir = 'DataTest';

% L?y danh sách các th? m?c con c?p 1
subDirs = dir(dataTrainDir);
subDirs = subDirs([subDirs.isdir]);  % L?c ch? l?y các th? m?c
subDirs = subDirs(3:end);  % B? qua '.' và '..'

N_FFT = 512;


% Duy?t qua t?ng th? m?c và ??c file 'a.wav'
filename = ["a.wav"; "e.wav";"i.wav";"o.wav";"u.wav"];



dataDB = csvread('data.csv'); % import file excel

total = 0;
count = 0;
fprintf('Thông tin file: \n');
for i = 1:length(subDirs)
    currentDir = fullfile(dataTrainDir, subDirs(i).name);
   
    for j = 1:5
        audioFile = fullfile(currentDir, filename(j));
        % Ki?m tra xem file 'a.wav' có t?n t?i không
        if exist(audioFile, 'file')
            fprintf('%s', audioFile);
            
            y = feature_vector_DB(audioFile,N_FFT);
            %y = Cal_MFCC(audioFile,N_FFT);
            %y = y(1:floor(length(y)/2)); % 1ay 1 nua thoi
            
            minDistance = 1000000000;
            position = 0;
            for k = 1: 5
                tmpDistance = euclideanDistance(y,dataDB(:,k));
                if(minDistance>=tmpDistance)
                    minDistance = tmpDistance;
                    position = k;
                end
                
            end
            
            if(j==position)
                count = count+1;
                fprintf(': True\n');
            else
                fprintf(': False\n');    
            end
                
            total = total+1;
            
        else
            fprintf('File %s không t?n t?i.\n', audioFile);
        end 
        
    end
    
end

fprintf('Ty le: %f\n', count/total);
