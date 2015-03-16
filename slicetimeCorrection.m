function img = slicetimeCorrection(img_old)
% SLICETIMECORRECTION  Performs slice time correction using linear
% interpolation on a 4D image.
%
%   IMG = SLICETIMECORRECTION(IMG_OLD) performs slice time correction on
%   IMG_OLD (using slices as defined by the 3rd dimension of IMG_OLD) using
%   linear interpolation based on INTERP1. It uses the middle slice as the
%   reference point and interpolates the time series of every voxel. In
%   this way, no time series is shifted by more than (TR/2).
%
%   For more information on slice time correction, visit 
%   http://mindhive.mit.edu/node/109
%
%   See also INTERP1

fprintf('Slice time correction...');

%get dimensions
dim = size(img_old);
Nslices = dim(3);

%if Nslices = 1, then return
if Nslices == 1
    img = img_old;
    return;
end


%permute old image to put time as first dimension (allows faster memory
%access)

img_old = permute(img_old, [4 1 2 3]);
dim = size(img_old);
img = zeros(dim);
vox = 1:dim(1); %time points

%go through image
for z=1:dim(4)
    %get interpolation vector
    vox_q = vox + (z - Nslices/2)/Nslices;
            
    for y=1:dim(3)
        %interp1 can handle a 2D input (i.e. spatially along a line and 
        %though time, so this speeds it up
        img(:,:,y,z) = interp1(vox, img_old(:,:,y,z), vox_q, 'spline'); 
    end
end

%permute back to original dimensions
img = permute(img, [2 3 4 1]);

fprintf('complete!\n');

% %create new image
% img = zeros(dim);
% 
% %go through image
% for x=1:dim(1)
%     for y=1:dim(2)
%         for z=1:dim(3)
%             %get time series of voxel
%             ts = squeeze(img_old(x,y,z,:));
%             
%             %interpolate to Nslices points per time point
%             ts_i = interp(ts, Nslices);
%             
%             %downsample back to time series, but phase by distance from
%             %middle slice
%             ts = downsample(ts_i, Nslices, abs(round(Nslices/2 - z)));
%             
%             %put into new image
%             img(x,y,z,:) = ts';
%         end
%     end
% end
% 
% disp('Slice time correction complete!');

end