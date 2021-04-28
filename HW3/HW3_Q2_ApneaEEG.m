% Question 2
% apnea detection using EEG
% Automatic detection of sleep apnea events based on inter-band energy ratio
% obtained from multi-band EEG signal
% I`ve implement this question based on an article which has been attached in github repository

% Apena03.txt and Normal03.txt contain the C3/C4 channels data which each of them contains 20framed 10sec 128Hz data
% except Normal03 which has 30 sec pointless data at its beginning 

% at first we have to extract the frames from our data


Fs = 128; % sampling frequency

% AllEEG(1) contains Normal03 and ALLEEG(2) contains Apnea03 

Normal_selected = ALLEEG(1).data(:,(30*Fs+1):(length(ALLEEG(1).data)));
Normal_epoch = reshape(Normal_selected,[2 25600/20 20]);

Apnea_epoch = reshape(ALLEEG(2).data,[2 25600/20 20]);

% Averaging in time domain
% now we calculate the average of each frame in time domain for each channel
Normal_mean = mean(Normal_epoch,2);
Apnea_mean = mean(Apnea_epoch,2);

% pre-processing
% at first we have to subtract the mean of each frame from each sample value in that frame
Normal_epoch = Normal_epoch - Normal_mean;
Apnea_epoch = Apnea_epoch - Apnea_mean;


% nomalize each frame`s data with refrence to the maximum sample value of that frame
Normal_epoch = Normal_epoch./max(Normal_epoch,[],2);
Apnea_epoch = Apnea_epoch./max(Apnea_epoch,[],2);




