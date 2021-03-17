%%
% a simplified version of the LIF model

dt = 0.01; % Simulation time step
Duration = 200; % Simulation length
T = ceil(Duration/dt);
t = (1:T) * dt; % Simulation time points in ms

vr = 0; % in mv, resting potential
tau_m = 20; %Arbitrary
v = vr * ones(1,T); % Vector of output voltage
vth = 0.015; % Threshold Voltage
% RI = 0.02; % A constant value in the diffrential equation of V
R = 0.001;
I = ones(1,250); % in uA, external stimulus (external current)
dv = 0;
flag = 0;
FR = zeros(1,250);
I_Values = 2:2:500;

for j = 2:2:500  %part 3
     flag2 = 1;
     v(:) = vr; % Vector of output voltage
    for i = 1:(T-1)
        % Spike
        if (v(i) < vth)
        dv = (-v(i) + R*j*I(j/2)) / tau_m; % part 3
        % dv = (-v(i) + RI) / tau_m;
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
                    %0.026 is the highest voltage when spiking
                    flag = 1;
                    FR(j/2) = FR(j/2) + 1;
                end
            end
        end
    end
end

% part_1    
% plot(t,v);
% title('Voltage/Time');
% xlabel('Time');
% ylabel('Voltage');

% part_3
% plot(I_Values,FR);
% title('Firerate by diffrenet currents');
% xlabel('External Stimulus');
% ylabel('Firerate');
%%

% Poisson distribution - a vector of 0,1 with Poisson distribution
lambda = input('');
run_time = input('');

dt = 0.01; % Simulation time step
T = ceil(run_time/dt);
t = (1:T) * dt; % Simulation time points in ms
vector = zeros(1,T);
probabilities = poisspdf(1:T,lambda);

for i=1:T
    vector(i) = 100*binornd(1,probabilities(i));
end
plot(vector);
xlabel('Element index');
ylabel('Value');
%%

