close all; clear all; clc;
k=2; M=2^k; Nsymb=2000; nsamp=32;

%% Grey encoding vector
ph1=[pi/4]; 
theta=[ph1; -ph1; pi-ph1; -pi+ph1];
mapping=exp(1j*theta);
if(k>2)
 for j=3:k
 theta=theta/2;
 mapping=exp(1j*theta);
 mapping=[mapping; -conj(mapping)];
 theta=angle(mapping);
 end
end

%% Random bits -> symbols
x=floor(2*rand(k*Nsymb,1)); 
xsym=bi2de(reshape(x,k,length(x)/k).','left-msb')';
y=[];
for i=1:length(xsym)
 y=[y mapping(xsym(i)+1)];
end

%% Filter parametres
delay=8;
rolloff=0.5;
filtorder = delay*nsamp*2;
rNyquist= rcosine(1,nsamp,'fir/sqrt',rolloff,delay);

%% Transmitter
y=upsample(y,nsamp);
ytx = conv(y,rNyquist);
R=2000000; % bit rate
Fs=R/k*nsamp;
fc=8; % carrier frequency in multiples of baud rate (1/T=1MHz)
m=(1:length(ytx));
s=real(ytx.*exp(1j*2*pi*fc*m/nsamp));  % shift to desired frequency band
%plots
%figure; pwelch(real(ytx),[],[],[],Fs); %before frequency shifting
figure; pwelch(s,[],[],[],Fs);