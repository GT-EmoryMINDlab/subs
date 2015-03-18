function img_new =thresholdimage(img, threshold)
% THRESHOLDIMAGE  Thresholds a 3D/4D image
%
%   IMG_NEW = THRESHOLDIMAGE(IMG) thresholds the 3D or 4D image IMG. The
%   threshold value is automatically calculated by doing a histogram of
%   voxel intensities and picking a value T such that T equals 1/e times
%   the peak intensity of the histogram. This is done because most fMRI
%   images have an exponential decay from the peak intensity to higher
%   intensities. When creating the histogram, voxels with intensity zero
%   are ignored (i.e. sections outside the brain).
%
%   IMG_NEW = THRESHOLDIMAGE(IMG, THRESHOLD) uses the specified threshold
%   passed as the second parameter.
%
%   See also HIST

%if the threshold isn't set, calculate one
if ~exist('threshold','var')
    [n, x] = hist(img(:),100);      %use histogram with 100 bins
    [n_max, n_max_ind] = max(n);     %find peak
    n = n(n_max_ind:end);            %crop indices before peak
    x = x(n_max_ind:end);
    [temp, ind_thresh] = min(abs(n - n_max / exp(1)));   %index of 1/e value
    threshold = x(ind_thresh);
end

%get size of image
dim=size(img);
DimX=dim(1,1);
DimY=dim(1,2);
DimZ=dim(1,3);
DimTime=dim(1,4);

%create new image
img_new=zeros(DimY, DimX, DimZ, DimTime);

%finds inds > threshold
inds = find(img > threshold);

%set those values
img_new(inds) = img(inds);
 
% %apply threshold
% for z=1:DimZ
%     for y=1:DimY
%         for x=1:DimX
%             if (abs(img(y,x,z,1))> threshold)
%                 img_new(y,x,z,:)=img(y,x,z,:);
%             end
%         end
%     end
% end

disp('Thresholding complete!');
