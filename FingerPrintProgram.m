function varargout = FingerPrintProgram(varargin)
% FINGERPRINTPROGRAM M-file for FingerPrintProgram.fig
%      FINGERPRINTPROGRAM, by itself, creates a new FINGERPRINTPROGRAM or raises the existing
%      singleton*.
%
%      H = FINGERPRINTPROGRAM returns the handle to a new FINGERPRINTPROGRAM or the handle to
%      the existing singleton*.
%
%      FINGERPRINTPROGRAM('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FINGERPRINTPROGRAM.M with the given input arguments.
%
%      FINGERPRINTPROGRAM('Property','Value',...) creates a new FINGERPRINTPROGRAM or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before FingerPrintProgram_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to FingerPrintProgram_OpeningFcn via
%      varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help FingerPrintProgram

% Last Modified by GUIDE v2.5 15-Apr-2016 21:43:29

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @FingerPrintProgram_OpeningFcn, ...
                   'gui_OutputFcn',  @FingerPrintProgram_OutputFcn, ...
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


% --- Executes just before FingerPrintProgram is made visible.
function FingerPrintProgram_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to FingerPrintProgram (see VARARGIN)

% Choose default command line output for FingerPrintProgram
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes FingerPrintProgram wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = FingerPrintProgram_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in btnOpenImage.
function btnOpenImage_Callback(hObject, eventdata, handles)
% hObject    handle to btnOpenImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global originImage;
originImage = loadImage();
axes(handles.axes1);
imagesc(originImage);
colormap(gray);


% --- Executes on button press in btnEnhancement.
function btnEnhancement_Callback(hObject, eventdata, handles)
% hObject    handle to btnEnhancement (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global originImage;
originImage = histogramEqualization(originImage);
originImage = fouriorTranform(originImage,0.45);
axes(handles.axes2);
imagesc(originImage);



% --- Executes on button press in btnBinarization.
function btnBinarization_Callback(hObject, eventdata, handles)
% hObject    handle to btnBinarization (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global originImage;

originImage = binarization(double(originImage));
axes(handles.axes1);
imagesc(originImage);


% --- Executes on button press in btnDirection.
function btnDirection_Callback(hObject, eventdata, handles)
% hObject    handle to btnDirection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global originImage;
global outArea;
global outBound;
axes(handles.axes2);
[outBound,outArea] = direction(originImage,16);


% --- Executes on button press in btnROIArea.
function btnROIArea_Callback(hObject, eventdata, handles)
% hObject    handle to btnROIArea (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global originImage;
global outArea;
global outBound;
global process1Image;

axes(handles.axes1);
[process1Image,outBound,outArea] = ROIArea(originImage,outBound,outArea);

% --- Executes on button press in btnThinning.
function btnThinning_Callback(hObject, eventdata, handles)
% hObject    handle to btnThinning (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global process1Image;
global process2Image;

process2Image = im2double(bwmorph(process1Image,'thin',Inf));
process2Image = im2double(bwmorph(process2Image,'clean'));
process2Image = im2double(bwmorph(process2Image,'hbreak'));
process2Image = im2double(bwmorph(process2Image,'spur'));
axes(handles.axes2);
imagesc(process2Image,[0,1]);


% --- Executes on button press in btnMarking.
function btnMarking_Callback(hObject, eventdata, handles)
% hObject    handle to btnMarking (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global process2Image;
global outBound;
global outArea;
global endList;
global branchList;
global ridgeMap;
global edgeWidth;

[endList,branchList,ridgeMap,edgeWidth]=markMinutia(process2Image,outBound,outArea,16);
axes(handles.axes1);
showMinutia(process2Image,endList,branchList);

% --- Executes on button press in btnFalseRemove.
function btnFalseRemove_Callback(hObject, eventdata, handles)
% hObject    handle to btnFalseRemove (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global process2Image;
global outArea;
global endList;
global branchList
global ridgeMap;
global edgeWidth;
global pathMap;
global endListReal;
global branchListReal;
global pathMap;
global endListReal;
[pathMap,endListReal,branchListReal]=falseMinutiaRemove(process2Image,endList,branchList,outArea,ridgeMap,edgeWidth);

axes(handles.axes2);
showMinutia(process2Image,endListReal,branchListReal);



% --- Executes on button press in btnSave.
function btnSave_Callback(hObject, eventdata, handles)
% hObject    handle to btnSave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global pathMap;
global endListReal;
saveFinger(pathMap, endListReal);


% --- Executes on button press in btnMatch.
function btnMatch_Callback(hObject, eventdata, handles)
% hObject    handle to btnMatch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

finger1=fingerTemplateRead;
finger2=fingerTemplateRead;
percent_match=match_end(finger1,finger2,10);