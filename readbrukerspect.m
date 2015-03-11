%reads in a bruker 2d seq file with dimensions dim, returns reshaped dat

function [fdat]=readbrukerspect()

[filename, pathname]=uigetfile('*.*','Select fid data');

fid=fopen(fullfile(pathname,filename),'r');

np=2048;

dat=fread(fid,np*2,'int32');

reshape(dat, 2, np);
dat1=complex(dat(1,:),dat(2,:);
fdat=fft(dat1);
plot(fdat);

fprintf('Read in data OK! \n');

