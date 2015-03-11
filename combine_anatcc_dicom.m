%maps cc onto anatomical image

function [NewImage]=combine_anatcc_dicom(OldImage, ccmap, ccthresh, imgthresh);

dim=size(OldImage);
DimX=dim(1,1);
DimY=dim(1,2);
DimZ=dim(1,3);
DimTime=dim(1,4);

temp=reshape(OldImage,DimX*DimY*DimZ*DimTime,1);
mx=max(temp);
scale=mx-imgthresh;
OldImage=(OldImage-imgthresh)/scale*0.5;
imgmask=OldImage(:,:,1,1)>0;
OldImage(:,:,1,1)=OldImage(:,:,1,1).*imgmask;


%mx=max(reshape(ccmap,DimX*DimY*DimZ,1));
scale=1-ccthresh;
ccmap=(ccmap-ccthresh)/scale*0.5+0.5;
ccmask=ccmap>=0.5;
ccmap=ccmap.*ccmask;

NewImage=zeros(DimY, DimX, DimZ);
for z=1:DimZ
    for y=1:DimY
        for x=1:DimX
            if (ccmap(y,x,z)> 0)
                NewImage(y,x,z)=ccmap(y,x,z);
            else
                NewImage(y,x,z)=OldImage(y,x,z,1);
            end
        end
    end
end

disp('CC mapped to anatomical image!');

load skfmrimap;

figure(2);
colormap(c4);
imagesc(NewImage(:,:,1));axis image;