function varargout = annotation(varargin)
% ANNOTATION MATLAB code for annotation.fig
%      ANNOTATION, by itself, creates a new ANNOTATION or raises the existing
%      singleton*.
%
%      H = ANNOTATION returns the handle to a new ANNOTATION or the handle to
%      the existing singleton*.
%
%      ANNOTATION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ANNOTATION.M with the given input arguments.
%
%      ANNOTATION('Property','Value',...) creates a new ANNOTATION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before annotation_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to annotation_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help annotation

% Last Modified by GUIDE v2.5 15-Oct-2014 20:26:52

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @annotation_OpeningFcn, ...
                   'gui_OutputFcn',  @annotation_OutputFcn, ...
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


% --- Executes just before annotation is made visible.
function annotation_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to annotation (see VARARGIN)
% Create the data to plot.
dataroot= 'data/datasetClean/';
[ img ] = generate_image_list( dataroot , true);
%annotated = zeros(size(img,1),1);
%lables=zeros(size(img,1),10);
%an_table= table(img,annotated,lables);

lables=cell(size(img,1),11);
an_table = cat(2,img,lables);

handles.an_table=an_table;
guidata(hObject,handles);

%load('an_table');
C= an_table(:,2);
curent_index = find([C{:}], 1,'last')+1;
%curent_index= find(an_table.annotated,1,'last')+1;

if size(curent_index,1)<1
    curent_index = 1;
end
handles.curent_index=curent_index;
an_table = handles.an_table;
guidata(hObject,handles);
g = imread(char(an_table(curent_index,1)));
axes(handles.axes1)
imshow(g);

% Choose default command line output for annotation
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes annotation wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = annotation_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in btn_confirm.
function btn_confirm_Callback(hObject, eventdata, handles)
% hObject    handle to btn_confirm (see GCBO)
% Set current data to the selected data set.
an_table = handles.an_table;
an_table(handles.curent_index,2)={1};
handles.an_table=an_table;
curent_index = handles.curent_index+1;
handles.curent_index = curent_index;
g = imread(char(an_table(curent_index,1)));
axes(handles.axes1)
imshow(g);
set(handles.check_noisy,'Value',0);
set(handles.check_abnormal,'Value',0);
set(handles.check_congestion,'Value',0);
set(handles.check_violence,'Value',0);
set(handles.check_Panic,'Value',0);
set(handles.check_Joy,'Value',0);
set(handles.check_Irregularity,'Value',0);
set(handles.check_object,'Value',0);
set(handles.check_Social,'Value',0);
set(handles.check_Indoor,'Value',0);
% switch str{val};
% case '1' % User selects peaks.
%    handles.current_data = handles.peaks;
% case 'Membrane' % User selects membrane.
%    handles.current_data = handles.membrane;
% case 'Sinc' % User selects sinc.
%    handles.current_data = handles.sinc;
% end
% Save the handles structure.
save('an_table_autosave','an_table');
guidata(hObject,handles)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in check_noisy.
function check_noisy_Callback(hObject, eventdata, handles)
% hObject    handle to check_noisy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
str = get(hObject, 'String');
val = get(hObject,'Value');
an_table = handles.an_table;
curent_index = handles.curent_index;
an_table(curent_index,3)={val};
handles.an_table=an_table;
% Hint: get(hObject,'Value') returns toggle state of check_noisy
guidata(hObject,handles)


% --- Executes on button press in check_abnormal.
function check_abnormal_Callback(hObject, eventdata, handles)
% hObject    handle to check_abnormal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
val = get(hObject,'Value');
an_table = handles.an_table;
curent_index = handles.curent_index;
an_table(curent_index,4)={val};
handles.an_table=an_table;
% Hint: get(hObject,'Value') returns toggle state of check_noisy
guidata(hObject,handles)
% Hint: get(hObject,'Value') returns toggle state of check_abnormal


