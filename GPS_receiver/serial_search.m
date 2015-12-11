function [ C ] = serial_search( samp,j, CA, fc, fs )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

t = (j-1:(j+length(samp)-2))/fs;

sig = samp'.*exp(-1j*2*pi*fc*t);
C = zeros(size(samp));
for ts = 1:length(samp)
    Itilde = sum(real(sig).*CA);
    Qtilde = sum(imag(sig).*CA);
    
    CA = circshift(CA',1)';
    C(ts) = abs(Itilde).^2+abs(Qtilde).^2;
end

end
