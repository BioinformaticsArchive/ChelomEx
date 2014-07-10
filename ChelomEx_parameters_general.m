function varargout = ChelomEx_parameters_general(varargin)
% CHELOMEX_PARAMETERS_GENERAL MATLAB code for ChelomEx_parameters_general.fig
%      CHELOMEX_PARAMETERS_GENERAL, by itself, creates a new CHELOMEX_PARAMETERS_GENERAL or raises the existing
%      singleton*.
%
%      H = CHELOMEX_PARAMETERS_GENERAL returns the handle to a new CHELOMEX_PARAMETERS_GENERAL or the handle to
%      the existing singleton*.
%
%      CHELOMEX_PARAMETERS_GENERAL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CHELOMEX_PARAMETERS_GENERAL.M with the given input arguments.
%
%      CHELOMEX_PARAMETERS_GENERAL('Property','Value',...) creates a new CHELOMEX_PARAMETERS_GENERAL or raises
%      the existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ChelomEx_parameters_general_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ChelomEx_parameters_general_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ChelomEx_parameters_general

% Last Modified by GUIDE v2.5 06-Jul-2014 23:01:45

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ChelomEx_parameters_general_OpeningFcn, ...
                   'gui_OutputFcn',  @ChelomEx_parameters_general_OutputFcn, ...
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

% --- Executes just before ChelomEx_parameters_general is made visible.
function ChelomEx_parameters_general_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ChelomEx_parameters_general (see VARARGIN)


% read current filter parameters
handles.user.parameters.search = varargin{1};
update_GUI(handles);

% initialize uicontrols
handles.user.popupitems = {'Positive'; 'Negative'};
set(handles.popupmenu_polarity, 'String', handles.user.popupitems);
set(handles.popupmenu_polarity, 'Value', find(strcmp(handles.user.parameters.search.polarity, handles.user.popupitems)));

% Update handles structure
guidata(hObject, handles);

%UIWAIT makes ChelomEx_parameters_general wait for user response (see UIRESUME)
uiwait(handles.figure_parameters_general);


% --- Outputs from this function are returned to the command line.
function varargout = ChelomEx_parameters_general_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

varargout{1} = handles.user.parameters.search;
varargout{2} = handles.user.ok;

% Delete the figure
delete(handles.figure_parameters_general);

