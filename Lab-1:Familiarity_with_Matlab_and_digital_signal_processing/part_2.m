%% clear
clear all; close all;
clc;
%% create a sin
Fs=2000; %συνχότητα δειγματοληψίας
Ts=1/Fs;
T=0.1; %διάρκεια σήματος
t=0:Ts:T-Ts; %χρονικές στιγμές δειγματοληψίας
A=1; %πλάτος σήματος
x=A*sin(2*pi*100*t); %σήμα
L=length(x);
plot(t,x);
pause
%% create dft fourier transform
N=1*L; %μήκος μετασχηματισμού
Fo=Fs/N; %ανάλυση συχνότητας
Fx=fft(x,N); %dft fourier transform
freq=(0:N-1)*Fo; %διάνυσμα συχνοτήτων
plot(freq,abs(Fx));
title('FFT');
pause
axis([0 100 0 L/2]);
pause
%% σχεδίαση περιοδογράμματος
power=Fx.*conj(Fx)/Fs/L; %υπολογισμός πυκνότητας φασματικής ισχύος
plot(freq, power);
xlabel('Frequency (Hz)');
ylabel('Power');
title('{\bf Periodogram}');
%% υπολογισμός ισχύος
power_theory=A^2/2; %ισχύς βάση θεωρίας
db=10*log10(power_theory);
power_in_time_domain=sum(abs(x).^2)/L;
power_in_freq_domain=sum(power)*Fo;