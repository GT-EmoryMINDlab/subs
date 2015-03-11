%%Display slices of a 4D image
% if cmap (a colormap) is defined, then will use that. Otherwise, uses the
% standard gray colormap.

function displaySlices(img, cmap)

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
    img(:,:,:,1) = img(:,:,:);
    dimT = 1;
    showtime = 0;   %flag to show time slider
else
    dimT = dim(4);
    showtime = 1;   %flag to show time slider
end

curT = 1;               %show first time point initially

%check to see if we have a colormap 'cmap' defined
if nargin == 1
    %use gray by default
    cmap = colormap('gray');
end

%get max and min of image to use as scaling
max_img = max(img(:));
min_img = min(img(:));
lims = [min_img max_img];

%image panel
panel1 = uipanel('Parent',h,'Position',[0.05 0.1 0.9 0.9],'BackgroundColor','white');
panax = axes('Units','normal','Position',[0 0 1 1], 'Parent', panel1);
imagesc(img(:,:,curZ,curT), 'Parent', panax, lims); %middle slice, time 1
axis image; colormap(cmap);

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


%Functions for UI elements

    %update the slice based on user scroll
    function setslice(source,~)
        %prevent error throwing
        if isnumeric(source)
            return;
        end
        
        curZ = round(source.Value);
       imagesc(img(:,:,curZ,curT), 'Parent', panax, lims);
       axis image; colormap(cmap);
       drawnow;
    end

    %update the time based on user scroll
    function settime(source,~)
        %prevent error throwing
        if isnumeric(source)
            return;
        end
        
        curT = round(source.Value);
       imagesc(img(:,:,curZ,curT), 'Parent', panax, lims);
       axis image; colormap(cmap);
       drawnow;
    end

end