dt = 0.01; % Simulation time step
Duration = 100; % Simulation length
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

I = 100*ones(1,T); % in uA, external stimulus (external current)

% I = ones(1,100); % for part 10

%FireRate for part 10
% FR = zeros(1,100);
% I_Values = 2:2:200;


%chirp
% I = 50 * chirp((1:T)/1000,0.4,T,6000) + 50;
% %triangular wave
% flag = 1;
% for i = 1:T
%     if(flag == 1)
%         I(i) = (mod(i,2000))/100 + 30;
%         if(mod(i,2000) == 1999)
%             flag = 0;
%         end
%     else
%         I(i) = (2000 - mod(i,2000))/100 + 30;
%         if(mod(i,2000) == 1999)
%             flag = 1;
%         end
%     end
%  end

% sin
%  for i = 1:T
%         I(i) = 10 * sin(i/100) + 50;  
%  end
% % square pulse
% flag = 1;
% for i = 1:T
%     if(flag <= 500)
%         I(i) = 40;
%         flag = flag + 1;
%     else
%         I(i) = 50;
%         flag = flag + 1;
%         if(flag == 1000)
%             flag = 1;
%         end
%     end
%  end

% I = [1:200/T:200];
%I =  155 * ones(1,T); % in uA, external stimulus (external current)
%I =  [2.39 * ones(1,759), zeros(1,T-759)]; % for the minimum time of
%stimulation for spiking at least once
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

%change I to see diffrenet behaviors of the nueron
%Here we add another for loop, for part 1.10 to simulate the model for 100
%diff currents, Vth = -38

% for j = 2:2:200 part 10
%     n(:) = n_initialCond;
%     m(:) = m_initialCond;
%     h(:) = h_initialCond;
%     flag = 1;
%     v(:) = vr; % Vector of output voltage
    for i = 1:(T-1)
%         dv = (gl*(El - v(i)) - gNa*(m(i)^3)*h(i)*(v(i) - ENa) - gK*(n(i)^4).*(v(i) - EK) + j*I(j/2))/Cm;
          dv = (gl*(El - v(i)) - gNa*(m(i)^3)*h(i)*(v(i) - ENa) - gK*(n(i)^4).*(v(i) - EK) + I(i))/Cm;
          v(i+1) = v(i) + dv*dt;
%         if(v(i) <= -38) part 10
%             flag = 1;
%         end
%         if(v(i) >= -38 && flag == 1)
%             FR(j/2) = FR(j/2) + 1;
%             flag = 0;
%         end
        u(i) = vr - v(i);
        alpha_n(i) = (.1 * u(i) + 1)./(exp(1 + .1 * u(i)) - 1) / 10;
        beta_n(i) = .125 * exp(u(i)/80);
        alpha_m(i) = (u(i)+25) ./ (exp(2.5+.1*u(i))-1)/10;
        beta_m(i) = 4*exp(u(i)/18);
        alpha_h(i) = .07 * exp(u(i)/20);
        beta_h(i) = 1 ./ (1+exp(3 + .1*u(i)));
        dn = (-n(i) + alpha_n(i)/(alpha_n(i) + beta_n(i)))*(alpha_n(i) + beta_n(i));
        dm = (-m(i) + alpha_m(i)/(alpha_m(i) + beta_m(i)))*(alpha_m(i) + beta_m(i));
        dh = (-h(i) + alpha_h(i)/(alpha_h(i) + beta_h(i)))*(alpha_h(i) + beta_h(i));
        n(i+1) = n(i) + dn*dt;
        m(i+1) = m(i) + dm*dt;
        h(i+1) = h(i) + dh*dt;
    end
%end


% I_FR for part 10
% plot(I_Values,FR);
% title('FireRates for diffrenet currents');
% xlabel('Current');
% ylabel('FireRates in 2000ms');


% %n/voltage
%  plot(v,n); %Plot n-v
%  title('n versus v when I = 200μA');
%  xlabel('v');
%  ylabel('n');

% voltage/t
% subplot(2,1,1);     
% plot(t,v); %Plot v-t
% title('');
% xlabel('t');
% ylabel('v');
% subplot(2,1,2); 
% plot(t,I); %Plot v-t
% title('External Stimulus');
% xlabel('t');
% ylabel('I');

% time constants and steady state values of probabilites
% subplot(2,1,1); %plot tau-v
% plot(v,1./(alpha_n + beta_n),v,1./(alpha_m + beta_m),v,1./(alpha_h + beta_h));
% title('Time Constants when I = 0');
% xlabel('v');
% ylabel('Time Constants');
% xlim([-60.17 -59.97]);
% subplot(2,1,2); %plot probabilites_steadystates-v
% plot(v,alpha_n./(alpha_n + beta_n),v,alpha_m./(alpha_m + beta_m),v,alpha_h./(alpha_h + beta_h));
% title('Probabilites-SteadyState when I = 0');
% xlabel('v');
% ylabel('Probabilites-SteadyState');
% xlim([-60.17 -59.97]);


