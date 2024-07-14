close all; clear all; clc;
k=mod(20162,2)+3; Nsymb=40000; EbNo = 16; nsamp = 20;

L=2^k;
SNR=EbNo-10*log10(nsamp/2/k); % SNR ανά δείγμα σήματος

% Διάνυσμα τυχαίων ακεραίων {±1, ±3, ... ±(L-1)}. Να επαληθευθεί
x=2*floor(L*rand(1,Nsymb))-L+1;

Px=(L^2-1)/3; % θεωρητική ισχύς σήματος
Px2=sum(x.^2)/length(x); % μετρούμενη ισχύς σήματος (για επαλήθευση)

h=ones(1,nsamp); h=h/sqrt(h*h'); % κρουστική απόκριση φίλτρου
% πομπού (ορθογωνικός παλμός μοναδιαίας ενέργειας)
y=upsample(x,nsamp); % μετατροπή στο πυκνό πλέγμα
y=conv(y,h); % το προς εκπομπή σήμα
y=y(1:Nsymb*nsamp); % περικόπτεται η ουρά που αφήνει η συνέλιξη

ynoisy=awgn(y,SNR,'measured'); % θορυβώδες σήμα

for i=1:nsamp 
    matched(i)=h(end-i+1); 
end
yrx=conv(ynoisy,matched);
z = yrx(nsamp:nsamp:Nsymb*nsamp); % Yποδειγμάτιση -- στο τέλος
 % κάθε περιόδου Τ

A=[-L+1:2:L-1];
for i=1:length(z)
    [m,j]=min(abs(A-z(i)));
    z(i)=A(j);
end

err=not(x==z);
errors=sum(err);

%% Question 3.B
ynoisy = y; % θορυβώδες σήμα
yrx=conv(ynoisy,matched);

figure(1); stem(x(1:20)); 
title('Produced L-ASK signal (x) for first 20 symbols'); pause;
figure(2); stem(y(1:20*nsamp)); 
title('Transmitted signal (y)'); pause;
figure(3); stem(yrx(1:nsamp:20*nsamp));
title('The 20 first received symbols (yrx)'); pause;

%% Question 3.C
clear all;
nsamp = [8,32,64];

for i=1:3
    xaxis = [1:nsamp(i)];
    h1=ones(1,nsamp(i)); h1=h1/sqrt(h1*h1');
    h2=cos(2*pi*(1:nsamp(i))/nsamp(i)); h2=h2/sqrt(h2*h2');

    figure(i+3);
    subplot(1,2,1); stem(xaxis,h1);
    subplot(1,2,2); stem(xaxis,h2); 
    pause
end