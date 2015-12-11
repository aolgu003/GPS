function [ sub_accumm ] = gen_accum( samples, j, T, cx, Beta)
%UNTITLED Summary of this function goes here
%   BBsamp - is the samples that this accumulator will be analyzing
%   fIF - The intermidiate frequency that the accumulator will be
%   shifting the baseband samples to.
%   T - The sampling time that the baseband samples were taken at
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i = 1;
% n = (0:(length(samples)-1))';

sub_accumm = zeros([Beta length(samples)]);

%itereate through all doppler frequencys and store the fd vs time values
for fd = -5e3:250:5e3
    sub_accumm(i,:) = fft_search(samples, j, cx, fd, 1/(2*T));
%     test_accumm(i,:) = serial_search(samples, j, cx, fd, 1/(2*T));

    i = i + 1;
end
end

