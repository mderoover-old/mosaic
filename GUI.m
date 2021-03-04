function varargout = GUI(varargin)
% GUI MATLAB code for GUI.fig
%      GUI, by itself, creates a new GUI or raises the existing
%      singleton*.
%
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.
%
%      GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI.M with the given input arguments.
%
%      GUI('Property','Value',...) creates a new GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI

% Last Modified by GUIDE v2.5 23-May-2018 14:49:26

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_OutputFcn, ...
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


% --- Executes just before GUI is made visible.
function GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI (see VARARGIN)

handles.refImg = 'Big3.jpg';
handles.filterType = 'Hist';
handles.colorSpace = 'RGB';

% handles.HistPanel = 'on';
% handles.MSEPanel = 'off';
% handles.OCCDPanel = 'off';

handles.PreFilterQuality = 'fast';
handles.PreFilterAmount = 500;
handles.subImSize = 32;
handles.neighbourhood = 7;

handles.Histquality = 'intersection';
handles.MSEquality = 'abs';
handles.OCCDquality = 'std';
handles.Edgequality = 'RGB';
handles.histBins = 256;

handles.saveImg = 'result.jpg';


% Choose default command line output for GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in popupmenuSelectMethod.
function popupmenuSelectMethod_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenuSelectMethod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
val = get(hObject,'Value');
str = get(hObject, 'String');
switch str{val};
case 'Histogram'
	handles.filterType = 'Hist';
    set(handles.HistOptns,'Visible','On')
    set(handles.MSEOptns,'Visible','Off')
    set(handles.OCCDOptns,'Visible','Off')
    set(handles.EdgeOptns,'Visible','Off')
    uistack(handles.HistOptns,'top');
    uistack(handles.MSEOptns,'bottom');
    uistack(handles.OCCDOptns,'bottom');
    uistack(handles.EdgeOptns,'bottom');
case 'Mean Square Error'
	handles.filterType = 'MSE';
    set(handles.HistOptns,'Visible','Off')
    set(handles.MSEOptns,'Visible','On')
    set(handles.OCCDOptns,'Visible','Off')
    set(handles.EdgeOptns,'Visible','Off')
    uistack(handles.HistOptns,'bottom');
    uistack(handles.MSEOptns,'top');
    uistack(handles.OCCDOptns,'bottom');
    uistack(handles.EdgeOptns,'bottom');
case 'OCCD'
	handles.filterType = 'OCCD';
    set(handles.HistOptns,'Visible','Off')
    set(handles.MSEOptns,'Visible','Off')
    set(handles.OCCDOptns,'Visible','On')
    set(handles.EdgeOptns,'Visible','Off')
    uistack(handles.HistOptns,'bottom');
    uistack(handles.MSEOptns,'bottom');
    uistack(handles.OCCDOptns,'top');
    uistack(handles.EdgeOptns,'bottom');
case 'Edge Detection'
	handles.filterType = 'Edge';
    set(handles.HistOptns,'Visible','Off')
    set(handles.MSEOptns,'Visible','Off')
    set(handles.OCCDOptns,'Visible','Off')
    set(handles.EdgeOptns,'Visible','On')
    uistack(handles.HistOptns,'bottom');
    uistack(handles.MSEOptns,'bottom');
    uistack(handles.OCCDOptns,'bottom');
    uistack(handles.EdgeOptns,'top');
end
guidata(hObject,handles)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenuSelectMethod contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenuSelectMethod


