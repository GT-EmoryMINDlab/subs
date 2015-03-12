function cc = corr_lags_with_reftc(reftimecourse, img, maxlag, use_parallel)
% CORR_LAGS_WITH_REFTC  Calculates the cross-correlation between a
% reference time course and all voxels in a 4D image
%
%   CC = CORR_LAGS_WITH_REFTC(REFTIMECOURSE, IMG) calculates the cross
%   correlation between the time series specified by REFTIMECOURSE and the
%   time courses of all voxels in IMG. It uses lags from -10 to +10 and
%   returns a 4D matrix CC, with size (X,Y,Z,21) where X, Y, and Z are the
%   sizes of the first three dimensions of IMG.
%
%   CC = CORR_LAGS_WITH_REFTC(REFTIMECOURSE, IMG, MAXLAG) specifies the
%   maximum lag to use and calculates the cross correlation with lag from
%   -MAXLAG to +MAXLAG. CC is a 4D matrix with size (X,Y,Z,2*MAXLAG+1).
%
%   CC = CORR_LAGS_WITH_REFTC(___, USE_PARALLEL) specifies whether to use a
%   single thread (default), or to use the maximum number of threads
%   possible to speed up the computer. Set USE_PARALLEL = 1 to use multiple
%   threads.
%
%   See also XCORR, CORR_WITH_REFTC

%if lag isn't set, set it to 10
if ~exist('lag', 'var')
    maxlag = 10;
end

%if the use_parallel flag isn't set isn't set, use a single CPU as default
if ~exist('use_parallel','var')
    use_parallel = 0;
end

%get dimensions of image
dim = size(img);

%number of lag time points = 2*lag + 1
dimL = 2*maxlag + 1;

%pre-allocate cc matrix
cc = zeros(dim(1), dim(2), dim(3), dimL);

%run the algorithm based on what ptype is being used
switch use_parallel
    
    %single CPU
    case 0     
       for x=1:dim(1)
            for y=1:dim(2)
                for z=1:dim(3)
                    voxel_tc = squeeze(img(x,y,z,:))';   %voxel time series
                    cc(x,y,z,:) = xcorr(reftimecourse, voxel_tc, 10);
                end
            end
       end

    %parallel cpu   
    case 1
        dimY = dim(2);
        dimZ = dim(3);
        parfor x=1:dim(1)
            for y=1:dimY
                for z=1:dimZ
                    voxel_tc = squeeze(img(x,y,z,:))';   %voxel time series
                    cc(x,y,z,:) = xcorr(reftimecourse, voxel_tc, 10);
                end
            end
        end        
end

end