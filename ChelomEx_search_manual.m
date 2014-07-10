function varargout = ChelomEx_search_manual(varargin)
% CHELOMEX_SEARCH_MANUAL MATLAB code for ChelomEx_search_manual.fig
%      CHELOMEX_SEARCH_MANUAL, by itself, creates a new CHELOMEX_SEARCH_MANUAL or raises the existing
%      singleton*.
%
%      H = CHELOMEX_SEARCH_MANUAL returns the handle to a new CHELOMEX_SEARCH_MANUAL or the handle to
%      the existing singleton*.
%
%      CHELOMEX_SEARCH_MANUAL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CHELOMEX_SEARCH_MANUAL.M with the given input arguments.
%
%      CHELOMEX_SEARCH_MANUAL('Property','Value',...) creates a new CHELOMEX_SEARCH_MANUAL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ChelomEx_search_manual_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ChelomEx_search_manual_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ChelomEx_search_manual

% Last Modified by GUIDE v2.5 24-Feb-2014 13:04:07

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ChelomEx_search_manual_OpeningFcn, ...
                   'gui_OutputFcn',  @ChelomEx_search_manual_OutputFcn, ...
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


% --- Executes just before ChelomEx_search_manual is made visible.
function ChelomEx_search_manual_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ChelomEx_search_manual (see VARARGIN)

% read varargin input from ChelomEx_Menu
% (handles.user.parameters.search)
handles.user.parameters = varargin{1};

% populate popupmenu_dbspecies with predefined species from database
load('database.mat', 'database');
handles.user.database = database;
set(handles.popupmenu_dbspecies, 'String', [{'Select Database Ligand'}; handles.user.database.ID], 'Value', 1);

% populate popupmenu_type with values 
set(handles.popupmenu_type, 'String', [{'Ligand'};{'Complex'}], 'Value', 1);
type = get(handles.popupmenu_type, 'String');
handles.user.parameters.search.targeted.manual.type = type{get(handles.popupmenu_type, 'Value')};

% populate listbox_species with possible complex species
% change IDs from -Fe +3H to +Fe -3H etc.
handles.user.species.id = handles.user.parameters.patternID.(handles.user.parameters.currentPattern).species.id;
if ~isempty(handles.user.species.id)
    for j = 1:size(handles.user.species.id,1)
         idstring = handles.user.species.id{j};
         for k = 1:length(idstring)
            if isequal(idstring(k),'+')
                idstring(k) = '-';
            elseif isequal(idstring(k),'-')
                idstring(k) = '+';
            end
         end
         handles.user.species.id{j} = idstring;
    end
    set(handles.listbox_species,'String', handles.user.species.id, 'Max', length(handles.user.species.id), 'Value', 1:length(handles.user.species.id));
% if no species defined in pattern: only search for given complex m/z possible
else   
    set(handles.listbox_species, 'Enable', 'off');
    set(handles.popupmenu_dbspecies, 'Enable', 'off');
    set(handles.popupmenu_type, 'Value', 2, 'Enable', 'off');
    handles.user.parameters.search.targeted.manual.type = type{get(handles.popupmenu_type, 'Value')};
end
    
% defaut if listbox selection is not changed
handles.user.parameters.search.targeted.manual.species.id = handles.user.species.id;
handles.user.parameters.search.targeted.manual.species.dmz = handles.user.parameters.patternID.(handles.user.parameters.currentPattern).species.dmz;

% use predefined z values from handles.user.parameters
set(handles.edit_zs, 'String', num2str(handles.user.parameters.search.zs));
handles.user.parameters.search.targeted.manual.zs = handles.user.parameters.search.zs;

% use predefined max mass offset from handles.user.parameters.offerr
set(handles.edit_offerr, 'String', sprintf('%6.4f', handles.user.parameters.search.offerr));
handles.user.parameters.search.targeted.manual.offerr = str2double(get(handles.edit_offerr, 'String'));

% get polarity mode and set static_mz text 
if strcmp(handles.user.parameters.search.polarity, 'Positive')
    handles.user.parameters.search.targeted.manual.polarity = 1.00728;
    set(handles.static_mz, 'String', 'm/z (M + H+)');
elseif strcmp(handles.user.parameters.search.polarity, 'Negative')
    handles.user.parameters.search.targeted.manual.polarity = -1.00728;
    set(handles.static_mz, 'String', 'm/z (M - H+)');
end

% initialize output variables
handles.user.ok = false;
handles.user.parameters.search.targeted.manual.mz = [];

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ChelomEx_search_manual wait for user response (see UIRESUME)
uiwait(handles.figure_ChelomEx_search_manual);


% --- Outputs from this function are returned to the command line.
function varargout = ChelomEx_search_manual_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Function output
varargout{1} = handles.user.ok;
varargout{2} = handles.user.parameters.search.targeted.manual;

% Delete the figure
delete(handles.figure_ChelomEx_search_manual);

