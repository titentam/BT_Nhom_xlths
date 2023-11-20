% G?i hàm STE và nh?n k?t qu? tr? v?
fileName = 'DataTrain/46PTT/a.wav'; % ???ng d?n t?p tin WAV
[x, fs] = STE(fileName);
%[x, fs] = audioread(fileName);

%plot(x);
%sound(x,fs);

y = feature_vector_DB(fileName);

N = length(y);
figure;
plot(y(1:floor(N/2)));
title('Feature vector spectrum (dB)');
xlabel('Frequency');
ylabel('Magnitude (dB)');


% % V? bi?u ?? ph? t?n s? c?a vector ??c tr?ng (??n v? dB)
% 
% N = length(feature_vector_db);
% figure;
% plot(feature_vector_db(1:floor(N/2)));
% title('Feature vector spectrum (dB)');
% xlabel('Frequency');
% ylabel('Magnitude (dB)');
% 
% % Ví d?: V? bi?u ?? ph? t?n s? c?a vector ??c tr?ng
% figure;
% plot(abs(feature_vector));
% title('Feature vector spectrum');
% xlabel('Frequency');
% ylabel('Magnitude');