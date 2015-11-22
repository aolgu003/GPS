%----- Setup
Tfull = 0.5; % Time interval of data to load
fsampIQ = 5.0e6; % IQ sampling frequency (Hz)
N = floor(fsampIQ*Tfull);
nfft = 2^9; % Size of FFT used in power spectrum estimation

%----- Load data
fid = fopen('niData01head.bin','r','l');
Y = fread(fid, [2,N], 'int16')';
X = Y(:,1) + j*Y(:,2);


Z = iq2if(Y(:,1), Y(:,2), 1/fsampIQ,300000);
[Syy, fVec] = pwelch(Y, window, [], nfft, fsampIQ);

fclose(fid);