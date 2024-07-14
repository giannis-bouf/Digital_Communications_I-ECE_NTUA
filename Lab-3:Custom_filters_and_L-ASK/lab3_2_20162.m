%% Σχεδιασμός καμπύλης
clear all; close all; clc;

k = mod(20162,2)+3;
L = 2^k;
EbNo = 0.1:0.1:18; 
EbNo_d = 1:18;
figure; hold on;

Pe = ((L-1)/L)*erfc(sqrt(((3*log2(L))/((L^2)-1))*10.^(0.1*EbNo)));
BER = Pe/log2(L);

plot(EbNo, 10*log10(BER)); % switch axes to log scale

for i=1:18 
  ber(i) = ask_errors(3,20000,20,i)/20000;
end
stem(EbNo_d, 10*log10(ber));

xlabel('Eb/No (dB)');
ylabel('BER (dB)');
title('BER curves for 8-ASK');