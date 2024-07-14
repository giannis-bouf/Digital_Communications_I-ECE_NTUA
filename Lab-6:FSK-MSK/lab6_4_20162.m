clear all; close all; clc;
% Οριζόμενες παράμετροι
n=4000; % αριθμός data bits
R=2000000; % bit rate
fc=8/2*R; % φέρουσα συχνότητα
ns=16; % παράγοντας υπερδειγμάτισης

% Παραγόμενες παράμετροι
T=1/R; % περίοδος 1 bit (= βασική περίοδος)
Ts=T/ns; % συχνότητα δειγματοληψίας

% ακολουθία εισόδου
y=[1;sign(rand(n-1,1)-0.5)]; % random numbers, -1 ή 1

% προκωδικοποίηση
x(1)=1;
for i=2:length(y)
    x(i)=y(i)*y(i-1);
end
x=x';
g=ones(ns,1);
x_upsampled = upsample(x,ns);
xx=conv(x_upsampled,g); % δείγματα παλμοσειράς NRZ polar

% χρονικό πλέγμα
ts=[0:Ts:length(xx)*Ts]'; % μήκους ns*(n+1)

%% ΠΟΜΠΟΣ MSK
xs=xx;
theta=cumsum(xs)*pi/2/ns;
xs_i=cos(theta); % συμφασική συνιστώσα
xs_i=[xs_i; xs_i(length(xs_i))]; % επέκταση με ένα ακόμη δείγμα
xs_q=sin(theta); % εγκάρσια συνιστώσα
xs_q=[xs_q; xs_q(length(xs_q))]; % επέκταση με ένα ακόμη δείγμα

% Διαμόρφωση
s=xs_i.*cos(2*pi*fc*ts)-xs_q.*sin(2*pi*fc*ts);
figure(1); pwelch(s, [], [], fc, 1/Ts);