% --- Executes when user attempts to close figure_parameters_general.
function figure_parameters_general_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure_parameters_general (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
    if isequal(get(handles.figure_parameters_general, 'waitstatus'), 'waiting')
        handles.user.ok = 0;
        guidata(hObject, handles);
        uiresume(handles.figure_parameters_general);
    else
        delete(handles.figure_parameters_general);
    end

% --- Executes on button press in pushbutton_ok.
function pushbutton_ok_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_ok (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    handles.user.ok = 1;
    guidata(hObject, handles);
    uiresume(handles.figure_parameters_general);    
    
% --- Executes on button press in pushbutton_cancel.
function pushbutton_cancel_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    handles.user.ok = 0;
    guidata(hObject, handles);
    uiresume(handles.figure_parameters_general);


% --- Executes during object creation, after setting all properties.
function edit_zs_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_zs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_noise_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_noise (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_relerr_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_relerr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_minerr_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_minerr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_offerr_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_offerr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_skip_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_skip (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_baseline_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_baseline (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_speciesnoise_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_speciesnoise (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_MS2err_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_MS2err (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_MS2noise_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_MS2noise (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function popupmenu_polarity_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_polarity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Callback functions for text edit controls ---------------

function popupmenu_polarity_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_polarity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    contents = cellstr(get(hObject,'String'));
    handles.user.parameters.search.polarity = contents{get(hObject,'Value')};
    guidata(hObject, handles);

function edit_zs_Callback(hObject, eventdata, handles)
% hObject    handle to edit_zs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_zs as text
%        str2double(get(hObject,'String')) returns contents of edit_zs as a double
    num = round(str2num(get(hObject,'String'))); 
    if ~isnan(max(num)) & ~isempty(max(num))
        handles.user.parameters.search.zs = num;
    else
        errordlg('Entry must be numeric.', 'Input error');
    end
    update_GUI(handles);
    guidata(hObject,handles);

function edit_noise_Callback(hObject, eventdata, handles)
% hObject    handle to edit_noise (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_noise as text
%        str2double(get(hObject,'String')) returns contents of edit_noise as a double

    num = str2double(get(hObject,'String')); 
    if ~isnan(num) & ~isempty(num)
        handles.user.parameters.search.noise = num;
    else
        errordlg('Entry must be numeric.', 'Input error');
    end
    update_GUI(handles);
    guidata(hObject,handles);



function edit_relerr_Callback(hObject, eventdata, handles)
% hObject    handle to edit_relerr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_relerr as text
%        str2double(get(hObject,'String')) returns contents of edit_relerr as a double

    num = str2double(get(hObject,'String')); 
    if ~isnan(num) & ~isempty(num)
        handles.user.parameters.search.relerr = num;
    else
        errordlg('Entry must be numeric.', 'Input error');
    end
    update_GUI(handles);
    guidata(hObject,handles);

function edit_minerr_Callback(hObject, eventdata, handles)
% hObject    handle to edit_minerr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    num = str2double(get(hObject,'String')); 
    if ~isnan(num) & ~isempty(num)
        handles.user.parameters.search.minerr = num;
    else
        errordlg('Entry must be numeric.', 'Input error');
    end
    update_GUI(handles);
    guidata(hObject,handles);

function edit_offerr_Callback(hObject, eventdata, handles)
% hObject    handle to edit_offerr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_offerr as text
%        str2double(get(hObject,'String')) returns contents of edit_offerr as a double

    num = str2double(get(hObject,'String')); 
    if ~isnan(num) & ~isempty(num)
        handles.user.parameters.search.offerr = num;
    else
        errordlg('Entry must be numeric.', 'Input error');
    end
    update_GUI(handles);
    guidata(hObject,handles);
    
function edit_skip_Callback(hObject, eventdata, handles)
% hObject    handle to edit_skip (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_skip as text
%        str2double(get(hObject,'String')) returns contents of edit_skip as a double

    num = round(str2num(get(hObject,'String'))); 
    if ~isnan(num) & ~isempty(num) & num >= 0
        handles.user.parameters.search.skip = num;
    else
        errordlg('Entry must be positive integer.', 'Input error');
    end
    update_GUI(handles);
    guidata(hObject,handles);

function edit_baseline_Callback(hObject, eventdata, handles)
% hObject    handle to edit_baseline (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_baseline as text
%        str2double(get(hObject,'String')) returns contents of edit_baseline as a double

    num = str2double(get(hObject,'String')); 
    if ~isnan(num) & ~isempty(num)
        handles.user.parameters.search.baseline = num;
    else
        errordlg('Entry must be numeric.', 'Input error');
    end
    update_GUI(handles);
    guidata(hObject,handles);

function edit_speciesnoise_Callback(hObject, eventdata, handles)
% hObject    handle to edit_speciesnoise (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_speciesnoise as text
%        str2double(get(hObject,'String')) returns contents of edit_speciesnoise as a double

    num = str2double(get(hObject,'String')); 
    if ~isnan(num) & ~isempty(num)
        handles.user.parameters.search.speciesnoise = num;
    else
        errordlg('Entry must be numeric.', 'Input error');
    end
    update_GUI(handles);
    guidata(hObject,handles);

function edit_MS2err_Callback(hObject, eventdata, handles)
% hObject    handle to edit_MS2err (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_MS2err as text
%        str2double(get(hObject,'String')) returns contents of edit_MS2err as a double

    num = str2double(get(hObject,'String')); 
    if ~isnan(num) & ~isempty(num)
        handles.user.parameters.search.MS2err = num;
    else
        errordlg('Entry must be numeric.', 'Input error');
    end
    update_GUI(handles);
    guidata(hObject,handles);

function edit_MS2noise_Callback(hObject, eventdata, handles)
% hObject    handle to edit_MS2noise (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_MS2noise as text
%        str2double(get(hObject,'String')) returns contents of edit_MS2noise as a double
    num = str2double(get(hObject,'String')); 
    if ~isnan(num) & ~isempty(num)
        handles.user.parameters.search.MS2noise = num;
    else
        errordlg('Entry must be numeric.', 'Input error');
    end
    update_GUI(handles);
    guidata(hObject,handles);


% --- user function to update data display in GUI -----------------------
function update_GUI(handles)
    set(handles.edit_zs, 'String', num2str(handles.user.parameters.search.zs));
    set(handles.edit_noise, 'String', num2str(handles.user.parameters.search.noise));
    set(handles.edit_relerr, 'String', num2str(handles.user.parameters.search.relerr));
    set(handles.edit_minerr, 'String', num2str(handles.user.parameters.search.minerr));
    set(handles.edit_offerr, 'String', num2str(handles.user.parameters.search.offerr));
    set(handles.edit_skip, 'String', num2str(handles.user.parameters.search.skip));
    set(handles.edit_baseline, 'String', num2str(handles.user.parameters.search.baseline));
    set(handles.edit_speciesnoise, 'String', num2str(handles.user.parameters.search.speciesnoise));
    set(handles.edit_MS2err, 'String', num2str(handles.user.parameters.search.MS2err));
    set(handles.edit_MS2noise, 'String', num2str(handles.user.parameters.search.MS2noise));
    
    handles.user.parameters.search.smooth = handles.user.parameters.search.skip + 1;
    
