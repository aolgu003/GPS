function [gps_lat, gps_long, t] = gps_receiver(fid, sv, N, M, Tc, fIF, fsampIQ, ...
                                                BL_target, Tsub, looporder, run_time)
%UNTITLED2 Summary of this function goes here
%   s ----- A structure array with the following fields
%            Ipk
%            Qpk
%            Iek
%            Qek
%            Ilk
%            Qlk
%            xk
%            BL_target
%            IsqQsqAvg
%            sigmaIQ
%            Ad,bd,Cd,Dd
%            vpk
%            Tc

load('CA_code.mat');
Tl = 1/fsampIQ;
T = Tl/2;
fsampIF = 1/T;
s.Tl = Tl;
s.Tc = Tc;
s.M = M;
s.N = N;
s.Nk = Tc*1/(Tl);
s.BL_target = BL_target;
[s.Ad, s.Bd, s.Cd, s.Dd] = configureLoopFilter(BL_target, Tsub, looporder);

% data = fread(fid,[2 N], 'uint16');
[sv_present, fc_hat, ts_hat] = acquisition(fid, sv, N, M, Tc, T, fIF);



frewind(fid);

gps_lat = 0;
gps_long = 0;

j = 1;
Number_points = fsampIQ*run_time;
for t = 0:((s.Nk*s.M*s.N)*s.Tl):run_time
    [s] = computeCorrelation(fid, t, s, sv_present, fc_hat, ts_hat, fsampIQ);
    states_info(j) = s;
    j = j+1;
%     [xkp1, s.vpk] = updatePll(s);
%     vtotal = updateDll(s);
%     
%     s.xk = xkp1;
end


% end

