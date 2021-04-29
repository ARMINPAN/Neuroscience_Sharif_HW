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
Normal_selected = ALLEEG(1).data(:,1:(length(ALLEEG(1).data)-30*Fs));
Normal_frame = reshape(Normal_selected,[2 25600/20 20]);

Apnea_frame = reshape(ALLEEG(2).data,[2 25600/20 20]);

% at first average values
% of the two channels in time domain are considered for feature
% extraction in the proposed scheme
Normal_avg = ((Normal_frame(1,:,:)+Normal_frame(2,:,:))./2);
Apnea_avg = ((Apnea_frame(1,:,:)+Apnea_frame(2,:,:))./2);

% Averaging in time domain
% now we calculate the average of each frame in time domain for each channel
Normal_mean = mean(Normal_avg,2);
Apnea_mean = mean(Apnea_avg,2);



% pre-processing
% next we have to subtract the mean of each frame from each sample value in that frame
Normal_frame_avg = Normal_avg - Normal_mean;
Apnea_frame_avg = Apnea_avg - Apnea_mean;


% nomalize each frame`s data with refrence to the maximum sample value of that frame
Normal_frame_normalized = Normal_frame_avg./max(Normal_frame_avg,[],2);
Apnea_frame_normalized = Apnea_frame_avg./max(Apnea_frame_avg,[],2);

% save datas
save('Normal_frame_normalized.mat','Normal_frame_normalized');
save('Apnea_frame_normalized.mat','Apnea_frame_normalized');

% now we have partitioned the datas into five frequency bands
% using eeglab
% delta (δ) (0.25–4 Hz), theta
% (θ) (4–8 Hz), alpha (α) (8–12 Hz), sigma (σ) (12–16 Hz) and beta
% (β) (16–40 Hz)

% frequency bands is stored in ALEEG struct from index 5 to 14

% next step: Proposed inter-band energy ratio feature.
% First, energies of δ, θ, α, σ and β frequency bands are computed
E_Normal_delta = sum((ALLEEG(5).data).^2,2);
E_Normal_theta = sum((ALLEEG(6).data).^2,2);
E_Normal_alpha = sum((ALLEEG(7).data).^2,2);
E_Normal_sigma = sum((ALLEEG(8).data).^2,2);
E_Normal_beta = sum((ALLEEG(9).data).^2,2);

E_Apnea_delta = sum((ALLEEG(10).data).^2,2);
E_Apnea_theta = sum((ALLEEG(11).data).^2,2);
E_Apnea_alpha = sum((ALLEEG(12).data).^2,2);
E_Apnea_sigma = sum((ALLEEG(13).data).^2,2);
E_Apnea_beta = sum((ALLEEG(14).data).^2,2);


% Next, the inter-band energy ratios are computed. 
% The ratio p–q is defined as Rpq = Ep / Eq
% ratios are: delta-teta , delta-alpha , delta-sigma , delta-beta , theta-alpha
Rdt_Normal = E_Normal_delta./E_Normal_theta;
Rdt_Apnea = E_Apnea_delta./E_Apnea_theta;

Rda_Normal = E_Normal_delta./E_Normal_alpha;
Rda_Apnea = E_Apnea_delta./E_Apnea_alpha;

Rds_Normal = E_Normal_delta./E_Normal_sigma;
Rds_Apnea = E_Apnea_delta./E_Apnea_sigma;

Rdb_Normal = E_Normal_delta./E_Normal_beta;
Rdb_Apnea = E_Apnea_delta./E_Apnea_beta;

Rta_Normal = E_Normal_theta./E_Normal_alpha;
Rta_Apnea = E_Apnea_theta./E_Apnea_alpha;

plotbox = [Rdt_Normal Rdt_Apnea Rda_Normal Rda_Apnea Rds_Normal Rds_Apnea ...
Rdb_Normal Rdb_Apnea Rta_Normal Rta_Apnea];

boxplot((reshape(plotbox,[10 20])).')