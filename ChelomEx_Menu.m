function varargout = ChelomEx_Menu(varargin)
% FIGURE_CHELOMEX_MENU MATLAB code for figure_ChelomEx_Menu.fig
%      FIGURE_CHELOMEX_MENU, by itself, creates a new FIGURE_CHELOMEX_MENU or raises the existing
%      singleton*.
%
%      H = FIGURE_CHELOMEX_MENU returns the handle to a new FIGURE_CHELOMEX_MENU or the handle to
%      the existing singleton*.
%
%      FIGURE_CHELOMEX_MENU('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FIGURE_CHELOMEX_MENU.M with the given input arguments.
%
%      FIGURE_CHELOMEX_MENU('Property','Value',...) creates a new
%      FIGURE_CHELOMEX_MENU or raises thef
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ChelomEx_Menu_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ChelomEx_Menu_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help figure_ChelomEx_Menu

% Last Modified by GUIDE v2.5 02-Jul-2014 10:41:15

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ChelomEx_Menu_OpeningFcn, ...
                   'gui_OutputFcn',  @ChelomEx_Menu_OutputFcn, ...
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


% --- Executes just before figure_ChelomEx_Menu is made visible.
function ChelomEx_Menu_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to figure_ChelomEx_Menu (see VARARGIN)

% Choose default command line output for figure_ChelomEx_Menu
handles.output = hObject;

% load default parameters from 'startup_parameters.mat' file
% handles.user contains three sub-fields: handles.user.temp (temporary
% needed variables); handles.user.parameters and handles.user.data
handles.user.parameters = load('startup_parameters.mat'); 
% order fields of pattern ID structure alphabetically
handles.user.parameters.patternID = orderfields(handles.user.parameters.patternID);

% - default current path for file open and save dialogs -
% if no default path is present then change to directory from which the program is run (current path)
if isequal(handles.user.parameters.currentpath, '') || ~exist(handles.user.parameters.currentpath,'dir')
      handles.user.parameters.currentpath = pwd;
end
handles.user.parameters.programpath = pwd;

% initialize uicontrols
handles.uitable_patterns = uitable(hObject, 'Units', 'pixels', 'Position', [20 9 560 320], 'RearrangeableColumns', 'on','Visible', 'off');
handles.uitable_peaks = uitable(hObject, 'Units', 'pixels', 'Position', [20 9 560 320], 'RearrangeableColumns', 'on', 'Visible', 'off');

% get initial figure size (required when resizing window)
handles.user_static.fposold = get(hObject, 'Position');

% set table property CellSelectionCallback to @(src,evnt) to read out selection
% indices
set(handles.uitable_patterns, 'CellSelectionCallback', @(src,evnt)set(src,'UserData',evnt.Indices));
set(handles.uitable_peaks, 'CellSelectionCallback', @(src,evnt)set(src,'UserData',evnt.Indices));

% update uicontrols
handles = update_GUI(handles);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes figure_ChelomEx_Menu wait for user response (see UIRESUME)
% uiwait(handles.figure_ChelomEx_Menu);


% --- Outputs from this function are returned to the command line.
function varargout = ChelomEx_Menu_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes when user attempts to close figure_ChelomEx_Menu.
function figure_ChelomEx_Menu_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure_ChelomEx_Menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure

% To do: delete other open windows

% save startup parameters
temp = handles.user.parameters;
save('startup_parameters.mat', '-struct', 'temp', 'currentpath', '-append');
delete(hObject);

% --- Executes when figure_ChelomEx_Menu is resized.
function figure_ChelomEx_Menu_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to figure_ChelomEx_Menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    if isfield(handles, 'user_static')          % do not this function when get(hObject, 'Position') is executed in OpeningFcn
        fposnew = get(hObject, 'Position');
        dypos = fposnew(4)-handles.user_static.fposold(4);

        % adjust table sizes
        set(handles.uitable_patterns, 'Position', [20 9 fposnew(3)-40 fposnew(4)-105]); 
        set(handles.uitable_peaks, 'Position', [20 9 fposnew(3)-40 fposnew(4)-105]); 

        % adjust positions of other uicontrols
        uicontrolist = {'pushbutton_figure' 'pushbutton_peak' 'pushbutton_pattern' 'pushbutton_database'...
                        'text_currentPattern' 'text_MS2filename' 'text_MS1filename'...
                        'static_patternID' 'static_MS2dataset' 'static_MS1dataset'...
                        'pushbutton_MS1file' 'pushbutton_MS2file' 'pushbutton_patternID'...
                        };

        for i = 1:length(uicontrolist)
            uipos = get(handles.(uicontrolist{i}), 'Position');
            uipos(2) = uipos(2) + dypos;
            set(handles.(uicontrolist{i}), 'Position', uipos);
        end      

        handles.user_static.fposold = fposnew;
    end
    guidata(hObject, handles);

    
% user variables:
% -------------------------------------------------
% handles.user.parameters.patternID
% handles.user.parameters.search
% handles.user.parameters.currentPattern
% handles.user.parameters.currentpath
% handles.user.parameters.programpath
% 
% handles.user.data.run(1).mzXML_Filename (1 or 2)
% handles.user.data.run(1).pks (1 or 2)
% handles.user.data.run(1).ts (1 or 2)
% 
% handles.user.data.results.pattern.
% handles.user.data.results.peaks.

% handles.user.temp


% open and save or start a new ChelomEx session
% -------------------------------
function menu_file_open_session_Callback(hObject, eventdata, handles)
% hObject    handle to menu_file_open_session (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    % loads a saved data from a .mat file to handles.user.data
    choice = ChelomEx_qdlg('title','Load ChelomEx session', 'string', 'Load a stored ChelomEx session? This will end the current session.');
    switch choice
        case 'Yes'
            [filename, pathname] = uigetfile([handles.user.parameters.currentpath '\*.chd'], 'Load ChelomEx session');
            
            if filename ~= 0  % filename is 0 if user selects cancel  
                % load data 
                load([pathname filename], '-mat', 'saved');
                handles.user = saved;
                clear saved;       
                % set program path to current directory 
                handles.user.parameters.programpath = pwd; 
                % update currentpath
                handles.user.parameters.currentpath = pathname;

                % update uicontrols
                handles = update_GUI(handles);
            end
        case 'No'
    end
    
    guidata(hObject, handles);

function menu_file_save_session_Callback(hObject, eventdata, handles)
% hObject    handle to menu_file_save_session (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    % saves handles.user to a .mat file
    [filename, pathname] = uiputfile([handles.user.parameters.currentpath '\*.chd'], 'Save ChelomEx session');
    if filename ~= 0  % filename is 0 if user selects cancel
        saved = handles.user;
        save([pathname filename], 'saved');
        % update currentpath
        handles.user.parameters.currentpath = pathname;
    end
    guidata(hObject, handles);

function menu_file_new_Callback(hObject, eventdata, handles)
% hObject    handle to menu_file_new (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    %starts a new session, therefore delete handles.user.data and update
    %uicontrols but leave handles.user.parameters unchanged
    choice = ChelomEx_qdlg('title','Start ChelomEx session', 'string', ['Start a new ChelomEx session?' char(012) 'This will end the current session.']);
    switch choice
        case 'Yes'
            handles.user = rmfield(handles.user, 'data');
            % update uicontrols
            handles = update_GUI(handles);
        case 'No'
    end
    
    guidata(hObject, handles);

function menu_file_open_Callback(hObject, eventdata, handles)
% hObject    handle to menu_file_open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function menu_file_save_Callback(hObject, eventdata, handles)
% hObject    handle to menu_file_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function menu_file_Callback(hObject, eventdata, handles)
% hObject    handle to menu_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% open a mzxml file
% --------------------------------------------------------------------
function menu_file_open_run_Callback(hObject, eventdata, handles)
% hObject    handle to menu_file_open_run (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    [handles.user.data.run(1).mzXML_Filename, import] = ChelomEx_open_run_menu({handles.user.parameters.currentpath});
    if import == 1
        handles.msgbox_import = msgbox('Importing LC-MS run... please wait...');
        [handles.user.data.run(1).pks(1), handles.user.data.run(1).ts(1)] = mzxmlimport(handles.user.data.run(1).mzXML_Filename(1),1);
        delete(handles.msgbox_import);
        if ~isequal(handles.user.data.run(1).mzXML_Filename{2},'')
            handles.msgbox_import = msgbox('Importing MSMS precursor list... please wait...');
            [handles.user.data.run(1).pks(2), handles.user.data.run(1).ts(2)] = mzxmlimport(handles.user.data.run(1).mzXML_Filename(2),2);
            delete(handles.msgbox_import);
        end
        msgbox('File import complete');
        
        % update current path
        handles.user.parameters.currentpath = fileparts(handles.user.data.run(1).mzXML_Filename{1});
            
        % update uicontrols
        handles = update_GUI(handles);
    end
     
    guidata(hObject, handles);

    
    % --- Executes on button press in pushbutton_MS1file.
function pushbutton_MS1file_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_MS1file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    % open uigetfile dialog GUI
    [filename, pathname] = uigetfile([handles.user.parameters.currentpath '\*.mzxml'], 'Open LCMS run (mzxml file)');
    if filename ~= 0  % filename is 0 if user selects cancel
        % import file
        handles.user.data.run(1).mzXML_Filename(1) = {[pathname filename]};
        handles.msgbox_import = msgbox('Importing LC-MS run... please wait...');
        [handles.user.data.run(1).pks(1), handles.user.data.run(1).ts(1)] = mzxmlimport(handles.user.data.run(1).mzXML_Filename(1),1);
        delete(handles.msgbox_import);
        % create empty field for mzXML_Filename{2}
        if length(handles.user.data.run(1).mzXML_Filename) == 1
            handles.user.data.run(1).mzXML_Filename(2) = {[]};
        end
        % update current path
        handles.user.parameters.currentpath = fileparts(handles.user.data.run(1).mzXML_Filename{1});
        % update uicontrols
        handles = update_GUI(handles);
    end
    
    guidata(hObject, handles);

% --- Executes on button press in pushbutton_MS2file.
function pushbutton_MS2file_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_MS2file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    % open uigetfile dialog GUI
    [filename, pathname] = uigetfile([handles.user.parameters.currentpath '\*.mzxml'], 'Open MSMS precursor list (mzxml file)');
    if filename ~= 0  % filename is 0 if user selects cancel
       % import file
        handles.user.data.run(1).mzXML_Filename(2) = {[pathname filename]};
        handles.msgbox_import = msgbox('Importing MSMS precursor list... please wait...');
        [handles.user.data.run(1).pks(2), handles.user.data.run(1).ts(2)] = mzxmlimport(handles.user.data.run(1).mzXML_Filename(2),2);
        delete(handles.msgbox_import);
       
        % update current path
        handles.user.parameters.currentpath = fileparts(handles.user.data.run(1).mzXML_Filename{2});
            
        % update uicontrols
        handles = update_GUI(handles);
    end   
    
    guidata(hObject, handles);

    
% define a pattern
% --------------------------------------------------------------------
function menu_pattern_select_Callback(hObject, eventdata, handles)
% hObject    handle to menu_pattern_select (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    % Open list-selection dialog box. The listnames correspond to field name
    % IDs in the fields of handles.user.parameters.patternID  
    
    pfields = fieldnames(handles.user.parameters.patternID);    
    plist = cell(length(pfields),1);
    for i=1:length(pfields)
       plist{i} = handles.user.parameters.patternID.(pfields{i}).ID;
    end
    pnum = listdlg('PromptString',...
                   'Select saved pattern','SelectionMode','single',...
                   'Name','Load Pattern',...
                   'ListString', plist);
    % if a selection was made in the list dialog then get the set of parameters
    if ~isempty(pnum)
        if isfield(handles.user, 'data') & isfield(handles.user.data, 'results')  % analysis results exist - if other metal is selected delete these results
            choice = ChelomEx_qdlg('title','Select new isotope pattern', 'string', sprintf('%0s\n %0s\n %0s', 'Existing analysis results', 'will be deleted.', 'Continue?'));
                switch choice
                    case 'Yes'
                        handles.user.data = rmfield(handles.user.data, 'results');
                        handles = update_GUI(handles); 
                        handles.user.parameters.currentPattern = pfields{pnum};
                        % update text box with current parameter info
                        set(handles.text_currentPattern, 'String', handles.user.parameters.patternID.(handles.user.parameters.currentPattern).ID);
                    case 'No'
                end
        else 
            handles.user.parameters.currentPattern = pfields{pnum};
            % update text box with current parameter info
            set(handles.text_currentPattern, 'String', handles.user.parameters.patternID.(handles.user.parameters.currentPattern).ID);
        end
    end
    
    guidata(hObject, handles);
    
% --- Executes on button press in pushbutton_patternID.
function pushbutton_patternID_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_patternID (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA) 
        menu_pattern_select_Callback(handles.menu_pattern_select, [], handles); 
    
    
function menu_pattern_new_Callback(hObject, eventdata, handles)
% hObject    handle to menu_pattern_new (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    [pattern, ok] = ChelomEx_pattern_definition(handles.user.parameters.search);
    if ok == 1
        if isfield(handles.user, 'data') & isfield(handles.user.data, 'results')  % analysis results exist - if changes are made delete results
            choice = ChelomEx_qdlg('title','New isotope pattern', 'string', sprintf('%0s\n %0s\n %0s', 'Existing analysis results', 'will be deleted.', 'Continue?'));
                switch choice
                    case 'Yes'
                        handles.user.data = rmfield(handles.user.data, 'results');
                        handles = update_GUI(handles); 
                    case 'No'
                        ok = 0;
                end
        end
    end
    if ok == 1
        % to save in new field to patternID: use first five letters from pattern.ID 
        % + number to make letter unique
        pnames = fieldnames(handles.user.parameters.patternID);
        % use only letters from pattern.ID to assign to fieldname
        str = pattern.ID(isletter(pattern.ID));
        if isempty(str)
            str = 'ID';
        end
        if length(str) >= 5
            f_letters = str(1:5);
        else 
            f_letters = str;
        end 
        i = 1;
        while ismember([f_letters num2str(i)],pnames)
            i=i+1;
        end
        f_name = [f_letters num2str(i)];
        handles.user.parameters.patternID.(f_name) = pattern;
        % order fields of pattern ID structure alphabetically
        handles.user.parameters.patternID = orderfields(handles.user.parameters.patternID);
        handles = update_GUI(handles);
    end
    
    guidata(hObject, handles);

function menu_pattern_edit_Callback(hObject, eventdata, handles)
% hObject    handle to menu_pattern_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    [pattern, ok] = ChelomEx_pattern_definition(handles.user.parameters.search, handles.user.parameters.patternID.(handles.user.parameters.currentPattern));
    % ok = 1 if user select ok; ok = 2, if user selects save as new
    if ok ~= 0
        if isfield(handles.user, 'data') & isfield(handles.user.data, 'results')  % analysis results exist 
            choice = ChelomEx_qdlg('title','Edit isotope pattern', 'string', sprintf('%0s\n %0s\n %0s', 'Existing analysis results', 'will be deleted.', 'Continue?'));
                switch choice
                    case 'Yes'
                        handles.user.data = rmfield(handles.user.data, 'results');
                        handles = update_GUI(handles); 
                    case 'No'
                        ok = 0;
                end
        end
    end
    if ok == 1
            % remove field from structure and create new, in case ID has changed
            handles.user.parameters.patternID = rmfield(handles.user.parameters.patternID, handles.user.parameters.currentPattern);
    end
    if ok == 1 | ok == 2  
        % to save in new field to patternID: use first five letters from pattern.ID 
        % + number to make letter unique
        pnames = fieldnames(handles.user.parameters.patternID);
        % use only letters from pattern.ID to assign to fieldname
        str = pattern.ID(isletter(pattern.ID));
        if isempty(str)
            str = 'ID';
        end
        if length(str) >= 5
            f_letters = str(1:5);
        else 
            f_letters = str;
        end 
        i = 1;
        while ismember([f_letters num2str(i)],pnames)
            i=i+1;
        end
        f_name = [f_letters num2str(i)];
        handles.user.parameters.currentPattern = f_name;
        handles.user.parameters.patternID.(f_name) = pattern;
        % order fields of pattern ID structure alphabetically
        handles.user.parameters.patternID = orderfields(handles.user.parameters.patternID);
        handles = update_GUI(handles);
    end
    
    guidata(hObject, handles);
    

function menu_pattern_delete_Callback(hObject, eventdata, handles)
% hObject    handle to menu_pattern_delete (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    pfields = fieldnames(handles.user.parameters.patternID);    
    plist = cell(length(pfields),1);
    for i=1:length(pfields)
       plist{i} = handles.user.parameters.patternID.(pfields{i}).ID;
    end
    pnum = listdlg('PromptString',...
                   'Delete a pattern','SelectionMode','single',...
                   'Name','Delete Pattern',...
                   'ListString', plist);
    % if a selection was made in the list dialog then get the set of parameters
    if ~isempty(pnum)
        % only delete a pattern if at least 1 pattern remains
        if length(pfields) > 1   
            if isfield(handles.user, 'data') & isfield(handles.user.data, 'results')  % analysis results exist - if other metal is selected delete these results
                choice = ChelomEx_qdlg('title','Delete isotope pattern', 'string', sprintf('%0s\n %0s\n %0s', 'Existing analysis results', 'will be deleted.', 'Continue?'));
                    switch choice
                        case 'Yes'
                            handles.user.data = rmfield(handles.user.data, 'results');    
                            handles.user.parameters.patternID = rmfield(handles.user.parameters.patternID, pfields{pnum}); 
                            % if currentPattern was deleted, use first in patternID list as
                            % currentPattern
                            if isequal(handles.user.parameters.currentPattern, pfields{pnum})
                                pnames = fieldnames(handles.user.parameters.patternID);
                                handles.user.parameters.patternID.currentPattern = pnames{1};
                            end
                            handles = update_GUI(handles);
                        case 'No'
                    end
            else
                handles.user.parameters.patternID = rmfield(handles.user.parameters.patternID, pfields{pnum}); 
                % if currentPattern was deleted, use first in patternID list as
                % currentPattern
                if isequal(handles.user.parameters.currentPattern, pfields{pnum})
                    pnames = fieldnames(handles.user.parameters.patternID);
                    handles.user.parameters.patternID.currentPattern = pnames{1};
                end
                handles = update_GUI(handles);
            end

        elseif length(pfields) == 1
            errordlg('At least one isotope pattern must remain', 'Delete isotope pattern error');
        end        
    end
    
    guidata(hObject, handles);
        
 
function menu_pattern_database_load_Callback(hObject, eventdata, handles)
% hObject    handle to menu_pattern_database_load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    [filename, pathname] = uigetfile([handles.user.parameters.currentpath '\*.chp'], 'Load Isotope Pattern Database File');
    if filename ~= 0  % filename is 0 if user selects cancel
        ok = true;
        if isfield(handles.user, 'data') & isfield(handles.user.data, 'results')  % analysis results exist - if other metal is selected delete these results
            choice = ChelomEx_qdlg('title','Delete isotope pattern', 'string', sprintf('%0s\n %0s\n %0s', 'Existing analysis results', 'will be deleted.', 'Continue?'));
                switch choice
                    case 'Yes'
                        handles.user.data = rmfield(handles.user.data, 'results');
                    case 'No'
                        ok = false;
                end
        end
        if ok
            temp = load([pathname filename], '-mat', 'pattern');
            handles.user.parameters.patternID = temp.pattern;
            % order fields of pattern ID structure alphabetically
            handles.user.parameters.patternID = orderfields(handles.user.parameters.patternID);
            pnames = fieldnames(handles.user.parameters.patternID);
            handles.user.parameters.currentPattern = pnames{1};
            % update current path
            handles.user.parameters.currentpath = pathname;
            % update uicontrols
            handles = update_GUI(handles);
        end
    end
        
    guidata(hObject, handles);


function menu_pattern_database_save_Callback(hObject, eventdata, handles)
% hObject    handle to menu_pattern_database_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    [filename, pathname] = uiputfile([handles.user.parameters.currentpath '\*.chp'], 'Save Isotope Pattern Database');
    if filename ~= 0  % filename is 0 if user selects cancel
        pattern = handles.user.parameters.patternID;
        save([pathname filename], 'pattern');   
        % update current path
        handles.user.parameters.currentpath = pathname;
    end
    
    guidata(hObject, handles);


function menu_pattern_database_Callback(hObject, eventdata, handles)
% hObject    handle to menu_pattern_database (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
      

function menu_pattern_Callback(hObject, eventdata, handles)
% hObject    handle to menu_pattern (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
   

% Targeted search for patterns and peaks using database or manually entered
% m/z
% --------------------------------------------------------------------
% --------------------------------------------------------------------
function menu_search_targeted_database_Callback(hObject, eventdata, handles)
% hObject    handle to menu_search_targeted_database (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    complex_id = handles.user.parameters.patternID.(handles.user.parameters.currentPattern).species.id;
    % continue only if complex species are defined in pattern
    if ~isempty(complex_id)
        % change IDs from -Fe +3H to +Fe -3H etc.
        for j = 1:size(complex_id,1)
             idstring = complex_id{j};
             for k = 1:length(idstring)
                if isequal(idstring(k),'+')
                    idstring(k) = '-';
                elseif isequal(idstring(k),'-')
                    idstring(k) = '+';
                end
             end
             complex_id{j} = idstring;
        end
        dbtarget.species.id = complex_id;
        dbtarget.species.dmz = handles.user.parameters.patternID.(handles.user.parameters.currentPattern).species.dmz;
        [species_idx,ok] = listdlg('Name', 'Start Targeted Search', 'PromptString', 'Select Complex Species', ...
                                   'ListString',dbtarget.species.id,...
                                   'InitialValue', 1:length(dbtarget.species.id));

        if ok & ~isempty(species_idx) % selected ok and not cancel in input dialog
            if isfield(handles.user, 'data') & isfield(handles.user.data, 'results')  % analysis results exist 
                choice = ChelomEx_qdlg('title','Start targeted search', 'string', sprintf('%0s\n %0s\n %0s', 'Existing analysis results', 'will be deleted.', 'Continue?'));
                    switch choice
                        case 'Yes'
                            handles.user.data = rmfield(handles.user.data, 'results');
                            handles = update_GUI(handles); 
                        case 'No'
                            ok = false;
                    end
            end
        end
        if ok   
            dbtarget.species.id = dbtarget.species.id(species_idx);
            dbtarget.species.dmz = dbtarget.species.dmz(species_idx);

            % load database entries
            load('database.mat', 'database');
            dbtarget.db = database;

            % get ion polarity mode from parameters
            if strcmp(handles.user.parameters.search.polarity, 'Positive')
                dbtarget.polarity = 1.00728;
            elseif strcmp(handles.user.parameters.search.polarity, 'Negative')
                dbtarget.polarity = -1.00728;
            end
            
            % calculate possible complex species;
            dbtarget.mzs = []; Lnum = {'Mono Complex '; 'Bis Complex '; 'Tris Complex '};
            dbtarget.ids = cell(0);  
            for k = 1:size(dbtarget.db.data,1)  % for all database entries
                dbtarget.id = dbtarget.db.ID{k};
                dbtarget.mz = dbtarget.db.data(k,1) + dbtarget.polarity;
                for i = 1:3                     % mono, bis and tris complexes 
                    dbtarget.mzs = [dbtarget.mzs; (dbtarget.mz-dbtarget.polarity).*i + dbtarget.polarity - dbtarget.species.dmz];
                    for j = 1:size(dbtarget.species.id,1)
                         idstring = [Lnum{i} dbtarget.species.id{j}];
                         dbtarget.ids(size(dbtarget.ids,1)+1,:) = {dbtarget.id idstring};
                    end
                end
            end
            % column numbers in results.peak.data
            mzcol = 2; zcol = 3;

            % search patterns for each m/z mass 
            handles.user.data.results.pattern = search_Pattern(handles.user.parameters.patternID.(handles.user.parameters.currentPattern).pattern,...
                                                                     handles.user.parameters.search.zs,...
                                                                     handles.user.parameters.search.noise,...
                                                                     handles.user.parameters.search.noise,...
                                                                     handles.user.parameters.search.minerr,...,...
                                                                     handles.user.parameters.search.relerr,...
                                                                     handles.user.data.run(1).pks{1}, handles.user.data.run(1).ts{1},...
                                                                     dbtarget.mzs, handles.user.parameters.search.polarity, handles.user.parameters.search.offerr);
            if ~isempty(handles.user.data.results.pattern.pks)                                                     
                handles.user.data.results(1).pattern = sort_results_pks(handles.user.data.results(1).pattern, -4);

                % search peaks 
                if ~isequal(handles.user.data.run(1).mzXML_Filename{2},'')
                        handles.user.data.results.peak = ptrn2pk_species(handles.user.parameters.patternID.(handles.user.parameters.currentPattern),...
                                                                             handles.user.data.results(1).pattern,...
                                                                             handles.user.parameters.search,...
                                                                             handles.user.data.run(1).pks{1}, handles.user.data.run(1).ts{1},...
                                                                             handles.user.data.run(1).pks{2}, handles.user.data.run(1).ts{2},...
                                                                             handles.user.parameters.search.MS2err, handles.user.parameters.search.MS2noise);
                else 
                        handles.user.data.results.peak = ptrn2pk_species(handles.user.parameters.patternID.(handles.user.parameters.currentPattern),...
                                                                         handles.user.data.results(1).pattern,...
                                                                         handles.user.parameters.search,...
                                                                         handles.user.data.run(1).pks{1}, handles.user.data.run(1).ts{1});
                end

                % prepare presentation in uitable
                % replace NaNs with ''
                PeakData = num2cell(handles.user.data.results(1).peak.data);
                PeakData(isnan(handles.user.data.results(1).peak.data)) = {''};
                % fill in checkbox for user, flag desciriptions and results of database search
                for i = size(handles.user.data.results(1).peak.data,1):-1:1
                     flags{i,1} = handles.user.data.results(1).peak.flagID{cell2mat(handles.user.data.results(1).peak.flagID(:,1))==handles.user.data.results(1).peak.data(i,1),2};
                end  
                % get ID of complexes 
                % compare found m/z values of complexes with dbtarget.species.mzs and get id from dbtarget.species.ids
                PeakID = cell(size(handles.user.data.results.peak.data,1),2);
                for i = 1:size(handles.user.data.results.peak.data,1)
                    % singly charged m/z
                    mzs = (dbtarget.mzs + dbtarget.polarity*(handles.user.data.results.peak.data(i,zcol)-1))./ handles.user.data.results.peak.data(i,zcol);
                    err = handles.user.parameters.search.offerr + max(handles.user.parameters.search.minerr, handles.user.parameters.search.relerr*10^-6*handles.user.data.results.peak.data(i,mzcol)); 
                    foundid_rows = find(mzs >= (handles.user.data.results.peak.data(i,mzcol)-err) & mzs <= (handles.user.data.results.peak.data(i,mzcol)+err));
                    if isempty(foundid_rows)
                        foundid_rows = find(abs(mzs-handles.user.data.results.peak.data(i,mzcol)) == min(abs(mzs-handles.user.data.results.peak.data(i,mzcol))));
                    end
                    if length(foundid_rows) == 1
                        PeakID(i,1) = {[PeakID{i,1} dbtarget.ids{foundid_rows(1),1}]}; 
                        PeakID(i,2) = {[PeakID{i,2} dbtarget.ids{foundid_rows(1),2}]};
                    elseif length(foundid_rows) > 1
                        for j = 1:length(foundid_rows)
                            PeakID(i,1) = {[PeakID{i,1} dbtarget.ids{foundid_rows(j),1} ' |']};
                            PeakID(i,2) = {[PeakID{i,2} dbtarget.ids{foundid_rows(j),2} ' |']};
                        end
                    end
                end

                % compile table data
                handles.user.data.results(1).peak.table.data =...
                           [repmat({'---'},size(handles.user.data.results(1).peak.data,1),1)...
                            PeakID(:,1) PeakID(:,2)...
                            flags... 
                            PeakData(:,2:3)... 
                            PeakData(:,4)...
                            handles.user.data.results.peak.apos.speciesID(:)...
                            PeakData(:,5:size(PeakData,2)-2)...
                            PeakData(:,1)]; %last column is numeric flag data for sorting, not to be shown in uitable
                PeakColumnFormat{1} = {'---' 'OK' 'FAIL' 'AMBIGUOUS'}; 
                PeakColumnFormat([2:4,8]) = {'char'}; 
                PeakColumnFormat([5:7,9:size(handles.user.data.results(1).peak.data,2)+3])= {'numeric'}; 
                handles.user.data.results(1).peak.table.format = PeakColumnFormat;
                handles.user.data.results(1).peak.table.header = [{'Manual|Check' 'Species|ID' 'Isotope Pattern|ID'} handles.user.data.results(1).peak.header(1:4) {'Species|ID'} handles.user.data.results(1).peak.header(5:length(handles.user.data.results(1).peak.header)-2)];
                handles.user.data.results(1).peak.table.edit = [true false(1,length(handles.user.data.results(1).peak.table.header)-1)];  
    %            ChelomEx_peak_figure(handles.user, 1:size(handles.user.data.results.peak.table.data,1), 'Database');

                handles.user.parameters.search.targeted.database = database;
                handles.user.parameters.search.type = 'Database';

                % update uicontrols
                handles = update_GUI(handles);
                guidata(hObject, handles);
            else
                msgbox('No database isotope patterns found', 'Targeted Search');
            end        
        end
    else
        errordlg('No species defined in isotope pattern. To continue, define at least one species (Isotope Pattern -> Edit).', 'Database search error');
    end


function menu_search_targeted_manual_Callback(hObject, eventdata, handles)
% hObject    handle to menu_search_targeted_manual (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA) 
    % get mz of complex, charge states and max error offset
    [ok,manual] = ChelomEx_search_manual(handles.user.parameters);
    
    if ok  % selected ok and not cancel in input dialog
        % if speciestype=apo calculate possible complex species;
        if isequal(manual.type, 'Ligand')
            manual.mzs = []; Lnum = {'Mono Complex '; 'Bis Complex '; 'Tris Complex '};
            manual.ids = cell(0);
            for i = 1:3  % mono, bis and tris complexes 
                manual.mzs = [manual.mzs; (manual.mz-manual.polarity).*i + manual.polarity - manual.species.dmz];
                for j = 1:size(manual.species.id,1)
                     idstring = [Lnum{i} manual.species.id{j}];
                     manual.ids(size(manual.ids,1)+1,:) = {manual.id idstring};
                end
            end
        elseif isequal(manual.type, 'Complex')
            manual.mzs = manual.mz;
            manual.ids = {manual.id 'Complex'};
        end
        
        % in the following overwrite data in handles.user only temporarily with results from
        % manual search by not using guidata to update handles structure
        % allows for easy use of ChelomEx_peak_figure function           
        handles.user.parameters.search.zs = manual.zs;
        handles.user.parameters.search.offerr = manual.offerr;
        
        % column numbers in results.peak.data
        mzcol = 2; zcol = 3;
        
        % search patterns for each m/z mass 
        handles.user.data.results.pattern = search_Pattern(handles.user.parameters.patternID.(handles.user.parameters.currentPattern).pattern,...
                                                                 handles.user.parameters.search.zs,...
                                                                 handles.user.parameters.search.noise,...
                                                                 handles.user.parameters.search.noise,...
                                                                 handles.user.parameters.search.minerr,...
                                                                 handles.user.parameters.search.relerr,...
                                                                 handles.user.data.run(1).pks{1}, handles.user.data.run(1).ts{1},...
                                                                 manual.mzs, handles.user.parameters.search.polarity, handles.user.parameters.search.offerr);
        if ~isempty(handles.user.data.results.pattern.pks)                                                     
            handles.user.data.results(1).pattern = sort_results_pks(handles.user.data.results(1).pattern, -4);

            % search peaks 
            if ~isequal(handles.user.data.run(1).mzXML_Filename{2},'')
                    handles.user.data.results.peak = ptrn2pk_species(handles.user.parameters.patternID.(handles.user.parameters.currentPattern),...
                                                                         handles.user.data.results(1).pattern,...
                                                                         handles.user.parameters.search,...
                                                                         handles.user.data.run(1).pks{1}, handles.user.data.run(1).ts{1},...
                                                                         handles.user.data.run(1).pks{2}, handles.user.data.run(1).ts{2},...
                                                                         handles.user.parameters.search.MS2err, handles.user.parameters.search.MS2noise);
            else 
                    handles.user.data.results.peak = ptrn2pk_species(handles.user.parameters.patternID.(handles.user.parameters.currentPattern),...
                                                                     handles.user.data.results(1).pattern,...
                                                                     handles.user.parameters.search,...
                                                                     handles.user.data.run(1).pks{1}, handles.user.data.run(1).ts{1});
            end

            % prepare presentation in uitable
            % replace NaNs with ''
            PeakData = num2cell(handles.user.data.results(1).peak.data);
            PeakData(isnan(handles.user.data.results(1).peak.data)) = {''};
            % fill in checkbox for user, flag desciriptions and results of database search
            for i = size(handles.user.data.results(1).peak.data,1):-1:1
                 flags{i,1} = handles.user.data.results(1).peak.flagID{cell2mat(handles.user.data.results(1).peak.flagID(:,1))==handles.user.data.results(1).peak.data(i,1),2};
            end  
            % get ID of complexes in case of manual search with given ligand m/z
            % therefore compare found m/z values of complexes with
            % manual.mzs and get id from manual.ids
            
            PeakID = cell(size(handles.user.data.results.peak.data,1),2);
            if isequal(manual.type, 'Ligand')
                for i = 1:size(handles.user.data.results.peak.data,1)
                    % singly charged m/z
                    mzs = (manual.mzs + manual.polarity*(handles.user.data.results.peak.data(i,zcol)-1))./ handles.user.data.results.peak.data(i,zcol);
                    err = handles.user.parameters.search.offerr + max(handles.user.parameters.search.minerr, handles.user.parameters.search.relerr*10^-6*handles.user.data.results.peak.data(i,mzcol)); 
                    foundid_rows = find(mzs >= (handles.user.data.results.peak.data(i,mzcol)-err) & mzs <= (handles.user.data.results.peak.data(i,mzcol)+err));
                    if isempty(foundid_rows)
                        foundid_rows = find(abs(mzs-handles.user.data.results.peak.data(i,mzcol)) == min(abs(mzs-handles.user.data.results.peak.data(i,mzcol))));
                    end
                    if length(foundid_rows) == 1
                        PeakID(i,1) = {[PeakID{i,1} manual.ids{foundid_rows(1),1}]}; 
                        PeakID(i,2) = {[PeakID{i,2} manual.ids{foundid_rows(1),2}]};
                    elseif length(foundid_rows) > 1
                        for j = 1:length(foundid_rows)
                            PeakID(i,1) = {[PeakID{i,1} manual.ids{foundid_rows(j),1} ' |']};
                            PeakID(i,2) = {[PeakID{i,2} manual.ids{foundid_rows(j),2} ' |']};
                        end
                    end
                end
                
            elseif isequal(manual.type, 'Complex')
                for i = 1:size(handles.user.data.results.peak.data,1)
                    PeakID(i,:) = manual.ids;
                end
            end
            
            % compile table data
            handles.user.data.results(1).peak.table.data =...
                       [PeakID(:,1) PeakID(:,2)...
                        flags... 
                        PeakData(:,2:3)... 
                        PeakData(:,4)...
                        handles.user.data.results.peak.apos.speciesID(:)...
                        PeakData(:,5:size(PeakData,2)-2)...
                        PeakData(:,1)]; %last column is numeric flag data for sorting, not to be shown in uitable
            %PeakColumnFormat{1} = {'---' 'OK' 'FAIL' 'AMBIGUOUS'}; 
            PeakColumnFormat([1:3,7]) = {'char'}; 
            PeakColumnFormat([4:6,8:size(handles.user.data.results(1).peak.data,2)+2])= {'numeric'}; 
            handles.user.data.results(1).peak.table.format = PeakColumnFormat;
            handles.user.data.results(1).peak.table.header = [{'Species|ID' 'Isotope Pattern|ID'} handles.user.data.results(1).peak.header(1:4) {'Species|ID'} handles.user.data.results(1).peak.header(5:length(handles.user.data.results(1).peak.header)-2)];
            handles.user.data.results(1).peak.table.edit = false(1,length(handles.user.data.results(1).peak.table.header));  
            ChelomEx_peak_figure(handles.user, 1:size(handles.user.data.results.peak.table.data,1), 'Manual');
        else
            msgbox('No isotope patterns found', 'Manual search');
        end        
    end

function menu_search_targeted_Callback(hObject, eventdata, handles)
% hObject    handle to menu_search_targeted (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% Untargeted search for patterns and define parameters for pattern search
% --------------------------------------------------------------------
   
function menu_search_untargeted_pattern_Callback(hObject, eventdata, handles)
% hObject    handle to menu_search_pattern_start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    choice = ChelomEx_qdlg('title','Start Pattern Search', 'string', 'Start Pattern Search now?');
    switch choice
        case 'Yes'
            if isfield(handles.user, 'data') & isfield(handles.user.data, 'results')
                handles.user.data = rmfield(handles.user.data, 'results');
            end
            handles.user.data.results(1).pattern = search_Pattern(handles.user.parameters.patternID.(handles.user.parameters.currentPattern).pattern,...
                                                                 handles.user.parameters.search.zs,...
                                                                 handles.user.parameters.search.noise,...
                                                                 handles.user.parameters.search.noise,...
                                                                 handles.user.parameters.search.minerr,...
                                                                 handles.user.parameters.search.relerr,...
                                                                 handles.user.data.run(1).pks{1}, handles.user.data.run(1).ts{1});
            if ~isempty(handles.user.data.results.pattern.pks)                                                        
                handles.user.data.results(1).pattern = sort_results_pks(handles.user.data.results(1).pattern, -4);
            else
                msgbox('No isotope patterns found', 'Pattern search');
            end
                
        case 'No'
    end
                
    % update uicontrols
    handles = update_GUI(handles);
    
    guidata(hObject, handles);
    
function menu_search_untargeted_Callback(hObject, eventdata, handles)
% hObject    handle to menu_search_untargeted (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    


% Search for pattern peak correlation and define parameters 
% --------------------------------------------------------------------

function menu_search_untargeted_peak_Callback(hObject, eventdata, handles)
% hObject    handle to menu_search_untargeted_peak (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    choice = ChelomEx_qdlg('string','Start Pattern Peak Correlation analysis now?','title','Start Correlation Analysis');
    switch choice
        case 'Yes'
            if ~isequal(handles.user.data.run(1).mzXML_Filename{2},'')
                handles.user.data.results(1).peak = ptrn2pk_species(handles.user.parameters.patternID.(handles.user.parameters.currentPattern),...
                                                                     handles.user.data.results(1).pattern,...
                                                                     handles.user.parameters.search,...
                                                                     handles.user.data.run(1).pks{1}, handles.user.data.run(1).ts{1},...
                                                                     handles.user.data.run(1).pks{2}, handles.user.data.run(1).ts{2},...
                                                                     handles.user.parameters.search.MS2err, handles.user.parameters.search.MS2noise);
            else 
                handles.user.data.results(1).peak = ptrn2pk_species(handles.user.parameters.patternID.(handles.user.parameters.currentPattern),...
                                                                     handles.user.data.results(1).pattern,...
                                                                     handles.user.parameters.search,...
                                                                     handles.user.data.run(1).pks{1}, handles.user.data.run(1).ts{1});
            end
            
%             % search for for agreement of found m/z values with database
%             % entries
%             dbid_MS = dbcompare(handles.user.data.results(1).peak.data, 2, 3,...
%                                 handles.user.parameters.search.offerr,...
%                                 handles.user.parameters.search.relerr,...
%                                 handles.user.parameters.search.minerr, 0);
                            
%             % mulitple entries for one m/z value are in separate cell rows, reformat to one cell row for later displaz in uitable 
%             for i = 1:size(dbid_MS,1)
%                 numcells = size(dbid_MS{i},1);
%                 if numcells > 1
%                     for j=2:numcells
%                         dbid_MS{i}{1} = [dbid_MS{i}{1} ' OR ' dbid_MS{i}{j}];
%                     end
%                     dbid_MS{i} = dbid_MS{i}{1};
%                 elseif numcells == 1
%                     dbid_MS{i} = dbid_MS{i}{1};
%                 end       
%             end 
%             handles.user.data.results(1).peak.dbid_MS = dbid_MS;
            
            % prepare presentation in uitable
            % replace NaNs with ''
            PeakData = num2cell(handles.user.data.results(1).peak.data);
            PeakData(isnan(handles.user.data.results(1).peak.data)) = {''};
            % fill in checkbox for user, flag desciriptions and results of database search
            for i = size(handles.user.data.results(1).peak.data,1):-1:1
                 flags{i,1} = handles.user.data.results(1).peak.flagID{cell2mat(handles.user.data.results(1).peak.flagID(:,1))==handles.user.data.results(1).peak.data(i,1),2};
            end          
            handles.user.data.results(1).peak.table.data =...
                       [repmat({'---'},size(handles.user.data.results(1).peak.data,1),1)...
                        flags... 
                        PeakData(:,2:3)... 
                        PeakData(:,4)...
                        handles.user.data.results.peak.apos.speciesID(:)...
                        PeakData(:,5:size(PeakData,2)-2)...
                        PeakData(:,1)]; %last column is numeric flag data for sorting, not to be shown in uitable
            PeakColumnFormat{1} = {'---' 'OK' 'FAIL' 'AMBIGUOUS'}; 
            PeakColumnFormat([2,6]) = {'char'}; 
            PeakColumnFormat([3:5,7:size(handles.user.data.results(1).peak.data,2)+1])= {'numeric'}; 
            handles.user.data.results(1).peak.table.format = PeakColumnFormat;
            handles.user.data.results(1).peak.table.header = [{'Manual|Check'} handles.user.data.results(1).peak.header(1:4) {'Species|ID'} handles.user.data.results(1).peak.header(5:length(handles.user.data.results(1).peak.header)-2)];
            handles.user.data.results(1).peak.table.edit = [true false(1,length(handles.user.data.results(1).peak.table.header)-1)];
            
            handles.user.parameters.search.type = 'Untargeted';
        case 'No';
    end
    
                
    % update uicontrols
    handles = update_GUI(handles);
    
    guidata(hObject, handles);


% Complete analysis batch: first pattern search then pattern peak correlation analysis
% -----------------------------------------------------------------------------------
function menu_search_untargeted_batch_Callback(hObject, eventdata, handles)
% hObject    handle to menu_search_untargeted_batch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

choice = ChelomEx_qdlg('title','Start Analysis Batch?', 'string', 'Start Analysis Batch Now (Pattern Search and Pattern Peak Correlation)?');
    switch choice
        case 'Yes'
            %---1 Pattern Search---
            if isfield(handles.user, 'data') & isfield(handles.user.data, 'results')
                handles.user.data = rmfield(handles.user.data, 'results');
            end
            handles.user.data.results(1).pattern = search_Pattern(handles.user.parameters.patternID.(handles.user.parameters.currentPattern).pattern,...
                                                                 handles.user.parameters.search.zs,...
                                                                 handles.user.parameters.search.noise,...
                                                                 handles.user.parameters.search.noise,...
                                                                 handles.user.parameters.search.minerr,...
                                                                 handles.user.parameters.search.relerr,...
                                                                 handles.user.data.run(1).pks{1}, handles.user.data.run(1).ts{1});
            if ~isempty(handles.user.data.results.pattern.pks)                                                        
                handles.user.data.results(1).pattern = sort_results_pks(handles.user.data.results(1).pattern, -4);
            else
                msgbox('No isotope patterns found', 'Pattern search');
            end
                
            % update uicontrols
            handles = update_GUI(handles);
            guidata(hObject, handles);
            
            %---2 Pattern Peak Correlation---
            if ~isempty(handles.user.data.results.pattern.pks)     
                if ~isequal(handles.user.data.run(1).mzXML_Filename{2},'')
                    handles.user.data.results(1).peak = ptrn2pk_species(handles.user.parameters.patternID.(handles.user.parameters.currentPattern),...
                                                                         handles.user.data.results(1).pattern,...
                                                                         handles.user.parameters.search,...
                                                                         handles.user.data.run(1).pks{1}, handles.user.data.run(1).ts{1},...
                                                                         handles.user.data.run(1).pks{2}, handles.user.data.run(1).ts{2},...
                                                                         handles.user.parameters.search.MS2err, handles.user.parameters.search.MS2noise);
                else 
                    handles.user.data.results(1).peak = ptrn2pk_species(handles.user.parameters.patternID.(handles.user.parameters.currentPattern),...
                                                                         handles.user.data.results(1).pattern,...
                                                                         handles.user.parameters.search,...
                                                                         handles.user.data.run(1).pks{1}, handles.user.data.run(1).ts{1});
                end

                % prepare presentation in uitable
                % replace NaNs with ''
                PeakData = num2cell(handles.user.data.results(1).peak.data);
                PeakData(isnan(handles.user.data.results(1).peak.data)) = {''};
                % fill in checkbox for user, flag desciriptions and results of database search
                for i = size(handles.user.data.results(1).peak.data,1):-1:1
                     flags{i,1} = handles.user.data.results(1).peak.flagID{cell2mat(handles.user.data.results(1).peak.flagID(:,1))==handles.user.data.results(1).peak.data(i,1),2};
                end          
                handles.user.data.results(1).peak.table.data =...
                           [repmat({'---'},size(handles.user.data.results(1).peak.data,1),1)...
                            flags... 
                            PeakData(:,2:3)... 
                            PeakData(:,4)...
                            handles.user.data.results.peak.apos.speciesID(:)...
                            PeakData(:,5:size(PeakData,2)-2)...
                            PeakData(:,1)]; %last column is numeric flag data for sorting, not to be shown in uitable
                PeakColumnFormat{1} = {'---' 'OK' 'FAIL' 'AMBIGUOUS'}; 
                PeakColumnFormat([2,6]) = {'char'}; 
                PeakColumnFormat([3:5,7:size(handles.user.data.results(1).peak.data,2)+1])= {'numeric'}; 
                handles.user.data.results(1).peak.table.format = PeakColumnFormat;
                handles.user.data.results(1).peak.table.header = [{'Manual|Check'} handles.user.data.results(1).peak.header(1:4) {'Species|ID'} handles.user.data.results(1).peak.header(5:length(handles.user.data.results(1).peak.header)-2)];
                handles.user.data.results(1).peak.table.edit = [true false(1,length(handles.user.data.results(1).peak.table.header)-1)];

                handles.user.parameters.search.type = 'Untargeted';  

                % update uicontrols
                handles = update_GUI(handles);
                guidata(hObject, handles);
            end
        
        case 'No'
    end
    

% Save the results in a text file
% --------------------------------------------------------------------
function menu_file_save_results_Callback(hObject, eventdata, handles)
% hObject    handle to menu_file_save_results (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    % save the table that belongs to the active table    
    if isequal(get(handles.uitable_patterns, 'Visible'), 'on')
        [filename, pathname] = uiputfile([handles.user.parameters.currentpath '\*.txt'], 'Save pattern result table');
        if filename ~= 0  % filename is 0 if user selects cancel
            save_results([pathname filename], handles.user.data.results, 'Pattern');
            handles.user.parameters.currentpath = pathname;
        end

    elseif isequal(get(handles.uitable_peaks, 'Visible'), 'on')
        [filename, pathname] = uiputfile([handles.user.parameters.currentpath '\*.txt'], 'Save peaks result table');
        if filename ~= 0  % filename is 0 if user selects cancel
            save_results([pathname filename], handles.user.data.results, handles.user.parameters.search.type);
            handles.user.parameters.currentpath = pathname;
        end
    end

     guidata(hObject, handles);
     
% --------------------------------------------------------------------
% Edit, restore and save parameters 
    
% General parameters    
function menu_options_parameters_search_Callback(hObject, eventdata, handles)
% hObject    handle to menu_options_parameters_search (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Input Dialog Box to query the parameters for search-> Pattern and search -> Peaks:
    % the last used parameters are loaded at startup in handles.user.parameters.search
    [handles.user.temp, ok] = ChelomEx_parameters_general(handles.user.parameters.search);
    if ok == 1
        handles.user.parameters.search = handles.user.temp;
    end
    guidata(hObject, handles);

% Parameters for evaluation of chromatographic consistency 
function menu_options_parameters_filters_Callback(hObject, eventdata, handles)
% hObject    handle to menu_options_parameters_filters (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    [handles.user.temp, ok] = ChelomEx_parameters_filters(handles.user.parameters.search.filters);    
    if ok == 1
        handles.user.parameters.search.filters = handles.user.temp;
    end 
    guidata(hObject, handles);
    
function menu_options_parameters_Callback(hObject, eventdata, handles)
% hObject    handle to menu_search_pattern_parameters (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    
function menu_options_restore_Callback(hObject, eventdata, handles)
% hObject    handle to menu_options_restore (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    % ask user if default parameters should be really loaded
    choice = ChelomEx_qdlg('string','Do you really want to restore the default set of parameters?','title','Restore Default Parameters');
    switch choice
        case 'Yes'
            % loads default parameterset  
            handles.user.parameters.currentpath = handles.user.parameters.programpath;
            handles.user.temp = load([handles.user.parameters.programpath '/default_parameters.mat']);
            handles.user.parameters.patternID = handles.user.temp.patternID;
            % order fields of pattern ID structure alphabetically
            handles.user.parameters.patternID = orderfields(handles.user.parameters.patternID);
            handles.user.parameters.currentPattern = handles.user.temp.currentPattern;
            handles.user.parameters.search = handles.user.temp.search;
            msgbox('Default parameters restored');
            % update uicontrols
            handles = update_GUI(handles);
            
        case 'No'
    end
    
    guidata(hObject, handles);
    

function menu_options_save_Callback(hObject, eventdata, handles)
% hObject    handle to menu_options_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    % ask user if default parameters should be really be saved
    choice = ChelomEx_qdlg('string','Save the current set of parameters?','title','Save Parameters');
    switch choice
        case 'Yes'
            temp = handles.user.parameters;
            save('startup_parameters.mat', '-struct', 'temp', 'currentpath', 'patternID', 'currentPattern', 'search', '-append');
            
        case 'No'
    end
    
function menu_file_options_Callback(hObject, eventdata, handles)
% hObject    handle to menu_file_options (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% Help menu: User guide and about ChelomEx
% --------------------------------------------------------------------
function menu_help_guide_Callback(hObject, eventdata, handles)
% hObject    handle to menu_help_guide (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


function menu_help_about_Callback(hObject, eventdata, handles)
% hObject    handle to menu_help_about (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function menu_help_Callback(hObject, eventdata, handles)
% hObject    handle to menu_help (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% Main user interface: static text, textboxes and pushbuttons
% the function update_GUI controls activation and appearance 
% --------------------------------------------------------------------

function handles = update_GUI(handles)
% updates the gui window: activate or deactivate menu entries and
% pushbuttons and update textboxes. Run if changes to
% handles.user.data or handles.user.parameters are made
            
            %update uicontrols: textboxes, menus, pushbuttons, uitables,
            %figures. 
            %therefore query which of the fields exist: 
            %user.data(.run)
            %user.data.results (can not exist without run and pattern)
            %user.data.results.peak
            
            grey = [0.9375 0.9375 0.9375];
            
%             %close open visualization figures
%             if ~isempty(findobj(get(0,'Children'), 'flat', 'Tag', 'figure_ChelomEx_pattern'))
%                % delete(ChelomEx_pattern_figure);
%             end
%             if ~isempty(findobj(get(0,'Children'), 'flat', 'Tag', 'figure_ChelomEx_peak'))
%               %  delete(ChelomEx_peak_figure);
%             end
%            
            
            switch isfield(handles.user, 'data') 
                case 1
                    if ~isempty(handles.user.data.run(1).mzXML_Filename{1})
                        [~, filename, filext] = fileparts(handles.user.data.run(1).mzXML_Filename{1});
                        set(handles.text_MS1filename, 'String', [filename filext]);
                        set(handles.menu_file_save_session,'Enable','on');
                        set(handles.menu_search_untargeted_pattern, 'Enable','on');
                        set(handles.menu_search_untargeted_batch, 'Enable','on');
                        set(handles.menu_search_targeted_manual, 'Enable','on');
                        set(handles.menu_search_targeted_database, 'Enable','on');
                    else
                        set(handles.menu_file_save_results, 'Enable','off');
                        set(handles.menu_search_untargeted_peak, 'Enable','off');
                        set(handles.menu_search_targeted_manual, 'Enable','off');
                        set(handles.menu_search_targeted_database, 'Enable','off');
                    end
                    if ~isempty(handles.user.data.run(1).mzXML_Filename{2})
                        [~, filename, filext] = fileparts(handles.user.data.run(1).mzXML_Filename{2});
                        set(handles.text_MS2filename, 'String', [filename filext]);
                    end
                                
                    if isfield(handles.user.data, 'results') & ~isempty(handles.user.data.results.pattern.pks)     
                            set(handles.menu_file_save_results, 'Enable','on');
                            set(handles.menu_search_untargeted_peak, 'Enable','on');
                            set(handles.pushbutton_figure, 'Enable','on');
                            set(handles.static_noresults, 'Visible', 'off');
                            set(handles.pushbutton_MS1file, 'Enable','off');
                            set(handles.pushbutton_MS2file, 'Enable','off');
%                             set(handles.pushbutton_patternID, 'Enable','off');
                            set(handles.menu_file_open_run, 'Enable','off');
%                            set(handles.menu_pattern, 'Enable', 'off');
                            
                            switch isfield(handles.user.data.results, 'peak')
                                case 1
                                    set(handles.pushbutton_pattern, 'Enable','on','BackgroundColor',grey);
                                    set(handles.pushbutton_peak, 'Enable','on','BackgroundColor','white');
                                    set(handles.uitable_peaks, 'Visible', 'on');
                                    set(handles.pushbutton_database, 'Enable','on');
                                    % populate uitable_peaks with results and enable context menu
                                    set(handles.uitable_peaks,'Data',handles.user.data.results(1).peak.table.data(:,1:size(handles.user.data.results(1).peak.table.data,2)-1),...
                                                              'ColumnFormat', handles.user.data.results(1).peak.table.format,... 
                                                              'ColumnName', handles.user.data.results(1).peak.table.header,...
                                                              'ColumnEditable', handles.user.data.results(1).peak.table.edit);
                                    set(handles.uitable_peaks,'UIContextMenu', handles.context_menu_sortable_peaks);
                                    % callback if user changes the manual uitable column entries
                                    set(handles.uitable_peaks,'CellEditCallback', {@uitable_peaks_CellEditCallback, handles});
                                    set(handles.uitable_patterns, 'Visible', 'off');
                                    % populate uitable_patterns with results and enable context menu   
                                    set(handles.uitable_patterns,'Data', handles.user.data.results(1).pattern.pks,...
                                                                 'ColumnName', handles.user.data.results(1).pattern.pks_header);
                                    set(handles.uitable_patterns,'UIContextMenu', handles.context_menu_sortable_patterns);
                                    
        
                                case 0
                                    set(handles.pushbutton_pattern, 'Enable','on','BackgroundColor','white');
                                    set(handles.pushbutton_peak, 'Enable','off','BackgroundColor',grey);
                                    set(handles.uitable_patterns, 'Visible', 'on');
                                    set(handles.uitable_peaks, 'Visible', 'off');
                                    % populate uitable_patterns with results and enable context menu
                                    set(handles.uitable_patterns,'Data', handles.user.data.results(1).pattern.pks,...
                                                                 'ColumnName', handles.user.data.results(1).pattern.pks_header);
                                    set(handles.uitable_patterns,'UIContextMenu', handles.context_menu_sortable_patterns);
                            end
                            
                    else  
                            set(handles.menu_file_save_results, 'Enable','off');
                            set(handles.menu_search_untargeted_peak, 'Enable','off');
                            set(handles.pushbutton_pattern, 'Enable','off','BackgroundColor',grey);
                            set(handles.pushbutton_peak, 'Enable','off','BackgroundColor',grey);
                            set(handles.pushbutton_figure, 'Enable','off');
                            set(handles.pushbutton_database, 'Enable','off');
                            set(handles.uitable_patterns, 'Visible', 'off');
                            set(handles.uitable_peaks, 'Visible', 'off');
                            set(handles.static_noresults, 'Visible', 'on');
                            set(handles.pushbutton_MS1file, 'Enable','on');
                            set(handles.pushbutton_MS2file, 'Enable','on');
                            set(handles.pushbutton_patternID, 'Enable','on');
                            set(handles.menu_file_open_run, 'Enable','on');
                            set(handles.menu_pattern, 'Enable', 'on');
                            
                            
                    end
                    
                case 0
                     set(handles.text_MS1filename, 'String', 'please load file');
                     set(handles.text_MS2filename, 'String', 'optional');
                     set(handles.menu_file_save_session,'Enable','off');
                     set(handles.menu_file_save_results, 'Enable','off');
                     set(handles.menu_search_untargeted_pattern, 'Enable','off');
                     set(handles.menu_search_untargeted_batch, 'Enable','off');
                     set(handles.menu_search_untargeted_peak, 'Enable','off');
                     set(handles.pushbutton_pattern, 'Enable','off','BackgroundColor',grey);
                     set(handles.pushbutton_peak, 'Enable','off','BackgroundColor',grey);
                     set(handles.pushbutton_figure, 'Enable','off');
                     set(handles.pushbutton_database, 'Enable','off');
                     set(handles.uitable_patterns, 'Visible', 'off');
                     set(handles.uitable_peaks, 'Visible', 'off');
                     set(handles.menu_search_targeted_manual, 'Enable','off');
                     set(handles.menu_search_targeted_database, 'Enable','off');
                     set(handles.static_noresults, 'Visible', 'on');
                     set(handles.pushbutton_MS1file, 'Enable','on');
                     set(handles.pushbutton_MS2file, 'Enable','on');
                     set(handles.pushbutton_patternID, 'Enable','on');
                     set(handles.menu_file_open_run, 'Enable','on');
                     set(handles.menu_pattern, 'Enable', 'on');
                     
                      
            end
            
            % update parameter uicontrols; all parameter fields always
            % exist
            set(handles.text_currentPattern, 'String', handles.user.parameters.patternID.(handles.user.parameters.currentPattern).ID);
           


% --- Executes when entered data in editable cell(s) in uitable.
function uitable_peaks_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to uitable (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)
    if ~isempty(eventdata)
        handles.user.data.results.peak.table.data(eventdata.Indices(1)) = {eventdata.NewData};
        guidata(hObject,handles);
    end

            
% --- Executes on button press in pushbutton_pattern.
function pushbutton_pattern_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_pattern (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    set(handles.uitable_patterns, 'Visible', 'on');
    set(handles.uitable_peaks, 'Visible', 'off');
    set(handles.pushbutton_database, 'Enable','off');
    grey = [0.9375 0.9375 0.9375];
    set(handles.pushbutton_pattern, 'BackgroundColor','white');
    set(handles.pushbutton_peak, 'BackgroundColor',grey);

% --- Executes on button press in pushbutton_peak.
function pushbutton_peak_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_peak (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    set(handles.uitable_patterns, 'Visible', 'off');
    set(handles.uitable_peaks, 'Visible', 'on');
    set(handles.pushbutton_database, 'Enable','on');
    grey = [0.9375 0.9375 0.9375];
    set(handles.pushbutton_pattern, 'BackgroundColor',grey);
    set(handles.pushbutton_peak, 'BackgroundColor','white');
    

% --- Executes on button press in pushbutton_figure.
function pushbutton_figure_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_figure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
        
     % read selected cell indices in active uitable and launch
     % ChelomEx_pattern_figure for data visualization
     if isequal(get(handles.uitable_patterns, 'Visible'), 'on')
         select_rc = get(handles.uitable_patterns, 'UserData');
     elseif isequal(get(handles.uitable_peaks, 'Visible'), 'on')
         select_rc = get(handles.uitable_peaks, 'UserData');
     end
     if ~isempty(select_rc)                                    % selection made in the table
        select_rc = select_rc(:,1);
        % remove rownumbers that may appear more than 1 time (if user
        % selects multiple columns)
        i = 1;
        while i < length(select_rc)
            duplicate = find(select_rc(:) == select_rc(i));
            if length(duplicate) > 1  
                select_rc(duplicate(2:length(duplicate),:)) = [];
            end
            i = i+1;
        end      
        if isequal(get(handles.uitable_patterns, 'Visible'), 'on')
          ChelomEx_pattern_figure(handles.user, select_rc(:));  
        elseif isequal(get(handles.uitable_peaks, 'Visible'), 'on')    
          [temp, cancel] = ChelomEx_peak_figure(handles.user, select_rc(:), handles.user.parameters.search.type); 
          if ~cancel   % exit of Peak Figure with click on Accept Changes
              handles.user.data.results.peak.table.data = temp;
          end
          handles = update_GUI(handles);
          guidata(hObject, handles);
        end
     else 
        msgbox('plese select one or more rows in the table');   % no selection made
     end
     

% --- Executes on button press in pushbutton_database.
function pushbutton_database_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_database (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)   
    select_rc = get(handles.uitable_peaks, 'UserData');
    if ~isempty(select_rc)                                    % selection made in the table
        select_rc = select_rc(:,1);
        % remove rownumbers that may appear more than 1 time (if user
        % selects multiple columns)
        i = 1;
        while i < length(select_rc)
            duplicate = find(select_rc(:) == select_rc(i));
            if length(duplicate) > 1  
                select_rc(duplicate(2:length(duplicate),:)) = [];
            end
            i = i+1;
        end      
        ChelomEx_id_database(handles.user, select_rc(:), handles.user.parameters.search.type); 
     else 
        msgbox('plese select one or more rows in the table');   % no selection made
     end
         

function text_MS1filename_Callback(hObject, eventdata, handles)
% hObject    handle to text_MS1filename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of text_MS1filename as text
%        str2double(get(hObject,'String')) returns contents of text_MS1filename as a double

% --- Executes during object creation, after setting all properties.
function text_MS1filename_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text_MS1filename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function text_MS2filename_Callback(hObject, eventdata, handles)
% hObject    handle to text_MS2filename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of text_MS2filename as text
%        str2double(get(hObject,'String')) returns contents of text_MS2filename as a double

% --- Executes during object creation, after setting all properties.
function text_MS2filename_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text_MS2filename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function text_currentPattern_Callback(hObject, eventdata, handles)
% hObject    handle to text_currentPattern (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of text_currentPattern as text
%        str2double(get(hObject,'String')) returns contents of text_currentPattern as a double

% --- Executes during object creation, after setting all properties.
function text_currentPattern_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text_currentPattern (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% Context menus for sorting of uitable_patterns
% --------------------------------------------------------------------
function context_menu_sortable_patterns_mz_Callback(hObject, eventdata, handles)
% hObject    handle to context_menu_sortable_patterns_mz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    % sort results.pks and results.pkspattern
    handles.user.data.results(1).pattern = sort_results_pks(handles.user.data.results(1).pattern, 2);
    set(handles.uitable_patterns,'Data',handles.user.data.results(1).pattern.pks);
    guidata(hObject, handles);
    

function context_menu_sortable_patterns_z_Callback(hObject, eventdata, handles)
% hObject    handle to context_menu_sortable_patterns_z (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    handles.user.data.results(1).pattern = sort_results_pks(handles.user.data.results(1).pattern, 3);
    set(handles.uitable_patterns,'Data',handles.user.data.results(1).pattern.pks);
    guidata(hObject, handles);


function context_menu_sortable_patterns_Int_Callback(hObject, eventdata, handles)
% hObject    handle to context_menu_sortable_patterns_Int (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    handles.user.data.results(1).pattern = sort_results_pks(handles.user.data.results(1).pattern, -4);
    set(handles.uitable_patterns,'Data',handles.user.data.results(1).pattern.pks);
    guidata(hObject, handles);

function context_menu_sortable_patterns_RT_Callback(hObject, eventdata, handles)
% hObject    handle to context_menu_sortable_patterns_RT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    handles.user.data.results(1).pattern = sort_results_pks(handles.user.data.results(1).pattern, 5);
    set(handles.uitable_patterns,'Data',handles.user.data.results(1).pattern.pks);
    guidata(hObject, handles);


function context_menu_sortable_patterns_nptn_Callback(hObject, eventdata, handles)
% hObject    handle to context_menu_sortable_patterns_nptn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    handles.user.data.results(1).pattern = sort_results_pks(handles.user.data.results(1).pattern, -1);
    set(handles.uitable_patterns,'Data',handles.user.data.results(1).pattern.pks);
    guidata(hObject, handles);


function context_menu_sortable_patterns_Callback(hObject, eventdata, handles)
% hObject    handle to context_menu_sortable_patterns (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% Context menus for sorting of uitable_peaks
% --------------------------------------------------------------------
function context_menu_sortable_peaks_manual_Callback(hObject, eventdata, handles)
% hObject    handle to context_menu_sortable_peaks_manual (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    if isequal(handles.user.parameters.search.type, 'Untargeted')
        handles.user.data.results(1).peak.table.data = sortrows(handles.user.data.results(1).peak.table.data, -1);
    elseif isequal(handles.user.parameters.search.type, 'Database')
        handles.user.data.results(1).peak.table.data = sortrows(handles.user.data.results(1).peak.table.data, -1);
    end
    set(handles.uitable_peaks,'Data',handles.user.data.results(1).peak.table.data(:,1:size(handles.user.data.results(1).peak.table.data,2)-1));
    guidata(hObject, handles);


function context_menu_sortable_peaks_pass_Callback(hObject, eventdata, handles)
% hObject    handle to context_menu_sortable_peaks_pass (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    if isequal(handles.user.parameters.search.type, 'Untargeted')
        handles.user.data.results(1).peak.table.data = sortrows(handles.user.data.results(1).peak.table.data, size(handles.user.data.results(1).peak.table.data,2));
    elseif isequal(handles.user.parameters.search.type, 'Database')
        handles.user.data.results(1).peak.table.data = sortrows(handles.user.data.results(1).peak.table.data, size(handles.user.data.results(1).peak.table.data,2));
    end
    set(handles.uitable_peaks,'Data',handles.user.data.results(1).peak.table.data(:,1:size(handles.user.data.results(1).peak.table.data,2)-1));
    guidata(hObject, handles);

function context_menu_sortable_peaks_mz_Callback(hObject, eventdata, handles)
% hObject    handle to context_menu_sortable_peaks_mz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    if isequal(handles.user.parameters.search.type, 'Untargeted')
        handles.user.data.results(1).peak.table.data = sortrows(handles.user.data.results(1).peak.table.data,-3);
    elseif isequal(handles.user.parameters.search.type, 'Database')
            handles.user.data.results(1).peak.table.data = sortrows(handles.user.data.results(1).peak.table.data,-5);
    end
    set(handles.uitable_peaks,'Data',handles.user.data.results(1).peak.table.data(:,1:size(handles.user.data.results(1).peak.table.data,2)-1));
    guidata(hObject, handles);

function context_menu_sortable_peaks_Int_Callback(hObject, eventdata, handles)
% hObject    handle to context_menu_sortable_peaks_Int (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    if isequal(handles.user.parameters.search.type, 'Untargeted')
        handles.user.data.results(1).peak.table.data = sortrows(handles.user.data.results(1).peak.table.data,-12);
    elseif isequal(handles.user.parameters.search.type, 'Database')
            handles.user.data.results(1).peak.table.data = sortrows(handles.user.data.results(1).peak.table.data,-14);
    end
    set(handles.uitable_peaks,'Data',handles.user.data.results(1).peak.table.data(:,1:size(handles.user.data.results(1).peak.table.data,2)-1));
    guidata(hObject, handles);

function context_menu_sortable_peaks_RT_Callback(hObject, eventdata, handles)
% hObject    handle to context_menu_sortable_peaks_RT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    if isequal(handles.user.parameters.search.type, 'Untargeted')
        handles.user.data.results(1).peak.table.data = sortrows(handles.user.data.results(1).peak.table.data,-16);
    elseif isequal(handles.user.parameters.search.type, 'Database')
            handles.user.data.results(1).peak.table.data = sortrows(handles.user.data.results(1).peak.table.data,-18);
    end
    set(handles.uitable_peaks,'Data',handles.user.data.results(1).peak.table.data(:,1:size(handles.user.data.results(1).peak.table.data,2)-1));
    guidata(hObject, handles);

function context_menu_sortable_peaks_mzapo_Callback(hObject, eventdata, handles)
% hObject    handle to context_menu_sortable_peaks_mzapo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    if isequal(handles.user.parameters.search.type, 'Untargeted')
        handles.user.data.results(1).peak.table.data = sortrows(handles.user.data.results(1).peak.table.data,-7);
    elseif isequal(handles.user.parameters.search.type, 'Database')
            handles.user.data.results(1).peak.table.data = sortrows(handles.user.data.results(1).peak.table.data,-9);
    end
    set(handles.uitable_peaks,'Data',handles.user.data.results(1).peak.table.data(:,1:size(handles.user.data.results(1).peak.table.data,2)-1));
    guidata(hObject, handles);

function context_menu_sortable_peaks_Intapo_Callback(hObject, eventdata, handles)
% hObject    handle to context_menu_sortable_peaks_Intapo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    if isequal(handles.user.parameters.search.type, 'Untargeted')
        handles.user.data.results(1).peak.table.data = sortrows(handles.user.data.results(1).peak.table.data,-14);
    elseif isequal(handles.user.parameters.search.type, 'Database')
            handles.user.data.results(1).peak.table.data = sortrows(handles.user.data.results(1).peak.table.data,-16);
    end
    set(handles.uitable_peaks,'Data',handles.user.data.results(1).peak.table.data(:,1:size(handles.user.data.results(1).peak.table.data,2)-1));
    guidata(hObject, handles);


function context_menu_sortable_peaks_RTapo_Callback(hObject, eventdata, handles)
% hObject    handle to context_menu_sortable_peaks_RTapo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    if isequal(handles.user.parameters.search.type, 'Untargeted')
        handles.user.data.results(1).peak.table.data = sortrows(handles.user.data.results(1).peak.table.data,19);
    elseif isequal(handles.user.parameters.search.type, 'Database')
            handles.user.data.results(1).peak.table.data = sortrows(handles.user.data.results(1).peak.table.data,21);
    end
    set(handles.uitable_peaks,'Data',handles.user.data.results(1).peak.table.data(:,1:size(handles.user.data.results(1).peak.table.data,2)-1));
    guidata(hObject, handles);

function context_menu_sortable_peaks_speciescor_Callback(hObject, eventdata, handles)
% hObject    handle to context_menu_sortable_peaks_speciescor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    if isequal(handles.user.parameters.search.type, 'Untargeted')
        handles.user.data.results(1).peak.table.data = sortrows(handles.user.data.results(1).peak.table.data,-9);
    elseif isequal(handles.user.parameters.search.type, 'Database')
            handles.user.data.results(1).peak.table.data = sortrows(handles.user.data.results(1).peak.table.data,-11);
    end
    set(handles.uitable_peaks,'Data',handles.user.data.results(1).peak.table.data(:,1:size(handles.user.data.results(1).peak.table.data,2)-1));
    guidata(hObject, handles);
    

function context_menu_sortable_peaks_MS2_Callback(hObject, eventdata, handles)
% hObject    handle to context_menu_sortable_peaks_MS2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    if isequal(handles.user.parameters.search.type, 'Untargeted')
        handles.user.data.results(1).peak.table.data = sortrows(handles.user.data.results(1).peak.table.data,-8);
    elseif isequal(handles.user.parameters.search.type, 'Database')
            handles.user.data.results(1).peak.table.data = sortrows(handles.user.data.results(1).peak.table.data,-10);
    end
    set(handles.uitable_peaks,'Data',handles.user.data.results(1).peak.table.data(:,1:size(handles.user.data.results(1).peak.table.data,2)-1));
    guidata(hObject, handles);
    
function context_menu_sortable_peaks_Callback(hObject, eventdata, handles)
% hObject    handle to context_menu_sortable_peaks (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
