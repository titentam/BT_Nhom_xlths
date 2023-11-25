N_FFT_values = [512, 1024, 2048];
rates = cell(1, 4);
rates{1,1} = "Rate";
for k = 1:length(N_FFT_values)
    total = 0;
    cnt = 0;
    N_FFT = N_FFT_values(k);
    trained_vectors = trainAndGetFeatures(N_FFT);
    trained_vectors = transpose(trained_vectors);
    input_signal = 'NguyenAmKiemThu-16k';

    subDirs = dir(input_signal);
    subDirs = subDirs([subDirs.isdir]);  
    subDirs = subDirs(3:end);
    results = cell(5, 6);
    tables = cell(21,6);
    for i = 1:size(tables, 1) 
        for j = 2:size(tables, 2) 
            tables{i, j} = 0; 
        end
    end
    for i = 1:size(results, 1) 
        for j = 2:size(results, 2) 
            results{i, j} = 0; 
        end
    end
    filename = ["a.wav"; "e.wav";"i.wav";"o.wav";"u.wav"];
    for j = 1:5
        for i = 1:length(subDirs)
            total = total + 1;
            currentDir = fullfile(input_signal, subDirs(i).name);
            audioFile = fullfile(currentDir, filename(j));

            if exist(audioFile, 'file')
                input_feature = feature_vector_DB(audioFile, N_FFT);
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
                results{j,min_index+1} = results{j,min_index+1} + 1;
                
            else
                fprintf('File %s không t?n t?i.\n', audioFile);
            end 
        end
    end
    results{1,1} = 'am_a';
    results{2,1} = 'am_e';
    results{3,1} = 'am_i';
    results{4,1} = 'am_o';
    results{5,1} = 'am_u';
    rates{1,k+1} = cnt/total;
    % T?o table t? cell array, ??t tên cho c?t và hàng
    columnNames = {'nhan_dung_vs_nhan_dinh','am_a', 'am_e', 'am_i', 'am_o', 'am_u'};
    resultTable = cell2table(results, 'VariableNames', columnNames);
    tableTable = cell2table(tables, 'VariableNames', columnNames);
    excelFileName = sprintf('Results_%d.xlsx', N_FFT); % Tên file Excel t??ng ?ng v?i giá tr? N_FFT
    excelFileNameTable = sprintf('Table_%d.xlsx', N_FFT);
    writetable(tableTable, excelFileNameTable);
    writetable(resultTable, excelFileName); % Ghi d? li?u vào file Excel
end
columnNames = {'total','N_FFT_512', 'N_FFT_1024', 'N_FFT_2048'};
rateTable = cell2table(rates, 'VariableNames', columnNames);
excelFileName = sprintf('Rates.xlsx');
writetable(rateTable, excelFileName);