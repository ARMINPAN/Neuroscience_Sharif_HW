%Integrate & Fire Model
clc
clear 
figure

dt = 0.1; % Simulation Time Step
Duration = 300; % Simulation Time
T = ceil(Duration/dt);
t = (1:T) * dt; % Simulation time points in ms


% initial values
v_initial = -45; % in mv
gE_initial = 700;
gI_initial = 200;
El = -60; % Leak reversaⅼ potentiaⅼ in mv
Ee = 0; % Excitatory synaptic reversaⅼ potentiaⅼ in mv
Ei = -80; % Inhibitory synaptiⅽ reversaⅼ potentiaⅼ in mv
gl = 9.99; % Leak ⅽonductance in nS
Cm = 198; % in pF
Tau_e = 5; % in ms
Tau_i = 10; % in ms
I_ex = 150; % in pA

% initilize 3 vectors for values of v,gE,gI
v = v_initial * ones(1,T);
gE = gE_initial * ones(1,T);
gI = gI_initial * ones(1,T);

for i=1:(T-1)
    dv = (gl*(El-v(i)) + gE(i)*(Ee-v(i)) + gI(i)*(Ei-v(i)) + I_ex)/Cm;
    dgE = -gE(i)/Tau_e;
    dgI = -gI(i)/Tau_i;
    v(i+1) = v(i) + dv*dt;
    gE(i+1) = gE(i) + dgE*dt;
    gI(i+1) = gI(i) + dgI*dt;
end

% plot v
subplot(1,3,1);
plot(t,v,'LineWidth',2);
grid on;
title('v/t plot for 300ms');
xlabel('t(ms)','FontWeight','bold');
ylabel('v(mv)','FontWeight','bold');
% plot gE
subplot(1,3,2);
plot(t,gE,'LineWidth',2);
grid on;
title('gE/t plot for 300ms');
xlabel('t(ms)','FontWeight','bold');
ylabel('gE(S)','FontWeight','bold');
% plot gI
subplot(1,3,3);
plot(t,gI,'LineWidth',2);
grid on;
title('gI/t plot for 300ms');
xlabel('t(ms)','FontWeight','bold');
ylabel('gI(S)','FontWeight','bold');