
filename = ["a.wav"; "e.wav";"i.wav";"o.wav";"u.wav"];
colors = [...
    0 0.4470 0.7410;  % M�u xanh d??ng
    0.8500 0.3250 0.0980;  % M�u cam
    0.9290 0.6940 0.1250;  % M�u v�ng
    0.4940 0.1840 0.5560;  % M�u t�m
    0.4660 0.6740 0.1880   % M�u xanh l� c�y
];
dataDB = []; % export file excel

for radio = 0.1:0.1:1
    fprintf('radio: %f ', radio);
    dataTrainDir = 'DataTrain';

    % L?y danh s�ch c�c th? m?c con c?p 1
    subDirs = dir(dataTrainDir);
    subDirs = subDirs([subDirs.isdir]);  % L?c ch? l?y c�c th? m?c
    subDirs = subDirs(3:end);  % B? qua '.' v� '..'

    N_FFT = 13;
    frame_length = 22;
    frame_shift = 12;
    for j = 1:5
        result = zeros(N_FFT, 1);

        for i = 1:length(subDirs)

            currentDir = fullfile(dataTrainDir, subDirs(i).name);
            audioFile = fullfile(currentDir, filename(j));

            % Ki?m tra xem file 'a.wav' c� t?n t?i kh�ng
            if exist(audioFile, 'file')
                %fprintf('Th�ng tin file: %s\n', audioFile);

                y = Cal_MFCC(audioFile,N_FFT,frame_length,frame_shift,radio);
                result = result + y;

            else
                fprintf('File %s kh�ng t?n t?i.\n', audioFile);
            end 

        end

        trungbinh = result / length(subDirs);

        %dataDB = [dataDB,trungbinh(1:floor(N/2))];
        dataDB = [dataDB,trungbinh];

        plot(trungbinh, 'Color', colors(j, :));
    end
%     legend(filename(1:5), 'Location', 'eastoutside');
%     title('Feature vector spectrum ');
%     xlabel('N MFCC');
%     ylabel('Magnitude');

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
                %fprintf('Th�ng tin file: %s\n', audioFile);

                y = Cal_MFCC(audioFile,N_FFT,frame_length,frame_shift,radio);
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

    %disp(confusion);

    fprintf('Ty le: %f\n', count/total);
end



