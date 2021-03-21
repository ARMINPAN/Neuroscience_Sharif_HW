% LIF complete model

dt = 0.01; % Simulation time step
Duration = 200; % Simulation length
T = ceil(Duration/dt);
t = (1:T) * dt; % Simulation time points in ms


vr = 0; % in mv, resting potential
tau_m = 20; %Arbitrary
tau_peak = 1;
K = t .* exp(-t/tau_peak); 
v = vr * ones(1,T); % Vector of output voltage
% RI = 0.02; % A constant value in the diffrential equation of V
R = 1;
%I = ones(50,2*T-1); % for inhibitory and excitatory
I = ones(1,T);
dv = 0;
flag = 0;

% poisson distribution
lambda = 3000;
%vector = zeros(50,T);for inhibitory and excitatory
vector = zeros(1,T);
probabilities = poisspdf(1:T,lambda);
% I_total = zeros(1,2*T-1);% for inhibitory and excitatory
% coutnerInhibitory = 0;
% coutnerTot = 0;
% for j=1:50% 50 currents for inhibitory and excitatory
    for i=1:T
        % for inhibitory and excitatory
%          vector(j,i) = binornd(1,probabilities(i));
           vector(i) = binornd(1,probabilities(i));
    end
%     I(j,:) = conv(K,vector(j,:)); % for inhibitory and excitatory
      I = conv(K,vector);
%     coutnerTot = coutnerTot + 1; % for inhibitory and excitatory
%     flag = binornd(1,0.43); % for inhibitory and excitatory
%     if(flag == 0) % for inhibitory and excitatory
%         I_total = I_total + I(j,:); % for inhibitory and excitatory
%     else
%         I_total = I_total - I(j,:); % for inhibitory and excitatory
%         coutnerInhibitory = coutnerInhibitory + 1; % for inhibitory and excitatory
%     end% for inhibitory and excitatory
%end



% Euler method for v(t)
for i=1:(T-1)
    if(v(i) < 0.02)
    %dv = (-v(i) + R*I_total(i)) / tau_m; for inhibitory and excitatory
    dv = (-v(i) + R*I(i)) / tau_m; 
    v(i+1) = v(i) + dv*dt;
    else
        v(i+1) = 0;
    end
end
subplot(2,1,1);
plot(t,v);
xlabel('Time');
ylabel('Voltage');
subplot(2,1,2);
%plot(I_total); %for inhibitory and excitatory
plot(I); %deactive this for inhibitory and excitatory
xlabel('Element index');
ylabel('Current');



