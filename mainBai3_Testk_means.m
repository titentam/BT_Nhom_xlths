% Th? m?c ch?a d? li?u
dataTrainDir = 'DataTrain';

% L?y danh s�ch c�c th? m?c con c?p 1
subDirs = dir(dataTrainDir);
subDirs = subDirs([subDirs.isdir]);  % L?c ch? l?y c�c th? m?c
subDirs = subDirs(3:end);  % B? qua '.' v� '..'

N_FFT = 13;

kk =2;
% Duy?t qua t?ng th? m?c v� ??c file 'a.wav'
filename = ["a.wav"; "e.wav";"i.wav";"o.wav";"u.wav"];

dataDB = []; % export file excel
figure;
for j = 1:5
    result = zeros(N_FFT, length(subDirs));
    
    for i = 1:length(subDirs)
      
        currentDir = fullfile(dataTrainDir, subDirs(i).name);
        audioFile = fullfile(currentDir, filename(j));

        % Ki?m tra xem file 'a.wav' c� t?n t?i kh�ng
        if exist(audioFile, 'file')
            fprintf('Th�ng tin file: %s\n', audioFile);
            
            y = Cal_MFCC(audioFile,N_FFT);
            result(:,i) = y;

        else
            fprintf('File %s kh�ng t?n t?i.\n', audioFile);
        end 
        
    end
    
    % thay vi lay trung binh thi dung kmeans
    
    % ch?n c�c ?i?m trung t�m ban ??u
    result = transpose(result);
    [idx, x] = kmeans(result, kk);
    
    
    %dataDB = [dataDB,trungbinh(1:floor(N/2))];
    dataDB = [dataDB,transpose(x)];
    

end


dlmwrite('data.csv', dataDB, 'delimiter', ',');  % Ghi ma tr?n vector3 v�o file CSV v?i d?u ph?y l�m d?u ph�n c�ch


% Th? m?c ch?a d? li?u
dataTrainDir = 'DataTest';

% L?y danh s�ch c�c th? m?c con c?p 1
subDirs = dir(dataTrainDir);
subDirs = subDirs([subDirs.isdir]);  % L?c ch? l?y c�c th? m?c
subDirs = subDirs(3:end);  % B? qua '.' v� '..'



dataDB = csvread('data.csv'); % import file excel

total = 0;
count = 0;
confusion = zeros(5, 5);
for i = 1:length(subDirs)
    currentDir = fullfile(dataTrainDir, subDirs(i).name);
    
    
    for j = 1:5
        audioFile = fullfile(currentDir, filename(j));
        % Ki?m tra xem file 'a.wav' c� t?n t?i kh�ng
        if exist(audioFile, 'file')
            fprintf('Th�ng tin file: %s\n', audioFile);
            
            y = Cal_MFCC(audioFile,N_FFT);
            %y = y(1:floor(length(y)/2)); % 1ay 1 nua thoi
            
            minDistance = 1000000000;
            position = 0;
            for k = 1: 5    
                
                for L =1:kk
                    tmpDistance = euclideanDistance(y,dataDB(:,(k-1)*kk+L));
                    if(minDistance>=tmpDistance)
                        minDistance = tmpDistance;
                        position = k;
                    end
                end
                  
            end
            
            confusion(position, j) = confusion(position, j) + 1;
            
            if(j==position)   
                count = count+1;
            end
                
            total = total+1;
            
        else
            fprintf('File %s kh�ng t?n t?i.\n', audioFile);
        end 
        
    end
    
end

disp(confusion);

fprintf('Ty le: %f\n', count/total);



