function varargout = ChelomEx_parameters_filters(varargin)
% CHELOMEX_PARAMETERS_FILTERS MATLAB code for ChelomEx_parameters_filters.fig
%      CHELOMEX_PARAMETERS_FILTERS, by itself, creates a new CHELOMEX_PARAMETERS_FILTERS or raises the existing
%      singleton*.
%
%      H = CHELOMEX_PARAMETERS_FILTERS returns the handle to a new CHELOMEX_PARAMETERS_FILTERS or the handle to
%      the existing singleton*.
%
%      CHELOMEX_PARAMETERS_FILTERS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CHELOMEX_PARAMETERS_FILTERS.M with the given input arguments.
%
%      CHELOMEX_PARAMETERS_FILTERS('Property','Value',...) creates a new CHELOMEX_PARAMETERS_FILTERS or raises
%      the existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ChelomEx_parameters_filters_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ChelomEx_parameters_filters_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ChelomEx_parameters_filters

% Last Modified by GUIDE v2.5 02-Jul-2014 13:18:42

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ChelomEx_parameters_filters_OpeningFcn, ...
                   'gui_OutputFcn',  @ChelomEx_parameters_filters_OutputFcn, ...
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

% --- Executes just before ChelomEx_parameters_filters is made visible.
function ChelomEx_parameters_filters_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ChelomEx_parameters_filters (see VARARGIN)

% read current filter parameters
handles.user.parameters.filters = varargin{1};
update_GUI(handles);

% Update handles structure
guidata(hObject, handles);

%UIWAIT makes ChelomEx_parameters_filters wait for user response (see UIRESUME)
uiwait(handles.figure_parameters_filters);


% --- Outputs from this function are returned to the command line.
function varargout = ChelomEx_parameters_filters_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

varargout{1} = handles.user.parameters.filters;
varargout{2} = handles.user.ok;

% Delete the figure
delete(handles.figure_parameters_filters);

