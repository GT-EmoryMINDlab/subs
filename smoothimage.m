%detrends all time courses for an image
function [NewImage]=smoothimage(OldImage);

dim=size(OldImage);
DimZ=dim(1,3);
DimTime=dim(1,4);

h=fspecial('gaussian', [2 2], 2);

for z=1:DimZ
    for t=1:DimTime
        NewImage(:,:,z,t)=imfilter(OldImage(:,:,z,t), h);
    end
end

disp('Image smoothed!');
