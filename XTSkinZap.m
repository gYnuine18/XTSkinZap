%% Imaris XTension - Remove Skin
% 
% This function identifies surface skin autofluorescence on zebrafish brain
% and removes it. Example images and parameters are noted in the 
% 'How to use SkinZap.pdf' file packaged with this function. Things to note, 
% this function was designed specifically for use in zebrafish brain confocal 
% microscopy and may not be applicable for your use.
% Feel free to contact me by email if you have any queries.
%
% Lloyd Hamilton 2018-11-08
% University Of Edinburgh
% Email : S0973826@sms.ed.ac.uk
% Imaris version : 8.4.1
% Matlab Version : MATLAB R2016a
%
%<CustomTools>
%   <Menu>
%       <Submenu name="Custom Scripts">
%       <Item name="SkinZap" icon="Matlab">
%          <Command>MatlabXT::XTSkinZap(%i)</Command>
%       </Item>
%       </Submenu>
% </CustomTools>

function XTSkinZap(aImarisApplicationID)
%% Imaris Initialisation and Connection 

global vImarisApplication

    function anObjectID = GetObjectID

        vServer = vImarisLib.GetServer;
        vNumberOfObjects = vServer.GetNumberOfObjects;
        anObjectID = vServer.GetObjectID(vNumberOfObjects - 1);

    end

if ~isa(aImarisApplicationID, 'Imaris.IApplicationPrxHelper')
    
    javaaddpath ImarisLib.jar;
    vImarisLib = ImarisLib;
    vImarisApplication = vImarisLib.GetApplication(GetObjectID);
    
else
    
    vImarisApplication = aImarisApplicationID;
    
end

% Undo Function.
vImarisApplication.DataSetPushUndo('SkinZap')

%% Data Import to Matlab and Waitbar construction

vProgressDisplay = waitbar(0,'Importing Data to Matlab','Name','XTSkinZap',...
                   'CreateCancelBtn',...
                   'setappdata(gcbf,''Canceling'',1)');

setappdata(vProgressDisplay,'Canceling',0);

vData = vImarisApplication.GetDataSet;

global ChannelNames, ChannelNames =  cell(99,1);

for ChNumber = 1:99
    try
        ChannelNames{ChNumber} = char(vData.GetChannelName(ChNumber-1));
    catch
        keep = any(~cellfun('isempty',ChannelNames),2);
        ChannelNames = ChannelNames(keep);
        break
    end    
end

if getappdata(vProgressDisplay,'Canceling')
    delete(vProgressDisplay)
    errordlg('User Termination')
    return
end

%% Call GUI and request user threshold input.

set(vProgressDisplay, 'Visible', 'off')

[handle] = InputDialogGuide;

waitfor(handle);

set(vProgressDisplay, 'Visible', 'on')

global thresh

if isempty(thresh)
    delete(vProgressDisplay)
    errordlg('User Termination')
    return
end


%% Slice Processing
global Image
numberofSlices = size(Image,3);
processStack = single(zeros(size(Image,1),size(Image,2),size(Image,3)));
progressText = 'Processing slice %d.';
threshold = str2double(thresh.BinaryThreshold);
lowerSizeThreshold = str2double(thresh.SizeThreshold);

for sliceNumber = numberofSlices:-1:1
    
    waitbar((numberofSlices - sliceNumber) / numberofSlices,...
            vProgressDisplay,sprintf(progressText,sliceNumber))
    
    if thresh.Bit16Button == 1 % If 16 bit image
        singleImage = uint16(Image(:,:,sliceNumber));%16 bit data
        SingleimagetoProcess = im2uint8(singleImage);
    else 
        SingleimagetoProcess = Image(:,:,sliceNumber);
    end
    
    if getappdata(vProgressDisplay,'Canceling')
        delete(vProgressDisplay)
        errordlg('User Termination')
        return
    end
    
    % Threshold image base on intensity. Where singleImage pixel value is
    % greater than [threshold] a true (1) is assigned.
    binThreshImage = SingleimagetoProcess >= threshold; 
    se2 = strel('Diamond',1);
    se3 = strel('Diamond',3);
    erodeimage = imerode(binThreshImage,se2);%Erode image to clean up noise
   
    if max(erodeimage(:)) == 0
        if thresh.Bit16Button == 1 % If 16 bit image
           processStack(:,:,sliceNumber) = im2uint16(SingleimagetoProcess);
           continue
        else
           processStack(:,:,sliceNumber) = uint8(SingleimagetoProcess);
           continue 
        end
    end
    
    dilatedimage = imdilate(erodeimage, se3);
    largestSize = bwarea(bwareafilt(dilatedimage,1,'largest'));
    
    if largestSize < lowerSizeThreshold
        if thresh.Bit16Button == 1 % If 16 bit image
           processStack(:,:,sliceNumber) = im2uint16(SingleimagetoProcess);
           continue
        else
           processStack(:,:,sliceNumber) = uint8(SingleimagetoProcess);
           continue 
        end
    end
    
    rangeFilteredImage = bwareafilt(dilatedimage, [lowerSizeThreshold largestSize]);
    logicalImage = imdilate(rangeFilteredImage, se3);
    imshow(logicalImage)
    SingleimagetoProcess(logicalImage) = 0;
    processStack(:,:,sliceNumber) = uint8(SingleimagetoProcess);
end

vDataSet = vImarisApplication.GetDataSet;
waitbar(1,vProgressDisplay,'Sending Images to Imaris')
vDataSet.SetDataVolumeFloats(processStack,thresh.ChannelSelect,0);
delete(vProgressDisplay)
close all hidden
end
