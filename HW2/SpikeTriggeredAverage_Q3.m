% Spike-Triggered Average
clc;
clear;

% sampling freqeuncy 2kHz, duration: 90s, Stim is a stimulus signal into a
% neuron, Spike times are the times when neuron has spiked
load('Q3_data.mat');


% plot stim over 1s which is 2000 samples - Q.3.1
figure;
plot((1:2000)/2000,Stim(1:2000));
xlabel('time')
grid on;
title('Stim','interpreter','latex');


% Q.3.2
figure;


SelectedSpikes = randperm(598,20);

% just to sort the plots 
SelectedSpikes = sort(SelectedSpikes);

for i=1:20
    subplot(4,5,i);
    grid on;
    sSpikeT = (Spike_times(SelectedSpikes(i)));
    plot((0:150)/2000,Stim(2000*sSpikeT - 150 : 2000*sSpikeT));
    xlim([0 0.075]);
    xlabel('time','FontWeight','bold');
    title(SelectedSpikes(i));
end




% Q.3.3
figure;
Samples = ((2000.*Spike_times));
StimVal = zeros(length(Samples),151);
for i=1:length(Samples)
    StimVal(i,:) = Stim(cast(Samples(i),'int64')-150:cast(Samples(i),'int64'));
end

plot((0:150)/2000,mean(StimVal,1));
grid on;
xlabel('time(ms)');
title('Spike-Triggered Average','interpreter','latex');

% Q.3.4
figure;

%plots in part 3.2
for i=1:20
	hold on;
    grid on;
    sSpikeT = (Spike_times(SelectedSpikes(i)));
    plot((0:150)/2000,Stim(2000*sSpikeT - 150 : 2000*sSpikeT),'LineWidth',0.1,'color','#3399FF');
end
    plot((0:150)/2000,mean(StimVal,1),'LineWidth',4,'color','#404040');
    xlabel('time(ms)');
    title('Spike-Triggered Average','interpreter','latex');