% --- Executes on button press in check_congestion.
function check_congestion_Callback(hObject, eventdata, handles)
% hObject    handle to check_congestion (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
val = get(hObject,'Value');
an_table = handles.an_table;
curent_index = handles.curent_index;
an_table(curent_index,5)={val};
handles.an_table=an_table;
% Hint: get(hObject,'Value') returns toggle state of check_noisy
guidata(hObject,handles)
% Hint: get(hObject,'Value') returns toggle state of check_congestion


% --- Executes on button press in check_violence.
function check_violence_Callback(hObject, eventdata, handles)
% hObject    handle to check_violence (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
val = get(hObject,'Value');
an_table = handles.an_table;
curent_index = handles.curent_index;
an_table(curent_index,6)={val};
handles.an_table=an_table;
% Hint: get(hObject,'Value') returns toggle state of check_noisy
guidata(hObject,handles)
% Hint: get(hObject,'Value') returns toggle state of check_violence


% --- Executes on button press in check_Panic.
function check_Panic_Callback(hObject, eventdata, handles)
% hObject    handle to check_Panic (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
val = get(hObject,'Value');
an_table = handles.an_table;
curent_index = handles.curent_index;
an_table(curent_index,7)={val};
handles.an_table=an_table;
% Hint: get(hObject,'Value') returns toggle state of check_noisy
guidata(hObject,handles)
% Hint: get(hObject,'Value') returns toggle state of check_Panic


% --- Executes on button press in check_Joy.
function check_Joy_Callback(hObject, eventdata, handles)
% hObject    handle to check_Joy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
val = get(hObject,'Value');
an_table = handles.an_table;
curent_index = handles.curent_index;
an_table(curent_index,8)={val};
handles.an_table=an_table;
% Hint: get(hObject,'Value') returns toggle state of check_noisy
guidata(hObject,handles)
% Hint: get(hObject,'Value') returns toggle state of check_Joy


% --- Executes on button press in check_Irregularity.
function check_Irregularity_Callback(hObject, eventdata, handles)
% hObject    handle to check_Irregularity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
val = get(hObject,'Value');
an_table = handles.an_table;
curent_index = handles.curent_index;
an_table(curent_index,9)={val};
handles.an_table=an_table;
% Hint: get(hObject,'Value') returns toggle state of check_noisy
guidata(hObject,handles)
% Hint: get(hObject,'Value') returns toggle state of check_Irregularity


% --- Executes on button press in check_object.
function check_object_Callback(hObject, eventdata, handles)
% hObject    handle to check_object (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
val = get(hObject,'Value');
an_table = handles.an_table;
curent_index = handles.curent_index;
an_table(curent_index,10)={val};
handles.an_table=an_table;
% Hint: get(hObject,'Value') returns toggle state of check_noisy
guidata(hObject,handles)
% Hint: get(hObject,'Value') returns toggle state of check_object


% --- Executes on button press in check_Social.
function check_Social_Callback(hObject, eventdata, handles)
% hObject    handle to check_Social (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
val = get(hObject,'Value');
an_table = handles.an_table;
curent_index = handles.curent_index;
an_table(curent_index,11)={val};
handles.an_table=an_table;
% Hint: get(hObject,'Value') returns toggle state of check_noisy
guidata(hObject,handles)
% Hint: get(hObject,'Value') returns toggle state of check_Social


% --- Executes on button press in check_Indoor.
function check_Indoor_Callback(hObject, eventdata, handles)
% hObject    handle to check_Indoor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
val = get(hObject,'Value');
an_table = handles.an_table;
curent_index = handles.curent_index;
an_table(curent_index,12)={val};
handles.an_table=an_table;
% Hint: get(hObject,'Value') returns toggle state of check_noisy
guidata(hObject,handles)
% Hint: get(hObject,'Value') returns toggle state of check_Indoor



% --- Executes on button press in btn_load.
function btn_load_Callback(hObject, eventdata, handles)
% hObject    handle to btn_load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

load('an_table');
C= an_table(:,2);
curent_index = find([C{:}], 1,'last')+1;
if size(curent_index,1)<1
    curent_index = 1;
end
handles.curent_index=curent_index;
handles.an_table = an_table;
g = imread(char(an_table(curent_index,1)));
axes(handles.axes1)
imshow(g);
guidata(hObject,handles);


% --- Executes on button press in btn_save.
function btn_save_Callback(hObject, eventdata, handles)
% hObject    handle to btn_save (see GCBO)
an_table = handles.an_table;
save('an_table','an_table');
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
