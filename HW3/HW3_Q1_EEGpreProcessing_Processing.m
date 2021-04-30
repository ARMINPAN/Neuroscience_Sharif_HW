% Homework 3
% EEG pre processing and processing
%% 1 - Pre processing
figure;
% 1.1 - frequency spectrum of FZ channel
Fs = 500;
X = ALLEEG(5).data(5,:);
L = length(X);
Y = fft(X);
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(L/2))/L;
plot(f,P1)
title(' Frequency Spectrum of Fz Channel');
figure;

% 1.2 - epoch
% for epoching we need to find 2s in the 20th column in the
% Subject01_rawdata which is in the ALLEEG struct

% at first we seperate our three 600s/500Hz tasks
% from each 2 in the mark column after 30s/500Hz the task begins
% 1.auditory-visual task  |  2.visual task  |  3.auditory task
tasks_Times = find(ALLEEG(1).data(20,:) ~= 0);

% timing of each task
audio_visual_start_end = [tasks_Times(1) + 30*Fs + 1, tasks_Times(1) + 30*Fs + 600*Fs];
visual_start_end = [tasks_Times(2) + 30*Fs + 1, tasks_Times(2) + 30*Fs + 600*Fs];
audio_start_end = [tasks_Times(3) + 30*Fs + 1, tasks_Times(3) + 30*Fs + 600*Fs];

% seperate tasks in 3 differenet matrices
% we use the filtered noise removed data which is in ALLEEG struct 
% 'Subject01_selected_reref_BPfilter0.5to70-rmvLnoise'
audio_visual_task = ALLEEG(5).data(:,audio_visual_start_end(1):audio_visual_start_end(2));
visual_task = ALLEEG(5).data(:,visual_start_end(1):visual_start_end(2));
audio_task = ALLEEG(5).data(:,audio_start_end(1):audio_start_end(2));

% now we have to epoch each trials, each task includes 60 10s trials - we would have a 3d matrix
% each trials is 10s/500Hz
audio_visual_epoched = reshape(audio_visual_task,[19 5000 60]);
visual_epoched = reshape(visual_task,[19 5000 60]);
audio_epoched = reshape(audio_task,[19 5000 60]);

% save the epochs
save('av_epoch.mat','audio_visual_epoched');
save('v_epoch.mat','visual_epoched');
save('a_epoch.mat','audio_epoched');
%%
% 1.3 - remove noisy trials
% calculate power spectrum of each trial in each channel and put them in a
% 3d matrix for av_task
av_epoch = zeros(60,length(pspectrum(audio_visual_epoched(1,:,1))),19);
noisy_trials_av_task = [];
for i=1:19
    for k=1:60
        av_epoch(k,:,i) = (pspectrum(audio_visual_epoched(i,:,k))).';
    end
end
for i=1:19
    vr = sum(nanstd(av_epoch(:,:,i),[ ],2).^2,2);
    noisy_trials_av_task = union((find(abs(zscore(vr)) > 3.5)),noisy_trials_av_task);
end

% now remove these trials from av_epoch
audio_visual_epoched(:,:,(noisy_trials_av_task).') = [];


%%%%%%%%%%%%%%%%%%%%%%%% remove noisy trails of v_task
v_epoch = zeros(60,length(pspectrum(visual_epoched(1,:,1))),19);
noisy_trials_v_task = [];
for i=1:19
    for k=1:60
        v_epoch(k,:,i) = (pspectrum(visual_epoched(i,:,k))).';
    end
end
for i=1:19
    vr = sum(nanstd(v_epoch(:,:,i),[ ],2).^2,2);
    noisy_trials_v_task = union((find(abs(zscore(vr)) > 3.5)),noisy_trials_v_task);
end
% now remove these trials from v_epoch
visual_epoched(:,:,(noisy_trials_v_task).') = [];


%%%%%%%%%%%%%%%%%%%%%%%% remove noisy trails of a_task
a_epoch = zeros(60,length(pspectrum(audio_epoched(1,:,1))),19);
noisy_trials_a_task = [];
for i=1:19
    for k=1:60
        a_epoch(k,:,i) = (pspectrum(audio_epoched(i,:,k))).';
    end
end
for i=1:19
    vr = sum(nanstd(a_epoch(:,:,i),[ ],2).^2,2);
    noisy_trials_a_task = union((find(abs(zscore(vr)) > 3.5)),noisy_trials_a_task);
end

% now remove these trials from v_epoch
audio_epoched(:,:,(noisy_trials_a_task).') = [];
% save the new data
save('av_epoch_noisyTrialsRmv.mat','audio_visual_epoched');
save('v_epoch_noisyTrialsRmv.mat','visual_epoched');
save('a_epoch_noisyTrialsRmv.mat','audio_epoched');


%%
% 1.5 separate task and rest states - ALLEEG 7 9 11 are our epoches after
% ICA in part 1.4

% normalize the epochs
av_data = zscore(ALLEEG(7).data);
v_data = zscore(ALLEEG(9).data);
a_data = zscore(ALLEEG(11).data);

% av - task
avTask_stimuli = av_data(:,1:2500,:);
avTask_rest = av_data(:,2501:5000,:);

% v - task
vTask_stimuli = v_data(:,1:2500,:);
vTask_rest = v_data(:,2501:5000,:);

% a - task
aTask_stimuli = a_data(:,1:2500,:);
aTask_rest = a_data(:,2501:5000,:);

% sum of stimulations
avTask_stimuli_sum = sum(avTask_stimuli,[3]);
vTask_stimuli_sum = sum(vTask_stimuli,[3]);
aTask_stimuli_sum = sum(aTask_stimuli,[3]);

% sum of rests
avTask_rest_sum = sum(avTask_rest,[3]);
vTask_rest_sum = sum(vTask_rest,[3]);
aTask_rest_sum = sum(aTask_rest,[3]);

% mean of stimulations
avTask_stimuli_mean = avTask_stimuli_sum./60;
vTask_stimuli_mean = vTask_stimuli_sum./60;
aTask_stimuli_mean = aTask_stimuli_sum./60;

% mean of rests
avTask_rest_mean = avTask_rest_sum./60;
vTask_rest_mean = vTask_rest_sum./60;
aTask_rest_mean = aTask_rest_sum./60;


% frequency spectrum of FZ channel of auditory task
Fs = 500;
X = vTask_stimuli_mean(19,:);
L = length(X);
Y = fft(X);
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(L/2))/L;
p1 = plot(f,P1);
title('FFT of mean of all trials over O2 channel during visual task');

hold on;
X = vTask_rest_mean(19,:);
L = length(X);
Y = fft(X);
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(L/2))/L;
p2 = plot(f,P1);
legend('task','rest');