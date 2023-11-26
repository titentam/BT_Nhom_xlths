% Th? m?c ch?a d? li?u
dataTrainDir = '../DataTrain';

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
title('Feature vector spectrum (k = 1)');
xlabel('N MFCC');
ylabel('Magnitude');

dlmwrite('data.csv', dataDB, 'delimiter', ',');  % Ghi ma tr?n vector3 vào file CSV v?i d?u ph?y làm d?u phân cách


% Th? m?c ch?a d? li?u
dataTrainDir = '../DataTest';

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
            
            
            y = Cal_MFCC(audioFile,N_FFT,frame_length,frame_shift);
           
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

tables{22,1} = 'rate';
tables{22,2} = count/total;
columnNames = {'ten_file','am_a', 'am_e', 'am_i', 'am_o', 'am_u'};

tableTable = cell2table(tables, 'VariableNames', columnNames);
excelFileNameTable = sprintf('Ketqua_nhandangBai3K1.xlsx');
writetable(tableTable, excelFileNameTable);
    
fprintf('Ty le(khong dung kmeans): %f\n', count/total);



% 2 y cuoi cung dung kmeans

filename = ["a.wav"; "e.wav";"i.wav";"o.wav";"u.wav"];

rates = cell(1, 5);
rates{1,1} = "Rate";

for kk =2:5
    results = cell(6, 6);
    for i = 1:size(results, 1)-1
        for j = 2:size(results, 2) 
            results{i, j} = 0; 
        end
    end
    % Th? m?c ch?a d? li?u
    dataTrainDir = '../DataTrain';

    % L?y danh s?ch c?c th? m?c con c?p 1
    subDirs = dir(dataTrainDir);
    subDirs = subDirs([subDirs.isdir]);  % L?c ch? l?y c?c th? m?c
    subDirs = subDirs(3:end);  % B? qua '.' v? '..'

    N_MFCC = 13;
    frame_length = 22;
    frame_shift = 14;

    dataDB = []; % export file excel

    for j = 1:5
        result = zeros(N_MFCC, length(subDirs));

        for i = 1:length(subDirs)

            currentDir = fullfile(dataTrainDir, subDirs(i).name);
            audioFile = fullfile(currentDir, filename(j));

            % Ki?m tra xem file 'a.wav' c? t?n t?i kh?ng
            if exist(audioFile, 'file')
                %fprintf('Th?ng tin file: %s\n', audioFile);

                y = Cal_MFCC(audioFile,N_MFCC,frame_length,frame_shift);
                result(:,i) = y;

            else
                fprintf('File %s kh?ng t?n t?i.\n', audioFile);
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


    dlmwrite('data.csv', dataDB, 'delimiter', ',');  % Ghi ma tr?n vector3 v?o file CSV v?i d?u ph?y l?m d?u ph?n c?ch


    % Th? m?c ch?a d? li?u
    dataTrainDir = '../DataTest';

    % L?y danh s?ch c?c th? m?c con c?p 1
    subDirs = dir(dataTrainDir);
    subDirs = subDirs([subDirs.isdir]);  % L?c ch? l?y c?c th? m?c
    subDirs = subDirs(3:end);  % B? qua '.' v? '..'



    dataDB = csvread('data.csv'); % import file excel

    total = 0;
    count = 0;
    confusion = zeros(5, 5);
    for i = 1:length(subDirs)
        currentDir = fullfile(dataTrainDir, subDirs(i).name);


        for j = 1:5
            audioFile = fullfile(currentDir, filename(j));
            % Ki?m tra xem file 'a.wav' c? t?n t?i kh?ng
            if exist(audioFile, 'file')
                %fprintf('Th?ng tin file: %s\n', audioFile);

                y = Cal_MFCC(audioFile,N_MFCC,frame_length,frame_shift);
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
                results{j,position+1} = results{j,position+1} + 1;
                confusion(position, j) = confusion(position, j) + 1;

                if(j==position)   
                    count = count+1;
                end

                total = total+1;

            else
                fprintf('File %s kh?ng t?n t?i.\n', audioFile);
            end 

        end

    end
    %disp(confusion);
    rates{1,kk} = count/total;
%     fprintf('%f\n', count/total);
    results{1,1} = 'am_a';
    results{2,1} = 'am_e';
    results{3,1} = 'am_i';
    results{4,1} = 'am_o';
    results{5,1} = 'am_u';
    results{6,1} = 'ty_le_chung';
    results{6,2} = count/total;
    columnNames = {'nhan_dung_vs_nhan_dinh','am_a', 'am_e', 'am_i', 'am_o', 'am_u'};
    resultTable = cell2table(results, 'VariableNames', columnNames);
    excelFileName = sprintf('ConfusionMatrix_k%d.xlsx',kk); 
    writetable(resultTable, excelFileName);
    
end
columnNames = {'total','k_2', 'k_3', 'k_4', 'k_5'};
rateTable = cell2table(rates, 'VariableNames', columnNames);
excelFileName = sprintf('RatesBai3.xlsx');
writetable(rateTable, excelFileName);

excelFileName = sprintf('ConfusionMatrix_k3.xlsx'); 
excel = actxserver('Excel.Application');
excel.Workbooks.Open(fullfile(pwd, excelFileName));
excel.Visible = true;
sheet = excel.ActiveSheet;

% In ??m ? F6 (5,6)
highlightCell = sheet.Range('F6'); 
highlightCell.Font.Bold = true;

% In ??m ? C3 (2,3)
highlightCell = sheet.Range('E5'); 
highlightCell.Font.Italic = true;

% L?u l?i v? ??ng file Excel
% excel.ActiveWorkbook.Save;
% excel.ActiveWorkbook.Close;
% excel.Quit;





