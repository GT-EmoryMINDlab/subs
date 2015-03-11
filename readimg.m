function [ImageSeries]=readimg(dim, filestring);


disp('Select your img data');

[filename, pathname]=uigetfile('*.*','Select img data');
dat1=zeros(dim(1,1)*dim(1,2)*dim(1,3),dim(1,4));

for i=1:dim(1,4)
    filename=sprintf('%02d.img',i);
    file2=strcat(pathname,filestring,filename);
    fid=fopen(file2,'r');
    dat=fread(fid,[dim(1,1)*dim(1,2)*dim(1,3)],'int16');
    dat1(:,i)=dat;
end

ImageSeries=reshape(dat1,[dim(1,2), dim(1,1), dim(1,3), dim(1,4)]);

%can add this for display purposes
%for i=1:dim(1,4)
%    for j=1:dim(1,3)
   %     ImageSeries(:,:,j,i)=rot90(ImageSeries1(:,:,j,i));
 %   end
%end