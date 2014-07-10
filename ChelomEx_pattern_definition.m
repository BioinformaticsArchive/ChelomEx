function varargout = ChelomEx_pattern_definition(varargin)
% CHELOMEX_PATTERN_DEFINITION MATLAB code for ChelomEx_pattern_definition.fig
%      CHELOMEX_PATTERN_DEFINITION, by itself, creates a new CHELOMEX_PATTERN_DEFINITION or raises the existing
%      singleton*.
%
%      H = CHELOMEX_PATTERN_DEFINITION returns the handle to a new CHELOMEX_PATTERN_DEFINITION or the handle to
%      the existing singleton*.
%
%      CHELOMEX_PATTERN_DEFINITION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CHELOMEX_PATTERN_DEFINITION.M with the given input arguments.
%
%      CHELOMEX_PATTERN_DEFINITION('Property','Value',...) creates a new CHELOMEX_PATTERN_DEFINITION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ChelomEx_pattern_definition_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ChelomEx_pattern_definition_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ChelomEx_pattern_definition

% Last Modified by GUIDE v2.5 24-Feb-2014 20:32:58

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ChelomEx_pattern_definition_OpeningFcn, ...
                   'gui_OutputFcn',  @ChelomEx_pattern_definition_OutputFcn, ...
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


% --- Executes just before ChelomEx_pattern_definition is made visible.
function ChelomEx_pattern_definition_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ChelomEx_pattern_definition (see VARARGIN)

% Choose default command line output for ChelomEx_pattern_definition
handles.output = hObject;

% initialize user variables
handles.user.ok = 0;

if length(varargin) == 2
    % read input parameters: handles.user from ChelomEx_Menu
    handles.user.errors = varargin{1};   % used for standard errors when defining new pattern
    handles.user.pattern = varargin{2};

elseif length(varargin) == 1   %no pattern is given: define new pattern structure
    handles.user.errors = varargin{1};
    handles.user.pattern.ID = [''];
    handles.user.pattern.pattern = struct('dmz', [1], 'dmzerr', [1 1 1], 'IRel', [1], 'IRelerr', [1 1], 'required', [11], 'minpknum', [1], 'ID', {['']}, 'groupID', '');
    handles.user.pattern.pattern(1) = [];
    handles.user.pattern.species = struct('dmz',[1],'id',{['']});
    handles.user.pattern.species.dmz = [];
    handles.user.pattern.species.id = [];
end

% populate uicontrols with data
update_GUI(handles);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ChelomEx_pattern_definition wait for user response (see UIRESUME)
uiwait(handles.figure_ChelomEx_pattern_definition);


% --- Outputs from this function are returned to the command line.
function varargout = ChelomEx_pattern_definition_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.user.pattern;
varargout{2} = handles.user.ok;

% Delete the figure
delete(handles.figure_ChelomEx_pattern_definition);



