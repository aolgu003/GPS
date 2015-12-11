% Problem 2 Assignment 6
%% Part 1
% Caclculate Closed loop transfer function H(s)
B_L = 10;

% 1st order
% Calc params
s = tf('s');

K = 4 * B_L;
Hs_first = K / (s + K)

% 2nd order
K = 8/3 * B_L;
a = K/2;

Hs_second =  K * (s + a)/(s^2 + K*s + K*a)

% 3rd order
a = 1.2 * B_L;
b = a^2 / 2;
K = 2 * a;

Hs_third =  K*(s^2 + a*s + b)/(s^3 + K * s^2 + K*a*s + K*b)

%% Part 3 
% Simulate

%Set up parameters for simulation
dt = .001;
t = -.5:dt:15;

impulse = t==0;
step = heaviside(t);
ramp = t.*5.*step;
quad = t.^2.*5.*step;

% ind = find(ramp > 1);
% ramp(ind) = 1;
% ind = find(quad > 1);
% quad(ind) = 1;
% 
% Hs_first = feedback(Hs_first,1);
% Hs_second = feedback(Hs_second,2);
% Hs_third = feedback(Hs_third,3);

figure(1)
clf

subplot(3,1,1)
hold on
lsim(Hs_first, step, t);
lsim(Hs_second, step, t);
lsim(Hs_third, step, t);
hold off
title('Step Input')
legend('First order', 'Second order', 'Third order')

subplot(3,1,2)
hold on
lsim(Hs_first, ramp, t);
lsim(Hs_second, ramp, t);
lsim(Hs_third, ramp, t);
hold off
title('Ramp Input')
legend('First order', 'Second order', 'Third order')

subplot(3,1,3)
hold on
lsim(Hs_first, quad, t);
lsim(Hs_second, quad, t);
lsim(Hs_third, quad, t);
hold off
title('Parabola Input')
legend('First order', 'Second order', 'Third order')

figure(2)
clf
bode(Hs_first, Hs_second, Hs_third)
legend('First order', 'Second order', 'Third order')

