%% Επίδειξη μορφοποίησης παλμών L-ASK με φίλτρο Nyquist
% και φιλτραρίσματος με το αντίστοιχο προσαρμ. φίλτρο
clear all; close all;
k=3; Nbits=9999; nsamp=32; step=2;
L=2^k;
% Διάνυσμα τυχαίων bits
bits = randi([0 1], [1 Nbits]);

%Gray mapping
mapping=[step/2; -step/2];
if(k>1)
 for j=2:k
 mapping=[mapping+2^(j-1)*step/2; ...
 -mapping-2^(j-1)*step/2];
 end
end
xsym=bi2de(reshape(bits,k,length(bits)/k).','left-msb');
x=[];
for i=1:length(xsym)
 x=[x mapping(xsym(i)+1)];
end

% Ορισμός παραμέτρων φίλτρου
delay = 4; % Group delay (# of input symbols)
filtorder = delay*nsamp*2; % τάξη φίλτρου
rolloff = 0.4; % Συντελεστής πτώσης -- rolloff factor
% κρουστική απόκριση φίλτρου τετρ. ρίζας ανυψ. συνημιτόνου
rNyquist = rcosine(1,nsamp,'fir/sqrt',rolloff,delay);

% ΕΚΠΕΜΠΟΜΕΝΟ ΣΗΜΑ
% Υπερδειγμάτιση και εφαρμογή φίλτρου rNyquist
y=upsample(x,nsamp);
ytx = conv(y,rNyquist); clear y;

% Λαμβανόμενο σήμα: ytx (χωρίς παραμόρφωση)
% Φιλτράρισμα σήματος με φίλτρο τετρ. ρίζας ανυψ. συνημ.
yrx=conv(ytx,rNyquist);
yrx=yrx(2*delay*nsamp+1:end-2*delay*nsamp); %Περικοπή-λόγω καθυστέρησης

% Σχεδίαση yrx και υπέρθεση x
figure(1);
plot(yrx(1:10*nsamp)); hold;
stem([1:nsamp:nsamp*10],x(1:10),'filled');
title('The first 10 symbols')
grid; pause

figure(2);
pwelch(yrx); pause 