% --- Executes when user attempts to close figure_parameters_filters.
function figure_parameters_filters_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure_parameters_filters (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
    if isequal(get(handles.figure_parameters_filters, 'waitstatus'), 'waiting')
        handles.user.ok = 0;
        guidata(hObject, handles);
        uiresume(handles.figure_parameters_filters);
    else
        delete(handles.figure_parameters_filters);
    end

% --- Executes on button press in pushbutton_ok.
function pushbutton_ok_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_ok (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    handles.user.ok = 1;
    guidata(hObject, handles);
    uiresume(handles.figure_parameters_filters);    
    
% --- Executes on button press in pushbutton_cancel.
function pushbutton_cancel_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    handles.user.ok = 0;
    guidata(hObject, handles);
    uiresume(handles.figure_parameters_filters);



% --- Executes during object creation, after setting all properties.
function edit_tolerate_correlation_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_tolerate_correlation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- CreateFcn functions for text edit controls ---------------
function edit_tolerate_number_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_tolerate_number (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_outlier_correlation_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_outlier_correlation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_outlier_number_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_outlier_number (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_outlier_fraction2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_outlier_fraction2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_outlier_fraction1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_outlier_fraction1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_tolerate_fraction1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_tolerate_fraction1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_tolerate_fraction2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_tolerate_fraction2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Callback functions for text edit controls ---------------
function edit_tolerate_correlation_Callback(hObject, eventdata, handles)
% hObject    handle to edit_tolerate_correlation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_tolerate_correlation as text
%        str2double(get(hObject,'String')) returns contents of edit_tolerate_correlation as a double
    num = str2double(get(hObject,'String')); 
    if ~isnan(num) 
        handles.user.parameters.filters.correlation(1) = num;
        if handles.user.parameters.filters.correlation(2) > num
            handles.user.parameters.filters.correlation(2) = num;
        end
    else
        errordlg('Entry must be numeric.', 'Input error');
    end
    update_GUI(handles);
    guidata(hObject,handles);
    
function edit_outlier_correlation_Callback(hObject, eventdata, handles)
% hObject    handle to edit_outlier_correlation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    num = str2double(get(hObject,'String')); 
    if ~isnan(num)
        handles.user.parameters.filters.correlation(2) = num;
        if handles.user.parameters.filters.correlation(1) < num
            handles.user.parameters.filters.correlation(1) = num;
        end
    else
        errordlg('Entry must be numeric.', 'Input error');
    end
    update_GUI(handles);
    guidata(hObject,handles);
  
function edit_tolerate_number_Callback(hObject, eventdata, handles)
% hObject    handle to edit_tolerate_number (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    num = round(str2double(get(hObject,'String'))); 
    if num > 0 
        handles.user.parameters.filters.number(1) = num;
        if handles.user.parameters.filters.number(2) > num
            handles.user.parameters.filters.number(2) = num;
        end
    else
        errordlg('Entry must be positive integer.', 'Input error');
    end
    update_GUI(handles);
    guidata(hObject,handles);

function edit_outlier_number_Callback(hObject, eventdata, handles)
% hObject    handle to edit_outlier_number (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    num = round(str2double(get(hObject,'String'))); 
    if num > 0 
        handles.user.parameters.filters.number(2) = num;
        if handles.user.parameters.filters.number(1) < num
            handles.user.parameters.filters.number(1) = num;
        end
    else
        errordlg('Entry must be numeric.', 'Input error');
    end
    update_GUI(handles);
    guidata(hObject,handles);

function edit_tolerate_fraction1_Callback(hObject, eventdata, handles)
% hObject    handle to edit_tolerate_fraction1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    num = str2double(get(hObject,'String')); 
    if ~isnan(num) & num >= 0 
        handles.user.parameters.filters.fraction1(1) = num;
        if handles.user.parameters.filters.fraction1(2) > num
            handles.user.parameters.filters.fraction1(2) = num;
        end
    else
        errordlg('Entry must be positive number.', 'Input error');
    end
    update_GUI(handles);
    guidata(hObject,handles);

function edit_outlier_fraction1_Callback(hObject, eventdata, handles)
% hObject    handle to edit_outlier_fraction1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    num = str2double(get(hObject,'String')); 
    if ~isnan(num) & num >= 0
        handles.user.parameters.filters.fraction1(2) = num;
        if handles.user.parameters.filters.fraction1(1) < num
            handles.user.parameters.filters.fraction1(1) = num;
        end
    else
        errordlg('Entry must be positive number.', 'Input error');
    end
    update_GUI(handles);
    guidata(hObject,handles);

function edit_tolerate_fraction2_Callback(hObject, eventdata, handles)
% hObject    handle to edit_tolerate_fraction2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    num = str2double(get(hObject,'String')); 
    if ~isnan(num) & num >= 0
        handles.user.parameters.filters.fraction2(1) = num;
        if handles.user.parameters.filters.fraction2(2) > num
            handles.user.parameters.filters.fraction2(2) = num;
        end
    else
        errordlg('Entry must be positive number.', 'Input error');
    end
    update_GUI(handles);
    guidata(hObject,handles);

function edit_outlier_fraction2_Callback(hObject, eventdata, handles)
% hObject    handle to edit_outlier_fraction2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    num = str2double(get(hObject,'String')); 
    if ~isnan(num) & num >= 0
        handles.user.parameters.filters.fraction2(2) = num;
        if handles.user.parameters.filters.fraction2(1) < num
            handles.user.parameters.filters.fraction2(1) = num;
        end
    else
        errordlg('Entry must be positive number.', 'Input error');
    end
    update_GUI(handles);
    guidata(hObject,handles);


% --- user function to update data display in GUI -----------------------
function update_GUI(handles)
    set(handles.edit_tolerate_correlation, 'String', sprintf('%3.2f', handles.user.parameters.filters.correlation(1)));
    set(handles.edit_tolerate_number, 'String', num2str(handles.user.parameters.filters.number(1)));
    set(handles.edit_tolerate_fraction1, 'String', sprintf('%3.2f', handles.user.parameters.filters.fraction1(1)));
    set(handles.edit_tolerate_fraction2, 'String', sprintf('%3.2f', handles.user.parameters.filters.fraction2(1)));
    
    set(handles.edit_outlier_correlation, 'String', sprintf('%3.2f', handles.user.parameters.filters.correlation(2)));
    set(handles.edit_outlier_number, 'String', num2str(handles.user.parameters.filters.number(2)));
    set(handles.edit_outlier_fraction1, 'String', sprintf('%3.2f', handles.user.parameters.filters.fraction1(2)));
    set(handles.edit_outlier_fraction2, 'String', sprintf('%3.2f', handles.user.parameters.filters.fraction2(2)));
        
 
