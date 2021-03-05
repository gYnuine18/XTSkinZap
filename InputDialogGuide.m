function varargout = InputDialogGuide(varargin)
% INPUTDIALOGGUIDE MATLAB code for InputDialogGuide.fig
%      INPUTDIALOGGUIDE, by itself, creates a new INPUTDIALOGGUIDE or raises the existing
%      singleton*.
%
%      H = INPUTDIALOGGUIDE returns the handle to a new INPUTDIALOGGUIDE or the handle to
%      the existing singleton*.
%
%      INPUTDIALOGGUIDE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in INPUTDIALOGGUIDE.M with the given input arguments.
%
%      INPUTDIALOGGUIDE('Property','Value',...) creates a new INPUTDIALOGGUIDE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before InputDialogGuide_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to InputDialogGuide_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help InputDialogGuide

% Last Modified by GUIDE v2.5 13-Apr-2017 14:52:20

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @InputDialogGuide_OpeningFcn, ...
                   'gui_OutputFcn',  @InputDialogGuide_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before InputDialogGuide is made visible.
function InputDialogGuide_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to InputDialogGuide (see VARARGIN)

% Choose default command line output for InputDialogGuide
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
set(handles.slider1,'Value',1);
hListener = addlistener(handles.slider1,...
                        'ContinuousValueChange',...
                        @(hObject,eventdata)InputDialogGuide('slider1_Callback',hObject,eventdata,guidata(hObject)));
setappdata(handles.slider1, 'listener',hListener);

% UIWAIT makes InputDialogGuide wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = InputDialogGuide_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in PlotHistButton.
function PlotHistButton_Callback(hObject, eventdata, handles)
% hObject    handle to PlotHistButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
vProgressDisplay = waitbar(0, 'Plotting data...', 'Name','Plot Histogram');
global Image
global vImarisApplication
global xAxes
axes(handles.Histogram);
cla;
waitbar(1/3,vProgressDisplay,'Importing data...')
vData = vImarisApplication.GetDataSet;
SelectedChannel = get(handles.ChannelSelect,'Value') - 1;
Image = vData.GetDataVolumeFloats(SelectedChannel,0);
waitbar(2/3,vProgressDisplay,'Import complete...')
if handles.Bit16Button.Value == true % If 16 bit image
        Images = uint16(Image(:,:,:));%16 bit data
        ImagetoProcess = im2uint8(Images);
        histogram(ImagetoProcess(:,:,:))
        waitbar(3/3,vProgressDisplay,'Plotting...')
        delete(vProgressDisplay)
        xAxes = handles.Histogram.XLim;
else
        histogram(Image(:,:,:))
        waitbar(3/3,vProgressDisplay,'Plotting...')
        delete(vProgressDisplay)
        xAxes = handles.Histogram.XLim;
end


function BinaryThresholdTextEdit_Callback(hObject, eventdata, handles)
% hObject    handle to BinaryThresholdTextEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of BinaryThresholdTextEdit as text
%        str2double(get(hObject,'String')) returns contents of BinaryThresholdTextEdit as a double


% --- Executes during object creation, after setting all properties.
function BinaryThresholdTextEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BinaryThresholdTextEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function SizeThresholdTextEdit_Callback(hObject, eventdata, handles)
% hObject    handle to SizeThresholdTextEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SizeThresholdTextEdit as text
%        str2double(get(hObject,'String')) returns contents of SizeThresholdTextEdit as a double


% --- Executes during object creation, after setting all properties.
function SizeThresholdTextEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SizeThresholdTextEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in FinishButton.
function FinishButton_Callback(hObject, eventdata, handles)
% hObject    handle to FinishButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

BinaryThreshold = str2double(get(handles.BinaryThresholdTextEdit,'String'));
SizeThreshold = str2double(get(handles.SizeThresholdTextEdit,'String'));

global thresh 
global vImarisApplication
global Image

if isnan(BinaryThreshold) || isnan(SizeThreshold)
       errordlg('Only whole integers are accepted for thresholds')
       return    
elseif get(handles.Bit8Button,'Value') == 1 && (BinaryThreshold > 255 || BinaryThreshold < 0)
       errordlg('8 Bit Values are between 0 and 255. Please check input.')
       return     
elseif get(handles.Bit16Button,'Value') == 1 && (BinaryThreshold > 65535 || BinaryThreshold < 0)
       errordlg('16 Bit Values are between 0 and 65535. Please check input.')
       return
else
    set(handles.FinishButton,'Value',1);
    set(handles.figure1,'Visible','off');
    thresh.BinaryThreshold = get(handles.BinaryThresholdTextEdit,'String');
    thresh.SizeThreshold = get(handles.SizeThresholdTextEdit,'String');
    thresh.Bit8Button = get(handles.Bit8Button,'Value');
    thresh.Bit16Button = get(handles.Bit16Button,'Value');
    thresh.ChannelSelect = get(handles.ChannelSelect,'Value') - 1;
    vData = vImarisApplication.GetDataSet;
    Image = vData.GetDataVolumeFloats(thresh.ChannelSelect,0);
    close(handles.figure1);
end
% --- Executes on button press in CancelButton.
function CancelButton_Callback(hObject, eventdata, handles)
% hObject    handle to CancelButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global thresh 
thresh = {};
close(handles.figure1);

% --- Executes on key press with focus on FinishButton and none of its controls.
function FinishButton_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to FinishButton (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over Bit8Button.
function Bit8Button_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to Bit8Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.Bit8Button.Value = true;



% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over Bit16Button.
function Bit16Button_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to Bit16Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.Bit16Button.Value = true;


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over PlotHistButton.
function PlotHistButton_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to PlotHistButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in ChannelSelect.
function ChannelSelect_Callback(hObject, eventdata, handles)
% hObject    handle to ChannelSelect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ChannelSelect contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ChannelSelect


% --- Executes during object creation, after setting all properties.
function ChannelSelect_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ChannelSelect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global ChannelNames
set(hObject, 'String', ChannelNames);


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
try
    global xAxes
    sliderValue = handles.slider1.Value;
    handles.Histogram.XLim = [0 (xAxes(2) * sliderValue)];
catch
    return
end
    

% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
