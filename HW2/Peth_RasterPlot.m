%PETH and Raster plot
clc;
clear;

load('Q4_data.mat');

%Q.4.1 - Raster Plot
durations_vector = 0.250 * Fs * ones(1,size(trials,1));
input_matrix = trials;
rasterplot(input_matrix, durations_vector);
%%
%Q.4.3 PETH or PSTH
clc;
clear;
load('Q4_data.mat');

durations_vector = 0.250 * Fs * ones(1,size(trials,1));
input_matrix = trials;
PETH(input_matrix,durations_vector); % for windowLentgh 20 samples

%Q.4.4 
PETH1(input_matrix,durations_vector); % for windowLentgh 5 samples
PETH2(input_matrix,durations_vector); % for windowLentgh 35 samples
%%
%functions 

%Q.4.1
% rasterplot is a function which plot the rasterplot of a matrix for us
% which a the matrix contains the data of n trials described by the Time
% vector which shows each trial`s duration
function rasterplot(input_matrix, durations)  
    num = [1, 20, size(input_matrix,1)]; % trials we want to plot

    % you can change num(i) in for to see the first trial and the first 20
    % trials
    
    for j = 1:num(3)
        % find the spikes in each trial
        spikesTime = find(input_matrix(j,:));
        % raster plot / dots
        for k = 1:length(spikesTime)
            plot(spikesTime(k)/2000, j,'r.','color','black');
            hold on;
        end
        title('For first 100 trials','interpreter','latex');
    end
    plot([0.05,0.05],[0,num(3)],'--','LineWidth',2,'color','b'); % line of time zero which is 50ms
    xlabel('time(ms)');
    ylabel('number of trial');
end


%Q.4.3 PETH or PSTH for length 20 samples
function PETH(input_matrix,durations)
    figure;
    summ = zeros(1,durations(1)/20); % a vector to save number of spikes in each window of all trials


    %20 is the length of the window
    % the duration of all trials are the same in here
    for i=1:durations(1)/20
             spikesTime = find(input_matrix(:,(i-1)*20+1:(i)*20));    
             % count number of spikes in the window
             summ(i) = summ(i) + size(spikesTime,1);
    end
    
    firerates = summ*100; % our window length is 10ms or 20 samples so for calculating fire rate
    % we have to multiply it to 100
    
    meanofFirerates = firerates/size(input_matrix,1); % we have 100 trials in here
    
    % PETH/PSTH
    bar((1:25),meanofFirerates,'FaceColor','#A2142F','EdgeColor','#A2142F');
    line([5.5 5.5],[0 700],'Color','black','LineStyle','--','LineWidth',2); % line of time zero which is at 50ms
    grid on;
    title('PETH|window length = 20');
    xlabel('window number');
    ylabel('fire rate');
end


%Q.4.4 for length 5 samples
function PETH1(input_matrix,durations)
    figure;
    summ = zeros(1,durations(1)/5); % a vector to save number of spikes in each window of all trials


    % 5 is the length of the window
    % the duration of all trials are the same in here
    for i=1:durations(1)/5
             spikesTime = find(input_matrix(:,(i-1)*5+1:(i)*5));    
             % count number of spikes in the window
             summ(i) = summ(i) + size(spikesTime,1);
    end

    firerates = summ.*400; % our window length is 5 samples equals to 2.5ms so for calculating fire rate
    % we have to multiply it to 400
    
    meanofFirerates = firerates/size(input_matrix,1); % we have 100 trials in here
    
    % PETH/PSTH
    bar((1:100),meanofFirerates,'FaceColor','#A2142F','EdgeColor','#A2142F');
    line([20.5 20.5],[0 700],'Color','black','LineStyle','--','LineWidth',2); % line of time zero which is at 50ms
    grid on;
    title('PETH|window length = 5');
    xlabel('window number');
    ylabel('fire rate');

end

%Q.4.4 for length 35 samples
function PETH2(input_matrix,durations)
    figure;
    numberOfWindows = floor(durations(1)/35)+1; % number of windows
    
    summ = (zeros(1,numberOfWindows)); % a vector to save number of spikes in each window of all trials


    % 35 is the length of the window
    % the duration of all trials are the same in here
    % we have to seperate the last window because it`s length is diffrenet
    % because 500 is not divisble by 35
    
    for i=1:floor(durations(1)/35)+1
        if(i~=floor(durations(1)/35)+1)
             spikesTime = find(input_matrix(:,(i-1)*35+1:(i)*35));    
             % count number of spikes in the window
             summ(i) = summ(i) + size(spikesTime,1);
        else % last window
             spikesTime = find(input_matrix(:,(i-1)*35+1:durations(1)));    
             % count number of spikes in the window
             summ(i) = summ(i) + size(spikesTime,1);
        end
    end

    firerates = summ.*57; % our window length is 35 samples equals to 17.5ms so for calculating fire rate
    % we have to multiply it to something about 57
    
    meanofFirerates = firerates/size(input_matrix,1); % we have 100 trials in here
    
    % PETH/PSTH
    bar((1:numberOfWindows),meanofFirerates,'FaceColor','#A2142F','EdgeColor','#A2142F');
    line([2.85 2.85],[0 700],'Color','black','LineStyle','--','LineWidth',2); % line of time zero which is at 50ms
    grid on;
    title('PETH|window length = 35');
    xlabel('window number');
    ylabel('fire rate');

end
