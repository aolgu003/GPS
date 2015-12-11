% topPerformAcqHypothesisCalcs
%
% Top-level script for performing acquisition calculations

%----- Setup
clear 
clc
% s.C_N0dBHz = 44;    
s.N = 1;    
s.M = 10;
s.PfaAcq = .001;   
s.Tsub = 0.001;     
s.fMax = 7000;
s.nCodeOffsets = 1023*5; 
s.ZMax = 1000;
s.delZ = 0.1;

%----- Execute
figure(1)
clf
Pd = 0;
i = 1;
for C_N0dBHz = 30:3:51
    s.C_N0dBHz = C_N0dBHz;
    while Pd < .95
        [pZ_H0,pZ_H1,lambda0,Pd,ZVec] = performAcqHypothesisCalcs(s);
        s.N = s.N+1;
        Pd_array(i) = Pd;
        i = i+1;
    end
    i = 1;
    Pd = 0;
    hold on
    figure
    stem(Pd_array)
    hold off
end

%----- Visualize the results
figure(2);
[pmax,iimax] = max(pZ_H1);
Zmax = ZVec(iimax);
clf;
ash = area(ZVec,pZ_H0);
set(get(ash,'children'), 'facecolor', 'g', 'linewidth', 2, 'facealpha', 0.5);
hold on;
ash = area(ZVec,pZ_H1);
set(get(ash,'children'), 'facecolor', 'b', 'linewidth', 2, 'facealpha', 0.5);
linemax = 1/5*max([pZ_H0;pZ_H1]);
line([lambda0,lambda0],[0,linemax], 'linewidth', 2, 'color', 'r');
xlim([0 max(Zmax*2,lambda0*1.5)]);
ylabel('Probability density');
xlabel('Z');
fs = 12;
title('GNSS Acquisition Hypothesis Testing Problem');
disp(['Probability of acquisition false alarm (PfaAcq): ' ...
      num2str(s.PfaAcq)]);
disp(['Probability of detection (Pd): ' num2str(Pd)]);
text(lambda0,linemax*1.1, ['\lambda_0 = ' num2str(lambda0) ], ...
     'fontsize',fs);
shg