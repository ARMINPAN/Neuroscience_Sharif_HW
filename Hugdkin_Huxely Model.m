dt = 0.01; % Simulation time step
Duration = 2; % Simulation length
T = ceil(Duration/dt);
t = (1:T) * dt; % Simulation time points in ms
Cm = 1; % Membrane capacitance in micro Farads
gNa = 120; % in Siemens, maximum conductivity of Na+ Channel
gK = 36; % in Siemens, maximum conductivity of K+ Channel
gl = 0.3; % in Siemens, conductivity of leak Channel
ENa = 55; % in mv, Na+ nernst potential
EK = -72; % in mv, K+ nernst potential
El = -49.4; % in mv, nernst potential for leak channel
vr = -60; % in mv, resting potential
v = vr * ones(1,T); % Vector of output voltage
I = zeros(1,T); % in uA, external stimulus (external current)
% for example: I(1:10000) = 2; % an input current pulse

u = vr - v;
alpha_n = (.1 * u + 1)./(exp(1 + .1 * u) - 1) / 10;
beta_n = .125 * exp(u/80);
alpha_m = (u+25) ./ (exp(2.5+.1*u)-1)/10;
beta_m = 4*exp(u/18);
alpha_h = .07 * exp(u/20);
beta_h = 1 ./ (1+exp(3 + .1*u));
%intial condintions
n_initialCond = 0.0001;
m_initialCond = 0.0001;
h_initialCond = 0.0009;
dv_initialCond = 3.18;  
n = n_initialCond * ones(1,T);
m = m_initialCond * ones(1,T);
h = h_initialCond * ones(1,T);
dv = dv_initialCond * ones(1,T);
Iext = 0;

for i = 1:(T-1)
    dv =(gl.*(El - v) - gNa.*(m.^3).*h.*(v - ENa) - gK.*(n.^4).*(v - EK) + Iext)./Cm;
end
    




