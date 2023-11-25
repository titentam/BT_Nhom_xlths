

filename = ["a.wav"; "e.wav";"i.wav";"o.wav";"u.wav"];
rates = cell(1, 5);
rates{1,1} = "Rate";
results = cell(6, 6);
for i = 1:size(results, 1)-1
        for j = 2:size(results, 2) 
            results{i, j} = 0; 
        end
end
for kk =2:5
% Th? m?c ch?a d? li?u
dataTrainDir = 'DataTrain';

% L?y danh sách các th? m?c con c?p 1
subDirs = dir(dataTrainDir);
subDirs = subDirs([subDirs.isdir]);  % L?c ch? l?y các th? m?c
subDirs = subDirs(3:end);  % B? qua '.' và '..'

N_MFCC = 13;
dataDB = []; % export file excel

for j = 1:5
    result = zeros(N_MFCC, length(subDirs));
    
    for i = 1:length(subDirs)
      
        currentDir = fullfile(dataTrainDir, subDirs(i).name);
        audioFile = fullfile(currentDir, filename(j));

        % Ki?m tra xem file 'a.wav' có t?n t?i không
        if exist(audioFile, 'file')
            %fprintf('Thông tin file: %s\n', audioFile);
            
            y = Cal_MFCC(audioFile,N_MFCC);
            result(:,i) = y;

        else
            fprintf('File %s không t?n t?i.\n', audioFile);
        end 
        
    end
    
    % thay vi lay trung binh thi dung kmeans
    result = transpose(result);
    
    nums = size(result,1);
    shift = floor(nums/(kk+1));
    fixedCentroids =zeros(kk,N_MFCC);
    for i = 1:kk
        fixedCentroids(i,:) = result(i*shift,:);
    end
    
    [x,~,~,~] = v_kmeans(result,kk,fixedCentroids,5000);
    
    
    %dataDB = [dataDB,trungbinh(1:floor(N/2))];
    dataDB = [dataDB,transpose(x)];
    

end


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
for i = 1:length(subDirs)
    currentDir = fullfile(dataTrainDir, subDirs(i).name);
    
    
    for j = 1:5
        audioFile = fullfile(currentDir, filename(j));
        % Ki?m tra xem file 'a.wav' có t?n t?i không
        if exist(audioFile, 'file')
            %fprintf('Thông tin file: %s\n', audioFile);
            
            y = Cal_MFCC(audioFile,N_MFCC);
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
            if kk == 3
                results{j,position+1} = results{j,position+1} + 1;
            end
            
            total = total+1;
            
        else
            fprintf('File %s không t?n t?i.\n', audioFile);
        end 
        
    end
    
end

%disp(confusion);


rates{1,kk} = count/total;
fprintf('Ty le: %f\n', count/total);

end
columnNames = {'total','k_2', 'k_3', 'k_4', 'k_5'};
rateTable = cell2table(rates, 'VariableNames', columnNames);
excelFileName = sprintf('Rates.xlsx');
writetable(rateTable, excelFileName);

results{1,1} = 'am_a';
results{2,1} = 'am_e';
results{3,1} = 'am_i';
results{4,1} = 'am_o';
results{5,1} = 'am_u';
results{6,1} = 'ty_le_chung';
results{6,2} = rates{1,3};
columnNames = {'nhan_dung_vs_nhan_dinh','am_a', 'am_e', 'am_i', 'am_o', 'am_u'};
resultTable = cell2table(results, 'VariableNames', columnNames);
excelFileName = sprintf('Results.xlsx'); 
writetable(resultTable, excelFileName);

excel = actxserver('Excel.Application');
excel.Workbooks.Open(fullfile(pwd, excelFileName));
excel.Visible = true;
sheet = excel.ActiveSheet;

% In ??m ô F6 (5,6)
highlightCell = sheet.Range('F6'); 
highlightCell.Font.Bold = true;

% In ??m ô C3 (2,3)
highlightCell = sheet.Range('C3'); 
highlightCell.Font.Italic = true;

% L?u l?i và ?óng file Excel
excel.ActiveWorkbook.Save;
% excel.ActiveWorkbook.Close;
% excel.Quit;
% excel.Visible = false;