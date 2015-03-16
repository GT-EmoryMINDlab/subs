function [dat, dim] = readbruker(dim)
% READBRUKER  Reads in a Bruker 2dseq file
%
%   DAT = READBRUKER(DIM) reads in a Bruker 2dseq file with the dimensions
%   specified by DIM, reshapes the data to match DIM, and then returns DAT.
%   The user is prompted to select a 2dseq file using the system file
%   dialog.
%
%   [DAT, DIM] = READBRUKER without any DIM input parameter will attempt to
%   automatically calculate dimensions based on additional header files
%   (specifically, 'd3proc' and 'method') in the filetree of the selected
%   '2dseq'. If it cannot automatically find these files, it will prompt
%   the user to select them. The second returned parameter will specify the
%   dimensions that were calculated.
 
%prompt user to select 2dseq file
[filename, pathname]=uigetfile('*.*','Select 2dseq data');
 
%get size of 2dseq file
s = dir(fullfile(pathname, filename));
img_size = s.bytes;       %number of bytes

%if the dimensions aren't explicitly specified, look in the same folder for
%the 'd3proc' file, and two folders up for the 'method' file
if ~exist('dim','var')
    
    %get d3proc file from same directory
    fid2 = fopen(fullfile(pathname, 'd3proc'),'r');
    if fid2 == -1  %couldn't automatically open   
        %request user to select d3proc file
        [filename2, pathname2] = uigetfile('d3proc', 'Select corresponding d3proc file');
        
        try
            fid2 = fopen(fullfile(pathname2, filename2),'r');
        catch
            disp('Error - invalid d3proc file');
            dat = -1;
            return;
        end
    end
    
    %try to read X and Y dimensions from this file
    %also read in the "Z" parameter, which is really Z*T in these 2dseq
    %files
    fl = fgetl(fid2);
    haveX = 0; haveY = 0; haveZT = 0;
    
    while ischar(fl) && ~(haveX && haveY && haveZT)
        %try to get X dimension
        si = regexp(fl, '##\$IM_SIX=\d*', 'match', 'once');

        %if this line exists, get the number
        if ~isempty(si) 
            dim(1) = str2num(si(11:end));
            haveX = 1;
        end
        
        %try to get Y dimension
        si = regexp(fl, '##\$IM_SIY=\d*', 'match', 'once');
        
        %if this line exists, get the number
        if ~isempty(si) 
            dim(2) = str2num(si(11:end));
            haveY = 1;
        end
        
        %try to get Z*T dimension
        si = regexp(fl, '##\$IM_SIZ=\d*', 'match', 'once');
        
        %if this line exists, get the number
        if ~isempty(si) 
            zt = str2num(si(11:end));
            haveZT = 1;
        end

        %read next line
        fl = fgetl(fid2);
    end
    
    if ~(haveX && haveY)
        %if we don't have the X and Y dimension, throw error and break
        disp('ERROR - Could not read FOV dimensions');
        dat = -1;
        return;
    end
    
    fclose(fid2);
    
    %now try to read in T from the 'method' file in the
    %superdirectory
    fid2 = fopen(fullfile(pathname,'../../method'),'r');
    if fid2 == -1   %couldn't automatically find
        %request user to select method file
        [filename2, pathname2] = uigetfile('method', 'Select corresponding method file');
        
        try
            fid2 = fopen(fullfile(pathname2, filename2),'r');
        catch
            disp('Error - invalid method file');
            dat = -1;
            return;
        end
    end
    
    %look through the file
    haveT = 0;
    fl = fgetl(fid2);
    
    while ischar(fl) && ~haveT
        %look for the line ##$PVM_NRepetitions
        si = regexp(fl, '##\$PVM_NRepetitions=\d*', 'match', 'once');

        %if this line exists, get the number
        if ~isempty(si) 
            dim(4) = str2num(si(21:end));
            haveT = 1;
            break;
        end

        %read next line
        fl = fgetl(fid2);
    end
    
    if ~haveT
        %if we don't have the T dimension, throw error and break
        disp('ERROR - Could not read NRepetitions');
        dat = -1;
        return;
    end
    
    %compute Z from T and zt
    dim(3) = zt / dim(4);
    
    %confirm that the size of the file matches these dimensions
    %each number is 2 bits, so filesize === 2 * dimX * dimY * dimZ 8 dimT
    if img_size / prod(dim) ~= 2
        disp('ERROR - Dimensions do not match size of 2dseq');
        dat = -1;
        return;
    end        
end


%read in 2dseq file
fid=fopen(fullfile(pathname,filename),'r');
 
%apply dimensions
DimX=dim(1);
DimY=dim(2);
DimZ=dim(3);
DimTime=dim(4);
 
%read and reshape
dat1=fread(fid,[DimX*DimY*DimZ*DimTime],'int16');
dat=reshape(dat1,[DimX DimY DimZ DimTime]);
 
fprintf('Read in data OK! \n');
 
end
 

