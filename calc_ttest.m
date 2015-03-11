% takes image series and ref time course and calculates cross-correlation

function [tt]=calc_ttest(reftimecourse, OldImage);


dim=size(OldImage);
tcsz=size(reftimecourse);
DimX=dim(1,1);
DimY=dim(1,2);
DimZ=dim(1,3);
DimTime=dim(1,4);

actimg=zeros(DimY, DimX, DimZ, nnz(reftimecourse));
restimg=zeros(DimY, DimX, DimZ, tcsz(1,1)-nnz(reftimecourse));

tt=zeros(DimY,DimX,DimZ);
a=1;
r=1;
rsample=zeros(1,tcsz(1,1)-nnz(reftimecourse));
asample=zeros(1,nnz(reftimecourse));

for t=1:DimTime
    if(reftimecourse(t,1)>0)
        actimg(:,:,:,a)=OldImage(:,:,:,t);
        a=a+1;
    else
        restimg(:,:,:,r)=OldImage(:,:,:,t);
        r=r+1;
    end
end


for z=1:DimZ
    for y=1:DimY
       for x=1:DimX
            if (abs(OldImage(y,x,z,1))> 0)
                 rsample(1,:)=squeeze(restimg(y,x,z,:));
                 asample(1,:)=squeeze(actimg(y,x,z,:));
                 h = ttest2(rsample, asample);
                 if (h>0.5)
                    tt(y,x,z) = h;
                 else 
                    tt (y,x,z) = 0.1;
                 end
            end
       end
    end
end

disp('t-test calculated!');