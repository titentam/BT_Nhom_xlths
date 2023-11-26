% Th? m?c ch?a d? li?u
dataTrainDir = '../DataTrain';

% L?y danh sách các th? m?c con c?p 1
subDirs = dir(dataTrainDir);
subDirs = subDirs([subDirs.isdir]);  % L?c ch? l?y các th? m?c
subDirs = subDirs(3:end);  % B? qua '.' và '..'

N_FFT = 512;


% Duy?t qua t?ng th? m?c và ??c file 'a.wav'

colors = [...
    0 0.4470 0.7410;  % Màu xanh d??ng
    0.8500 0.3250 0.0980;  % Màu cam
    0.9290 0.6940 0.1250;  % Màu vàng
    0.4940 0.1840 0.5560;  % Màu tím
    0.4660 0.6740 0.1880   % Màu xanh lá cây
];

filename = ["a"; "e";"i";"o";"u"];

frame_length = 21;
frame_shift = 18;
   
dataDB = []; % export file excel
figure;
hold on;
for j = 1:5
    result = zeros(N_FFT, 1);

    for i = 1:length(subDirs)

        currentDir = fullfile(dataTrainDir, subDirs(i).name);
        audioFile = fullfile(currentDir, filename(j)+".wav");

        % Ki?m tra xem file 'a.wav' có t?n t?i không
        if exist(audioFile, 'file')
            %fprintf('Thông tin file: %s\n', audioFile);

            y = feature_vector_DB(audioFile,N_FFT,frame_length,frame_shift);
            %y = Cal_MFCC(audioFile,N_FFT);
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

    %dataDB = [dataDB,trungbinh(1:floor(N/2))];
    dataDB = [dataDB,trungbinh];

    plot(trungbinh(1:floor(N/2)), 'Color', colors(j, :));

end

legend(filename(1:5), 'Location', 'eastoutside');
title('Feature vector spectrum (dB) N_F_F_T = 512 ');

dlmwrite('data.csv', dataDB, 'delimiter', ',');

N_FFT_values = [512, 1024, 2048];
rates = cell(1, 4);
rates{1,1} = "Rate";

frame_length = 21;
frame_shift = 18;
for k = 1:length(N_FFT_values)
    total = 0;
    cnt = 0;
    N_FFT = N_FFT_values(k);
    trained_vectors = trainAndGetFeatures(N_FFT,frame_length,frame_shift);
    trained_vectors = transpose(trained_vectors);
    input_signal = '../DataTest';

    subDirs = dir(input_signal);
    subDirs = subDirs([subDirs.isdir]);  
    subDirs = subDirs(3:end);
    results2 = cell(5, 6);
    tables = cell(21,6);
    for i = 1:size(tables, 1) 
        for j = 2:size(tables, 2) 
            tables{i, j} = 0; 
        end
    end
    for i = 1:size(results2, 1) 
        for j = 2:size(results2, 2) 
            results2{i, j} = 0; 
        end
    end
    filename = ["a.wav"; "e.wav";"i.wav";"o.wav";"u.wav"];
    for j = 1:5
        for i = 1:length(subDirs)
            total = total + 1;
            currentDir = fullfile(input_signal, subDirs(i).name);
            audioFile = fullfile(currentDir, filename(j));

            if exist(audioFile, 'file')
                input_feature = feature_vector_DB(audioFile, N_FFT,frame_length,frame_shift);
                min_distance = Inf;
                min_index = -1;

                for t = 1:size(trained_vectors, 2)
                    distance = euclideanDistance(trained_vectors(:, t),input_feature);
                    if distance < min_distance
                        min_distance = distance;
                        min_index = t; 
                    end
                end
                if min_index == j
                    tables{i,j+1} = 1;
                    cnt = cnt + 1;
                end
                tables{i,1} = subDirs(i).name;
                vowels = ['a', 'e', 'i', 'o', 'u'];
                recognized_vowel = vowels(min_index);
                results2{j,min_index+1} = results2{j,min_index+1} + 1;
                
            else
                fprintf('File %s kh?ng t?n t?i.\n', audioFile);
            end 
        end
    end
    
    results2{1,1} = 'am_a';
    results2{2,1} = 'am_e';
    results2{3,1} = 'am_i';
    results2{4,1} = 'am_o';
    results2{5,1} = 'am_u';

    % T?o table t? cell array, ??t t?n cho c?t v? h?ng
    columnNames = {'nhan_dung_vs_nhan_dinh','am_a', 'am_e', 'am_i', 'am_o', 'am_u'};
    resultTable = cell2table(results2, 'VariableNames', columnNames);
    tableTable = cell2table(tables, 'VariableNames', columnNames);
    excelFileName = sprintf('ConfusionMatrix_%d.xlsx', N_FFT); % T?n file Excel t??ng ?ng v?i gi? tr? N_FFT
    excelFileNameTable = sprintf('Ketqua_nhandang_%d.xlsx', N_FFT);
    writetable(tableTable, excelFileNameTable);
    writetable(resultTable, excelFileName); % Ghi d? li?u v?o file Excel
    
     rates{1,k+1} = cnt/total;
end
columnNames = {'total','N_FFT_512', 'N_FFT_1024', 'N_FFT_2048'};
rateTable = cell2table(rates, 'VariableNames', columnNames);
excelFileName = sprintf('RatesBai2.xlsx');
writetable(rateTable, excelFileName);

fprintf('Ty le cao nhat: %f ',rates{1,2});

% bat excel
excelFileName = sprintf('ConfusionMatrix_512.xlsx'); 
excel = actxserver('Excel.Application');
excel.Workbooks.Open(fullfile(pwd, excelFileName));
excel.Visible = true;
sheet = excel.ActiveSheet;