% --- Executes when user attempts to close figure_ChelomEx_search_manual.
function figure_ChelomEx_search_manual_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure_ChelomEx_search_manual (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
    if isequal(get(hObject, 'waitstatus'), 'waiting')
        uiresume(hObject);
    else
        delete(hObject);
    end

function edit_mz_Callback(hObject, eventdata, handles)
% hObject    handle to edit_mz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_mz as text
%        str2double(get(hObject,'String')) returns contents of edit_mz as a double
    mz = str2double(get(handles.edit_mz, 'String'));
    if ~isnan(mz) & ~isempty(mz)
        handles.user.parameters.search.targeted.manual.mz = mz;
        set(handles.popupmenu_dbspecies, 'Value', 1);
        handles.user.parameters.search.targeted.manual.id = '';
        guidata(hObject, handles);
    else 
        errordlg('Please enter a numeric value', 'Input error');
        set(handles.edit_mz, 'String', sprintf('%9.4f',handles.user.parameters.search.targeted.manual.mz));
    end


% --- Executes during object creation, after setting all properties.
function edit_mz_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_mz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_zs_Callback(hObject, eventdata, handles)
% hObject    handle to edit_zs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_zs as text
%        str2double(get(hObject,'String')) returns contents of edit_zs as a double
    zs = str2num(get(handles.edit_zs, 'String'));
    if ~isnan(zs) & ~isempty(zs)
        handles.user.parameters.search.targeted.manual.zs = zs;
        guidata(hObject, handles);
    else 
     errordlg('Please enter comma separated numeric values', 'Input error');
     set(handles.edit_zs, 'String', num2str(handles.user.parameters.search.zs));
    end


% --- Executes during object creation, after setting all properties.
function edit_zs_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_zs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_offerr_Callback(hObject, eventdata, handles)
% hObject    handle to edit_offerr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_offerr as text
%        str2double(get(hObject,'String')) returns contents of edit_offerr as a double
    offerr = str2double(get(handles.edit_offerr, 'String'));
    if ~isnan(offerr) & ~isempty(offerr)
        handles.user.parameters.search.targeted.manual.offerr = offerr;
     guidata(hObject, handles);
    else 
     errordlg('Please enter a numeric value', 'Input error');
     set(handles.edit_offerr, 'String', sprintf('%6.4f',handles.user.parameters.search.targeted.manual.offerr));
    end


% --- Executes during object creation, after setting all properties.
function edit_offerr_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_offerr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_type.
function popupmenu_type_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_type contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_type
    type = get(handles.popupmenu_type, 'String');
    handles.user.parameters.search.targeted.manual.type = type{get(handles.popupmenu_type, 'Value')};
    if get(handles.popupmenu_type, 'Value') > 1 
        set(handles.listbox_species, 'Enable', 'off');
        if get(handles.popupmenu_dbspecies, 'Value') > 1
            set(handles.popupmenu_dbspecies, 'Value', 1);
            handles.user.parameters.search.targeted.manual.id = '';
        end
    elseif get(handles.popupmenu_type, 'Value') == 1 
        set(handles.listbox_species, 'Enable', 'on');
    end
    guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function popupmenu_type_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_dbspecies.
function popupmenu_dbspecies_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_dbspecies (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_dbspecies contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_dbspecies
    handles.user.dbidx = get(handles.popupmenu_dbspecies, 'Value')-1;
    if handles.user.dbidx > 0   % selection was made
        handles.user.parameters.search.targeted.manual.id = handles.user.database.ID{handles.user.dbidx};
        handles.user.parameters.search.targeted.manual.mz = handles.user.database.data(handles.user.dbidx,1) + handles.user.parameters.search.targeted.manual.polarity;
        set(handles.edit_mz, 'String', sprintf('%9.4f', handles.user.parameters.search.targeted.manual.mz));
        set(handles.popupmenu_type, 'Value', 1);
        type = get(handles.popupmenu_type, 'String');
        handles.user.parameters.search.targeted.manual.type = type{get(handles.popupmenu_type, 'Value')};
        guidata(hObject, handles);
    end

% --- Executes during object creation, after setting all properties.
function popupmenu_dbspecies_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_dbspecies (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_start.
function pushbutton_start_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    if ~isempty(handles.user.parameters.search.targeted.manual.mz)
        handles.user.ok = true;
        guidata(hObject, handles);
        uiresume(handles.figure_ChelomEx_search_manual);
    else
        errordlg('Please enter m/z value', 'Input error');
    end


% --- Executes on button press in pushbutton_cancel.
function pushbutton_cancel_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    uiresume(handles.figure_ChelomEx_search_manual);


% --- Executes on selection change in listbox_species.
function listbox_species_Callback(hObject, eventdata, handles)
% hObject    handle to listbox_species (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox_species contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox_species
    species_idx = get(hObject, 'Value');
    if isempty(species_idx)
        species_idx = 1;
        set(hObject, 'Value', species_idx);
    end
    handles.user.parameters.search.targeted.manual.species.id = handles.user.species.id(species_idx);
    handles.user.parameters.search.targeted.manual.species.dmz = handles.user.parameters.patternID.(handles.user.parameters.currentPattern).species.dmz(species_idx);
    guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function listbox_species_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox_species (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
