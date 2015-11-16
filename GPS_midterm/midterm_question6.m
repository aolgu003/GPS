close all
clear all

n = 9;
D1 = [4, 9]';
D2 = [3, 4, 6, 9]';

a0Vec = [ 0 0 0 0 0 0 0 0 1 ]';
lfsrSeq1 = generateLfsrSequence(n, D1, a0Vec);
lfsrSeq2 = generateLfsrSequence(n, D2, a0Vec);


[Rseq1,iiVecSeq] = ccorr(lfsrSeq1, lfsrSeq1);
Rseq1 = 2*Rseq1 - 1;
[Rseq1,iiVecSeq] = ccorr(lfsrSeq2, lfsrSeq2);
[Rseq12,iiVecSeq] = ccorr(lfsrSeq1, lfsrSeq2)

goldSeq = xor(lfsrSeq1, lfsrSeq2);
goldSeq = 2*goldSeq - 1;
[GoldR, iigoldSeq] = ccorr(goldSeq, goldSeq);

plot(iiVecSeq, Rseq1)

figure
plot(iigoldSeq, GoldR)
figure
plot(iiVecSeq, Rseq12)