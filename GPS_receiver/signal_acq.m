clear all

nfft = 2^9;     % Size of FFT used in power spectrum estimation
window = 250;
Tfull = 0.5; % Time interval of data to load
fsampIQ = 5.0e6; % IQ sampling frequency (Hz)
fIF = 2.5e6;
Tl = 1/fsampIQ;
N = floor(fsampIQ*Tfull);
T = Tl/2;
fsampIF = 1/T; 

Tc = 1e-3; %milli seconds

fid = fopen('niData01head.bin','r','l');
Y = fread(fid, [2,N], 'int16')';
Y = Y(:,1) + 1j*Y(:,2);
samples_IF = iq2if(real(Y), imag(Y), Tl ,fIF );

% [Syy, fVec2] = pwelch(samples_fIF, 200, 100, nfft, 2/Tl,'psd', 'center220ed');
% yLow2 = min(10*log10(Syy));
% area(fVec2/1e6,10*log10(Syy),yLow2);

%generate C/A codes
sv = [1:31];
CA_codes = cacode(sv,fsampIF/1.023e6);

N0 = Tc*fsampIF;

Beta = length(-10e3:500:10e3);
sub_accum = zeros([Beta N0 length(sv)]);

tstart = 1;
M = 10;
for tcoh = 1:M
    %grab a new chunk of data
    IFsamp = samples_IF(tstart:(tstart+N0-1));
    
    for i=1:length(sv)
        %get new ca code
        cx = CA_codes(i,:);
        
        %Generate sub-accum
        sub_accum(:,:,i) = sub_accum(:,:,i) + ...
            gen_accum( IFsamp, T, fIF, cx, Beta);  
    end
    tstart = tstart+N0;
    
end

figure
mesh(sub_accum(:,:,10))
title('C/A code 10')
xaxis('Dopplar shift (kHz)')
yaxis('Time Shift (s)')

