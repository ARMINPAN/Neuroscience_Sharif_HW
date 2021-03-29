clc
clear
figure
% initial parameters
noip = 15;
interval = 60;
Mee = 1.25;
Mei = -1;
Mie = 1;
Mii = 0;
Ye = -10;
Yi = 10;
Te = 0.01;
Ti = 0.05;
f = @(t,Y) [(-Y(1)+Mee*Y(1)+Mei*Y(2)-Ye)/Te;(-Y(2)+Mie*Y(1)+Mii*Y(2)-Yi)/Ti];
y1 = linspace(-interval,interval,20);
y2 = linspace(-interval,interval,20);
% creates two matrices one for all the x-values on the grid, and one for
% all the y-values on the grid. Note that x and y are matrices of the same
% size and shape, in this case 20 rows and 20 columns
[x,y] = meshgrid(y1,y2);
u = zeros(size(x));
v = zeros(size(x));
% we can use a single loop over each element to compute the derivatives at
% each point (y1, y2)
t=0; % we want the derivatives at each point at t=0, i.e. the starting time
for i = 1:numel(x)
Yprime = f(t,[x(i); y(i)]);
u(i) = Yprime(1);
v(i) = Yprime(2);
end
quiver(x,y,u,v,'r');
xlabel('V_E')
ylabel('V_I')
% axis tight equal;
hold on
for i = 1:noip
[ts,ys] = ode45(f,[0,50],[rand()*interval*((-1)^floor(rand()*interval)); ...
rand()*interval*((-1)^floor(rand()*interval))]);
plot(ys(:,1),ys(:,2),'b')
plot(ys(1,1),ys(1,2),'bo') % starting point
plot(ys(end,1),ys(end,2),'ks') % ending point
xlim([-interval interval]);
ylim([-interval interval]);
end
syms t
fplot((t+Ye-Mee*t)/Mei,'m','LineWidth',2);
fplot((Yi-Mie*t)/(Mii-1),'g','LineWidth',2);
title("phase plane")
hold('off')