%reads in dicom file and reshapes data

function [NewImage]=readdicom(dim);

[filename, pathname]=uigetfile('*.*','Select dicom data');
dat1=zeros(dim(1,1), dim(1,2),dim(1,3),dim(1,4));
for i=1:dim(1,4)
    filename=sprintf('%05d.dcm',i);
    file2=strcat(pathname, filename);
    dat=dicomread(file2);
    size (dat)
    dat1(:,:,:,i)=dat;
end

NewImage=reshape(dat1,[dim(1,1), dim(1,2), dim(1,3),dim(1,4)]);

disp('Data read in');

