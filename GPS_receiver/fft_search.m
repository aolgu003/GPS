function [ C ] = fft_search( samp, CA, fc, fs )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

t = (0:(length(samp)-1))/fs;

I = samp'.*cos(2*pi*fc.*t);
Q = samp'.*sin(2*pi*fc.*t);

%circular correlation
X = fft(I+j*Q);
four_CA = conj(fft(CA));

c = ifft(X.*four_CA);

C = abs(c).^2;

end

