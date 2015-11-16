function [ fDVec, tVec ] =...
    simulateTrainDoppler(fc, vTrain, t0, x0, xObs, dObs, delt, N, vs)
% simulateTrainDoppler : Simulate the train horn Doppler shift scenario.
%
% INPUTS
%
% fc ------ train horn frequency, in Hz
%
% vTrain -- constant along-track train speed, in m/s
%
% t0 ------ time at which train passed the along-track coordinate x0, in
% seconds
%
% x0 ------ scalar along-track coordinate of train at time t0, in meters
%
% xObs ---- scalar along-track coordinate of observer, in meters
%
% dObs ---- scalar cross-track coordinate of observer, in meters (i.e.,
% shortest distance of observer from tracks)
%
% delt ---- measurement interval, in seconds
%
% N ------- number of measurements
%
% vs ------ speed of sound, in m/s
%
%
% OUTPUTS
%
% fDVec --- N-by-1 vector of apparent Doppler frequency shift measurements as
% sensed by observer at the time points in tVec
%
% tVec ---- N-by-1 vector of time points starting at t0 and spaced by delt
% corresponding to the measurements in fDVec
%
%+------------------------------------------------------------------------------+
% References: Global Positioning Systems
%
%
% Author: Andrew Olguin
%+==============================================================================+

x = x0;
dx = vTrain*delt;
rprev = 0;
j = 1;
t_end = delt*N;
fDVec = zeros([1 N+1]);
tVec = zeros([1 N+1]);
r = sqrt((xObs - x)^2 + dObs^2 );

for t = t0-delt:delt:t_end
    if t > 0
        % update the train state
        x = x + dx;
        r = sqrt((xObs - x)^2 + dObs^2 );
    end
    
    % use updated train state to calculate the shifted frequency    
    v_los = (r - rprev)/delt;
    fr = fc*(1-v_los/vs);
    
    fDVec(j) = fr - fc;
    tVec(j) = t;
    j = j+1;
    rprev = r;    
end

fDVec = fDVec(3:end);
tVec = tVec(3:end);

