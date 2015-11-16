% topSimulateTrainDoppler.m
%
% Top-level script for train Doppler simulation

close all
clear all; clc; clf;

load trainData.mat
%----- Setup
fc = 440;
vTrain = 20;
t0 = 0;
x0 = 0;
delt = 0.01;
N = 1000;
vs = 343;
xObs = 100;
dObs = 100;

%----- find the distance down the track
index = find(fApparentVec-fc > 0);
xObs = tVec(index(end))*vTrain;
fDVecArray = zeros([ length(1:.01:300) N]);
j =1;
%----- Simulate
for i=1:.01:300
    [fDVec,tVec] = simulateTrainDoppler(fc,vTrain,t0,x0,xObs,i,delt,N,vs);
    fDVecArray(j,:) = fDVec-(fApparentVec-fc);
    j=j+1;
end
[val ind] = min(var(fDVecArray'))


%----- Calculate rate of change for r
rdot = vs*fDVec/fc+1;
plot(tVec, rdot)

%----- Plot
figure
plot(tVec,fDVec + fc, 'r');
xlabel('Time (seconds)');
ylabel('Apparent horn frequency (Hz)');
grid on;
shg;