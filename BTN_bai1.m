foldername = {'30FTN','32MTP','33MHP','34MQP'};
for j = 1:4
    arr = ['a', 'e', 'i', 'o', 'u'];
    figure;  
    for i = 1:5
        audioName = ['F:\matlab\NguyenAmHuanLuyen-16k\' foldername{j} '\' arr(i) '.wav'];
        [x, Fs] = audioread(audioName);
        subplot(5, 1, i);
        spectrogram(x, 5 * 10^(-3) * Fs, 2 * 10^(-3) * Fs, 2048, Fs, 'yaxis');
        title(arr(i));
    end
    sgtitle(['Bieu do Spectrogram cho cac nguyen am cua thu muc ' foldername{j}]); 
end
