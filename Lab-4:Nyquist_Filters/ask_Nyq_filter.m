function errors=ask_Nyq_filter(k,Nbits,nsamp,EbNo,delay,rolloff)
% Η συνάρτηση αυτή εξομοιώνει την παραγωγή και αποκωδικοποίηση
% θορυβώδους ακολουθίας L-ASK και μετρά τα λαθεμένα σύμβολα,
% με μορφοποίηση παλμών μέσω φίλτρου τετρ. ρίζας Nyquist.
%%%%%% ΠΑΡΑΜΕΤΡΟΙ %%%%%%%
% k είναι ο αριθμός των bits ανά σύμβολο, έτσι L=2^k
% Nsymb είναι το μήκος της εξομοιούμενης ακολουθίας συμβόλων L-ASK
% nsamp είναι ο συντελεστής υπερδειγμάτισης, δηλ. #samples/Td
% EbNo είναι ο ανηγμένος σηματοθορυβικός λόγος, Εb/No, σε db
L=2^k;
SNR=EbNo-10*log10(nsamp/2/k); % SNR ανά δείγμα σήματος

% Διάνυσμα τυχαίων bits
bits = randi([0 1], [1 Nbits]);


% mapping
step = 2;
% Gray
mapping=[step/2; -step/2];
if(k>1)
 for j=2:k
   mapping=[mapping+2^(j-1)*step/2; ...
  -mapping-2^(j-1)*step/2];
 end
end
% alternative
% mapping=-(L-1):step:(L-1);
xsym=bi2de(reshape(bits,k,length(bits)/k).','left-msb');
x=[];
for i=1:length(xsym)
 x=[x mapping(xsym(i)+1)];
end

% Ορισμός παραμέτρων φίλτρου
% delay = 8; % Group delay (# of input symbols)
filtorder = delay*nsamp*2; % τάξη φίλτρου
% rolloff = 0.25; % Συντελεστής πτώσης -- rolloff factor
% κρουστική απόκριση φίλτρου τετρ. ρίζας ανυψ. συνημιτόνου
rNyquist= rcosine(1,nsamp,'fir/sqrt',rolloff,delay);

% ΕΚΠΕΜΠΟΜΕΝΟ ΣΗΜΑ
% Υπερδειγμάτιση και εφαρμογή φίλτρου rNyquist
y=upsample(x,nsamp);
ytx = conv(y,rNyquist);
ynoisy=awgn(ytx,SNR,'measured'); % θορυβώδες σήμα

% ΛΑΜΒΑΝΟΜΕΝΟ ΣΗΜΑ
% Φιλτράρισμα σήματος με φίλτρο τετρ. ρίζας ανυψ. συνημ.
yrx=conv(ynoisy,rNyquist);
yrx = downsample(yrx,nsamp); % Υποδειγμάτιση
yrx = yrx(2*delay+1:end-2*delay); % περικοπή, λόγω καθυστέρησης

% Ανιχνευτής ελάχιστης απόστασης L πλατών
for i=1:length(yrx)
    [m,j]=min(abs(mapping-yrx(i)));
    yrx(i)=mapping(j);
end
err=not(x==yrx);
errors=sum(err);
end
