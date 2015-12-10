nfft = 1024;     % Size of FFT used in power spectrum estimation
window = 250;
Tfull = 0.5; % Time interval of data to load
fsampIQ = 5.0e6; % IQ sampling frequency (Hz)
Tl = 1/fsampIQ;
N = floor(fsampIQ*Tfull);
fIF = 2.5e6;

fid = fopen('niData01head.bin','r','l');
Y = fread(fid, [2,N], 'int16')';

Xorig = Y(:,1) + j*Y(:,2);


Xvec = iq2if(Y, Tl, fIF);
[Ivec, Qvec] = if2iq(Xvec, Tl/2, fIF);

Xif = Ivec + 1j*Qvec;


%----- Calculate IF signal
[Sxx, fVec1] = pwelch(Xorig, window, [], nfft,fIF);

[Syy, fVec2] = pwelch(Xif, window, [], nfft, 1/Tl);

close all
%----- Display power spectral density estimate
yLow = min(10*log10(Syy));
yHigh = max(Syy);
T = nfft/fsampIQ;
delf = 1/T;
fcenter = (nfft/2)*delf;
fVec2 = (fVec2 - fcenter);
Syy = [Syy(nfft/2 + 1 : end); Syy(1:nfft/2)];
figure;
hold on
area(fVec2/1e6,10*log10(Syy),yLow);
% ylim([yLow,yHigh]);
grid on;
shg;
title('Power spectral density estimate of GPS L1 Signal');
xlabel('Frequency (MHz)');
ylabel('Power density (dB/Hz)');
hold off

yLow = min(10*log10(Sxx));
yHigh = max(Sxx);
T = nfft/fsampIQ;
delf = 1/T;
fcenter = (nfft/2)*delf;
fVec1 = (fVec1 - fcenter);
Syy = [Sxx(nfft/2 + 1 : end); Sxx(1:nfft/2)];
figure;
hold on
area(fVec1/1e6,10*log10(Sxx),yLow);
% ylim([yLow,yHigh]);
grid on;
shg;
title('Power spectral density estimate of GPS L1 Signal');
xlabel('Frequency (MHz)');
ylabel('Power density (dB/Hz)');
hold off

