close all; clear all;

% Χαρακτηριστικά Συστήματος
L=8; % σύστημα 8-ASK
Nbits=9999; % number of bits
nsamp=32;   % oversampling,i.e. number of samples per T
rolloff=0.4;
delay=4;

No = 100e-12; % πυκνότητα φάσματος θορύβου
R=4*10^(6); % ρυθμός μετάδοσης
W=1e6; % εύρος (βασικής) ζώνης διαύλου
ber=2000/R; % ανεκτό BER

% Υπολογισμός Προδιαγραφών
Baud_Rate=R/log2(L);
real_W=(1+rolloff)*Baud_Rate/2;
disp('Real Bandwidth:');
disp(real_W);
disp('Given Bandwidth:');
disp(W);
 
EbNo_min = 10^(0.1*15.6);
Eb_min = EbNo_min * (No * W);
disp('The minimum Signal Energy:');
disp(Eb_min);