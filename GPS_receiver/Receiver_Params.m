clear all

Tfull = 0.5; % Time interval of data to load
fsampIQ = 5.0e6; % IQ sampling frequency (Hz)
Tl = 1/fsampIQ;
N = floor(fsampIQ*Tfull);
fIF = 2.5e6;

fid = fopen('niData01head.bin','r','l');
Y = fread(fid, [2,N], 'int16')';

Xorig = Y(:,1) + j*Y(:,2);


Xvec = iq2if(Y, Tl, fIF);
[Ivec, Qvec] = if2iq(Ivec, Qvec, Tl/2, fIF);

Xif = Ivec + 1j*Qvec;

