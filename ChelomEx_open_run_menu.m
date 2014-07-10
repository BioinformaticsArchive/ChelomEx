function varargout = ChelomEx_open_run_menu(varargin)
% CHELOMEX_OPEN_RUN_MENU MATLAB code for ChelomEx_open_run_menu.fig
%      CHELOMEX_OPEN_RUN_MENU, by itself, creates a new CHELOMEX_OPEN_RUN_MENU or raises the existing
%      singleton*.
%
%      H = CHELOMEX_OPEN_RUN_MENU returns the handle to a new CHELOMEX_OPEN_RUN_MENU or the handle to
%      the existing singleton*.
%
%      CHELOMEX_OPEN_RUN_MENU('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CHELOMEX_OPEN_RUN_MENU.M with the given input arguments.
%
%      CHELOMEX_OPEN_RUN_MENU('Property','Value',...) creates a new CHELOMEX_OPEN_RUN_MENU or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ChelomEx_open_run_menu_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ChelomEx_open_run_menu_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ChelomEx_open_run_menu

% Last Modified by GUIDE v2.5 16-Jan-2014 12:56:32

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ChelomEx_open_run_menu_OpeningFcn, ...
                   'gui_OutputFcn',  @ChelomEx_open_run_menu_OutputFcn, ...
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


% --- Executes just before ChelomEx_open_run_menu is made visible.
function ChelomEx_open_run_menu_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ChelomEx_open_run_menu (see VARARGIN)

% default strings for text_MS1 and text_MS2
handles.user.runfile{1} = '';
handles.user.runfile{2} = '';
handles.user.import = 0;
handles.user.currentpath = varargin{1}{1};

% Choose default command line output for ChelomEx_open_run_menu
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ChelomEx_open_run_menu wait for user response (see UIRESUME)
uiwait(handles.ChelomEx_open_run_menu);


% --- Outputs from this function are returned to the command line.
function varargout = ChelomEx_open_run_menu_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.user.runfile;
varargout{2} = handles.user.import;

% Delete the figure
delete(handles.ChelomEx_open_run_menu);


% --- Executes on button press in pushbutton_import.
function pushbutton_import_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_import (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    % No selection made for MS1 filename: show error dialog box
    if isequal(handles.user.runfile{1}, '')
        errordlg('Please select a MS1 file');
    else
    % run mzxmlimport after closing the dialog box
        handles.user.import = 1;  
        guidata(hObject, handles);
        uiresume(handles.ChelomEx_open_run_menu);
    end

% --- Executes on button press in pushbutton_cancel.
function pushbutton_cancel_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    % do not run mzxmlimport after closing the dialog box
    handles.user.import = 0; 
    guidata(hObject, handles);
    uiresume(handles.ChelomEx_open_run_menu);

function text_MS1_Callback(hObject, eventdata, handles)
% hObject    handle to text_MS1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of text_MS1 as text
%        str2double(get(hObject,'String')) returns contents of text_MS1 as a double


% --- Executes during object creation, after setting all properties.
function text_MS1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text_MS1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function text_MS2_Callback(hObject, eventdata, handles)
% hObject    handle to text_MS2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of text_MS2 as text
%        str2double(get(hObject,'String')) returns contents of text_MS2 as a double


% --- Executes during object creation, after setting all properties.
function text_MS2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text_MS2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

    
% --- Executes on button press in pushbutton_MS1.
function pushbutton_MS1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_MS1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    
    % open uigetfile dialog GUI
    [filename, pathname] = uigetfile([handles.user.currentpath '\*.mzxml'], 'Open LCMS run (mzxml file)');
    if filename ~= 0  % filename is 0 if user selects cancel
        handles.user.runfile{1} = [pathname filename];
        handles.user.currentpath = pathname;
        % update text_MS1
        set(handles.text_MS1,'String',handles.user.runfile{1});
        guidata(hObject, handles);
    end


% --- Executes on button press in pushbutton_MS2.
function pushbutton_MS2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_MS2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    % open uigetfile dialog GUI
    [filename, pathname] = uigetfile([handles.user.currentpath '*.mzxml'], 'Open MSMS precursor list (mzxml file)');
    if filename ~= 0  % filename is 0 if user selects cancel
        handles.user.runfile{2} = [pathname filename];      
        % update text_MS2
        set(handles.text_MS2,'String',[handles.user.runfile{2}]);
        guidata(hObject, handles);
    end


% --- Executes during object creation, after setting all properties.
function pushbutton_MS1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton_MS1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
    set(hObject, 'CData', imread('OpenFile.png','png'));


% --- Executes during object creation, after setting all properties.
function pushbutton_MS2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton_MS2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
    set(hObject, 'CData', imread('OpenFile.png','png'));


% --- Executes during object creation, after setting all properties.
function axes_openrun_icon_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes_openrun_icon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes_openrun_icon


% --- Executes on button press in pushbutton_icon.
function pushbutton_icon_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_icon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function pushbutton_icon_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton_icon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
    set(hObject, 'CData', imread('Open_Run_Icon.png','png'));


% --- Executes when user attempts to close ChelomEx_open_run_menu.
function ChelomEx_open_run_menu_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to ChelomEx_open_run_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
    if isequal(get(handles.ChelomEx_open_run_menu, 'waitstatus'), 'waiting')
        uiresume(handles.ChelomEx_open_run_menu);
    else
        delete(handles.ChelomEx_open_run_menu);
    end
