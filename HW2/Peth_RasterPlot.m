%PETH and Raster plot
clc;
clear;

load('Q4_data.mat');

%Q.4.1

durations_vector = 0.250 * Fs * ones(1,size(trials,1));
input_matrix = trials;
rasterplot(input_matrix, durations_vector);


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
        title('For all trials','interpreter','latex');
    end
end