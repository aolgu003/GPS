% function genearates C/A prn code and generates .mat file with this code 
% for N seconds 
function CA_code_generator(sv,time_CA) 
% sv      - satellite PRN numbers e.g. [10 11] 
% time_CA - how long PRN sequence should be in seconds 
 
% table of C/A Code Tap Selection (sets delay for G2 generator) 
tap=[   2  6; 
    3  7; 
    4  8; 
    5  9; 
    1  9; 
    2 10; 
    1  8; 
    2  9; 
    3 10; 
    2  3; 
    3  4; 
    5  6; 
    6  7; 
    7  8; 
    8  9; 
    9 10; 
    1  4; 
    2  5; 
    3  6; 
    4  7; 
    5  8; 
    6  9; 
    1  3; 
    4  6; 
    5  7; 
    6  8; 
    7  9; 
    8 10; 
    1  6; 
    2  7; 
    3  8; 
    4  9; 
    5 10; 
    4 10; 
    1  7; 
    2  8; 
    4 10    ]; 
 
CA_prn(32).data = [];  
 
for ii=1:size(sv,2) 
     
    % G1 LFSR: x^10+x^3+1 
    s  = [0 0 1 0 0 0 0 0 0 1]; 
    %n  = length(s); 
    %n  = 10; 
    %g1 = ones(1,n);	% initialization vector for G1 
    g1 = [1 1 1 1 1 1 1 1 1 1];	% initialization vector for G1 
    %L  = 2^n-1; 
    L  = 1023; 
     
    % G2j LFSR: x^10+x^9+x^8+x^6+x^3+x^2+1 
    t = [0 1 1 0 0 1 0 1 1 1]; 
    %q = ones(1,n);	% initialization vector for G2 
    q = [1 1 1 1 1 1 1 1 1 1];	% initialization vector for G2 
     
    g2      = zeros(1,L); 
    prn     = g2; 
     
    % generate C/A Code sequences: 
    for inc = 1:L 
        g2(1,inc)   =  mod(q(tap(sv(ii),1))+q(tap(sv(ii),2)),2); 
        prn(1,inc)  =  mod(g1(10)+g2(1,inc),2); 
        %               x^10 + x^3 
        g1          = [mod(g1(3)*s(3)+g1(10)*s(10),2) g1(1:9)]; 
        %g1         = [mod(sum(g1.*s),2) g1(1:n-1)]; 
        %               x^10 + x^9 + x^8 + x^6 + x^3 + x^2 
        q           = [mod(q(2)*t(2)+q(3)*t(3)+q(6)*t(6)+q(8)*t(8)+q(9)*t(9)+q(10)*t(10),2) q(1:9)]; 
        %q          = [mod(sum(q .*t),2)  q(1:n-1)]; 
    end 
     
    % generate C/A code time_CA seconds long 
    % 1 C/A code = 1ms = 0.001 s, size=1023 chips 
     
    % how many codes there will fit in this time frame 
    n     = floor(time_CA*1000*1023); 
    chips = floor(time_CA*1000*1023-n)+1; % fractional chips 
    chips_total = n + chips; 
     
    CA_prnx = zeros(1,chips_total); 
    for i = 1: n/1023 
        CA_prnx((i-1)*1023+1:i*1023) = prn; 
    end 
    CA_prnx(i*1023+1:i+1023+1+chips) = prn(1:chips); 
     
    CA_prn(sv(ii)).data = int8(CA_prnx);     
end 
save CA_code.mat CA_prn time_CA 