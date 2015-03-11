%detrends all time courses for an image
function [NewImage]=detrendtimecourse(OldImage, stimstart, dummies);

dim=size(OldImage);
DimX=dim(1,1);
DimY=dim(1,2);
DimZ=dim(1,3);
DimTime=dim(1,4);
x1=[(dummies+1):stimstart];


NewImage=zeros(DimY, DimX, DimZ, DimTime);
coeffs=zeros(DimY, DimX, DimZ, 3);
for z=1:DimZ
    for y=1:DimY
        for x=1:DimX
            if (abs(OldImage(y,x,z,1))> 0)
                y1=squeeze(OldImage(y,x,z,(dummies+1):stimstart)).';
                coeffs(y,x,z,:)=polyfit(x1,y1,2);
                for x2=1:DimTime
                    NewImage(y,x,z,x2)=OldImage(y,x,z,x2)-(x2^2*coeffs(y,x,z,1)+x2*coeffs(y,x,z,2)+coeffs(y,x,z,3));
                end                
            end
        end
    end
end

disp('Image detrended!');
