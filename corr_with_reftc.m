% takes image series and ref time course and calculates cross-correlation

function [cc]=corr_with_reftc(reftimecourse, OldImage);


dim=size(OldImage);
DimX=dim(1,1);
DimY=dim(1,2);
DimZ=dim(1,3);
DimTime=dim(1,4);
timecourse=zeros(DimTime,1);

%calculate cross correlation with every pixel's time course

cc=zeros(DimX,DimY,DimZ);

for z=1:DimZ
    for y=1:DimY
       for x=1:DimX
                 timecourse(:)=squeeze(OldImage(y,x,z,:));
                 temp = corrcoef(reftimecourse,timecourse);
                 cc(y,x,z) = temp(2,1);
        end
    end
end

disp('Cross correlation calculated!');