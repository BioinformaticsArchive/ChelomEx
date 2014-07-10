function varargout = ChelomEx_pattern_definition_isotopes(varargin)
% CHELOMEX_PATTERN_DEFINITION_ISOTOPES MATLAB code for ChelomEx_pattern_definition_isotopes.fig
%      CHELOMEX_PATTERN_DEFINITION_ISOTOPES, by itself, creates a new CHELOMEX_PATTERN_DEFINITION_ISOTOPES or raises the existing
%      singleton*.
%
%      H = CHELOMEX_PATTERN_DEFINITION_ISOTOPES returns the handle to a new CHELOMEX_PATTERN_DEFINITION_ISOTOPES or the handle to
%      the existing singleton*.
%
%      CHELOMEX_PATTERN_DEFINITION_ISOTOPES('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CHELOMEX_PATTERN_DEFINITION_ISOTOPES.M with the given input arguments.
%
%      CHELOMEX_PATTERN_DEFINITION_ISOTOPES('Property','Value',...) creates a new CHELOMEX_PATTERN_DEFINITION_ISOTOPES or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ChelomEx_pattern_definition_isotopes_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ChelomEx_pattern_definition_isotopes_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ChelomEx_pattern_definition_isotopes

% Last Modified by GUIDE v2.5 28-Jan-2014 11:34:58

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ChelomEx_pattern_definition_isotopes_OpeningFcn, ...
                   'gui_OutputFcn',  @ChelomEx_pattern_definition_isotopes_OutputFcn, ...
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


% --- Executes just before ChelomEx_pattern_definition_isotopes is made visible.
function ChelomEx_pattern_definition_isotopes_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ChelomEx_pattern_definition_isotopes (see VARARGIN)

% Choose default command line output for ChelomEx_pattern_definition_isotopes
handles.output = hObject;

% initialize uicontrols
set(handles.popupmenu_itype, 'String', {'Required (in Pattern Search and Peak Correlation)' 'Required (in Pattern Search only)' 'Optional' 'Exclude'});
set(handles.text_inum, 'BackgroundColor', [0.95 0.95 0.95]);

% initialize parameters
handles.user.icount = 1; % counts current isotope number in groups with several isotopes
handles.user.ok = 0;   %returns 0 to command line of cancel is pressed or figure is closed; 
                       %if ok is pressend, this is set to 1 to update the
                       %isotope pattern

% read isotope parameters if provided in input
if ~isempty(varargin)
    handles.user.isotope = varargin{1};
    update_GUI(handles);
end

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ChelomEx_pattern_definition_isotopes wait for user response (see UIRESUME)
uiwait(handles.figure_pattern_definition_isotopes);


% --- Outputs from this function are returned to the command line.
function varargout = ChelomEx_pattern_definition_isotopes_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.user.isotope;
varargout{2} = handles.user.ok;

% Delete the figure
delete(handles.figure_pattern_definition_isotopes);



% --- Executes on selection change in popupmenu_itype.
function popupmenu_itype_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_itype (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_itype contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_itype
    slct = get(hObject,'Value');
    switch slct 
        case 1
            handles.user.isotope.required(:) = 11;
        case 2
            handles.user.isotope.required(:) = 12;
        case 3
            handles.user.isotope.required(:) = 2;
        case 4
            handles.user.isotope.required(:) = 31;
    end
    update_GUI(handles);
    guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function popupmenu_itype_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_itype (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function text_isotopeID_Callback(hObject, eventdata, handles)
% hObject    handle to text_isotopeID (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of text_isotopeID as text
%        str2double(get(hObject,'String')) returns contents of text_isotopeID as a double
    handles.user.isotope.ID{handles.user.icount} = get(hObject,'String');
    update_GUI(handles);
    guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function text_isotopeID_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text_isotopeID (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function text_IRel_range_min_Callback(hObject, eventdata, handles)
% hObject    handle to text_IRel_range_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of text_IRel_range_min as text
%        str2double(get(hObject,'String')) returns contents of text_IRel_range_min as a double
    num = [str2double(get(handles.text_IRel_range_min,'String'))...
            str2double(get(handles.text_IRel_range_max,'String'))];
    if ~isnan(sum(num))
        handles.user.isotope.IRelerr(:,handles.user.icount) = num;
    else
        errordlg('Entry must be numeric.', 'Input error');
        set(handles.text_IRel_range_min,'String', num2str(handles.user.isotope.IRelerr(1,handles.user.icount)));
        set(handles.text_IRel_range_min,'String', num2str(handles.user.isotope.IRelerr(2,handles.user.icount)));      
    end
   
    update_GUI(handles);
    guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function text_IRel_range_min_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text_IRel_range_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function text_IRel_range_max_Callback(hObject, eventdata, handles)
% hObject    handle to text_IRel_range_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of text_IRel_range_max as text
%        str2double(get(hObject,'String')) returns contents of text_IRel_range_max as a double
    text_IRel_range_min_Callback(hObject, [], handles);


% --- Executes during object creation, after setting all properties.
function text_IRel_range_max_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text_IRel_range_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function text_IRel_Callback(hObject, eventdata, handles)
% hObject    handle to text_IRel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of text_IRel as text
%        str2double(get(hObject,'String')) returns contents of text_IRel as a double
    num = str2double(get(hObject,'String')); 
    if ~isnan(num)
        handles.user.isotope.IRel(handles.user.icount) = num;
    else
        errordlg('Entry must be numeric.', 'Input error');
        set(hObject, 'String', num2str(handles.user.isotope.IRel(handles.user.icount)));
    end
    
    update_GUI(handles);
    guidata(hObject,handles);
   

% --- Executes during object creation, after setting all properties.
function text_IRel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text_IRel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function text_dmerr_const_Callback(hObject, eventdata, handles)
% hObject    handle to text_dmerr_const (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of text_dmerr_const as text
%        str2double(get(hObject,'String')) returns contents of text_dmerr_const as a double
    num = [str2double(get(handles.text_dmerr_const,'String'))...
            str2double(get(handles.text_dmerr_rel,'String'))...
            str2double(get(handles.text_dmerr_min,'String'))];
    if ~isnan(sum(num))
        handles.user.isotope.dmzerr(:,handles.user.icount) = num;
    else
        errordlg('Entry must be numeric.', 'Input error');
        set(handles.text_dmerr_const,'String', num2str(handles.user.isotope.dmzerr(1,handles.user.icount)));
        set(handles.text_dmerr_rel,'String', num2str(handles.user.isotope.dmzerr(2,handles.user.icount)));
        set(handles.text_dmerr_min,'String', num2str(handles.user.isotope.dmzerr(3,handles.user.icount)));       
    end
    
    update_GUI(handles);
    guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function text_dmerr_const_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text_dmerr_const (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function text_dmerr_rel_Callback(hObject, eventdata, handles)
% hObject    handle to text_dmerr_rel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of text_dmerr_rel as text
%        str2double(get(hObject,'String')) returns contents of text_dmerr_rel as a double
     text_dmerr_const_Callback(hObject, [], handles);


% --- Executes during object creation, after setting all properties.
function text_dmerr_rel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text_dmerr_rel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function text_dmerr_min_Callback(hObject, eventdata, handles)
% hObject    handle to text_dmerr_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of text_dmerr_min as text
%        str2double(get(hObject,'String')) returns contents of text_dmerr_min as a double
     text_dmerr_const_Callback(hObject, eventdata, handles);


% --- Executes during object creation, after setting all properties.
function text_dmerr_min_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text_dmerr_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function text_dm_Callback(hObject, eventdata, handles)
% hObject    handle to text_dm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of text_dm as text
%        str2double(get(hObject,'String')) returns contents of text_dm as a double
    num = str2double(get(hObject,'String')); 
    if ~isnan(num)
        handles.user.isotope.dmz(handles.user.icount) = num;
    else
        errordlg('Entry must be numeric.', 'Input error');
        set(hObject, 'String', num2str(handles.user.isotope.dmz(handles.user.icount)));
    end
    update_GUI(handles);
    guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function text_dm_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text_dm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function text_groupID_Callback(hObject, eventdata, handles)
% hObject    handle to text_groupID (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of text_groupID as text
%        str2double(get(hObject,'String')) returns contents of text_groupID as a double
    handles.user.isotope.groupID = get(hObject,'String');
    update_GUI(handles);
    guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function text_groupID_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text_groupID (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function text_icount_Callback(hObject, eventdata, handles)
% hObject    handle to text_icount (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of text_icount as text
%        str2double(get(hObject,'String')) returns contents of text_icount as a double


% --- Executes during object creation, after setting all properties.
function text_icount_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text_icount (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function text_inum_Callback(hObject, eventdata, handles)
% hObject    handle to text_inum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of text_inum as text
%        str2double(get(hObject,'String')) returns contents of text_inum as a double


% --- Executes during object creation, after setting all properties.
function text_inum_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text_inum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_inew.
function pushbutton_inew_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_inew (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    % make new column in fields of handles.user.isotope and populate with
    % values of previous isotope (apart from delta m and isotope ID)
    inum = length(handles.user.isotope.dmz);
    handles.user.isotope.ID{inum+1} = 'Enter ID';
    handles.user.isotope.dmz(inum+1) = Inf;
    handles.user.isotope.dmzerr(:,inum+1) = handles.user.isotope.dmzerr(:,handles.user.icount);
    handles.user.isotope.IRel(inum+1) = Inf;
    handles.user.isotope.IRelerr(:,inum+1) = [0 Inf]';
    
    % set new isotope as current isotope diplayed 
    handles.user.icount = inum + 1;
    
    % update GUI
    update_GUI(handles);
    
    guidata(hObject, handles);
    


% --- Executes on button press in pushbutton_idelete.
function pushbutton_idelete_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_idelete (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    % delete columns in fields of handles.user.isotope that belong
    % to the current isotope 
    handles.user.isotope.ID(handles.user.icount) = [];
    handles.user.isotope.dmz(handles.user.icount) = [];
    handles.user.isotope.dmzerr(:,handles.user.icount) = [];
    handles.user.isotope.IRel(handles.user.icount) = [];
    handles.user.isotope.IRelerr(:,handles.user.icount) = [];
        
    % set new isotope as isotope number 1
    handles.user.icount = 1;
    
    % update GUI
    update_GUI(handles);
    
    guidata(hObject, handles);
    
% --- Executes on button press in pushbutton_inext.
function pushbutton_inext_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_inext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    % increment handles.user.icount to display next isotope in group
    handles.user.icount = handles.user.icount + 1;
    update_GUI(handles);
    guidata(hObject, handles);

% --- Executes on button press in pushbutton_iprevious.
function pushbutton_iprevious_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_iprevious (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    % negative increment to handles.user.icount to display previous isotope in group
    handles.user.icount = handles.user.icount - 1;
    update_GUI(handles);
    guidata(hObject, handles);


% --- Executes on button press in pushbutton_OK.
function pushbutton_OK_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_OK (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    % set minpknum to 1: this feature is
    % not used in this ChelomEx version
    for i = 1:length(handles.user.isotope)
        handles.user.isotope(i).minpknum = 1;
    end
    handles.user.ok = 1;
    guidata(hObject, handles);
    uiresume(handles.figure_pattern_definition_isotopes);


% --- Executes on button press in pushbutton_cancel.
function pushbutton_cancel_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% user funciton to populate and update all uicontrols after GUI is called
% and after any changes are made to the parameters
    handles.user.ok = 0;
    guidata(hObject, handles);
    uiresume(handles.figure_pattern_definition_isotopes);


% user function to update data display in GUI
function update_GUI(handles)
    % group ID and isotope num
    inum = length(handles.user.isotope.dmz);
    set(handles.text_icount, 'String', num2str(handles.user.icount));
    set(handles.text_inum, 'String', num2str(inum));
    set(handles.text_groupID, 'String', handles.user.isotope.groupID);
    if inum == 1
       set(handles.text_groupID, 'Enable', 'off');
       set(handles.pushbutton_idelete, 'Enable', 'off');
    else
       set(handles.text_groupID, 'Enable', 'on');
       set(handles.pushbutton_idelete, 'Enable', 'on');
    end
    if handles.user.icount > 1
       set(handles.pushbutton_iprevious, 'Enable', 'on')
    else 
       set(handles.pushbutton_iprevious, 'Enable', 'off') 
    end
    if handles.user.icount < inum
       set(handles.pushbutton_inext, 'Enable', 'on');
    else 
       set(handles.pushbutton_inext, 'Enable', 'off');
    end
          
    % isotope ID and type
    set(handles.text_isotopeID, 'String', handles.user.isotope.ID{handles.user.icount});
    switch handles.user.isotope.required(1)
        case 11
            set(handles.popupmenu_itype,'Value',1);
        case 12
            set(handles.popupmenu_itype,'Value',2);
        case 2
            set(handles.popupmenu_itype,'Value',3);
        case 31
            set(handles.popupmenu_itype,'Value',4);
    end
    
    % mass parameters
    set(handles.text_dm, 'String', sprintf('%9.5f', handles.user.isotope.dmz(handles.user.icount)));
    set(handles.text_dmerr_const, 'String', sprintf('%6.5f', handles.user.isotope.dmzerr(1,handles.user.icount)));
    set(handles.text_dmerr_rel, 'String', sprintf('%3.1f', handles.user.isotope.dmzerr(2,handles.user.icount)));
    set(handles.text_dmerr_min, 'String', sprintf('%6.5f', handles.user.isotope.dmzerr(3,handles.user.icount)));
    
    % instensity parameters
    set(handles.text_IRel, 'String', sprintf('%4.3f', handles.user.isotope.IRel(1,handles.user.icount)));
    set(handles.text_IRel_range_min, 'String', sprintf('%4.3f', handles.user.isotope.IRelerr(1,handles.user.icount)));
    set(handles.text_IRel_range_max, 'String', sprintf('%4.3f', handles.user.isotope.IRelerr(2,handles.user.icount)));
    
    
    


% --- Executes when user attempts to close figure_pattern_definition_isotopes.
function figure_pattern_definition_isotopes_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure_pattern_definition_isotopes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
    if isequal(get(handles.figure_pattern_definition_isotopes, 'waitstatus'), 'waiting')
        handles.user.ok = 0;
        guidata(hObject, handles);
        uiresume(handles.figure_pattern_definition_isotopes);
    else
        delete(handles.figure_pattern_definition_isotopes);
    end
