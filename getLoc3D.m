function pix = getLoc3D(img, seedsize)
% GETLOC3D  Prompt user to select a point from a 3D or 4D image
%
%   PIX = GETLOC3D(IMG, SEEDSIZE) prepares a GUI to visualize a 3D or 4D image in
%   slices (similar to DISPLAYSLICES). Then, the user is prompted to select
%   a point using crosshairs (via the GINPUT command). A square region with 
%   side length SEEDSIZE is selected centered on this point. The indices of
%   points is returned in a N x 3 matrix, where N == SEEDSIZE^2, with the
%   rows depicting the points coordinate in the X, Y, and Z planes
%   respectively.
%
%   PIX = GETLOC3D(IMG, SEEDSIZE) uses a default SEEDSIZE of 2.
%
%   See also GETLOC, DISPLAYSLICES, GINPUT.

%set SEEDSIZE if not set
if ~exist('seedsize','var')
    seedsize = 2;
end

%main window
h = figure;
set(h, 'Position', [420 200 600 500]);

%get dims of image
dim = size(img);
dimZ = dim(3);

%if we only have a single slice, then don't display the slider
if dimZ == 1
    curZ = 1;
    showZ = 0;  %flag to show slice slider
else    %show slider and set initial slice to middle
    curZ = floor(dimZ/2);
    showZ = 1;  %flag to show slice slider
end

%if we only have a 3D image, create a 4th dimension
if numel(dim) == 3
    disp('hi');
    img(:,:,:,1) = img(:,:,:);
    dimT = 1;
    showtime = 0;   %flag to show time slider
else
    dimT = dim(4);
    showtime = 1;   %flag to show time slider
end

curT = 1;               %show first time point initially

%image panel
panel1 = uipanel('Parent',h,'Position',[0.05 0.15 0.9 0.85],'BackgroundColor','white');
panax = axes('Units','normal','Position',[0 0 1 1], 'Parent', panel1);
imagesc(img(:,:,curZ,curT), 'Parent', panax, 'ButtonDownFcn',@selectPoint); %middle slice, time 1
axis image; colormap gray;

%slice slider
if showZ
    slider_slice = uicontrol('Parent',h,'Style', 'slider', 'Min', 1, 'Max', dimZ, ...
        'SliderStep', [1/dimZ 1/dimZ], 'Value', curZ,'Position',[65 0 218 36], ...
        'Callback', @setslice, 'KeyPressFcn', @setslice);

    %add a listener to constantly update slice
    try  % R2014a and newer
       addlistener(slider_slice,'ContinuousValueChange',@setslice);
    catch    % R2013b and older
       addlistener(slider_slice,'ActionEvent',@setslice);
    end

    txt1 = uicontrol('Parent',h,'Style', 'text', 'String', 'Slice: ', ...
        'Position',[15 0 50 36]);
end

%time slider
if showtime
    slider_time = uicontrol('Parent',h,'Style', 'slider', 'Min', 1, 'Max', dimT, ...
        'SliderStep', [1/dimT 1/dimT], 'Value', curT,'Position',[355 0 218 36], ...
        'Callback', @settime, 'KeyPressFcn', @settime);

    %add a listener to constantly update time
    try  % R2014a and newer
       addlistener(slider_time,'ContinuousValueChange',@settime);
    catch    % R2013b and older
       addlistener(slider_time,'ActionEvent',@settime);
    end

    txt2 = uicontrol('Parent',h,'Style', 'text', 'String', 'Time: ', ...
        'Position',[305 0 50 36]);
end

%add text to tell users what to do
txt3 = uicontrol('Parent', h, 'Style', 'text', 'String', ...
    'Adjust sliders, then click on image to bring up crosshairs to select point.', ...
    'Position', [120 45 350 20]);

%wait for user to input location
pix = 0;
while pix == 0
    pause(0.1);
end

disp('Point Selected');
close(h);
drawnow;

%Functions for UI elements

    %update the slice based on user scroll
    function setslice(source,~)
        %prevent error throwing
        if isnumeric(source)
            return;
        end
        
        curZ = ceil(source.Value);
        imagesc(img(:,:,curZ,curT), 'Parent', panax, 'ButtonDownFcn',@selectPoint);
        axis image; colormap gray;
        drawnow;
    end

    %update the time based on user scroll
    function settime(source,~)
        %prevent error throwing
        if isnumeric(source)
            return;
        end
        
        curT = round(source.Value);
        imagesc(img(:,:,curZ,curT), 'Parent', panax, 'ButtonDownFcn',@selectPoint);
        axis image; colormap gray;
        drawnow;
    end

    function selectPoint(source,~)
        %prompt user for input on screen
        loc=round(ginput(1));
        i=loc(1);
        j=loc(2);
        
        %expand based on seedsize
        pix=zeros(seedsize*seedsize,3);

        for i1=1:seedsize
            for j1=1:seedsize
                pix((i1-1)*seedsize+j1,1)=i+(i1-1);
                pix((i1-1)*seedsize+j1,2)=j+(j1-1);
                pix((i1-1)*seedsize+j1,3)=curZ;
            end
        end    
    end

end