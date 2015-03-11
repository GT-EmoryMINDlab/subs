%down samples a series of images

function [NewImage]=downsampleimageseries(OldImage, dsrate);

dim=size(OldImage);
DimTime=dim(1,4);
DimTime2=DimTime/dsrate;

for i=1:DimTime2
    NewImage(:,:,:,i)=OldImage(:,:,:,(i-1)*dsrate+1);
end