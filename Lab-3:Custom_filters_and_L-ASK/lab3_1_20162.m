close all; clear all; clc;
k=mod(20162,2)+3; Nsymb=40000; EbNo = 16; nsamp = 20;
d=5;

L=2^k;
SNR=EbNo-10*log10(nsamp/2/k); % SNR ανά δείγμα σήματος

% Διάνυσμα τυχαίων ακεραίων {±d/2, ±3(d/2), ... ±(L-1)(d/2)}. Να επαληθευθεί
x=(2*floor(L*rand(1,Nsymb))-L+1)*(d/2); % παραγωγή του L-ASK σήματος
Px=((d^2)/4)*(L^2-1)/3; % θεωρητική ισχύς σήματος
Px2=sum(x.^2)/length(x); % μετρούμενη ισχύς σήματος (για επαλήθευση)
y=rectpulse(x,nsamp); % κρουστική απόκριση φίλτρου
n=wgn(1,length(y),10*log10(Px)-SNR); % παραγωγή θορύβου
ynoisy=y+n; % θορυβώδες σήμα
y=reshape(ynoisy,nsamp,length(ynoisy)/nsamp); % από εδώ
matched=ones(1,nsamp);
z=matched*y/nsamp; % μέχρι εδώ εφαρμογή προσαρμοσμένου φίλτρου
A=(-d*(L-1)/2):d:(d*(L-1)/2); % σύνολο στάθμεων

for i=1:length(z) % ανιχνευτής συμβόλου
    [m,j]=min(abs(A-z(i)));
    z(i)=A(j);
end

err=not(x==z); % αν το ανιχνευμένο δεν ταυτίζεται με το πραγματικό, τότε 1
errors=sum(err);

fprintf('Theoritically: %d\n', Px);
fprintf('Calculated: %d\n', Px2);
%% Question 1.A
close all; clear all; clc;

k=mod(20162,2)+3; Nsymb=40000; d=5;
L=2^k;

% Διάνυσμα τυχαίων ακεραίων {±d/2, ±3(d/2), ... ±(L-1)(d/2)}. Να επαληθευθεί
x=(2*floor(L*rand(1,Nsymb))-L+1)*(d/2);
 
Px=((d^2)/4)*(L^2-1)/3; % θεωρητική ισχύς σήματος
Px2=sum(x.^2)/length(x); % μετρούμενη ισχύς σήματος (για επαλήθευση)

A=(-d*(L-1)/2):d:(d*(L-1)/2);

figure(1); hist(x,A); pause

%% Question 1.B
clear all; close all; clc;

d=5; k=4; Nsymb=60000; nsamp=20; EbNo=[12,16,20];
L=2^k; 

% Διάνυσμα τυχαίων ακεραίων {±d/2, ±3(d/2), ... ±(L-1)(d/2)}. Να επαληθευθεί
x=(2*floor(L*rand(1,Nsymb))-L+1)*(d/2);

Px=((d^2)/4)*(L^2-1)/3; % θεωρητική ισχύς σήματος
Px2=sum(x.^2)/length(x); % μετρούμενη ισχύς σήματος (για επαλήθευση)
y=rectpulse(x,nsamp); % παραγόμενο από τον πομπό σήμα (τετραγωνικός παλμός)

for i=1:3
    SNR=EbNo(i)-10*log10(nsamp/2/k); % SNR ανά δείγμα σήματος

    n=wgn(1,length(y),10*log10(Px)-SNR);
    ynoisy=y+n; % θορυβώδες σήμα
    y1=reshape(ynoisy,nsamp,length(ynoisy)/nsamp);
    matched=ones(1,nsamp);
    z=matched*y1/nsamp;

    figure(i+1);
    hist(z,200); 
    title('EbNo = ', EbNo(i)); pause
end;