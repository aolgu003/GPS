function [IVec,QVec] = if2iq(xVec,T,fIF)
% IF2IQ : Convert intermediate frequency samples to baseband I and Q samples.
%
% Let x(n) = I(n*T)*cos(2*pi*fIF*n*T) - Q(n*T)*sin(2*pi*fIF*n*T) be a
% discrete-time bandpass signal centered at the user-specified intermediate
% frequency fIF, where T is the bandpass sampling interval. Then this
% function converts the bandpass samples to quadrature samples from a complex
% discrete-time baseband representation of the form xl(m*Tl) = I(m*Tl) +
% j*Q(m*Tl), where Tl = 2*T.
%
%
% INPUTS
%
% xVec -------- N-by-1 vector of intermediate frequency samples with
% sampling interval T.
%
% T ----------- Sampling interval of intermediate frequency samples, in
% seconds.
%
% fIF --------- Intermediate frequency of the bandpass signal, in Hz.
%
%
% OUTPUTS
%
% IVec -------- N/2-by-1 vector of in-phase baseband samples.
%
% QVec -------- N/2-by-1 vector of quadrature baseband samples.
%
%
%+------------------------------------------------------------------------+
% References:
%
%
%+========================================================================+

B = .8/(2*T); %fs = 1/T = 2W where W = B/.8

It = zeros(size(xVec));
Qt = zeros(size(xVec));

% Down mix the signal
for n = 0:length(xVec)-1
    It(n+1) = xVec(n+1)*cos(2*pi*fIF*n*T);
    Qt(n+1) = xVec(n+1)*sin(2*pi*fIF*n*T);
end
clear n xVec;

% Low pass filter the down mixied signal
normfIF = (5e6)*T;
[b,a] = butter(1,normfIF);

Iw = sqrt(2)*filter(b,a,It);
Qw = sqrt(2)*filter(b,a,Qt);
clear It Qt;

%Decimate the filtered signal
IVec = decimate(Iw,2);
QVec = decimate(Iw, 2);
% IVec = It;
% QVec = Qt;
