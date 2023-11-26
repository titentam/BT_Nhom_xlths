
N_FFT = 512;

% Duy?t qua t?ng th? m?c v� ??c file 'a.wav'

colors = [...
    0 0.4470 0.7410;  % M�u xanh d??ng
    0.8500 0.3250 0.0980;  % M�u cam
    0.9290 0.6940 0.1250;  % M�u v�ng
    0.4940 0.1840 0.5560;  % M�u t�m
    0.4660 0.6740 0.1880   % M�u xanh l� c�y
];

filename = ["a"; "e";"i";"o";"u"];
statisticTable = cell(7, 21);
for frame_length = 20:25
    statisticTable{frame_length-20+2,1} = [num2str(frame_length) 'ms'];
    for frame_shift  = 5:frame_length-1
        
        statisticTable{1,frame_shift-5+2} = [num2str(frame_shift) 'ms'];
        
        fprintf('Frame length: %d && Frame shift: %d => ',frame_length,frame_shift);
        dataDB = []; % export file excel
        %figure;
        %hold on;
        
        % Th? m?c ch?a d? li?u
        dataTrainDir = '../DataTrain';

        % L?y danh s�ch c�c th? m?c con c?p 1
        subDirs = dir(dataTrainDir);
        subDirs = subDirs([subDirs.isdir]);  % L?c ch? l?y c�c th? m?c
        subDirs = subDirs(3:end);  % B? qua '.' v� '..'
        for j = 1:5
            result = zeros(N_FFT, 1);

            for i = 1:length(subDirs)

                currentDir = fullfile(dataTrainDir, subDirs(i).name);
                audioFile = fullfile(currentDir, filename(j)+".wav");

                % Ki?m tra xem file 'a.wav' c� t?n t?i kh�ng
                if exist(audioFile, 'file')
                    %fprintf('Th�ng tin file: %s\n', audioFile);

                    y = feature_vector_DB(audioFile,N_FFT,frame_length,frame_shift);
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

            %plot(trungbinh(1:floor(N/2)), 'Color', colors(j, :));

        end

        %legend(filename(1:5), 'Location', 'eastoutside');
        %title('Feature vector spectrum (dB) ');
        %xlabel('Frequency');
        %ylabel('Magnitude (dB)');

        dlmwrite('data.csv', dataDB, 'delimiter', ',');  % Ghi ma tr?n vector3 v�o file CSV v?i d?u ph?y l�m d?u ph�n c�ch

        % Th? m?c ch?a d? li?u
        dataTrainDir = '../DataTest';

        % L?y danh s�ch c�c th? m?c con c?p 1
        subDirs = dir(dataTrainDir);
        subDirs = subDirs([subDirs.isdir]);  % L?c ch? l?y c�c th? m?c
        subDirs = subDirs(3:end);  % B? qua '.' v� '..'

        % Duy?t qua t?ng th? m?c v� ??c file 'a.wav'

        dataDB = csvread('data.csv'); % Import file excel

        total = 0;
        count = 0;
        %fprintf('Th�ng tin file: \n');

        result = cell(22, 6); % S? d?ng cell array ?? l?u k?t qu?
        for i = 1:length(subDirs)
            currentDir = fullfile(dataTrainDir, subDirs(i).name);
            result{i+1, 1} = subDirs(i).name;

            for j = 1:5
                audioFile = fullfile(currentDir, filename(j)+".wav");
                result{1, j+1} = filename(j); % Assign filename instead of audioFile

                % Ki?m tra xem file 'a.wav' c� t?n t?i kh�ng
                if exist(audioFile, 'file')
                    %fprintf('%s', audioFile);

                    y = feature_vector_DB(audioFile,N_FFT,frame_length,frame_shift);
                    %y = Cal_MFCC(audioFile,N_FFT);
                    %y = y(1:floor(length(y)/2)); % L?y 1 n?a th�i

                    minDistance = 1000000000;
                    position = 0;
                    for k = 1: 5
                        tmpDistance = euclideanDistance(y, dataDB(:, k));
                        if minDistance >= tmpDistance
                            minDistance = tmpDistance;
                            position = k;
                        end
                    end

                    if j == position
                        count = count + 1;
                        %fprintf(': True\n');
                        result{i+1, j+1} = 'True'; % Use char 'True' instead of "True"
                    else
                        %fprintf(': False\n');    
                        result{i+1, j+1} = 'False'; % Use char 'False' instead of "False"
                    end

                    total = total + 1;
                else
                    fprintf('File %s kh�ng t?n t?i.\n', audioFile);
                end 
            end
        end
        statisticTable{frame_length-20+2,frame_shift-5+2} = count/total ;    
        fprintf('%f\n', count/total);
    end
end

filename = 'statisticTable_window_TB.xlsx'; % T�n file Excel

% L?u m?ng cell v�o file Excel
xlswrite(filename, statisticTable);
