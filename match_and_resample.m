
% this function will take simultaneous eeg and mri data sets and resample
% them to the same temporal resolution, using start points provided by the
% user for now

function [mri, eeg]=match_and_resample(mridat, eegdat, startMRI, startEEG, mrirate, eegrate);

s_mri=size(mridat);
s_eeg=size(eegdat);

%first match starting points

mri_short=mridat(:,:,:,startMRI:s_mri(1,4));
eeg_short=eegdat(:,startEEG:s_eeg(1,2));

% resample (simply averaging over value for period)

conv=eegrate/mrirate;
s_mri_short=size(mri_short);

for j=1:s_eeg(1,1)
    for i=1:(s_mri_short(1,4)-1)
        eeg_resamp(j,i)=sum(eeg_short(j,((i-1)*conv+1):(i*conv)))/conv;
    end
end


s_eeg_resamp=size(eeg_resamp);

if (s_mri_short(1,4) < s_eeg_resamp(1,2))
    eeg=eeg_resamp(:,1:s_mri_short(1,4));
    mri=mri_short;
elseif (s_eeg_resamp(1,2) < s_mri_short(1,4))
    mri=mri_short(:,:,:,1:s_eeg_resamp(1,2));
    eeg=eeg_resamp;
end
    
%size(eeg)
%size(mri)

disp('Data time-matched and resampled!')



