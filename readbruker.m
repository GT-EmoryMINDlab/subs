%reads in a bruker 2d seq file with dimensions dim, returns reshaped dat

function [dat]=readbruker(dim);

[filename, pathname]=uigetfile('*.*','Select 2dseq data');

fid=fopen(fullfile(pathname,filename),'r');

DimX=dim(1,1);
DimY=dim(1,2);
DimZ=dim(1,3);
DimTime=dim(1,4);

dat1=fread(fid,[DimX*DimY*DimZ*DimTime],'int16');
dat=reshape(dat1,[DimX DimY DimZ DimTime]);

fprintf('Read in data OK! \n');

