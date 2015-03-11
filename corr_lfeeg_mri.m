%this function will perform the direct correlation between low frequency
%eeg data and low pass filtered mri data at various time lags and return
%the map at the time of maximum correlation
%lag_int should be given in TRs

function [corrmap, lag]=corr_lfeeg_mri(lf_mri, eegdat, lag_int);

dim=size(lf_mri);

%lag ranges in TRs 
lag_start=0;
lag_end=10;
nlag=(lag_end-lag_start)/lag_int+1;

cc_map=zeros(dim(1,1),dim(1,2),dim(1,3),nlag);


for l=1:nlag
    for i=1:dim(1,1)
        for j=1:dim(1,2)
            for k=1:dim(1,3)
                if (lf_mri(i,j,k,1) ~= 0)
                    temp=corrcoef(lf_mri(i,j,k,(lag_start+1+(l-1)*lag_int):dim(1,4)), eegdat(1:(dim(1,4)-lag_start-(l-1)*lag_int)));
                    cc_map(i,j,k,l)=temp(2,1);
                end 
            end
        end
    end
end


cc_tot=zeros(1,nlag);

for i=1:nlag
      cc_tot(1,i)=sum(sum(sum(cc_map(:,:,:,i))));
end
%cc_tot

[cc,lagpos]=max(cc_tot);
lag=lagpos*lag_int;
size(lag);
corrmap=(cc_map);
size(corrmap);

disp('CC map calculated!')


                    