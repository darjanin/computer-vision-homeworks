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

% Last Modified by GUIDE v2.5 22-Oct-2014 12:07:10

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
handles.input = ones(1);
handles.result = ones(1);

handles.smooth_filter_size = 3;
handles.edge_treshold = 0.1;

imshow(handles.input, 'Parent', handles.axes1);
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

% file_formats list of all supported formats
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
    handles.input = i_rgb;
    handles.result = i_rgb;
    [idx_im, handles.map] = rgb2ind(i_rgb, 256);
    handles.index_image = idx_im;
    handles.current_map = handles.map;
    % show original image in the first axes
    imshow(handles.input, 'Parent', handles.axes1);
    imshow(handles.input, 'Parent', handles.axes2);
    
end

% Update handles structure
guidata(hObject, handles);


% --- Executes on selection change in popup_smooth.
function popup_smooth_Callback(hObject, eventdata, handles)
% hObject    handle to popup_smooth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

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
% filter_size   size of filter defined in gui, if nothing specified than 3
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

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_filter_size_Callback(hObject, eventdata, handles)
% hObject    handle to edit_filter_size (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

value = str2double(get(hObject, 'String'));
if (value > 0)
    handles.smooth_filter_size = value;
end

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function edit_filter_size_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_filter_size (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popup_noise.
function popup_noise_Callback(hObject, eventdata, handles)
% hObject    handle to popup_noise (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
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

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function slider_treshold_Callback(hObject, eventdata, handles)
% hObject    handle to slider_treshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.edge_treshold = get(hObject, 'Value');

disp(handles.edge_treshold);

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function slider_treshold_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_treshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on selection change in popup_edge_detection.
function popup_edge_detection_Callback(hObject, eventdata, handles)
% hObject    handle to popup_edge_detection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%imshow(edge(handles.result,'sobel'), 'Parent', handles.axes2);
str = get(hObject, 'String');
val = get(hObject, 'Value');

handles.result = edgeDetection(handles.result, str{val}, handles.edge_treshold);

imshow(handles.result, 'Parent', handles.axes2);

guidata(hObject, handles);

function result_im = edgeDetection(im, method, threshold)

switch method;
case 'sobel' 
    Sx = [1 2 1; 0 0 0; -1 -2 -1];
    Sy = [1 0 -1; 2 0 -2; 1 0 -1];
case 'prewitt'
    Sx = [-1 0 1; -1 0 1; -1 0 1];
    Sy = [-1 -1 -1; 0 0 0; 1 1 1];
case 'roberts'
    Sx = [1 0; 0 -1];
    Sy = [0 1; -1 0];
end


H = conv2(double(im), Sx, 'same');
V = conv2(double(im), Sy, 'same');
E = sqrt(H.*H + V.*V);
whos E;
edge_image = uint8((E > threshold) * 255);

result_im = edge_image;



% --- Executes during object creation, after setting all properties.
function popup_edge_detection_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popup_edge_detection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btn_grayscale.
function btn_grayscale_Callback(hObject, eventdata, handles)
% hObject    handle to btn_grayscale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
gray = rgb2gray(handles.rgb);
handles.result = gray;

imshow(handles.result, 'Parent', handles.axes2);

% Update handles structure
guidata(hObject, handles);


% --------------------------------------------------------------------
function menu_edit_image_Callback(hObject, eventdata, handles)
% hObject    handle to menu_edit_image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_item_grayscale_Callback(hObject, eventdata, handles)
% hObject    handle to menu_item_grayscale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
gray = rgb2gray(handles.rgb);
handles.input = gray;
handles.result = gray;

imshow(handles.input, 'Parent', handles.axes1);
imshow(handles.result, 'Parent', handles.axes2);

% Update handles structure
guidata(hObject, handles);


% --------------------------------------------------------------------
function menu_item_rgb_Callback(hObject, eventdata, handles)
% hObject    handle to menu_item_rgb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.input = handles.rgb;
handles.result = handles.rgb;

imshow(handles.input, 'Parent', handles.axes1);
imshow(handles.result, 'Parent', handles.axes2);

% Update handles structure
guidata(hObject, handles);
