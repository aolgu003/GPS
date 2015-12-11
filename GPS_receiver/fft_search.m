function [ C ] = fft_search( samp,j, CA, fc, fs )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

t = (j-1:(j+length(samp)-2))/fs;

% I = samp'.*cos(2*pi*fc.*t);
% Q = samp'.*sin(2*pi*fc.*t);

sig = samp'.*exp(-1j*2*pi*fc*t);

%circular correlation
X = fft(sig);
four_CA = conj(fft(CA));

c = ifft(X.*four_CA);

C = abs(c).^2;

end

