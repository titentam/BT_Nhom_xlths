% Th? m?c ch?a d? li?u
dataTrainDir = 'DataTrain';

% L?y danh s�ch c�c th? m?c con c?p 1
subDirs = dir(dataTrainDir);
subDirs = subDirs([subDirs.isdir]);  % L?c ch? l?y c�c th? m?c
subDirs = subDirs(3:end);  % B? qua '.' v� '..'

N_FFT = 512;


% Duy?t qua t?ng th? m?c v� ??c file 'a.wav'
filename = ["a"; "e";"i";"o";"u"];
colors = [...
    0 0.4470 0.7410;  % M�u xanh d??ng
    0.8500 0.3250 0.0980;  % M�u cam
    0.9290 0.6940 0.1250;  % M�u v�ng
    0.4940 0.1840 0.5560;  % M�u t�m
    0.4660 0.6740 0.1880   % M�u xanh l� c�y
];

dataDB = []; % export file excel
figure;
hold on;
for j = 1:5
    result = zeros(N_FFT, 1);
    
    for i = 1:length(subDirs)
      
        currentDir = fullfile(dataTrainDir, subDirs(i).name);
        audioFile = fullfile(currentDir, filename(j)+".wav");

        % Ki?m tra xem file 'a.wav' c� t?n t?i kh�ng
        if exist(audioFile, 'file')
            fprintf('Th�ng tin file: %s\n', audioFile);

            y = feature_vector_DB(audioFile,N_FFT);
            %y = Cal_MFCC(audioFile,N_FFT);
            result = result + y;

%             y = feature_vector_DB(audioFile);
%             subplot(5,5,i);
%             plot(y(1:floor(length(y)/2)));
        else
            fprintf('File %s kh�ng t?n t?i.\n', audioFile);
        end 
        
    end
    
    trungbinh = result / length(subDirs);
    N = length(trungbinh);  
    
    %dataDB = [dataDB,trungbinh(1:floor(N/2))];
    dataDB = [dataDB,trungbinh];
    
    plot(trungbinh(1:floor(N/2)), 'Color', colors(j, :));
    
end

legend(filename(1:5), 'Location', 'eastoutside');
title('Feature vector spectrum (dB) ');
xlabel('Frequency');
ylabel('Magnitude (dB)');

dlmwrite('data.csv', dataDB, 'delimiter', ',');  % Ghi ma tr?n vector3 v�o file CSV v?i d?u ph?y l�m d?u ph�n c�ch