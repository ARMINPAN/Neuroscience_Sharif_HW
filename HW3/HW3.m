% Homework 3
% EEG pre processing , detect apena from EEG data
%% 1 - Pre processing
% 1.2 - epoch
% for epoching we need to find 2s in the 20th column in the
% Subject01_rawdata which is in the ALLEEG struct

% at first we seperate our three 600s/500Hz tasks
% from each 2 in the mark column after 30s/500Hz the task begins
% 1.auditory-visual task  |  2.visual task  |  3.auditory task
tasks_Times = find(ALLEEG(1).data(20,:) ~= 0);

% timing of each task
audio_visual_start_end = [tasks_Times(1) + 30*500 + 1, tasks_Times(1) + 30*500 + 600*500];
visual_start_end = [tasks_Times(2) + 30*500 + 1, tasks_Times(2) + 30*500 + 600*500];
audio_start_end = [tasks_Times(3) + 30*500 + 1, tasks_Times(3) + 30*500 + 600*500];

% seperate tasks in 3 differenet matrices
% we use the filtered noise removed data which is in ALLEEG struct 
% 'Subject01_selected_reref_BPfilter0.5to70-rmvLnoise'
audio_visual_task = ALLEEG(5).data(:,audio_visual_start_end(1):audio_visual_start_end(2));
visual_task = ALLEEG(5).data(:,visual_start_end(1):visual_start_end(2));
audio_task = ALLEEG(5).data(:,audio_start_end(1):audio_start_end(2));

% now we have to epoch each trials, each task includes 60 10s trials - we would have a 3d matrix
% each trials is 10s/500Hz
audio_visual_epoched = reshape(audio_visual_task,[19 5000 60]);
visual_epoched = reshape(audio_visual_task,[19 5000 60]);
audio_epoched = reshape(audio_visual_task,[19 5000 60]);

% save the epochs
dlmwrite('av_epoch.txt',audio_visual_epoched,'delimiter',' ');
dlmwrite('v_epoch.txt',visual_epoched,'delimiter',' ');
dlmwrite('a_epoch.txt',audio_epoched,'delimiter',' ');
%%
% 1.3 - remove noisy trials
% calculate power spectrum of each trial in each channel and put them in a
% 3d matrix for av task
av_epoch = zeros(60,4096,19);
noisy_trials = [];
for i=1:19
    for k=1:60
        av_epoch(k,:,i) = (pspectrum(audio_visual_epoched(i,:,k))).';
    end
end
for i=1:19
    vr = sum(nanstd(av_epoch(:,:,i),[ ],2).^2,2);
    noisy_trials = union((find(abs(zscore(vr)) > 3.5)),noisy_trials);
end

% now remove these trials from av_epoch
audio_visual_epoched(:,:,(noisy_trials).') = [];


%%%%%%%%%%%%%%%%%%%%%%%% remove noisy trails for v task
v_epoch = zeros(60,4096,19);
noisy_trials = [];
for i=1:19
    for k=1:60
        v_epoch(k,:,i) = (pspectrum(visual_epoched(i,:,k))).';
    end
end
for i=1:19
    vr = sum(nanstd(av_epoch(:,:,i),[ ],2).^2,2);
    noisy_trials = union((find(abs(zscore(vr)) > 3.5)),noisy_trials);
end

% now remove these trials from v_epoch
visual_epoched(:,:,(noisy_trials).') = [];


%%%%%%%%%%%%%%%%%%%%%%%% remove noisy trails for a task
a_epoch = zeros(60,4096,19);
noisy_trials = [];
for i=1:19
    for k=1:60
        a_epoch(k,:,i) = (pspectrum(audio_epoched(i,:,k))).';
    end
end
for i=1:19
    vr = sum(nanstd(av_epoch(:,:,i),[ ],2).^2,2);
    noisy_trials = union((find(abs(zscore(vr)) > 3.5)),noisy_trials);
end
% now remove these trials from v_epoch
audio_epoched(:,:,(noisy_trials).') = [];

% save the new data
dlmwrite('av_epoch_noisyTrialsRmv.txt',audio_visual_epoched,'delimiter',' ');
dlmwrite('v_epoch_noisyTrialsRmv.txt',visual_epoched,'delimiter',' ');
dlmwrite('a_epoch_noisyTrialsRmv.txt',audio_epoched,'delimiter',' ');