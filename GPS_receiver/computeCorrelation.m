function [s] = computeCorrelation(fid, t0, s, sv_present, fc_hat, ts_hat, fsampIQ)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

code_shift_index = ts_hat/s.Tl;
samples = fread(fid, [2 s.Nk*s.N*s.M], 'int16');
j = t0./(s.Tl)+1;

for i=1:length(sv_present)
    
    code = 2.*cacode(sv_present(i),1/s.Tl/1.023e6)-1;
    code_prompt = circshift(code', code_shift_index(i))';
    code_early = circshift(code', code_shift_index(i)+10)';
    code_late = circshift(code', code_shift_index(i)-10)';
    j = 1;
    for l = 1:s.N
        Itildepk = 0;
        Qtildepk = 0;
        
        Itildeek = 0;
        Qtildeek = 0;
        
        Itildelk = 0;
        Qtildelk = 0;
        for k = 1:s.M
            t = ((t0):s.Tl:(t0 + s.Tc - s.Tl));
            sig = samples(j:(j+s.Nk-1)) .* exp(-1j*2*pi*fc_hat(i).*t);
            
            %get new ca code
           
            Itildepk =Itildepk + sum(real(sig).*code_prompt);
            Qtildepk =Qtildepk + sum(imag(sig).*code_prompt);
            
            Itildeek = Itildeek + sum(real(sig).*code_early);
            Qtildeek = Qtildeek + sum(imag(sig).*code_early);
            
            Itildelk =Itildelk + sum(real(sig).*code_late);
            Qtildelk =Qtildelk + sum(imag(sig).*code_late);
            j = j+s.Nk;
            t0 = t(end)+s.Tl
        end
        
        s.Ipk = abs(Itildepk).^2;
        s.Qpk = abs(Qtildepk).^2;
        s.Iek = abs(Itildeek).^2;
        s.Qek = abs(Qtildeek).^2;
        s.Ilk = abs(Itildelk).^2;
        s.Qlk = abs(Qtildelk).^2;
    end
end
end