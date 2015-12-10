function [ sub_accumm ] = gen_accum( samples, T, fIF, cx, Beta)
%UNTITLED Summary of this function goes here
%   BBsamp - is the samples that this accumulator will be analyzing
%   fIF - The intermidiate frequency that the accumulator will be
%   shifting the baseband samples to.
%   T - The sampling time that the baseband samples were taken at
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

j = 1;
n = (0:(length(samples)-1))';
% 
% sub_accumm = zeros([Beta length(samples)]);

%itereate through all doppler frequencys and store the fd vs time values
for fd = -10e3:500:10e3
% %     IQvalues = samples.*(exp(-1j*(2*pi*(fIF+fc).*n.* T))); % there must be a problem with the doppller removal
%     I_vals = samples .* cos(2*pi*(fIF+fc).*n.*T);
%     Q_vals = samples .* sin(2*pi*(fIF+fc).*n.*T);
%     
%     x = I_vals + j*Q_vals;

    fc = (fIF + fd);
    sub_accumm(j,:) = fft_search(samples, cx, fc, 1/T);
    j = j + 1;
end


end

