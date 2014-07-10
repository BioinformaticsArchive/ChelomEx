function varargout = ChelomEx_id_database(varargin)
% CHELOMEX_ID_DATABASE MATLAB code for ChelomEx_id_database.fig
%      CHELOMEX_ID_DATABASE, by itself, creates a new CHELOMEX_ID_DATABASE or raises the existing
%      singleton*.
%
%      H = CHELOMEX_ID_DATABASE returns the handle to a new CHELOMEX_ID_DATABASE or the handle to
%      the existing singleton*.
%
%      CHELOMEX_ID_DATABASE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CHELOMEX_ID_DATABASE.M with the given input arguments.
%
%      CHELOMEX_ID_DATABASE('Property','Value',...) creates a new CHELOMEX_ID_DATABASE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ChelomEx_id_database_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ChelomEx_id_database_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ChelomEx_id_database

% Last Modified by GUIDE v2.5 21-Feb-2014 15:49:22

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ChelomEx_id_database_OpeningFcn, ...
                   'gui_OutputFcn',  @ChelomEx_id_database_OutputFcn, ...
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


% --- Executes just before ChelomEx_id_database is made visible.
function ChelomEx_id_database_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ChelomEx_id_database (see VARARGIN)

% Choose default command line output for ChelomEx_id_database
handles.output = hObject;

% read varargin input from ChelomEx_Menu
% (handles.user and selected table rows)
handles.user = varargin{1};
handles.user.row.slct = varargin{2};
handles.user.table.type = varargin{3};

% currently selected data in handles.user.data.results.pattern.pks
handles.user.row.index = 1;      %initally set to first selected cell in ChelomEx_menu table
handles.user.row.rownum = length(handles.user.row.slct);
handles.user.row.current = handles.user.row.slct(handles.user.row.index);

% uitable header, editable and columnformat
set(handles.uitable_select,'ColumnName', handles.user.data.results(1).peak.table.header,...
                    'ColumnFormat', handles.user.data.results(1).peak.table.format,...
                    'ColumnEditable', false(1,length(handles.user.data.results(1).peak.table.header)));
                
% customize table col numbers depending on whether untargeted or targeted search
switch handles.user.table.type
    case 'Untargeted'
        handles.user.col.mztable = 3; handles.user.col.ztable = 4;  
    case 'Manual' 
        handles.user.col.mztable = 4; handles.user.col.ztable = 5;  
    case 'Database'
        handles.user.col.mztable = 5; handles.user.col.ztable = 6;  
end
                
% list of adducts and derivatives of database entries that shall be
% considered
handles.user.addlist = get_db_species('adducts');
handles.user.derlist = get_db_species('derivatives');
% initially select complete list of adducts
handles.user.addlist_slct = handles.user.addlist;
handles.user.addlist_slct.rows = 1:length(handles.user.addlist.dm);
% initially do not include derivatives of database entries
handles.user.derlist_slct.rows = []; handles.user.derlist_slct.id = []; handles.user.derlist_slct.dm = [];

% populate edit textboxes
set(handles.edit_offerr, 'String', sprintf('%5.5f', handles.user.parameters.search.offerr));

% some column numbers for handles.user.data.results.peak.data
handles.user.col.z = 3;
handles.user.col.mz = 2;

% disable listbox with species if no species are defined
if isempty(handles.user.parameters.patternID.(handles.user.parameters.currentPattern).species.id)
    set(handles.listbox_species, 'Enable', 'off');
end

% update GUI with selected data
handles = refresh(handles);

% % update table with database hits
% handles = update_dbhits(handles);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ChelomEx_id_database wait for user response (see UIRESUME)
% uiwait(handles.figure_ChelomEx_id_database);


