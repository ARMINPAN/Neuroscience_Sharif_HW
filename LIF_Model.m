dt = 0.1; % Simulation time step
Duration = 200; % Simulation length
T = ceil(Duration/dt);
t = (1:T) * dt; % Simulation time points in ms

vr = 0; % in mv, resting potential
tau_m = 20; %Arbitrary
v = vr * ones(1,T); % Vector of output voltage
vth = 0.015; % Threshold Voltage
vrest = 0; % Rest voltage
RI = 0.02; % A constant value in the diffrential equation of V

dv = 0;
flag = 0;

for i = 1:(T-1)
    % Spike
    if (v(i) < vth)
    dv = (-v(i) + RI) / tau_m;
    v(i+1) = v(i) + dv*dt;
    % Rest
    elseif (v(i) >= vth) && (flag == 0)
        v(i) = 0;
    % Refractory
    elseif (v(i) <= 0)
        
    end
end
    
            


plot(t,v);