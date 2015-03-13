function data_lf = lpfilterimage(data, tr, cutpt, dim, use_parallel)
% LPFILTERIMAGE  Performs a low pass filter on a 4D image
%
%   DATA_LF = LPFILTERIMAGE(DATA, TR, CUTPT, DIM) performs a low-pass
%   filter on DATA using a 5th order Butterworth filter with cutoff
%   frequency Wn = 2*TR*CUTPT. DIM are the dimensions of DATA. DATA_LF
%   is a multidimensional matrix with the same size as DATA.
%
%   DATA_LF = LPFILTERIMAGE(___, USE_PARALLEL) specifies whether to use a
%   single thread (default), or to use the maximum number of threads
%   possible to speed up the computer. Set USE_PARALLEL = 1 to use multiple
%   threads.
%
%   See also BUTTER, LPFILTER

%if the dimensions aren't explicitly specified, use the dims of data
if ~exist('dim','var')
    dim = size(data);
end

%if the use_parallel flag isn't set isn't set, use a single CPU as default
if ~exist('use_parallel','var')
    use_parallel = 0;
end

%prepare 5th order butterworth filter
[b,a]=butter(5,cutpt/((1/tr)/2));
hd=dfilt.df2t(b,a);

%preallocate output matrix 
data_lf=zeros(dim(1,1),dim(1,2),dim(1,3),dim(1,4));

%run loop based on whether or not parallel threads should be used
switch use_parallel
    
    %single CPU
    case 0
        for x=1:dim(1,1)
            for y=1:dim(1,2)
                for z=1:dim(1,3)
                    if(data(x,y,z,1)~=0)
                        tc=data(x,y,z,:);
                        tc=(tc-mean(tc))/std(tc);
                        newtc=filter(hd,tc);
                        data_lf(x,y,z,:)=squeeze(newtc);
                    else
                        data_lf(x,y,z,:)=0;
                    end
                end
            end
        end
        
        
    %multiple threads
    case 1
        dimY = dim(2);
        dimZ = dim(3);
        
        parfor x=1:dim(1)
            %need to set hd within the parfor loop
            hd=dfilt.df2t(b,a);
            
            for y=1:dimY
                for z=1:dimZ
                    voxel_tc = squeeze(data(x,y,z,:));   %voxel time series
                    if(voxel_tc(1)~=0) 
                        voxel_tc=(voxel_tc-mean(voxel_tc))/std(voxel_tc);
                        newtc=filter(hd,voxel_tc);
                        data_lf(x,y,z,:)=squeeze(newtc);
                    else
                        data_lf(x,y,z,:)=0;
                    end
                end
            end
        end
        
end

disp('Filtering complete!');

