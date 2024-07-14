%% clearing and sima.mat

clear all; close all;
% Το αρχείο "sima.mat" περιέχει το σήμα s και τη συχνότητα
% δειγματοληψίας Fs. Το φάσμα του σήματος εκτείνεται σχεδόν σε όλη την
% περιοχή συχνοτήτων μέχρι 4 KHz. Πάνω από 1 KHz, όμως, είναι θόρυβος 
% και πρέπει να φιλτραριστεί.
load sima;  
figure; pwelch(s,[],[],[],Fs);
pause

%% rectangular LPF
% Ορίζεται η ιδανική βαθυπερατή συνάρτηση Η, με συχνότ. αποκοπ. Fs/8
H=[ones(1,Fs/8) zeros(1,Fs-Fs/4) ones(1,Fs/8)];
% Υπολογίζεται η κρουστική απόκριση με αντίστροφο μετασχ. Fourier
% Εναλλακτικά, μπορεί να χρησιμοποιηθεί η αναλυτική σχέση Sa(x)
h=ifft(H,'symmetric'); 
middle=length(h)/2; 
h=fftshift(h);
h32=h(middle+1-16:middle+17);
h64=h(middle+1-32:middle+33);
h128=h(middle+1-64:middle+65);
% figure; stem([0:length(h64)-1],h64); grid;
% figure; freqz(h64,1); % σχεδιάζουμε την απόκριση συχνότητας της h64
wvtool(h32,h64,h128);   % αποκρίσεις συχνότητας των περικομμένων h
pause

%% hamming windows
% Οι πλευρικοί λοβοί είναι υψηλοί!
% Πολλαπλασιάζουμε την περικομμένη κρουστική απόκριση με κατάλληλο 
% παράθυρο. Χρησιμοποιούμε την h64 και παράθυρο hamming 
wh=hamming(length(h64));
figure; plot(0:64,wh,'b'); grid;
pause
h_hamming=h64.*wh';
% figure; stem([0:length(h64)-1],h_hamming); grid;
% figure; freqz(h_hamming,1); 
wvtool(h64,h_hamming);
pause

%% filtering
% Φιλτράρουμε το σήμα μας με καθένα από τα δύο φίλτρα
y_rect=conv(s,h64);
figure; pwelch(y_rect,[],[],[],Fs); pause
y_hamm=conv(s,h_hamming);
figure; pwelch(y_hamm,[],[],[],Fs); pause

%% LPF Parks-MacClellan
hpm=firpm(64, [0 0.10 0.15 0.5]*2, [1 1 0 0]);
% figure; freqz(hpm,1);
s_pm=conv(s,hpm); 
figure; pwelch(s_pm,[],[],[],Fs);
pause
sound(20*s); pause     % ακούμε το αρχικό σήμα, s
sound(20*s_pm);  % ακούμε το φιλτραρισμένο σήμα, s_lp 

%% Πειραματισθείτε #2
h160=h(middle+1-80:middle+81);
wh160=hamming(length(h160));
h160_hamming=h160.*wh160';
wvtool(h160,h160_hamming);
pause

%% Πειραματισθείτε #3 
hpm_3=firpm(160,[0 0.1 0.15 0.5]*2, [1 1 0 0]);
wvtool(hpm,hpm_3); 
pause

%% Πειραματισθείτε #4
hpm_4=firpm(160,[0 0.11 0.12 0.5]*2, [1 1 0 0]);
wvtool(hpm_3,hpm_4); 
pause

%% Πειραματισθείτε #5
Ts=1/Fs;
T=0.1; %διάρκεια σήματος
t=0:Ts:T-Ts; %χρονικές στιγμές δειγματοληψίας
x=sin(2*pi*700*t)+...
    sin(2*pi*900*t)+...  
    sin(2*pi*1400*t)+...
    sin(2*pi*2500*t);       %σήμα
figure; pwelch(x,[],[],[],Fs); pause
x_pm3=conv(x,hpm_3);
x_pm4=conv(x,hpm_4);
figure; pwelch(x_pm3,[],[],[],Fs); pause
figure; pwelch(x_pm4,[],[],[],Fs); pause