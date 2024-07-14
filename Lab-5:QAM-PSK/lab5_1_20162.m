close all; clear all; clc;

% Χαρακτηριστικά του συστήματος
M=64; % 64-QAM
L=sqrt(M); % διάσταση του τετραγώνου
l=log2(L); % αριθμός bit ανά συνιστώσα

% Διάνυσμα mapping για την κωδικοποίηση Gray M-QAM
% Αφορά σε πλήρες ορθογωνικό πλέγμα σημείων, διάστασης M=L2
% l=log2(L): αριθμός bit ανά συνιστώσα (inphase, quadrature)
core=[1+1i;1-1i;-1+1i;-1-1i]; % τετριμμένη κωδικοποίηση, M=4
mapping=core;
if(l>1)
 for j=1:l-1
 mapping=mapping+j*2*core(1);
 mapping=[mapping;conj(mapping)];
 mapping=[mapping;-conj(mapping)];
 end
end


scatterplot(mapping);
title('64-QAM');
for k = 1 : length(mapping)
    text(real(mapping(k)), imag(mapping(k)), num2str(de2bi(k-1, log2(M), 'left-msb')), 'FontSize', 6, 'Color', 'white');
end 