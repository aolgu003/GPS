close all

syms f W
F = 1/W*(heaviside(f+W/2) - heaviside(f-W/2));

Rx = ifourier(F, f, f)

subplot(2,2,1)
ezsurf(Rx)
subplot(2,2,2)
ezplot(Rx)