function data_lf = lpfilterimage(data, tr, cutpt, dim, use_parallel)
% LPFILTERIMAGE  Performs a low pass filter on a 4D image
%
%   DATA_LF = LPFILTERIMAGE(DATA, TR, CUTPT, DIM) performs a low-pass
%   filter on DATA using a 5th order Butterworth filter with cutoff
%   frequency Wn = 2*TR*CUTPT. DIM are the dimensions of DATA. DATA_LF
%   is a multidimensional matrix with the same size as DATA.
%
%   DATA_LF = LPFILTERIMAGE(___, USE_PARALLEL) specifies whether to use a
%   single thread (default), multiple threads using the default parallel
%   pool, or GPU acceleration, depending on the value of USE_PARALLEL:
%
%       Single CPU      0 or 'cpu' (default)
%       Parallel        1 or 'par'
%       GPU             2 or 'gpu'
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
    case {0, 'cpu'}
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
    case {1, 'par'}
        dimY = dim(2);
        dimZ = dim(3);
        
        parfor x=1:dim(1)
            for y=1:dimY
                for z=1:dimZ
                    voxel_tc = squeeze(data(x,y,z,:));   %voxel time series
                    if(voxel_tc(1)~=0) 
                        voxel_tc=(voxel_tc-mean(voxel_tc))/std(voxel_tc);
                        newtc = filter(b,a,voxel_tc);
                        data_lf(x,y,z,:)=squeeze(newtc);
                    end
                end
            end
        end
        
    %GPU accelerated
    case {2,'gpu'}
        %convert to GPU array
        data_gpu = gpuArray(data);
        
        %reshape to be a matrix of size dimX*dimY*dimZ x dimT
        data_rs = reshape(data_gpu, [prod(dim(1:3)) dim(4)]);
        
        %find all indexes where the first voxel is non zero
        inds = find(data_rs(:,1) ~= 0);
        
        %get non-zero rows
        data_rs_nonzero = data_rs(inds,:);
        
        %normalize using z-score along rows
        data_rs_nonzero = zscore(data_rs_nonzero,[],2);

        %apply filter to non-zero rows
        data_lf_rs_nonzero = filter(b,a,data_rs_nonzero,[],2);
        
        %store in lowpass filter array
        data_lf_rs = zeros(size(data_rs),'gpuArray');
        data_lf_rs(inds,:) = data_lf_rs_nonzero;
        
        %convert back to CPU memory
        data_lf = gather(reshape(data_lf_rs, dim));

        
end

disp('Filtering complete!');