% --- Outputs from this function are returned to the command line.
function varargout = ChelomEx_id_database_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function pushbutton_previous_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton_previous (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
    set(hObject, 'CData', imread('ArrowUp.png','png'));


    function pushbutton_next_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton_next (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
    set(hObject, 'CData', imread('ArrowDown.png','png'));

    
function pushbutton_rightarrow_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton_rightarrow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
    set(hObject, 'CData', imread('ArrowRight.png','png', 'BackgroundColor',[0.94 0.94 0.94]));
    
    
% user function to update GUI if selections are changed
function handles = refresh(handles)
    % some temporary variables to make referencing easier
    mz = cell2mat(handles.user.data.results.peak.table.data(handles.user.row.current, handles.user.col.mztable));
    z = cell2mat(handles.user.data.results.peak.table.data(handles.user.row.current, handles.user.col.ztable));
    table_data = handles.user.data.results(1).peak.table.data;
    table_header = handles.user.data.results(1).peak.table.header;
    peak.data = handles.user.data.results.peak.data;
    species = handles.user.parameters.patternID.(handles.user.parameters.currentPattern).species;
    
    % find row in peak.data that corresponds to the current row in peaktable
    mzdiff = [abs(peak.data(:, handles.user.col.mz) - mz) [1:size(peak.data,1)]']; %col1=mz diff; col2=row number
    % use z values that crrespond to current z value in peak.data
    mzdiff = mzdiff(peak.data(:, handles.user.col.z) == z,:);      
    handles.user.row.pks = mzdiff(mzdiff(:,1)==min(mzdiff(:,1)),2);
    handles.user.row.pks = handles.user.row.pks(1);     
    
    % udpate uitable_select with current row
    set(handles.uitable_select, 'Data', table_data(handles.user.row.current,1:length(table_header)));
    
    % refresh Enable state of pushbutton_next and pushbutton_previous
    if handles.user.row.index < handles.user.row.rownum    
        set(handles.pushbutton_next, 'Enable', 'on'); 
    else
        set(handles.pushbutton_next, 'Enable', 'off'); 
    end
    if handles.user.row.index > 1
         set(handles.pushbutton_previous, 'Enable', 'on'); 
    else
        set(handles.pushbutton_previous, 'Enable', 'off'); 
    end
    
    if isequal(get(handles.listbox_species, 'Enable'), 'on')
        % populate listbox with species
        foundspecies = handles.user.data.results.peak.apos.foundspecies{handles.user.row.pks}; 
        if isempty(foundspecies)
            foundspecies = cell(1,2);
        end
        foundspecies = foundspecies(cell2mat(foundspecies(:,size(foundspecies,2))) == 1,:);
        notfoundspecies(:,1) = species.id;
        notfoundspecies(:,2) = num2cell(mz + species.dmz/z);
        delrows = []; 
        for i=size(foundspecies,1):-1:1
            foundspecies{i,1} = ['* ' foundspecies{i,1} sprintf(' (%0.4f)', cell2mat(foundspecies(i,2)))]; 
            delrows(i) = find(abs(cell2mat(foundspecies(i,2))-cell2mat(notfoundspecies(:,2))) == min(abs(cell2mat(foundspecies(i,2))-cell2mat(notfoundspecies(:,2)))),1,'first');
        end

        notfoundspecies(delrows,:) = [];
        for i=size(notfoundspecies,1):-1:1
            notfoundspecies{i,1} = [notfoundspecies{i,1} sprintf(' (%0.4f)', cell2mat(notfoundspecies(i,2)))];
        end
        handles.user.foundmzlist = cell2mat([foundspecies(:,2);notfoundspecies(:,2)]);
        set(handles.listbox_species, 'String', [foundspecies(:,1);notfoundspecies(:,1)]); 
        % update uitable_dbhits with results
        handles=update_dbhits(handles);
    else
        % no species given: use m/z of selected monoisotope
        set(handles.edit_mz, 'String', sprintf('%9.4f', mz));     
    end
    
    % refresh edit textbox z 
    set(handles.edit_z, 'String', sprintf('%1i', z));
    
    % update uitable_dbhits with results
    handles=update_dbhits(handles);
    
 
% user function to update table with database hits     
function handles = update_dbhits(handles,mzslct,z)
    if nargin == 1 
        if isequal(get(handles.listbox_species, 'Enable'), 'on')
            z = cell2mat(handles.user.data.results.peak.table.data(handles.user.row.current, handles.user.col.ztable));
            % selected row in listbox
            mzslct = handles.user.foundmzlist(get(handles.listbox_species, 'Value'));
        else 
            z = str2double(get(handles.edit_z, 'String'));
            mzslct = str2double(get(handles.edit_mz, 'String'));
        end
    end
    % compare species to database masses and their modifications
    handles.user.dbhits = dbcompare_pks(mzslct,z,handles.user.parameters.search.polarity, handles.user.addlist_slct,handles.user.derlist_slct, str2double(get(handles.edit_offerr, 'String')), handles.user.parameters.search.relerr, handles.user.parameters.search.minerr);
    % update uitable_dbhits with the results
    set(handles.uitable_dbhits, 'Data', handles.user.dbhits.table, 'ColumnName', handles.user.dbhits.header);

% --- Executes on button press in pushbutton_previous.
function pushbutton_previous_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_previous (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    if handles.user.row.index > 1 
        handles.user.row.index = handles.user.row.index - 1;      
        handles.user.row.current = handles.user.row.slct(handles.user.row.index);
        handles = refresh(handles);  
        guidata(hObject, handles);
    end

% --- Executes on button press in pushbutton_next.
function pushbutton_next_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_next (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    if handles.user.row.index < handles.user.row.rownum
        handles.user.row.index = handles.user.row.index + 1;      
        handles.user.row.current = handles.user.row.slct(handles.user.row.index);
        handles = refresh(handles);
        guidata(hObject, handles);
    end


% --- Executes on selection change in listbox_species.
function listbox_species_Callback(hObject, eventdata, handles)
% hObject    handle to listbox_species (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox_species contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox_species

    handles = update_dbhits(handles);
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


% --- Executes on button press in pushbutton_adducts.
function pushbutton_adducts_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_adducts (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    % Open list-selection dialog box. The listnames correspond to adduct
    % formula which is given by a matrix definition in get_db_species
    % IDs in addlist.id, dmzs in addlist.dm
        
    rows = listdlg('PromptString',...
                   'Choose Adducts','SelectionMode','multiple',...
                   'InitialValue', handles.user.addlist_slct.rows,...
                   'Name','Choose Adducts',...
                   'ListString', handles.user.addlist.id);

    if sum(size(rows)) == 0  % chose cancel
    else  % chose OK
        handles.user.addlist_slct.rows = rows;
        handles.user.addlist_slct.id = handles.user.addlist.id(rows);
        handles.user.addlist_slct.dm = handles.user.addlist.dm(rows);
        handles = update_dbhits(handles);
    end
    
    guidata(hObject, handles);


% --- Executes on button press in pushbutton_derivatives.
function pushbutton_derivatives_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_derivatives (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    rows   = listdlg('PromptString',...
                   'Choose Derivatives','SelectionMode','multiple',...
                   'InitialValue', handles.user.derlist_slct.rows,...
                   'Name','Choose Derivatives',...
                   'ListString', handles.user.derlist.id);
  
    if sum(size(rows)) == 0  % chose cancel
    else  % chose OK
        handles.user.derlist_slct.rows = rows;
        handles.user.derlist_slct.id = handles.user.derlist.id(rows);
        handles.user.derlist_slct.dm = handles.user.derlist.dm(rows);
        handles = update_dbhits(handles);
    end
    guidata(hObject, handles);


% --- Executes on button press in pushbutton_rightarrow.
function pushbutton_rightarrow_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_rightarrow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object deletion, before destroying properties.
function pushbutton_rightarrow_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton_rightarrow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit_offerr_Callback(hObject, eventdata, handles)
% hObject    handle to edit_offerr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_offerr as text
%        str2double(get(hObject,'String')) returns contents of edit_offerr as a double
    
    handles.user.parameters.search.offerr = str2double(get(hObject,'String'));
    handles=update_dbhits(handles);
    guidata(hObject, handles);


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



function edit_mz_Callback(hObject, eventdata, handles)
% hObject    handle to edit_mz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_mz as text
%        str2double(get(hObject,'String')) returns contents of edit_mz as a double
    mzslct = str2double(get(hObject,'String'));
    z = str2double(get(handles.edit_z, 'String'));
    if ~isnan(mzslct*z) & ~isempty(mzslct*z)
        handles = update_dbhits(handles,mzslct,z);
        guidata(hObject, handles);
    else 
        errordlg('m/z and z must be numeric', 'Manual search error');
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



function edit_z_Callback(hObject, eventdata, handles)
% hObject    handle to edit_z (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_z as text
%        str2double(get(hObject,'String')) returns contents of edit_z as a double
    z = str2double(get(handles.edit_z, 'String'));
    if isnan(z) | isempty(z)
        errordlg('z must be numeric', 'Manual search error');
    else
        mzslct = str2double(get(handles.edit_mz,'String'));
        if ~isempty(mzslct)        
            if ~isnan(mzslct*z) & ~isempty(mzslct*z)
                handles = update_dbhits(handles,mzslct,z);
                guidata(hObject, handles);
            else 
                errordlg('m/z and z must be numeric', 'Manual search error');
            end
        end
    end

% --- Executes during object creation, after setting all properties.
function edit_z_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_z (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
