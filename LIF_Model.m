dt = 0.1; % Simulation time step
Duration = 200; % Simulation length
T = ceil(Duration/dt);
t = (1:T) * dt; % Simulation time points in ms

vr = 0; % in mv, resting potential
tau_m = 20; %Arbitrary
v = vr * ones(1,T); % Vector of output voltage
vth = 0.015; % Threshold Voltage
RI = 0.02; % A constant value in the diffrential equation of V

dv = 0;
flag = 0;

for i = 1:(T-1)
    % Spike
    if (v(i) < vth)
    dv = (-v(i) + RI) / tau_m;
    v(i+1) = v(i) + dv*dt;
    flag = 0;
    % Rest
    elseif (v(i) >= vth) 
        if(flag == 1)
            v(i) = 0;
        else
            dv = (-v(i) + 0.04)^(0.5);
            v(i+1) = v(i) + dv*dt;
            if(v(i) >= 0.025)
                %0.055 is the highest voltage after the spiking
                flag = 1;
            end
        end
    end
end
    
            
plot(t,v);