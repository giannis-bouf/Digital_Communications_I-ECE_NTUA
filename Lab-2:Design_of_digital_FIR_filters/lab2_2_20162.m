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
H=[zeros(1,700) ones(1,800) zeros(1,5192) ones(1,800) zeros(1,700)];
% Υπολογίζεται η κρουστική απόκριση με αντίστροφο μετασχ. Fourier
% Εναλλακτικά, μπορεί να χρησιμοποιηθεί η αναλυτική σχέση Sa(x)
h=ifft(H,'symmetric'); 
middle=length(h)/2; 
h=fftshift(h);
h64=h(middle+1-32:middle+33);
% figure; stem([0:length(h64)-1],h64); grid;
% figure; freqz(h64,1); % σχεδιάζουμε την απόκριση συχνότητας της h64
wvtool(h64);   % αποκρίσεις συχνότητας των περικομμένων h
pause

%% hamming window
% Οι πλευρικοί λοβοί είναι υψηλοί!
% Πολλαπλασιάζουμε την περικομμένη κρουστική απόκριση με κατάλληλο 
% παράθυρο. Χρησιμοποιούμε την h64 και παράθυρο hamming
wh=hamming(length(h64));
figure; plot(0:64,wh,'b');
title('Hamming Window ΜΠΟΥΦΙΔΗΣ ΙΩΑΝΝΗΣ'); grid;
pause
h_hamming=h64.*wh';
% figure; stem([0:length(h64)-1],h_hamming); grid;
% figure; freqz(h_hamming,1); 
wvtool(h_hamming);
pause

%% filtering
% Φιλτράρουμε το σήμα μας με το φίλτρο
s_hamm=conv(s,h_hamming);
figure; pwelch(s_hamm,[],[],[],Fs); pause

%% BPF Parks-MacClellan
hpm=firpm(64, [0 0.13 0.17 0.35 0.39 1], [0 0 1 1 0 0]);
% figure; freqz(hpm,1);
s_pm=conv(s,hpm);  
figure; pwelch(s_pm,[],[],[],Fs);
pause 
sound(20*s); pause     % ακούμε το αρχικό σήμα, s
sound(20*s_pm);  % ακούμε το φιλτραρισμένο σήμα, s_l
