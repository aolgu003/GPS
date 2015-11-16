function [S4,tau0] = computeS4AndTau0(zkhist,tkhist)
% computeS4AndTau0 : Compute the scintillation index S4 and the decorrelation
% time tau0 corresponding to the input complex channel
% response function time history zkhist.
%
%
% INPUTS
%
% zkhist ----- Nt-by-1 vector containing the normalized complex scintillation
% time history in the form of averages over Ts with sampling
% interval Ts. zkhist(kp1) is the average over tk to tkp1.
%
% tkhist ----- Nt-by-1 vector of time points corresponding to zkhist.
%
%
% OUTPUTS
%
% S4 --------- Intensity scintillation index of the scintillation time history
% in zkhist, equal to the mean-normalized standard deviation of
% the intensity abs(zkhist).^2.
%
% tau0 ------- The decorrelation time of the scintillation time history in
% zkhist, in seconds.
%
%
%+------------------------------------------------------------------------------+
% References:
% mean normalization:
% http://stn.spotfire.com/spotfire_client_help/norm/norm_normalize_by_mean.htm
%
% Calculating Scintillation parameters:
%Humphreys, Todd E., Mark L. Psiaki, Joanna C. Hinks, Brady O'hanlon,
% and Paul M. Kintner.
%"Simulating Ionosphere-Induced Scintillation for Testing GPS Receiver Phase Tracking Loops."
% IEEE J. Sel. Top. Signal Process. IEEE Journal of Selected Topics in Signal Processing: 707-15.
% 
%+==============================================================================+

 S4 = std(abs(zkhist).^2/mean(abs(zkhist).^2));
 
 
 