% topSimulateTrainDoppler.m
%
% Top-level script for train Doppler simulation


%clear; clc; clf;
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

%----- Simulate
[fDVec,tVec] = simulateTrainDoppler(fc,vTrain,t0,x0,xObs,dObs,delt,N,vs);
fApparentVec = fDVec + fc;

%----- Plot
plot(tVec,fDVec + fc, 'r');
xlabel('Time (seconds)');
ylabel('Apparent horn frequency (Hz)');
grid on;
shg;

%----- Generate a sound vector
T = delt*N;                    % simulation time (sec)
fs = 22050;                    % sample frequency (Hz)
deltSamp = 1/fs;               % sampling interval (sec)
Ns = floor(T/deltSamp);        % number of samples
tsamphist = [0:Ns-1]'*deltSamp;
Phihist = zeros(Ns,1);
fApparentVecInterp = interp1(tVec,fApparentVec,tsamphist,'spline');
for ii=2:Ns
  fii = fApparentVecInterp(ii);
  Phihist(ii) = Phihist(ii-1) + 2*pi*fii*deltSamp;
end
soundVec = sin(Phihist);

% %----- Play the sound vector
% sound(soundVec, fs);    

%----- Write to audio file
wavwrite(soundVec,fs,32,'trainout.wav');

%----- Write frequency time history to output file
save trainData fApparentVec tVec