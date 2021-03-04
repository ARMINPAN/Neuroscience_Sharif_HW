dt = 0.01; % Simulation time step
Duration = 200; % Simulation length
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
n_initialCond = 0.32;
m_initialCond = 0.05;
h_initialCond = 0.59;
dv = 0;
dn = 0;
dm = 0;
dh = 0;
n = n_initialCond * ones(1,T);
m = m_initialCond * ones(1,T);
h = h_initialCond * ones(1,T);
%dv = dv_initialCond * ones(1,T);
%Iext = 0;


for i = 1:(T-1)
    dv = (gl*(El - v(i)) - gNa*(m(i)^3)*h(i)*(v(i) - ENa) - gK*(n(i)^4).*(v(i) - EK) + 200)/Cm;
    v(i+1) = v(i) + dv*dt;
    u = vr - v;
    n(i+1) = n(i) + dn*dt;
    m(i+1) = m(i) + dm*dt;
    h(i+1) = h(i) + dh*dt;
    alpha_n = (.1 * u + 1)./(exp(1 + .1 * u) - 1) / 10;
    beta_n = .125 * exp(u/80);
    alpha_m = (u+25) ./ (exp(2.5+.1*u)-1)/10;
    beta_m = 4*exp(u/18);
    alpha_h = .07 * exp(u/20);
    beta_h = 1 ./ (1+exp(3 + .1*u));
    dn = (-n(i) + alpha_n(i)/(alpha_n(i) + beta_n(i)))*(alpha_n(i) + beta_n(i));
    dm = (-m(i) + alpha_m(i)/(alpha_m(i) + beta_m(i)))*(alpha_m(i) + beta_m(i));
    dh = (-h(i) + alpha_h(i)/(alpha_h(i) + beta_h(i)))*(alpha_h(i) + beta_h(i));
end
    
%plot(t,v); %Plot v-t

subplot(2,1,1); %plot tau-v
plot(v,1./(alpha_n + beta_n),v,1./(alpha_m + beta_m),v,1./(alpha_h + beta_h));
subplot(2,1,2); %plot probabilites_steadystates-v
plot(v,alpha_n./(alpha_n + beta_n),v,alpha_m./(alpha_m + beta_m),v,alpha_h./(alpha_h + beta_h));