% --- Executes during object creation, after setting all properties.
function popupmenuSelectMethod_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenuSelectMethod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenuSelectColorSpace.
function popupmenuSelectColorSpace_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenuSelectColorSpace (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

val = get(hObject,'Value');
str = get(hObject, 'String');
switch str{val};
case 'RGB'
	handles.colorSpace = 'RGB';
case 'Lab Space'
	handles.colorSpace = 'LAB';
end
guidata(hObject,handles)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenuSelectColorSpace contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenuSelectColorSpace


% --- Executes during object creation, after setting all properties.
function popupmenuSelectColorSpace_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenuSelectColorSpace (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenuPreFilterQuality.
function popupmenuPreFilterQuality_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenuPreFilterQuality (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

val = get(hObject,'Value');
str = get(hObject, 'String');
switch str{val};
case 'Fast'
	handles.PreFilterQuality = 'fast';
case 'Best'
	handles.PreFilterQuality = 'best';
end
guidata(hObject,handles)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenuPreFilterQuality contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenuPreFilterQuality


% --- Executes during object creation, after setting all properties.
function popupmenuPreFilterQuality_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenuPreFilterQuality (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbuttonCreateMos.
function pushbuttonCreateMos_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonCreateMos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
DATA = guidata(hObject);
% --- For debugging ---
% DATA.refImg
% DATA.filterType
% DATA.Histquality
% DATA.MSEquality
% DATA.OCCDquality
% DATA.Edgequality
% DATA.colorSpace
% DATA.PreFilterQuality
% DATA.PreFilterAmount
% DATA.subImSize
% DATA.neighbourhood
% DATA.saveImg
% ---------------------
switch DATA.filterType
    case 'Hist'
        quality = DATA.Histquality;
    case 'MSE'
        quality = DATA.MSEquality;
    case 'OCCD'
        quality = DATA.OCCDquality;
    case 'Edge'
        quality = DATA.Edgequality;
    otherwise
        error('Error in pushbuttonCreateMos_Callback, faulty filterType')
end

% --- For debugging ---
display('Mosaic creation input data:')
display(strcat(DATA.refImg,', ',DATA.filterType,', ',quality,', ',DATA.colorSpace,', ',DATA.PreFilterQuality,', ',string(DATA.PreFilterAmount),', ',string(DATA.subImSize),', ',string(DATA.neighbourhood),', ',DATA.saveImg))
% ---------------------

GUImain(DATA.refImg,DATA.filterType,quality,DATA.colorSpace,DATA.PreFilterQuality,DATA.PreFilterAmount,DATA.subImSize,DATA.neighbourhood,DATA.saveImg)


% --- Executes when selected object is changed in uibuttongroupHistOptns.
function uibuttongroupHistOptns_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uibuttongroupHistOptns 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
str = get(hObject, 'String');
switch str;
case 'Intersection'
    handles.Histquality = 'intersection';
case 'Euclidian'
    handles.Histquality = 'euclidian';
end
guidata(hObject,handles)


% --- Executes when selected object is changed in uibuttongroupMSEOptns.
function uibuttongroupMSEOptns_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uibuttongroupMSEOptns 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
str = get(hObject, 'String');
switch str;
case 'Abs'
    handles.MSEquality = 'abs';
case 'MSE'
    handles.MSEquality = 'MSE';
end
guidata(hObject,handles)


% --- Executes when selected object is changed in uibuttongroupOCCDOptns.
function uibuttongroupOCCDOptns_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uibuttongroupOCCDOptns 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
str = get(hObject, 'String');
switch str;
case 'Standard'
    handles.Histquality = 'std';
end
guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function uibuttongroupHistOptns_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uibuttongroupHistOptns (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
handles.HistOptns = hObject;
set(handles.HistOptns,'Visible','On')
uistack(handles.HistOptns,'top');
guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function uibuttongroupMSEOptns_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uibuttongroupMSEOptns (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
handles.MSEOptns = hObject;
set(handles.MSEOptns,'Visible','Off')
guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function uibuttongroupOCCDOptns_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uibuttongroupOCCDOptns (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
handles.OCCDOptns = hObject;
set(handles.OCCDOptns,'Visible','Off')
guidata(hObject,handles)


% --- Executes on button press in pushbuttonGetFile.
function pushbuttonGetFile_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonGetFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[file,path] = uigetfile( ...
{  '*.jpg;*.png','Image files (*.jpg,*.png)'; ...
   '*.*',  'All Files (*.*)'}, ...
   'Select an Image');
if contains(file,{'.jpg','.png'})
    filePath = strcat(path,file);
    handles.refImg = filePath;
    set(handles.ImagePath,'String',file);
else
    display('Not a valid file format (jpg or png).')
end
guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function textImagePath_CreateFcn(hObject, eventdata, handles)
% hObject    handle to textImagePath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
handles.ImagePath = hObject;
guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function uibuttongroupEdgeOptns_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uibuttongroupEdgeOptns (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
handles.EdgeOptns = hObject;
set(handles.EdgeOptns,'Visible','Off')
guidata(hObject,handles)


% --- Executes when selected object is changed in uibuttongroupEdgeOptns.
function uibuttongroupEdgeOptns_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uibuttongroupEdgeOptns 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
str = get(hObject, 'String');
switch str;
case 'RGB'
    handles.Edgequality = 'RGB';
case 'Grayscale'
    handles.Edgequality = 'gray';
end
guidata(hObject,handles)



function editPreFiltAmount_Callback(hObject, eventdata, handles)
% hObject    handle to editPreFiltAmount (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
str = get(hObject, 'String');
number = round(str2num(str));
if isempty(str2num(str))
    display('You must give a correct number.')
    set(hObject, 'String', '500')
    handles.PreFilterAmount = 500;
else
    if number ~= str2num(str)
        display('Number rounded to an integer.')
        set(hObject, 'String', num2str(number))
    end
    if number >= 1 && number <= 50000
        handles.PreFilterAmount = number;
    else
        display('Number out of bounds. Insert a correct number.')
        set(hObject, 'String', '500')
        handles.PreFilterAmount = 500;
    end
end
guidata(hObject,handles)
% Hints: get(hObject,'String') returns contents of editPreFiltAmount as text
%        str2double(get(hObject,'String')) returns contents of editPreFiltAmount as a double


% --- Executes during object creation, after setting all properties.
function editPreFiltAmount_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editPreFiltAmount (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editSubImSize_Callback(hObject, eventdata, handles)
% hObject    handle to editSubImSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
str = get(hObject, 'String');
number = round(str2num(str));
if isempty(str2num(str))
    display('You must give a correct number.')
    set(hObject, 'String', '32')
    handles.subImSize = 32;
else
    if number ~= str2num(str)
        display('Number rounded to an integer.')
        set(hObject, 'String', num2str(number))
    end
    if number >= 1 && number <= 64
        handles.subImSize = number;
    else
        display('Number out of bounds. Insert a correct number.')
        set(hObject, 'String', '32')
        handles.subImSize = 32;
    end
end
guidata(hObject,handles)
% Hints: get(hObject,'String') returns contents of editSubImSize as text
%        str2double(get(hObject,'String')) returns contents of editSubImSize as a double


% --- Executes during object creation, after setting all properties.
function editSubImSize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editSubImSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editNeighbourhood_Callback(hObject, eventdata, handles)
% hObject    handle to editNeighbourhood (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
str = get(hObject, 'String');
number = round(str2num(str));
if isempty(str2num(str))
    display('You must give a correct number.')
    set(hObject, 'String', '7')
    handles.neighbourhood = 7;
else
    if number ~= str2num(str)
        display('Number rounded to an integer.')
        set(hObject, 'String', num2str(number))
    end
    if number >= 1
        handles.neighbourhood = number;
    else
        display('Number out of bounds. Insert a correct number.')
        set(hObject, 'String', '7')
        handles.neighbourhood = 7;
    end
end
guidata(hObject,handles)
% Hints: get(hObject,'String') returns contents of editNeighbourhood as text
%        str2double(get(hObject,'String')) returns contents of editNeighbourhood as a double


% --- Executes during object creation, after setting all properties.
function editNeighbourhood_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editNeighbourhood (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbuttonStoreFile.
function pushbuttonStoreFile_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonStoreFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[file,path] = uiputfile( ...
{  '*.jpg;*.png','Image files (*.jpg,*.png)'; ...
   '*.*',  'All Files (*.*)'}, ...
   'Choose a filename');
if contains(file,{'.jpg','.png'})
    filePath = strcat(path,file);
    handles.saveImg = filePath;
    set(handles.SavePath,'String',file);
else
    display('Not a valid file format (jpg or png).')
end
guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function text12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
handles.SavePath = hObject;
guidata(hObject,handles)
