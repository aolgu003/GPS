function [xVec] = iq2if(IVec,QVec,Tl,fIF)
% IQ2IF : Convert baseband I and Q samples to intermediate frequency samples.
%
% Let xl(m*Tl) = I(m*Tl) + j*Q(m*Tl) be a discrete-time baseband
% representation of a bandpass signal. This function converts xl(n) to a
% discrete-time bandpass signal x(n) = I(n*T)*cos(2*pi*fIF*n*T) -
% Q(n*T)*sin(2*pi*fIF*n*T) centered at the user-specified intermediate
% frequency fIF, where T = Tl/2.
%
%
% INPUTS
%
% IVec -------- N-by-1 vector of in-phase baseband samples.
%
% QVec -------- N-by-1 vector of quadrature baseband samples.
%
% Tl ---------- Sampling interval of baseband samples (complex sampling
% interval), in seconds.
%
% fIF --------- Intermediate frequency to which the baseband samples will
% be up-converted, in Hz.
%
%
% OUTPUTS
%
% xVec -------- 2*N-by-1 vector of intermediate frequency samples with
% sampling interval T = Tl/2.
%
%
%+------------------------------------------------------------------------+
% References:
%
%
%+========================================================================+

T = Tl/2;

Im = interp(IVec,2);

Qm = interp(QVec,2);

% n = 0:T:length(IVec);
i = 1;
n = 0;
for j=1:length(Im)
    I = Im(i)*cos(2*pi*fIF*n*T);
    Q = Qm(i)*sin(2*pi*fIF*n*T);
    xVec(i) = I+1i*Q;
    i = i+1;
    n = n + T;
end