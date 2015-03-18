function img_new = detrendimage(img, use_parallel)
% DETRENDIMAGE  Performs linear detrending for each voxel time-series
%
%   IMG_NEW = DETRENDIMAGE(IMG) uses the DETREND function to remove the
%   best-fit linear trend from each voxel's time series. IMG_NEW is a 4D
%   matrix with the same dimensions as IMG.
%
%   IMG_NEW = DETRENDIMAGE(IMG, USE_PARALLEL) specifies whether to use a
%   single thread (default) or multiple threads using the default parallel
%   pool, depending on the value of USE_PARALLEL:
%
%       Single CPU      0 or 'cpu' (default)
%       Parallel        1 or 'par'
%
%   See also DETREND

%if the use_parallel flag isn't set isn't set, use a single CPU as default
if ~exist('use_parallel','var')
    use_parallel = 0;
end

%get dimensions of OldImage
dim=size(img);
DimX=dim(1,1);
DimY=dim(1,2);
DimZ=dim(1,3);
DimTime=dim(1,4);

%preallocate new image
img_new=zeros(DimY, DimX, DimZ, DimTime);

%run loop based on whether or not parallel threads should be used
switch use_parallel
    
    %single CPU
    case {0, 'cpu'}
        for z=1:DimZ
            for y=1:DimY
                for x=1:DimX
                    if (abs(img(y,x,z,1))> 0)
                        img_new(y,x,z,:)=detrend(img(y,x,z,:));
                    end
                end
            end
        end
        
    %parallel threads
    case {1, 'par'}
        parfor z=1:DimZ
            for y=1:DimY
                for x=1:DimX
                    if (abs(img(y,x,z,1))> 0)
                        img_new(y,x,z,:)=detrend(img(y,x,z,:));
                    end
                end
            end
        end  
end

disp('Image detrended!');
