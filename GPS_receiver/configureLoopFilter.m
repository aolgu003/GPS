function [Ad,Bd,Cd,Dd,BL_act] = configureLoopFilter(BL_target,Tsub,loopOrder)
% configureLoopFilter : Configure a discrete-time loop filter for a feedback
% tracking loop.
%
% INPUTS
%
% BL_target ----- Target loop noise bandwidth of the closed-loop system, in Hz.
%
% Tsub ---------- Subaccumulation interval, in seconds. This is also the loop
% update (discretization) interval.2:
%
% loopOrder ----- The order of the closed-loop system. Possible choices are
% 1, 2, or 3.
%
% OUTPUTS
%
% Ad,Bd,Cd,Dd --- Discrete-time state-space model of the loop filter.
%
% BL_act -------- The actual loop noise bandwidth (in Hz) of the closed-loop
% tracking loop as determined by taking into account the
% discretized loop filter, the implicit integration of the
% carrier phase estimate, and the length of the accumulation
% interval.
%
%+------------------------------------------------------------------------------+
% References:
%+==============================================================================+


if loopOrder == 1
    K = 4 * BL_target;
    Fs = K;
elseif loopOrder == 2
    K = 8*BL_target/3;
    a = K/2;
    omegaN = sqrt(K*a);
    Fs = K*tf([1 a],[1 0]);
elseif loopOrder == 3
    a = 1.2 * BL_target;
    b = a^2 / 2;
    K = 2 * a;
    Fs = K*tf([1 a b],[1 0 0])
end

Fz = c2d(Fs,Tsub,'zoh'); % Conversion to discrete time
NCO = tf([Tsub],[1 -1],Tsub);
PD = 1/2*tf([1 1],[1 0],Tsub);
sysOpenLoop = PD*Fz*NCO;
[Aol,Bol,Col,Dol]=ssdata(ss(sysOpenLoop));
% Convert the loop filter to a discrete-time state-space model
[Ad,Bd,Cd,Dd]=ssdata(Fz);

end