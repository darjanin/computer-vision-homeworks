function varargout = darjanin_GUI(varargin)
% DARJANIN_GUI MATLAB code for darjanin_GUI.fig
%      DARJANIN_GUI, by itself, creates a new DARJANIN_GUI or raises the existing
%      singleton*.
%
%      H = DARJANIN_GUI returns the handle to a new DARJANIN_GUI or the handle to
%      the existing singleton*.
%
%      DARJANIN_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DARJANIN_GUI.M with the given input arguments.
%
%      DARJANIN_GUI('Property','Value',...) creates a new DARJANIN_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before darjanin_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to darjanin_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help darjanin_GUI

% Last Modified by GUIDE v2.5 19-Oct-2014 14:43:48

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @darjanin_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @darjanin_GUI_OutputFcn, ...
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

% --- Executes just before darjanin_GUI is made visible.
function darjanin_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to darjanin_GUI (see VARARGIN)

% Choose default command line output for darjanin_GUI
handles.output = hObject;

handles.rgb = ones(3);
handles.result = ones(1);

handles.smooth_filter_size = 3;

imshow(handles.rgb, 'Parent', handles.axes1);
imshow(handles.result, 'Parent', handles.axes2);

% Update handles structure
guidata(hObject, handles);


% UIWAIT makes darjanin_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = darjanin_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function menu_file_Callback(hObject, eventdata, handles)
% hObject    handle to menu_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_item_load_image_Callback(hObject, eventdata, handles)
% hObject    handle to menu_item_load_image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
file_formats = {
    '*.jpg', 'JPEG imagefile (*.jpg)';
    '*.png', 'PNG imagefile (*.png)';
};
[i_file, i_pathname] = uigetfile(file_formats, 'Select the image',[cd '\']);
if ~isequal(i_file, 0)
    % Reading the Image file
    i_file = fullfile(i_pathname, i_file);
    i_rgb = double(imread(i_file))/255;
    handles.rgb = i_rgb;
    handles.result = i_rgb;
    [idx_im, handles.map] = rgb2ind(i_rgb, 256);
    handles.index_image = idx_im;
    handles.current_map = handles.map;
    % show original image in the first axes
    imshow(i_rgb,'Parent',handles.axes1);
    imshow(i_rgb,'Parent',handles.axes2);
    
end

% Update handles structure
guidata(hObject, handles);


% --- Executes on selection change in popup_smooth.
function popup_smooth_Callback(hObject, eventdata, handles)
% hObject    handle to popup_smooth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popup_smooth contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popup_smooth
str = get(hObject, 'String');
val = get(hObject, 'Value');

handles.result = smooth_im(handles.result, str{val}, handles.smooth_filter_size);

imshow(handles.result, 'Parent', handles.axes2);

guidata(hObject, handles);

% --- Smooth image function
function result_im = smooth_im(im, method, filter_size)
% result_im     result
% im            input image
% method        method used for smoothing
% filter_size   size of filter defined in gui, if nothing specified than 1
switch method;
case 'average'
    h = fspecial('average', filter_size);
    result_im = imfilter(im, h);
case 'median'
    result_im = medfilt2(im, [filter_size, filter_size], 'symmetric');
end


% --- Executes during object creation, after setting all properties.
function popup_smooth_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popup_smooth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_filter_size_Callback(hObject, eventdata, handles)
% hObject    handle to edit_filter_size (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_filter_size as text
%        str2double(get(hObject,'String')) returns contents of edit_filter_size as a double
value = str2num(get(hObject, 'String'));
if (value > 0)
    handles.smooth_filter_size = value;
end

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function edit_filter_size_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_filter_size (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2



% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on selection change in popup_noise.
function popup_noise_Callback(hObject, eventdata, handles)
% hObject    handle to popup_noise (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popup_noise contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popup_noise
% Determine the selected noise value
str = get(hObject, 'String');
val = get(hObject, 'Value');

handles.result = imnoise(handles.result, str{val});
imshow(handles.result, 'Parent', handles.axes2);

guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function popup_noise_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popup_noise (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function slider3_Callback(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on selection change in popupmenu6.
function popupmenu6_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu6 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu6


% --- Executes during object creation, after setting all properties.
function popupmenu6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btn_grayscale.
function btn_grayscale_Callback(hObject, eventdata, handles)
% hObject    handle to btn_grayscale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.gray = rgb2gray(handles.rgb);
handles.result = handles.gray;

imshow(handles.result, 'Parent', handles.axes2);

% Update handles structure
guidata(hObject, handles);


