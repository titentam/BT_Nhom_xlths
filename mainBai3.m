% Th? m?c ch?a d? li?u
dataTrainDir = 'DataTrain';

% L?y danh sách các th? m?c con c?p 1
subDirs = dir(dataTrainDir);
subDirs = subDirs([subDirs.isdir]);  % L?c ch? l?y các th? m?c
subDirs = subDirs(3:end);  % B? qua '.' và '..'

N_FFT = 13;
frame_length = 22;
frame_shift = 12;


% Duy?t qua t?ng th? m?c và ??c file 'a.wav'
filename = ["a.wav"; "e.wav";"i.wav";"o.wav";"u.wav"];
colors = [...
    0 0.4470 0.7410;  % Màu xanh d??ng
    0.8500 0.3250 0.0980;  % Màu cam
    0.9290 0.6940 0.1250;  % Màu vàng
    0.4940 0.1840 0.5560;  % Màu tím
    0.4660 0.6740 0.1880   % Màu xanh lá cây
];
dataDB = []; % export file excel
figure;
hold on;
for j = 1:5
    result = zeros(N_FFT, 1);
    
    for i = 1:length(subDirs)
      
        currentDir = fullfile(dataTrainDir, subDirs(i).name);
        audioFile = fullfile(currentDir, filename(j));

        % Ki?m tra xem file 'a.wav' có t?n t?i không
        if exist(audioFile, 'file')
            fprintf('Thông tin file: %s\n', audioFile);
            
            y = Cal_MFCC(audioFile,N_FFT,frame_length,frame_shift);
            result = result + y;

        else
            fprintf('File %s không t?n t?i.\n', audioFile);
        end 
        
    end
    
    trungbinh = result / length(subDirs);
   
    %dataDB = [dataDB,trungbinh(1:floor(N/2))];
    dataDB = [dataDB,trungbinh];
    
    plot(trungbinh, 'Color', colors(j, :));
end
legend(filename(1:5), 'Location', 'eastoutside');
title('Feature vector spectrum ');
xlabel('N MFCC');
ylabel('Magnitude');

dlmwrite('data.csv', dataDB, 'delimiter', ',');  % Ghi ma tr?n vector3 vào file CSV v?i d?u ph?y làm d?u phân cách


% Th? m?c ch?a d? li?u
dataTrainDir = 'DataTest';

% L?y danh sách các th? m?c con c?p 1
subDirs = dir(dataTrainDir);
subDirs = subDirs([subDirs.isdir]);  % L?c ch? l?y các th? m?c
subDirs = subDirs(3:end);  % B? qua '.' và '..'



dataDB = csvread('data.csv'); % import file excel

total = 0;
count = 0;
confusion = zeros(5, 5);
tables = cell(22,6);
for i = 1:size(tables, 1)-1 
        for j = 2:size(tables, 2) 
            tables{i, j} = 0; 
        end
end
for i = 1:length(subDirs)
    currentDir = fullfile(dataTrainDir, subDirs(i).name);
    
    
    for j = 1:5
        audioFile = fullfile(currentDir, filename(j));
        % Ki?m tra xem file 'a.wav' có t?n t?i không
        if exist(audioFile, 'file')
            fprintf('Thông tin file: %s\n', audioFile);
            
            y = Cal_MFCC(audioFile,N_FFT,frame_length,frame_shift);
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
            if position == j
                    tables{i,j+1} = 1;
            end
            tables{i,1} = subDirs(i).name;
%             results{j,position+1} = results{j,position+1} + 1;
            confusion(position, j) = confusion(position, j) + 1;
            
            if(j==position)   
                count = count+1;
            end
                
            total = total+1;
            
        else
            fprintf('File %s không t?n t?i.\n', audioFile);
        end 
        
    end
    
end
% results{1,1} = 'am_a';
% results{2,1} = 'am_e';
% results{3,1} = 'am_i';
% results{4,1} = 'am_o';
% results{5,1} = 'am_u';
% results{6,1} = 'rate';
% results{6,2} = count/total;
tables{22,1} = 'rate';
tables{22,2} = count/total;
columnNames = {'ten_file','am_a', 'am_e', 'am_i', 'am_o', 'am_u'};
% resultTable = cell2table(results, 'VariableNames', columnNames);
% excelFileName = sprintf('Results.xlsx');
% writetable(resultTable, excelFileName);

tableTable = cell2table(tables, 'VariableNames', columnNames);
excelFileNameTable = sprintf('Ketqua_nhandangBai3.xlsx');
writetable(tableTable, excelFileNameTable);
    
disp(confusion);
fprintf('Ty le: %f\n', count/total);




