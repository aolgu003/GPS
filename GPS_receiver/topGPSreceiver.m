%Receiver Top
%Initialize params: fid, BL_target, 

clear all

fsampIQ = 5.0e6; % IQ sampling frequency (Hz)
fIF = 2.5e6;

BL_target = 10;
sv = [1 10];
Tc = 1e-3; %milli second chip rate
Tsub = 10;
looporder = 2;
N = 1;
M = 10;

run_time = .5; %in seconds

fid = fopen('niData01head.bin','r','l');

[gps_lat, gps_long, t] = gps_receiver(fid, sv, N, M, Tc, fIF, fsampIQ, ...
                                        BL_target, Tsub, looporder, run_time );