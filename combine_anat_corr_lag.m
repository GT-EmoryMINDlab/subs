function img = combine_anat_corr_lag(img_old, cc, ccthresh, imgthresh, use_parallel)
% COMBINE_ANAT_CORR_LAG  Maps temporal cross-correlation (at various lags)
% onto anatomical image
%
%   IMG = COMBINE_ANAT_CORR_LAG(IMG_OLD, CC, CCTHRESH, IMGTHRESH) maps the
%   cross-correlation with lags matrix CC (as created by the function
%   CORR_LAGS_WITH_REFTC) onto the anatomical image specified by IMG_OLD.
%   The variables CCTHRESH and IMGTHRESH are the thresholding values used
%   for the cross-correlation and image signals, respectively.
%
%   IMG = COMBINE_ANAT_CORR_LAG(___, USE_PARALLEL) specifies whether to use a
%   single thread (default) or multiple threads using the default parallel
%   pool, depending on the value of USE_PARALLEL:
%
%       Single CPU      0 or 'cpu' (default)
%       Parallel        1 or 'par'
%
%   See also CORR_LAGS_WITH_REFTC

%if the use_parallel flag isn't set isn't set, use a single CPU as default
if ~exist('use_parallel','var')
    use_parallel = 0;
end

%get dimensions of the anatomical image and the dimension of lags in cc
dim=size(img_old);
dimX=dim(1,1);      %FOV x
dimY=dim(1,2);      %FOV y
dimZ=dim(1,3);      %slices
dimT=dim(1,4);      %time points in anat
dimL=size(cc,4);    %time points of lag

%threshold the anatomical image
temp=reshape(img_old,dimX*dimY*dimZ*dimT,1);
mx=max(temp);
scale=mx-imgthresh;
img_old=(img_old-imgthresh)/scale*0.5;
imgmask=img_old(:,:,1,1)>0;
img_old(:,:,1,1)=img_old(:,:,1,1).*imgmask;

%we only need anatomical image from 1 time point, so let's use the mean
anat_img = mean(img_old, 4);

%threshold the cross correlation image
scale=1-ccthresh;
cc=(cc-ccthresh)/scale*0.5+0.5;
ccmask=cc>=0.5;
cc=cc.*ccmask;

%Overlay the cross correlation onto the anatomical image
img=zeros(dimY, dimX, dimZ, dimL);

%run the algorithm based on what ptype is being used
switch use_parallel
    
    %single CPU
    case {0, 'cpu'}
        for t=1:dimL
            for z=1:dimZ
                for y=1:dimY
                    for x=1:dimX
                        if (cc(y,x,z,t)> 0)
                            img(y,x,z,t)=cc(y,x,z,t);
                        else
                            img(y,x,z,t)=anat_img(y,x,z);
                        end
                    end
                end
            end
        end
        
        
    %parallel CPU
    case {1, 'par'}
        parfor t=1:dimL
            for z=1:dimZ
                for y=1:dimY
                    for x=1:dimX
                        if (cc(y,x,z,t)> 0)
                            img(y,x,z,t)=cc(y,x,z,t);
                        else
                            img(y,x,z,t)=anat_img(y,x,z);
                        end
                    end
                end
            end
        end
end

disp('CC mapped to anatomical image!');

return;
load skfmrimap;

figure(2);
colormap(c4);
imagesc(NewImage(:,:,1));axis image;