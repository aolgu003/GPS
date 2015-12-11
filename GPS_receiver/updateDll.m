function [vTotal] = updateDll(s)
% updateDll : Perform a single update step of a carrier-aided first-order code
% tracking loop.
%
%
% INPUTS
%
% s ------------- A structure with the following fields:
%
% BL_target -- Target bandwidth of the closed-loop code tracking loop, in
% Hz.
%
% IsqQsqAvg -- The average value of |Stildek|^2 = Ipk^2 + Qpk^2; also equal to
% (Nk*Abark/2)^2 + 2*sigmaIQ^2.
%
% sigmaIQ ---- The standard deviation of the noise in the prompt in-phase
% and quadrature subaccumulations.
%
% Ipk -------- The in-phase prompt subaccumulation over the interval from
% tkm1 to tk.
%
% Qpk -------- The quadrature prompt subaccumulation over the interval from
% tkm1 to tk.
%
% Iek -------- The in-phase early subaccumulation over the interval from
% tkm1 to tk.
%
% Qek -------- The quadrature early subaccumulation over the interval from
% tkm1 to tk.
%
% Ilk -------- The in-phase late subaccumulation over the interval from
% tkm1 to tk.
%
% Qlk -------- The quadrature late subaccumulation over the interval from tkm1
% to tk.
%
%
% vpk -------- The aiding signal from the phase tracking loop, in seconds
% per second. This is equal to the Doppler frequency shift
% that will be used to drive the receiver’s carrier-tracking
% numerically controlled oscillator during the time interval
% from tk to tkp1, divided by the carrier frequency and
% multiplied by -1 (high-side mixing) or 1 (low-side mixing)
% depending on whether the RF front-end peforms high- or
% low-side mixing. Thus, vpk = sMix*fDk/fc, with sMix = +/- 1.
%
% Tc --------- Spreading code chip interval, in seconds.
%
% OUTPUTS
%
% vTotalk ---- The code tracking loop’s estimate of the code phase rate at
% sample time tk, in sec/sec. vTotal is equal to the code
% tracking loop’s correction term vk plus the carrier aiding
% term vpk.
%
%+------------------------------------------------------------------------------+
% References:
%
%
%+==============================================================================+
% detect the code phase using a dot product phase detector
C = s.Tc/2/(s.IsqQsqAvg - 2*s.sigmaIQ^2);
ek = C*((s.Iek - s.Ilk)*s.Ipk + (s.Qek - s.Qlk)*s.Qpk);

% pass through the first order loop filter
vk = 4*s.BLtarget*ek;

% add in the aiding information from the PLL
vTotal = vk + s.vpk;
