%detrends all time courses for an image
function [NewImage]=detrendimage(OldImage);

dim=size(OldImage);
DimX=dim(1,1);
DimY=dim(1,2);
DimZ=dim(1,3);
DimTime=dim(1,4);

NewImage=zeros(DimY, DimX, DimZ, DimTime);
for z=1:DimZ
    for y=1:DimY
        for x=1:DimX
            if (abs(OldImage(y,x,z,1))> 0)
                NewImage(y,x,z,:)=detrend(OldImage(y,x,z,:));
            end
        end
    end
end

disp('Image detrended!');