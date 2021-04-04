%Integrate & Fire Model
clc
clear 
figure

dt = 1; % Simulation Time Step
Duration = 300; % Simulation Time
T = ceil(Duration/dt);
t = (1:T) * dt; % Simulation time points in ms


% initial values
v_initial = 0; % in mv
gE_initial = 0;
gI_initial = 0;
El = -60; % Leak reversaⅼ potentiaⅼ in mv
Ee = 0; % Excitatory synaptic reversaⅼ potentiaⅼ in mv
Ei = -80; % Inhibitory synaptiⅽ reversaⅼ potentiaⅼ in mv
gl = 9.99; % Leak ⅽonductance in ns
Cm = 198; % in pF
Tau_e = 5; % in ms
Tau_i = 10; % in ms
I_ex = 150; % in pA

% initilize 3 vectors for values of v,gE,gI
v = zeros(1,T);
gE = zeros(1,T);
gI = zeros(1,T);

for i=1:(T-1)
    dv = (gl*(El-v(i)) + gE(i)*(Ee-v(i)) + gI(i)*(Ei-v(i)) + I_ex)/Cm;
    dgE = -gE(i)/Tau_e;
    dgI = -gI(i)/Tau_e;
    v(i+1) = v(i) + dv*dt;
    gE(i+1) = gE(i) + dgE*dt;
    gI(i+1) = gI(i) + dgI*dt;
end

% plot v
plot(t,v);
grid on;
title('v/t plot','interpreter','latex');
xlabel('t');
ylabel('v');
% plot gE
figure
plot(t,gE);
grid on;
title('gE/t plot','interpreter','latex');
xlabel('t');
ylabel('gE');
% plot gI
figure
plot(t,gI);
grid on;
title('gI/t plot','interpreter','latex');
xlabel('t');
ylabel('gI');