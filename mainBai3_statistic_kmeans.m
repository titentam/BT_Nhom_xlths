

N_FFT = 13;
kk = 5;

% Duy?t qua t?ng th? m?c và ??c file 'a.wav'
filename = ["a.wav"; "e.wav";"i.wav";"o.wav";"u.wav"];
colors = [...
    0 0.4470 0.7410;  % Màu xanh d??ng
    0.8500 0.3250 0.0980;  % Màu cam
    0.9290 0.6940 0.1250;  % Màu vàng
    0.4940 0.1840 0.5560;  % Màu tím
    0.4660 0.6740 0.1880   % Màu xanh lá cây
];


statisticTable = cell(7, 21);

for frame_length = 20:23
    statisticTable{frame_length-20+2,1} = [num2str(frame_length) 'ms'];
    for frame_shift  = 5:frame_length-1
        
        fprintf('Frame length: %d && Frame shift: %d => ',frame_length,frame_shift);
        statisticTable{1,frame_shift-5+2} = [num2str(frame_shift) 'ms'];
        dataDB = []; % export file excel
        
                % Th? m?c ch?a d? li?u
        dataTrainDir = 'DataTrain';

        % L?y danh sách các th? m?c con c?p 1
        subDirs = dir(dataTrainDir);
        subDirs = subDirs([subDirs.isdir]);  % L?c ch? l?y các th? m?c
        subDirs = subDirs(3:end);  % B? qua '.' và '..'
        for j = 1:5
            result = zeros(N_MFCC, length(subDirs));

            for i = 1:length(subDirs)

                currentDir = fullfile(dataTrainDir, subDirs(i).name);
                audioFile = fullfile(currentDir, filename(j));

                % Ki?m tra xem file 'a.wav' có t?n t?i không
                if exist(audioFile, 'file')
                    %fprintf('Thông tin file: %s\n', audioFile);

                    y = Cal_MFCC(audioFile,N_FFT,frame_length,frame_shift);
                    result(:,i) = y;

                else
                    fprintf('File %s không t?n t?i.\n', audioFile);
                end 

            end

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

            %plot(trungbinh, 'Color', colors(j, :));
        end
%         legend(filename(1:5), 'Location', 'eastoutside');
%         title('Feature vector spectrum ');
%         xlabel('N MFCC');
%         ylabel('Magnitude');

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

                    y = Cal_MFCC(audioFile,N_FFT,frame_length,frame_shift);
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
                    fprintf('File %s không t?n t?i.\n', audioFile);
                end 

            end

        end

        %disp(confusion);

        statisticTable{frame_length-20+2,frame_shift-5+2} = count/total ;    
        fprintf('%f\n', count/total);
        
    end
end

filename = 'statisticTableBai3_window_k5.xlsx'; % Tên file Excel

% L?u m?ng cell vào file Excel
xlswrite(filename, statisticTable);

