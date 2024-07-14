%% clearing and sima.mat

clear all; close all;
% Το αρχείο "sima.mat" περιέχει το σήμα s και τη συχνότητα
% δειγματοληψίας Fs. Το φάσμα του σήματος εκτείνεται σχεδόν σε όλη την
% περιοχή συχνοτήτων μέχρι 4 KHz. Πάνω από 1 KHz, όμως, είναι θόρυβος 
% και πρέπει να φιλτραριστεί.
load sima;  

%% rectangular BPF
% Ορίζεται η ιδανική ζωνοπερατή συνάρτηση Η, με ζώνη διέλευσης(0.7kHz,
% 1.5kHz)
H=[ones(1,300) zeros(1,400) ones(1,400) zeros(1,5992) ones(1,400) zeros(1,400) ones(1,300)];
% Υπολογίζεται η κρουστική απόκριση με αντίστροφο μετασχ. Fourier
% Εναλλακτικά, μπορεί να χρησιμοποιηθεί η αναλυτική σχέση Sa(x)
h=ifft(H,'symmetric'); 
middle=length(h)/2; 
h=fftshift(h);
h160=h(middle+1-80:middle+81);
% figure; stem([0:length(h160)-1],h160); grid;
% figure; freqz(h160,1); % σχεδιάζουμε την απόκριση συχνότητας της h64
wvtool(h160);   % αποκρίσεις συχνότητας των περικομμένων h
pause

%% hamming window
% Οι πλευρικοί λοβοί είναι υψηλοί!
% Πολλαπλασιάζουμε την περικομμένη κρουστική απόκριση με κατάλληλο 
% παράθυρο. Χρησιμοποιούμε την h160 και παράθυρο hamming
wh=hamming(length(h160));
figure; plot(0:160,wh,'b');
title('Hamming Window ΜΠΟΥΦΙΔΗΣ ΙΩΑΝΝΗΣ'); grid;
pause
h_hamming=h160.*wh';
% figure; stem([0:length(h160)-1],h_hamming); grid;
% figure; freqz(h_hamming,1); 
wvtool(h_hamming);
pause

%% filtering
% Φιλτράρουμε το σήμα μας με το φίλτρο
s_hamm=conv(s,h_hamming);
figure; pwelch(s_hamm,[],[],[],Fs); pause

%% BPF Parks-MacClellan
hpm=firpm(160, [0 0.07 0.1 0.14 0.17 0.26 0.29 1], [1 1 0 0 1 1 0 0]);
% figure; freqz(hpm,1);
s_pm=conv(s,hpm);  
figure; pwelch(s_pm,[],[],[],Fs);
pause 
sound(20*s); pause     % ακούμε το αρχικό σήμα, s
sound(20*s_pm);  % ακούμε το φιλτραρισμένο σήμα, s_l