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

% Last Modified by GUIDE v2.5 22-Oct-2014 15:45:37

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

% 'one' variables saved in handles structure
handles.rgb = ones(3);
handles.gray = ones(1);
handles.input = ones(1);
handles.result = ones(1);

% default smooth smoothing filter size set to 3
handles.smooth_filter_size = 3;
% default edge detection threshold set to 0.22
handles.edge_treshold = 0.22;

% default noise method set to gaussian
handles.noise_method = 'gaussian';
% default edge detection method is set to 'sobel'
handles.edge_detection_method = 'sobel';
% default smooth method is set to 'average'
handles.smooth_method = 'average';

% show empty images in axes
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
    % Set global handles variables with loaded image 
    handles.rgb = i_rgb;
    handles.gray = rgb2gray(handles.rgb);
    handles.input = i_rgb;
    handles.result = i_rgb;

    % show loaded image in the axes1
    imshow(handles.input, 'Parent', handles.axes1);
    imshow(ones(1), 'Parent', handles.axes2);
end

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

% --- Executes on selection change in popup_smooth.
function popup_smooth_Callback(hObject, eventdata, handles)
% hObject    handle to popup_smooth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% load selected method name and save it in handles
str = get(hObject, 'String');
val = get(hObject, 'Value');
handles.smooth_method = str{val};

% generate noisy_im that will be smoothed
% method for noise is last method setted in noise popup
noisy_im = imnoise(handles.gray, handles.noise_method);
handles.result = smooth_im(noisy_im, handles.smooth_method, handles.smooth_filter_size);

imshow(noisy_im, 'Parent', handles.axes1);
imshow(handles.result, 'Parent', handles.axes2);

guidata(hObject, handles);

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

% when editext value is number larger than zero set it for
% smooth_filter_size in handles
value = str2double(get(hObject, 'String'));
if (value > 0)
    handles.smooth_filter_size = value;
end

% generate noisy_im that will be smoothed
% method for noise is last method setted in noise popup
noisy_im = imnoise(handles.gray, handles.noise_method);
handles.result = smooth_im(noisy_im, handles.smooth_method, handles.smooth_filter_size);

imshow(noisy_im, 'Parent', handles.axes1);
imshow(handles.result, 'Parent', handles.axes2);

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

% load the last selected noise method; save it in noise_method in handles
str = get(hObject, 'String');
val = get(hObject, 'Value');
handles.noise_method = str{val};

% generate noisy image from gray image
handles.result = imnoise(handles.gray, handles.noise_method);

imshow(handles.gray, 'Parent', handles.axes1);
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
% on change of the treshold value apply edge_detection again

handles.edge_treshold = get(hObject, 'Value');

handles.result = edge_detection(handles.gray, handles.edge_detection_method, handles.edge_treshold);

imshow(handles.gray, 'Parent', handles.axes1);
imshow(handles.result, 'Parent', handles.axes2);

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

% load the edget detection method and save it to the
% edge_detection_method in handles
str = get(hObject, 'String');
val = get(hObject, 'Value');
handles.edge_detection_method = str{val};

handles.result = edge_detection(handles.gray, handles.edge_detection_method, handles.edge_treshold);

imshow(handles.gray, 'Parent', handles.axes1);
imshow(handles.result, 'Parent', handles.axes2);

guidata(hObject, handles);

% --- Edge detection method using conv2
function result_im = edge_detection(im, method, threshold)
% im        input image
% method    method used for edge detection
% treshold  used threshold value from interval <0,1>

% base on method set the matrices Sx and Sy
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

% Horizontal direction
H = conv2(double(im), Sx, 'same');
% Vertical direction
V = conv2(double(im), Sy, 'same');
E = sqrt(H.*H + V.*V);
% transform threshold to interval <0,1> using max value of E
max_e = max(E(:));
% return binary image after applied treshold value
result_im = uint8((E > threshold*max_e) * 255);


% --- Executes during object creation, after setting all properties.
function popup_edge_detection_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popup_edge_detection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function menu_item_grayscale_Callback(hObject, eventdata, handles)
% hObject    handle to menu_item_grayscale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Show image in both axes
imshow(handles.rgb, 'Parent', handles.axes1);
imshow(handles.gray, 'Parent', handles.axes2);

% Update handles structure
guidata(hObject, handles);


% --------------------------------------------------------------------
function menu_item_rgb_Callback(hObject, eventdata, handles)
% hObject    handle to menu_item_rgb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Show rgb image in the axes1 and second one set to empty
imshow(handles.rgb, 'Parent', handles.axes1);
imshow(ones(1), 'Parent', handles.axes2);

% Update handles structure
guidata(hObject, handles);
