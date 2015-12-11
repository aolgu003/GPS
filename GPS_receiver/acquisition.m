function [ sv_present, fc_hat, ts_hat ] = acquisition( fid, sv, N, M, Tc, T, fIF )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
sv_present = zeros(size(sv));
fc_hat = zeros(size(sv));
ts_hat = zeros(size(sv));

fsampIF = 1/T;
samples = fread(fid, [2 N*M*Tc*fsampIF], 'int16')';


Tl = 2 * T;
Nk = Tc*1/Tl;

if size(samples,2) == 2
    samples = samples(:,1) + 1j*samples(:,2);
%     samples_IF = iq2if(real(samples), imag(samples), Tl ,fIF);
    CA_codes = 2.*cacode(sv,1/Tl/1.023e6)-1;

else
    samples_IF = samples;
end

Beta = length(-5e3:250:5e3);
Sk = zeros([Beta Nk]);

j = 1;
for i=1:length(sv)
    S = 0;
    for l = 1:N
        for k = 1:M
            % IFsamp = samples_IF(j:(j+Nk-1));
            % data = samples(j:(j+Nk-1));
            %get new ca code
            code = CA_codes(i,:);
            
            %Generate sub-accum
            [Sk ] = [Sk] + ...
                gen_accum(samples(j:(j+Nk-1)), j, T, code, Beta);
            j = j+Nk;
        end
        
        % S = S + abs(real(Sk)).^2 + abs(imag(Sk)).^2;
    end
    Z = 1/M.*Sk;
    
    %grab a new chunk of data
    j=1;
    
    [max_peak, ts_ind] = max(max(Z));
    [~, fd_index] = max(max(Z'));
    
    fd_hat = -5e3+ 250*fd_index;
    if(fd_index > length(Beta/2))
        noiseFloor = mean(mean(Z(1:floor(Beta/2)-1,:)));
    else
        noiseFloor = mean(mean(Z(floor(Beta/2)+1:end,:)));
    end
    C_N = 10*log10((max_peak - noiseFloor)/(noiseFloor*Tc));
    
    if C_N > 40
        fprintf('SV: %d C/N0: %f  Fd: %d ts_hat: %d \n',sv(i), C_N, fd_hat, ts_ind);
        sv_present(i) = sv(i);
        ts_hat(i) = ts_ind*Tl;
        fc_hat(i) = fd_hat;   
    else
        sv_present(i) = 0;
    end
    
end
end

