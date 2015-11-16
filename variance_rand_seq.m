%----- Setup
nStages = 10;                 % Number of stages in LFSR
Tc = 1e-3/1023;               % Chip interval in seconds
delChip = 3/217;              % Sampling interval in chips
delt = delChip*Tc;            % Sampling interval in seconds
fs = 1/delt;                  % Sampling frequency in Hz
Np = 2^nStages - 1;           % Period of the sequence in chips
Nr = 20;                      % Number of repetitions of the sequence
Ns = round(Nr*Np/delChip);    % Number of samples of the sequence 

%----- Generate codes
X1 = zeros(100,1);
X2 = zeros(100,1);

X1 = sign(sign(randn(100,1)) + 0.1);
X2 = sign(sign(randn(100,1)) + 0.1);

[Rseq12,iiVecSeq] = ccorr(X1,X2);
var(Rseq12)
V = sum((Rseq12-mean(Rseq12)).^2)

plot(V)