function text_patternID_Callback(hObject, eventdata, handles)
% hObject    handle to text_patternID (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of text_patternID as text
%        str2double(get(hObject,'String')) returns contents of text_patternID as a double
        handles.user.pattern.ID = get(hObject, 'String');
        update_GUI(handles);
        guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function text_patternID_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text_patternID (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_species_delete.
function pushbutton_species_delete_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_species_delete (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    slct = get(handles.listbox_species, 'Value');
    handles.user.pattern.species.id(slct) = [];
    handles.user.pattern.species.dmz(slct) = [];
    update_GUI(handles);
    
    guidata(hObject, handles);

% --- Executes on button press in pushbutton_species_edit.
function pushbutton_species_edit_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_species_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    %input dialog box to query name and delta m value
    slct = get(handles.listbox_species, 'Value');
    temp = inputdlg({'Related Adduct ID', 'delta m (amu)'}, ' ',1,...
                    {handles.user.pattern.species.id{slct}, sprintf('%9.5f',handles.user.pattern.species.dmz(slct))});
    if ~isempty(temp)
        if ~isempty(str2double(temp{2})) & ~isnan(str2double(temp{2}))
            handles.user.pattern.species.id{slct} = temp{1};
            handles.user.pattern.species.dmz(slct) = str2double(temp{2});
            update_GUI(handles);
            guidata(hObject, handles);
        else
            errordlg('Entry in ''delta m'' must be numeric.', 'Input error');
        end
    end
    
    
% --- Executes on button press in pushbutton_species_new.
function pushbutton_species_new_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_species_new (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    temp = inputdlg({'Related Adduct ID', 'delta m (amu)'}, ' ',1,...
                    {'Enter ID of related adduct', sprintf('%9.5f',NaN)});            
    if ~isempty(temp)
       num_species = length(handles.user.pattern.species.dmz); 
       handles.user.pattern.species.id{num_species+1} = temp{1};
       handles.user.pattern.species.dmz(num_species+1) = str2double(temp{2});
       update_GUI(handles);
    end
    
    guidata(hObject, handles);
    

% --- Executes on selection change in listbox_species.
function listbox_species_Callback(hObject, eventdata, handles)
% hObject    handle to listbox_species (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox_species contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox_species


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


% --- Executes on button press in pushbutton_isotopes_delete.
function pushbutton_isotopes_delete_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_isotopes_delete (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    slct = get(handles.listbox_isotopes, 'Value'); 
    handles.user.pattern.pattern(slct) = [];
    update_GUI(handles);
    
    guidata(hObject, handles);

% --- Executes on button press in pushbutton_isotopes_edit.
function pushbutton_isotopes_edit_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_isotopes_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    slct = get(handles.listbox_isotopes, 'Value'); 
    [pattern, ok] = ChelomEx_pattern_definition_isotopes(handles.user.pattern.pattern(slct));
    if ok == 1  % user closed dialog with ok
        handles.user.pattern.pattern(slct) = pattern;
        update_GUI(handles);
        guidata(hObject, handles);
    end
    
    

% --- Executes on button press in pushbutton_isotopes_new.
function pushbutton_isotopes_new_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_isotopes_new (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    inum = length(handles.user.pattern.pattern);
    % Create empty structure for new isotope and update listbox
    handles.user.pattern.pattern(inum+1).ID{1} = '';
    handles.user.pattern.pattern(inum+1).required = 11;
    handles.user.pattern.pattern(inum+1).dmz = NaN;
    handles.user.pattern.pattern(inum+1).dmzerr = [0 handles.user.errors.relerr handles.user.errors.minerr]';
    handles.user.pattern.pattern(inum+1).IRel = Inf;
    handles.user.pattern.pattern(inum+1).IRelerr = [0 Inf]';
    update_GUI(handles);
    % set selection to new isotope
    set(handles.listbox_isotopes, 'Value', inum+1);
    % Call Isotope Edit function
    pushbutton_isotopes_edit_Callback(handles.pushbutton_isotopes_edit, [], handles);
          


% --- Executes on selection change in listbox_isotopes.
function listbox_isotopes_Callback(hObject, eventdata, handles)
% hObject    handle to listbox_isotopes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox_isotopes contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox_isotopes


% --- Executes during object creation, after setting all properties.
function listbox_isotopes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox_isotopes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_OK.
function pushbutton_OK_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_OK (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
         handles.user.ok = 1;
         guidata(hObject, handles);
         uiresume(handles.figure_ChelomEx_pattern_definition);
         
% --- Executes on button press in pushbutton_save_new.
function pushbutton_save_new_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_save_new (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
         handles.user.ok = 2;
         guidata(hObject, handles);
         uiresume(handles.figure_ChelomEx_pattern_definition);

% --- Executes on button press in pushbutton_cancel.
function pushbutton_cancel_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
         handles.user.ok = 0;
         guidata(hObject, handles);
         uiresume(handles.figure_ChelomEx_pattern_definition);


% user function to refresh the textbox and tables
function update_GUI(handles)
    % textbox with pattern ID
    set(handles.text_patternID, 'String', handles.user.pattern.ID);
    
    % listbox with isotope IDs
    inum = length(handles.user.pattern.pattern);
    if inum == 0
       set(handles.listbox_isotopes,'String','');
       set(handles.pushbutton_isotopes_edit, 'Enable', 'off');
       set(handles.pushbutton_isotopes_delete, 'Enable', 'off');
    elseif inum > 0  
        plist = cell(inum,1);
        for i=1:length(plist)
            if isempty(handles.user.pattern.pattern(i).groupID)
                plist{i} = handles.user.pattern.pattern(i).ID{1};
            else
                plist{i} = handles.user.pattern.pattern(i).groupID;
            end
        end
        % if the last element in listbox gets removed, this sets value to a
        % valid entry
        set(handles.listbox_isotopes,'Value', 1);  
        set(handles.listbox_isotopes,'String',plist);
        set(handles.pushbutton_isotopes_edit, 'Enable', 'on');
        set(handles.pushbutton_isotopes_delete, 'Enable', 'on');
    end
    
    % listbox with species IDs
    % if the last element in listbox gets removed, this sets value to a
    % valid entry
    set(handles.listbox_species,'Value', 1);    
    set(handles.listbox_species,'String',handles.user.pattern.species.id);
    snum = length(handles.user.pattern.species.dmz);
    if snum == 0
        set(handles.pushbutton_species_edit, 'Enable', 'off');
        set(handles.pushbutton_species_delete, 'Enable', 'off');
    elseif snum > 0
        set(handles.pushbutton_species_edit, 'Enable', 'on');
        set(handles.pushbutton_species_delete, 'Enable', 'on');
    end
    
    
% --- Executes when user attempts to close figure_ChelomEx_pattern_definition.
function figure_ChelomEx_pattern_definition_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure_ChelomEx_pattern_definition (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
     if isequal(get(handles.figure_ChelomEx_pattern_definition, 'waitstatus'), 'waiting')
         handles.user.ok = 0;
         guidata(hObject, handles);
         uiresume(handles.figure_ChelomEx_pattern_definition);
     else
         delete(handles.figure_ChelomEx_pattern_definition);
     end


% --- Executes during object creation, after setting all properties.
function pushbutton_cancel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton_cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
