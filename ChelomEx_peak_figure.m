function varargout = ChelomEx_peak_figure(varargin)
% CHELOMEX_PEAK_FIGURE MATLAB code for ChelomEx_peak_figure.fig
%      CHELOMEX_PEAK_FIGURE, by itself, creates a new CHELOMEX_PEAK_FIGURE or raises the existing
%      singleton*.
%
%      H = CHELOMEX_PEAK_FIGURE returns the handle to a new CHELOMEX_PEAK_FIGURE or the handle to
%      the existing singleton*.
%
%      CHELOMEX_PEAK_FIGURE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CHELOMEX_PEAK_FIGURE.M with the given input arguments.
%
%      CHELOMEX_PEAK_FIGURE('Property','Value',...) creates a new CHELOMEX_PEAK_FIGURE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ChelomEx_peak_figure_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ChelomEx_peak_figure_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ChelomEx_peak_figure

% Last Modified by GUIDE v2.5 26-Feb-2014 22:46:46

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ChelomEx_peak_figure_OpeningFcn, ...
                   'gui_OutputFcn',  @ChelomEx_peak_figure_OutputFcn, ...
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


% --- Executes just before ChelomEx_peak_figure is made visible.
function ChelomEx_peak_figure_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ChelomEx_peak_figure (see VARARGIN)

% Choose default command line output for ChelomEx_peak_figure
% handles.output = handles.output;

% set axes appearance
%set(handles.axes_MSMS2, 'FontSize', 8);
%set(handles.axes_EIC_pattern, 'FontSize', 8);
%set(handles.axes_EIC_species, 'FontSize', 8);
%set(handles.axes_MS, 'FontSize', 8);

% read varargin input from ChelomEx_Menu
% (handles.user and selected table rows)
handles.user = varargin{1};
handles.user.row.slct = varargin{2};
handles.user.table.type = varargin{3};

% unless accept menu button is activated, the changes in table are
% discarded
handles.user.cancel = true;

% get initial figure size (required when resizing window)
handles.user.fposold = get(hObject, 'Position');
axes_MS = get(handles.axes_MS, 'Position');
axes_MSMS = get(handles.axes_MSMS1, 'Position');
handles.user.hratio = axes_MSMS(4)/axes_MS(4);

% currently selected data in handles.user.data.results.pattern.pks
handles.user.row.index = 1;      %initally set to first selected cell in ChelomEx_menu table
handles.user.row.rownum = length(handles.user.row.slct);
handles.user.row.current = handles.user.row.slct(handles.user.row.index);

% currently selected index in popupmenu for EIC pattern normalization selection
handles.user.EICptrn.normidx = 1;

% initally select species radiobutton to isotopes
set(handles.uipanel_MS, 'SelectedObject', handles.radiobutton_isotopes);
handles.user.MS.zoomtype = 'zoomIn';
set(handles.togglebutton_annotation,'Value',1);

% uitable header, editable and columnformat
set(handles.uitable,'ColumnName', handles.user.data.results(1).peak.table.header, 'ColumnFormat', handles.user.data.results(1).peak.table.format, 'ColumnEditable', handles.user.data.results(1).peak.table.edit);

% customize GUI depending on whether untargeted or targeted search
switch handles.user.table.type
    case 'Untargeted'
        set(handles.static_EIC_species, 'String', 'EICs of related species');
        % some column numbers for uitable
        handles.user.col.mztable = 3; handles.user.col.ztable = 4;  
    case 'Manual' 
        set(handles.static_EIC_species, 'String', 'EICs of all defined species');
        set(handles.menu_accept, 'Visible', 'off'); set(handles.menu_discard, 'Visible', 'off');
        handles.user.col.mztable = 4; handles.user.col.ztable = 5;  
    case 'Database'
        set(handles.static_EIC_species, 'String', 'EICs of all defined species');
        handles.user.col.mztable = 5; handles.user.col.ztable = 6;  
end

% toolbar menu items with customized callbacks to make them work in UIWAIT
% mode
handles.toolbar_zoom = zoom(handles.figure_ChelomEx_peak);
handles.toolbar_pan = pan(handles.figure_ChelomEx_peak);
handles.toolbar.dcm_obj = datacursormode(handles.figure_ChelomEx_peak);

% customize data cursor tool to display m/z values with enough precision
set(handles.toolbar.dcm_obj,'UpdateFcn',{@datacursorfcn, handles});

% style for total ion chromatogram area plots in background of figures
handles.user.ticstyle = {'FaceColor', [0.85 0.85 0.85], 'EdgeColor', 'none', 'LineStyle', 'none', 'Annotation', 'off'};
% style for mass spectrum time indicator line in chromatograms
handles.user.tidxstyle = {'Color', 'k', 'LineStyle', '--', 'LineWidth', 1};

% some column numbers for handles.user.data.results.peak.data
handles.user.col.z = 3;
handles.user.col.mz = 2;
handles.user.col.RTrange = [15 16];
handles.user.col.mz_apo = 5;
handles.user.col.numMS2 = 6;
handles.user.col.pkmax = 10;

% some column numbers for handles.user.data.results.pattern.pks
handles.user.col.ptrn_mz = 2;
handles.user.col.ptrn_z = 3;

% Update handles structure
guidata(hObject, handles);

% refresh table and axes
refresh(handles, 'all');

% UIWAIT makes ChelomEx_peak_figure wait for user response (see UIRESUME)
uiwait(handles.figure_ChelomEx_peak);

% --- Executes when user attempts to close figure_ChelomEx_peak.
function figure_ChelomEx_peak_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure_ChelomEx_peak (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
    if isequal(get(handles.figure_ChelomEx_peak, 'waitstatus'), 'waiting')
        uiresume(handles.figure_ChelomEx_peak);
    else
        delete(handles.figure_ChelomEx_peak);
    end

% --- Outputs from this function are returned to the command line.
function varargout = ChelomEx_peak_figure_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
    varargout{1} = handles.user.data.results.peak.table.data;
    varargout{2} = handles.user.cancel;
% Delete the figure
    delete(handles.figure_ChelomEx_peak);
    
    
% menu callbacks to accept or discard changes in table and close window
% --------------------------------------------------------------------
function menu_accept_Callback(hObject, eventdata, handles)
% hObject    handle to menu_accept (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    handles.user.cancel = false;
    guidata(hObject, handles);
    uiresume(handles.figure_ChelomEx_peak);
  
function menu_discard_Callback(hObject, eventdata, handles)
% hObject    handle to menu_discard (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    uiresume(handles.figure_ChelomEx_peak);

    
% --- Executes when entered data in editable cell(s) in uitable.
function uitable_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to uitable (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)

    handles.user.data.results.peak.table.data(handles.user.row.current,1) = {eventdata.NewData};
    guidata(hObject,handles);

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

function pushbutton_launch_EIC_pattern_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton_launch_EIC_pattern (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
    set(hObject, 'CData', imread('Arrow_LaunchFigure.jpg','jpg'));

function pushbutton_launch_EIC_species_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton_launch_EIC_species (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
    set(hObject, 'CData', imread('Arrow_LaunchFigure.jpg','jpg'));

function pushbutton_launch_MS_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton_launch_MS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
    set(hObject, 'CData', imread('Arrow_LaunchFigure.jpg','jpg'));

function pushbutton_launch_MSMS_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton_launch_MSMS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
    set(hObject, 'CData', imread('Arrow_LaunchFigure.jpg','jpg'));
    
    
% user function to generate the different plots 
function handles = refresh(handles, type)
% udpate table and axes; 
% type is a string: 'all' or 'MS'; 
% type is set to MS only axes_MS will be updated
    
    % some temporary variables to make referencing easier
    table_data = handles.user.data.results(1).peak.table.data;
    table_header = handles.user.data.results(1).peak.table.header;
    pattern.pks = handles.user.data.results.pattern.pks;
    pattern.pkscore = handles.user.data.results.pattern.pkscore;
    peak.data = handles.user.data.results.peak.data;
    currentPattern = handles.user.parameters.patternID.(handles.user.parameters.currentPattern).pattern;
    
    % use mz and z value from table to get corresponding entry in
    % pattern.pks, pattern.pkpattern and peak.data
    mz = cell2mat(handles.user.data.results.peak.table.data(handles.user.row.current, handles.user.col.mztable));
    z = cell2mat(handles.user.data.results.peak.table.data(handles.user.row.current, handles.user.col.ztable));
    err = max([handles.user.parameters.search.minerr mz*10^-6*handles.user.parameters.search.relerr]);
    
    % find row in pattern.pkscore that corresponds to the current row in peaktable
    mzdiff = [abs(pattern.pks(:, handles.user.col.ptrn_mz) - mz) [1:size(pattern.pks,1)]']; %col1=mz diff; col2=row number
    % use z values that crrespond to current z value in peak.data
    mzdiff = mzdiff(pattern.pks(:, handles.user.col.ptrn_z) == z,:);      
    handles.user.row.ptrn = mzdiff(mzdiff(:,1)==min(mzdiff(:,1)),2);
    handles.user.row.ptrn = handles.user.row.ptrn(1);    
    
    % find row in peak.data that corresponds to the current row in peaktable
    mzdiff = [abs(peak.data(:, handles.user.col.mz) - mz) [1:size(peak.data,1)]']; %col1=mz diff; col2=row number
    % use z values that crrespond to current z value in peak.data
    mzdiff = mzdiff(peak.data(:, handles.user.col.z) == z,:);      
    handles.user.row.pks = mzdiff(mzdiff(:,1)==min(mzdiff(:,1)),2);
    handles.user.row.pks = handles.user.row.pks(1);     
    
    if isequal(type, 'MS')
        cla(handles.axes_MS); hold(handles.axes_MS);
        % set axes labels
        xlabel(handles.axes_MS, 'm/z', 'FontSize', 8); ylabel(handles.axes_EIC_pattern, 'Intensity', 'FontSize', 8);
        % plot pattern
        set(handles.figure_ChelomEx_peak,'CurrentAxes',handles.axes_MS);
        % axis limits
        if handles.user.MS.pushbutton_action == 1   % if function was called by pushbutton then use the xrange and yrange provided from plot_pattern function
            [xrange, yrange, handles.user.MS.monoisotope_data] = plot_pattern(currentPattern, mz, z, err, handles.user.MS.timeidx, 0, handles.user.data.run.pks{1}, handles.user.data.run.ts{1}, handles.user.MS.zoomtype, get(handles.togglebutton_annotation,'Value'));
            set(gca, 'XLim', xrange, 'YLim', yrange);
            zoom reset;
        elseif handles.user.MS.pushbutton_action == 0  % if function was called by left or right arrow buttons then use existing axes limits
            xrange = get(handles.axes_MS, 'XLim');
            yrange = get(handles.axes_MS, 'YLim');
            [~,~,handles.user.MS.monoisotope_data] = plot_pattern(currentPattern, mz, z, err, handles.user.MS.timeidx, 0, handles.user.data.run.pks{1}, handles.user.data.run.ts{1}, handles.user.MS.zoomtype, get(handles.togglebutton_annotation,'Value'));
            set(gca, 'XLim', xrange, 'YLim', yrange);
        end
        
        % change position of line in axes_EIC_pattern and axes_EIC_species
        set(handles.user.t_EIC_pattern, 'XData', [handles.user.data.run.ts{1}(handles.user.MS.timeidx) handles.user.data.run.ts{1}(handles.user.MS.timeidx)],...
                                        'YData', [0 handles.user.EIC_pattern_ymax]);
        set(handles.user.t_EIC_species, 'XData', [handles.user.data.run.ts{1}(handles.user.MS.timeidx) handles.user.data.run.ts{1}(handles.user.MS.timeidx)],...
                                        'YData', [0 handles.user.EIC_species_ymax]);
        % set pushbutton_activation off
        handles.user.MS.pushbutton_action = 0;
        hold(handles.axes_MS);
        
    elseif isequal(type, 'MSMS')
         cla(handles.axes_MSMS1); cla(handles.axes_MSMS2); 
         if ~ishold(handles.axes_MSMS1), hold(handles.axes_MSMS1); end
         if ~ishold(handles.axes_MSMS2), hold(handles.axes_MSMS2); end
        
         % set axes labels
         xlabel(handles.axes_MSMS2, 'm/z', 'FontSize', 8); 
         handles = plotmsms(handles);
         togglebutton_annotation_MSMS_Callback([],[],handles);
         
         hold(handles.axes_MSMS1); hold(handles.axes_MSMS2);
         drawnow;        
         
        
    elseif isequal(type, 'EIC_pattern')         % update axes_EIC_pattern if context_menu_slctplot items are activated         
        num_pgroups = length(currentPattern);
        slctdlg = NaN(length(handles.user.EICptrn.legend),1); slctdlg(1) = 1;
        m = 1;  % do not hide monoisotope (index 1)
        for i = 1:num_pgroups
           switch currentPattern(i).required(1)
               case 11       %required isotope
                   vis = get(handles.context_menu_EICptrn_showplot_required, 'Checked');
                   for j = 1:length(currentPattern(i).dmz)
                       m = m + 1;
                       set(handles.user.EICptrn.h(m), 'Visible', vis);
%                        set(get(get(handles.user.EICptrn.h(m),'Annotation'),'LegendInformation'),...
%                            'IconDisplayStyle',vis); % Exclude line from legend
%                        legend(handles.user.EICptrn.h_lgd);
                       if isequal(vis, 'on')
                           slctdlg(m) = 1;
                       else
                           slctdlg(m) = 0;
                       end 
                   end
               case 12       %optional isotope in peak search
               case 2        %optional
               case 31       %exclude
                   vis = get(handles.context_menu_EICptrn_showplot_exclude, 'Checked');
                   for j = 1:length(currentPattern(i).dmz)
                       m = m + 1;
                       set(handles.user.EICptrn.h(m), 'Visible', vis);
%                        set(get(get(handles.user.EICptrn.h(m),'Annotation'),'LegendInformation'),...
%                            'IconDisplayStyle',vis); % Exclude line from legend
%                        legend(handles.user.EICptrn.h_lgd);
                       if isequal(vis, 'on')
                           slctdlg(m) = 1;
                       else
                           slctdlg(m) = 0;
                       end 
                   end
           end          
        end
        
        % delete those entries that are optional because they are not part
        % of the plot returned by the function ptrn2pk
        slctdlg(isnan(slctdlg)) = [];
        legend(handles.axes_EIC_pattern, handles.user.EICptrn.h(slctdlg == 1), handles.user.EICptrn.legend(slctdlg==1));
    
    elseif isequal(type, 'EIC_species')    
        % plots in axes_EIC_species are intensity sorted 
        % -> just set visibility of lowest intensity plots 
        num_plots = length(handles.user.EICspec.h);
        if num_plots > 3           
            if isequal(get(handles.context_menu_EICspec_showplot_max, 'Checked'),'on')
                    for i=4:num_plots
                        set(handles.user.EICspec.h(i), 'Visible', 'off');
                    end
                    legend(handles.user.EICspec.h(1:3), handles.user.EICspec.legend(1:3));
            else
                    for i=4:num_plots
                        set(handles.user.EICspec.h(i), 'Visible', 'on');
                    end
                    legend(handles.user.EICspec.h(:), handles.user.EICspec.legend(:));
            end
        end   
        
    elseif isequal(type, 'all')
        % find row in pattern.pkscore that corresponds to the current row in peak.data
        mzdiff = [abs(pattern.pks(:, handles.user.col.ptrn_mz) - mz) [1:size(pattern.pks,1)]']; %col1=mz diff; col2=row number
        % use z values that crrespond to current z value in peak.data
        mzdiff = mzdiff(pattern.pks(:, handles.user.col.ptrn_z) == z,:);
        handles.user.row.ptrn = mzdiff(mzdiff(:,1)==min(mzdiff(:,1)),2);
        handles.user.row.ptrn = handles.user.row.ptrn(1);
        % by defalut, plot mass spectrum at time of peak max of detected patterns
        handles.user.MS.pkscore = handles.user.data.results.pattern.pkscore{handles.user.row.ptrn,3};
        handles.user.MS.time = handles.user.MS.pkscore(find(handles.user.MS.pkscore(:,4) == max(handles.user.MS.pkscore(:,4)), 1, 'first'),1);
        % find mass spectrum index that is closest to a given time
        handles.user.MS.tdiff = abs(handles.user.data.run.ts{1}-handles.user.MS.time);
        handles.user.MS.timeidx = find(handles.user.MS.tdiff == min(handles.user.MS.tdiff),1,'first');
        
        % clear all axes and hold axes for multiple plots
        cla(handles.axes_MSMS1); cla(handles.axes_MSMS2); cla(handles.axes_EIC_pattern); cla(handles.axes_EIC_species); cla(handles.axes_MS);
        hold(handles.axes_MSMS1); hold(handles.axes_MSMS2); hold(handles.axes_EIC_pattern); hold(handles.axes_EIC_species); hold(handles.axes_MS);
        
        % pattern chromatogram plot (axes_EIC_pattern)
        % --------------------------------------------
        % set axes labels
        xlabel(handles.axes_EIC_pattern, 'time (s)', 'FontSize', 8); ylabel(handles.axes_EIC_pattern, 'Intensity', 'FontSize', 8);
        set(handles.figure_ChelomEx_peak,'CurrentAxes',handles.axes_EIC_pattern);
        % get TIC
        tc = totalionc(handles.user.data.run.pks{1}, handles.user.data.run.ts{1}, 0);
        % plot TIC 
        h_TIC_ptrn = area(handles.axes_EIC_pattern, tc(:,1),tc(:,2), handles.user.ticstyle{:}); 
        % normalize isotope - area object for popup menu selection, initially empty
        handles.user.EICptrn.h_norm = area(handles.axes_EIC_pattern, 1:2, 1:2, 'Visible', 'off');
        % plot results of ptrn2pk
        [ptrn2pk_results, handles.user.EICptrn.h] = ptrn2pk(currentPattern, handles.user.data.results.pattern,...
                                                            handles.user.parameters.search,...
                                                            handles.user.data.run.pks{1}, handles.user.data.run.ts{1}, 1, [mz z]);
        % change linestyles, annotate isotope IDs and get max. intensity for EICs
        set(handles.user.EICptrn.h(1), 'LineWidth', 0.5, 'LineStyle', '-', 'Marker', '.');
        eicmax = max(get(handles.user.EICptrn.h(1), 'YData'));
        handles.user.EICptrn.legend = cell(length(handles.user.EICptrn.h),1); handles.user.EICptrn.legend{1} = sprintf('%8.4f', mz);
        pkptrn = currentPattern; del = 0;
        for i=1:length(currentPattern)
            if currentPattern(i).required == 2 | currentPattern(i).required == 12
                pkptrn(i-del) = []; del = del+1;
            end
        end
        for i=2:length(handles.user.EICptrn.h)
            set(handles.user.EICptrn.h(i), 'Marker', 'none', 'LineWidth', 0.5, 'LineStyle', '-');
            eicmax = max(eicmax, max(get(handles.user.EICptrn.h(i), 'YData')));
        end
        m=1;
        for i = 1:length(pkptrn)
            for j = 1:length(pkptrn(i).dmz)
                m=m+1;
                handles.user.EICptrn.legend(m) = pkptrn(i).ID(j);
            end
        end
        
        % populate handles.popupmenu_EICptrn_normalize
        set(handles.popupmenu_EICptrn_normalize, 'String', [{'Normalize'}; handles.user.EICptrn.legend(2:size(handles.user.EICptrn.legend,1))]);
        
        % scale TIC to max of EICs
        set(h_TIC_ptrn, 'YData', tc(:,2).*eicmax./max(tc(:,2)));   
        zoom out; zoom reset;
        
        % y max
        handles.user.EIC_pattern_ymax = get(handles.axes_EIC_pattern, 'YLim'); handles.user.EIC_pattern_ymax = handles.user.EIC_pattern_ymax(2);
        % plot line that indicates time of displayed mass spectrum
        handles.user.t_EIC_pattern = line([handles.user.data.run.ts{1}(handles.user.MS.timeidx) handles.user.data.run.ts{1}(handles.user.MS.timeidx)],...
                                          [0 handles.user.EIC_pattern_ymax], handles.user.tidxstyle{:});
        
        % if peak is found: set axis limits to focus on peak
        if peak.data(handles.user.row.pks, handles.user.col.RTrange(2)) ~= 0
            RTlength = peak.data(handles.user.row.pks, handles.user.col.RTrange(2))-peak.data(handles.user.row.pks, handles.user.col.RTrange(1)); 
            handles.user.EICptrn.XRange = [max(0,peak.data(handles.user.row.pks, handles.user.col.RTrange(1))-RTlength*2) min(handles.user.data.run.ts{1}(length(handles.user.data.run.ts{1})),peak.data(handles.user.row.pks, handles.user.col.RTrange(2))+RTlength*2)];
            handles.user.EICptrn.YRange = [0 eicmax*1.3];
            set(gca,'XLim', handles.user.EICptrn.XRange,...
                    'YLim', handles.user.EICptrn.YRange);
        else
            handles.user.EICptrn.XRange = get(gca, 'XLim');
            handles.user.EICptrn.YRange = [0 eicmax*1.3];
            set(gca,'YLim', handles.user.EICptrn.YRange);
        end
        
        % legend
        handles.user.EICptrn.h_lgd = legend(handles.user.EICptrn.h, handles.user.EICptrn.legend);
        
        % if selection is made in popupmenu for isotope normalization, then populate the areaseries object
        popupmenu_EICptrn_normalize_Callback(handles.popupmenu_EICptrn_normalize, [], handles);
        
   
        % species chromatogram plot (axes_EIC_species) 
        % --------------------------------------------
        % set axes labels
        xlabel(handles.axes_EIC_species, 'time (s)', 'FontSize', 8); ylabel(handles.axes_EIC_species, 'Intensity','FontSize', 8);
        set(handles.figure_ChelomEx_peak,'CurrentAxes',handles.axes_EIC_species);
        % plot TIC 
        h_TIC_spec = area(handles.axes_EIC_species, tc(:,1),tc(:,2), handles.user.ticstyle{:});             
        % plot results of search_species
        set(handles.figure_ChelomEx_peak,'CurrentAxes',handles.axes_EIC_species);  
        species_all = handles.user.data.results.peak.apos.foundspecies{handles.user.row.pks};
        if ~isempty(species_all)
            switch handles.user.table.type
                case 'Untargeted' 
                    % in case of untargeted search: show only related species
                    species_related = species_all(cell2mat(species_all(:,size(species_all,2))) == 1,:);
                case 'Manual'
                    % in case of targeted search: show all found species 
                    species_related = species_all;
                case 'Database'
                    species_related = species_all;
            end
                         
            if ~isempty(species_related)
                [~, ~, ~, handles.user.EICspec.h] = eic([mz; cell2mat(species_related(:,2))],handles.user.parameters.search.relerr,handles.user.parameters.search.minerr,handles.user.data.run.pks{1},handles.user.data.run.ts{1},1);
                for n=1:size(species_related,1)
                    species_related{n,1} = sprintf('%10s\n %10.4f', species_related{n,1}, cell2mat(species_related(n,2)));
                end
                handles.user.EICspec.legend = [sprintf('%10.4f',mz); species_related(:,1)];
            else
                [~, ~, ~, handles.user.EICspec.h] = eic([mz; cell2mat(species_all(:,2))],handles.user.parameters.search.relerr,handles.user.parameters.search.minerr,handles.user.data.run.pks{1},handles.user.data.run.ts{1},1);
                for n=1:size(species_all,1)
                    species_all{n,1} = sprintf('%10s\n %10.4f', species_all{n,1}, cell2mat(species_all(n,2)));
                end
                handles.user.EICspec.legend = [sprintf('%10.4f',mz); species_all(:,1)];
            end
        else
            [~, ~, ~, handles.user.EICspec.h] = eic(mz,handles.user.parameters.search.relerr,handles.user.parameters.search.minerr,handles.user.data.run.pks{1},handles.user.data.run.ts{1},1);
            handles.user.EICspec.legend = sprintf('%10.4f',mz);
        end
        
        % add legend 
        legend(handles.user.EICspec.h(:),handles.user.EICspec.legend);
        % change linestyles and get max. intensity for EICs
        set(handles.user.EICspec.h(1), 'LineWidth', 0.5, 'LineStyle', '-', 'Marker', '.');
        eicmax = max(get(handles.user.EICspec.h(1), 'YData'));
        for i=2:length(handles.user.EICspec.h)
            set(handles.user.EICspec.h(i), 'Marker', 'none', 'LineWidth', 0.5, 'LineStyle', '-');
            eicmax = max(eicmax, max(get(handles.user.EICspec.h(i), 'YData')));
        end
        % scale TIC to max of EICs
        set(h_TIC_spec, 'YData', tc(:,2).*eicmax./max(tc(:,2)));        
        zoom out; zoom reset;
        % y max
        handles.user.EIC_species_ymax = get(handles.axes_EIC_species, 'YLim'); handles.user.EIC_species_ymax = handles.user.EIC_species_ymax(2);
        % plot line to indicate time of displayed mass spectrum
        handles.user.t_EIC_species = line([handles.user.data.run.ts{1}(handles.user.MS.timeidx) handles.user.data.run.ts{1}(handles.user.MS.timeidx)],...
                                          [0 handles.user.EIC_species_ymax], handles.user.tidxstyle{:});
        
        % set axis limits to focus on peak
        set(gca,'XLim', handles.user.EICptrn.XRange,...
                'YLim', [0 eicmax*1.3]);
        
            
        % Mass specrum plot (axes_MS)
        % ----------------------------
        % set axes labels
        xlabel(handles.axes_MS, 'm/z', 'FontSize', 8); ylabel(handles.axes_MS, 'Intensity', 'FontSize', 8);
       
        % plot mass spectrum (axes_MS)
        set(handles.figure_ChelomEx_peak,'CurrentAxes',handles.axes_MS);
        [xrange, yrange, handles.user.MS.monoisotope_data] = plot_pattern(currentPattern, mz, z, err, handles.user.MS.timeidx, 0, handles.user.data.run.pks{1}, handles.user.data.run.ts{1}, handles.user.MS.zoomtype, get(handles.togglebutton_annotation,'Value'));
        set(gca, 'XLim', xrange, 'YLim', yrange);
        zoom reset;
        
        % MS/MS plot (axes_MSMS1 and axes_MSMS2) 
        % ------------------------------ 
        % set axes labels
        xlabel(handles.axes_MSMS2, 'm/z', 'FontSize', 8); %ylabel(handles.axes_MSMS2, 'Intensity', 'FontSize', 8, 'Visible', 'off');
        %xlabel(handles.axes_MSMS1, 'm/z', 'FontSize', 8, 'Visible', 'off'); ylabel(handles.axes_MSMS1, 'Intensity', 'FontSize', 8, 'Visible', 'off');
        
        species_all = handles.user.data.results.peak.apos.foundspecies{handles.user.row.pks};
        if (length(handles.user.data.run.pks) > 1) & ~isempty(species_all)  %MSMS dataset exists and species were found
            % make axes visible and hide static textbox
            set(handles.static_noMS2, 'Visible', 'off');
            set(handles.axes_MSMS1, 'Visible', 'on'); set(handles.axes_MSMS2, 'Visible', 'on');
            set(handles.togglebutton_annotation_MSMS, 'Visible', 'on');
            set(handles.pushbutton_MSMS_next, 'Visible', 'on');
            set(handles.pushbutton_MSMS_previous, 'Visible', 'on');
            
            % list and index for selected apo species with exisiting common MS/MS spectra
            handles.user.MSMS.list = species_all(cell2mat(species_all(:,9)) > 0,:);
            if isempty(handles.user.MSMS.list)
                handles.user.MSMS.list = species_all(1,:);
            end
            handles.user.MSMS.idx = 1;   
            handles.user.MSMS.maxidx = size(handles.user.MSMS.list,1);
            
            % activate or deactivate buttons to select apomz value
            set(handles.pushbutton_MSMS_previous, 'Enable','off');
            if handles.user.MSMS.idx < handles.user.MSMS.maxidx
                set(handles.pushbutton_MSMS_next, 'Enable','on');
            else 
                set(handles.pushbutton_MSMS_next, 'Enable','off');
            end
            
            handles = plotmsms(handles);
            if isempty(handles.user.MSMS.data)
                set(handles.static_noMS2, 'Visible', 'on');
                set(handles.togglebutton_annotation_MSMS, 'Visible', 'off');
                set(handles.axes_MSMS1, 'Visible', 'off'); set(handles.axes_MSMS2, 'Visible', 'off');
                set(handles.pushbutton_MSMS_next, 'Visible', 'off');
                set(handles.pushbutton_MSMS_previous, 'Visible', 'off');
            else 
                togglebutton_annotation_MSMS_Callback([],[],handles);
            end
        else        % no MSMS data found
                % hide MSMS axes and show static textbox message
            set(handles.static_noMS2, 'Visible', 'on');
            set(handles.togglebutton_annotation_MSMS, 'Visible', 'off');
            set(handles.axes_MSMS1, 'Visible', 'off'); set(handles.axes_MSMS2, 'Visible', 'off');
            set(handles.pushbutton_MSMS_next, 'Visible', 'off');
            set(handles.pushbutton_MSMS_previous, 'Visible', 'off');
        end
        
        %release hold
        hold(handles.axes_MSMS1);hold(handles.axes_MSMS2); hold(handles.axes_EIC_pattern); hold(handles.axes_EIC_species); hold(handles.axes_MS);

        % udpate table with current row
        set(handles.uitable, 'Data', table_data(handles.user.row.current,1:length(table_header)));
        
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
    
    end
    
    drawnow;
    % update handles for data cursor function
    set(handles.toolbar.dcm_obj,'UpdateFcn',{@datacursorfcn, handles});
    guidata(handles.figure_ChelomEx_peak, handles); 

    
function handles = plotmsms(handles)
        % some variables for easier referencing
        mz = cell2mat(handles.user.data.results.peak.table.data(handles.user.row.current, handles.user.col.mztable)); %complex mz
        peak.data = handles.user.data.results.peak.data;
        
        % get MSMS spectra and compare spectra
        apomz =  cell2mat(handles.user.MSMS.list(handles.user.MSMS.idx,2));
        tMax = handles.user.data.run.ts{1}(length(handles.user.data.run.ts{1}));
        MS1err = max(handles.user.parameters.search.relerr*10^-6*mz, handles.user.parameters.search.minerr);
        [foundMS2num, MSMSdata] = findapoMS2(mz, peak.data(handles.user.row.pks,handles.user.col.RTrange),...
                        apomz, [0 tMax], MS1err,...
                        handles.user.parameters.search.MS2err, handles.user.parameters.search.MS2noise,...
                        handles.user.data.run.pks{2}, handles.user.data.run.ts{2}, 0);
        if foundMS2num == 0
            [foundMS2numRT, MSMSdataRT] = findapoMS2(mz, peak.data(handles.user.row.pks,handles.user.col.RTrange),...
                        apomz, peak.data(handles.user.row.pks, handles.user.col.RTrange), MS1err,...
                        handles.user.parameters.search.MS2err, handles.user.parameters.search.MS2noise,...
                        handles.user.data.run.pks{2}, handles.user.data.run.ts{2}, 0);
        end
        if foundMS2num > 0 | (foundMS2num == 0 & foundMS2numRT == 0)
            handles.user.MSMS.data = MSMSdata;
        else
            handles.user.MSMS.data = MSMSdataRT;
        end  
            
        % plot spectra          
        handles.user.MSMS.h_text = [];
        if ~isempty(handles.user.MSMS.data)  
            maxMS2pk = handles.user.MSMS.data.common.maxMS2pk;
            set(handles.figure_ChelomEx_peak,'CurrentAxes',handles.axes_MSMS1);
            set(gca,'xticklabel',[], 'YTick', [0 1], 'YMinorTick', 'on', 'YLim', [0 1.5]);
            plotms([handles.user.MSMS.data.MS2(1).spectrum(:,1) handles.user.MSMS.data.MS2(1).spectrum(:,2)./maxMS2pk(1)] , 'b', 0);  range = xlim;
            % y axis label as text, used for both axis in MSMS 
            text(range(1)-(range(2)-range(1))*0.075, 0, 'Relative Intensity', 'Rotation', 90, 'FontSize', 8, 'HorizontalAlignment', 'center'); 

            if ~isempty(handles.user.MSMS.data.common.spectrum)
                for i = 1:size(handles.user.MSMS.data.common.spectrum,1)
                    if handles.user.MSMS.data.common.s == 1
                        h_arrow = annotation('arrow', 'HeadStyle', 'vback2', 'HeadLength', 20, 'HeadWidth', range(2)*10); set(h_arrow,'Parent', gca);
                        x =handles.user.MSMS.data.common.spectrum(i,1); y = (handles.user.MSMS.data.common.spectrum(i,2)+0.15);
                        dx = 0; dy = -abs((handles.user.MSMS.data.common.spectrum(i,2)+0.05)-y);
                        set(h_arrow, 'Position', [x y dx dy]);                       
                        handles.user.MSMS.h_text(length(handles.user.MSMS.h_text)+1) = text(x,y,sprintf('%8.4f', handles.user.MSMS.data.common.spectrum(i,1)), 'FontSize', 7, 'Color', 'k', 'HorizontalAlignment', 'center',  'VerticalAlignment', 'bottom');
                    elseif handles.user.MSMS.data.common.s == 2 
                        h_arrow = annotation('arrow', 'HeadStyle', 'vback2', 'HeadLength', 20, 'HeadWidth', range(2)*10); set(h_arrow,'Parent', gca);
                        x =handles.user.MSMS.data.common.spectrum(i,1); y = (handles.user.MSMS.data.common.spectrum(i,2)+0.15);
                        dx = 0; dy = -abs((handles.user.MSMS.data.common.spectrum(i,2)+0.05)-y);
                        set(h_arrow, 'Position', [x y dx dy]);
                        handles.user.MSMS.h_text(length(handles.user.MSMS.h_text)+1) = text(x,y,sprintf('%0s\n %+7.4f', '\Deltam/z', handles.user.MSMS.data.common.spectrum(i,1)-handles.user.MSMS.data.common.spectrum(i,3)), 'FontSize', 7, 'Color', 'k', 'HorizontalAlignment', 'center',  'VerticalAlignment', 'bottom');
                    end
                end
            end
            % precursor m/z, maxInt and Time 
            handles.user.MSMS.h_text(length(handles.user.MSMS.h_text)+1) = text(range(2), 0.9, sprintf('%0s\n %0s %8.4f\n %0s %5.0f\n %0s %2.1E', 'Precursor', 'm/z=', handles.user.MSMS.data.MS2(1).precursor(3),'t(s)=', handles.user.MSMS.data.MS2(1).precursor(2), 'I_{max}=', maxMS2pk(1)),'FontSize', 7, 'HorizontalAlignment', 'right');
            if ~isempty(handles.user.MSMS.data.MS2(1))
                set(gca, 'XLim', range);
            end

            set(handles.figure_ChelomEx_peak,'CurrentAxes',handles.axes_MSMS2); 
            set(gca, 'YTick', [0 1], 'YMinorTick', 'on', 'YLim', [0 1.5]);
            if ~ishold(handles.axes_MSMS2), hold(handles.axes_MSMS2); end
            plotms([handles.user.MSMS.data.MS2(2).spectrum(:,1) handles.user.MSMS.data.MS2(2).spectrum(:,2)./maxMS2pk(2)], 'r', 0); xlim(range);
            if ~isempty(handles.user.MSMS.data.common.spectrum)
                for i = 1:size(handles.user.MSMS.data.common.spectrum,1)
                    if handles.user.MSMS.data.common.s == 2
                        h_arrow = annotation('arrow', 'HeadStyle', 'vback2', 'HeadLength', 20, 'HeadWidth', range(2)*10); set(h_arrow,'Parent', gca);
                        x =handles.user.MSMS.data.common.spectrum(i,3); y = (handles.user.MSMS.data.common.spectrum(i,4)+0.15);
                        dx = 0; dy = -abs((handles.user.MSMS.data.common.spectrum(i,4)+0.05)-y);
                        set(h_arrow, 'Position', [x y dx dy]);                       
                        handles.user.MSMS.h_text(length(handles.user.MSMS.h_text)+1) = text(x,y,sprintf('%8.4f', handles.user.MSMS.data.common.spectrum(i,3)), 'FontSize', 7, 'Color', 'k', 'HorizontalAlignment', 'center',  'VerticalAlignment', 'bottom');
                    elseif handles.user.MSMS.data.common.s == 1 
                        h_arrow = annotation('arrow', 'HeadStyle', 'vback2', 'HeadLength', 20, 'HeadWidth', range(2)*10); set(h_arrow,'Parent', gca);
                        x =handles.user.MSMS.data.common.spectrum(i,3); y = (handles.user.MSMS.data.common.spectrum(i,4)+0.15);
                        dx = 0; dy = -abs((handles.user.MSMS.data.common.spectrum(i,4)+0.05)-y);
                        set(h_arrow, 'Position', [x y dx dy]);
                        handles.user.MSMS.h_text(length(handles.user.MSMS.h_text)+1) = text(x,y,sprintf('%0s\n %+7.4f', '\Deltam/z', handles.user.MSMS.data.common.spectrum(i,3)-handles.user.MSMS.data.common.spectrum(i,1)), 'FontSize', 7, 'Color', 'k', 'HorizontalAlignment', 'center',  'VerticalAlignment', 'bottom');
                    end
                end                   
            end
            % precursor m/z, maxInt and Time
            %mzID = handles.user.data.results.peak.apos.foundspecies{handles.user.row.pks}(cell2mat(handles.user.data.results.peak.apos.foundspecies{handles.user.row.pks}(:,2)) == handles.user.MSMS.data.MS2(2).precursor(3),1);
            handles.user.MSMS.h_text(length(handles.user.MSMS.h_text)+1) = text(range(2), 0.9, sprintf('%0s\n %0s %8.4f\n (%0s)\n %0s %5.0f\n %0s %2.1E', 'Precursor', 'm/z=', handles.user.MSMS.data.MS2(2).precursor(3), handles.user.MSMS.list{handles.user.MSMS.idx,1}, 't(s)=', handles.user.MSMS.data.MS2(2).precursor(2), 'I_{max}=', maxMS2pk(2)),'FontSize', 7, 'HorizontalAlignment', 'right');
            set(gca, 'XLim', range);    
        end
    
% --- controls to select a species from the table to display ---
% pushbuttons
function handles = pushbutton_previous_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_previous (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    if handles.user.row.index > 1 
        handles.user.row.index = handles.user.row.index - 1;      
        handles.user.row.current = handles.user.row.slct(handles.user.row.index);
        handles = refresh(handles, 'all');  
        handles = refresh(handles, 'EIC_pattern');
        handles = refresh(handles, 'EIC_species');
        guidata(hObject, handles);
    end
    
function handles = pushbutton_next_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_next (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    if handles.user.row.index < handles.user.row.rownum
        handles.user.row.index = handles.user.row.index + 1;      
        handles.user.row.current = handles.user.row.slct(handles.user.row.index);
        handles = refresh(handles, 'all');
        handles = refresh(handles, 'EIC_pattern');
        handles = refresh(handles, 'EIC_species');
        guidata(hObject, handles);
    end
    
   
% keyboard control, also to select currently displayed mass spectrum 
function figure_ChelomEx_peak_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to figure_ChelomEx_peak (see GCBO)
% eventdata  structure with the following fields (see FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
%  handles    structure with handles and user data (see GUIDATA)
    
    switch eventdata.Key
        case 'uparrow'     % up arrow: previous m/z
            handles = pushbutton_previous_Callback(hObject, [], handles);
        case 'downarrow'     % down arrow: next m/z
            handles = pushbutton_next_Callback(hObject, [], handles);
        case 'leftarrow'     % left arrow: previous mass spectrum
            set(handles.toolbar_zoom, 'Enable', 'off');
            if handles.user.MS.timeidx > 1
                
                handles.user.MS.timeidx = handles.user.MS.timeidx - 1;
                handles.user.MS.pushbutton_action = 0;
                handles = refresh(handles, 'MS'); 
            end        
        case 'rightarrow'     % right arrow: next mass spectrum
            set(handles.toolbar_zoom, 'Enable', 'off');
            if handles.user.MS.timeidx < size(handles.user.data.run.ts{1},1)
                handles.user.MS.timeidx = handles.user.MS.timeidx + 1;
                handles.user.MS.pushbutton_action = 0;
                handles = refresh(handles, 'MS'); 
            end
        case 'shift'
            pan yon
        case 'control'
            pan xon
        
            
    end
    guidata(hObject, handles);
    
    
    
% --- Controls to change EIC pattern plot ---
% Popupmenu to select isotope for normalization in exes_EIC_pattern
function popupmenu_EICptrn_normalize_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_EICptrn_normalize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_EICptrn_normalize contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_EICptrn_normalize

    handles.user.EICptrn.normidx = get(hObject, 'Value');
    if handles.user.EICptrn.normidx == 1
        set(handles.user.EICptrn.h_norm, 'Visible', 'off');
    elseif handles.user.EICptrn.normidx > 1                                     
        idata = [get(handles.user.EICptrn.h(handles.user.EICptrn.normidx),'XData')' get(handles.user.EICptrn.h(handles.user.EICptrn.normidx),'YData')'];
        pkrange_t = handles.user.data.results.peak.data(handles.user.row.pks, handles.user.col.RTrange);
        pkrange_row(1) = find(handles.user.data.run.ts{1}-pkrange_t(1) >= 0, 1, 'first');
        if pkrange_t(2) == 0  % no peak was found, there fore peakstart and peakend are 0
            idata(:,2) = idata(:,2) ./ max(idata(:,2)) .* max(get(handles.user.EICptrn.h(1),'YData'));
        else
            pkrange_row(2) = find(handles.user.data.run.ts{1}-pkrange_t(2) >= 0, 1, 'first')-1;
            pkmax =  handles.user.data.results.peak.data(handles.user.row.pks, handles.user.col.pkmax);
            idata(:,2) = idata(:,2) ./ max(idata(pkrange_row(1):pkrange_row(2),2)) .* pkmax;
        end
        
        fillcolor = rgb2hsl(get(handles.user.EICptrn.h(handles.user.EICptrn.normidx),'Color')); fillcolor(3) = 0.95;
        fillcolor = hsl2rgb(fillcolor);
        set(handles.user.EICptrn.h_norm, 'XData', idata(:,1), 'YData', idata(:,2),...
            'EdgeColor', get(handles.user.EICptrn.h(handles.user.EICptrn.normidx),'Color'),...
            'FaceColor', fillcolor,...
            'Visible', 'on');
        set(handles.axes_EIC_pattern, 'XLim', handles.user.EICptrn.XRange,...
                                      'YLim', handles.user.EICptrn.YRange);
    end
    guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function popupmenu_EICptrn_normalize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_EICptrn_normalize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

    
    
% --- Controls to change Mass Spectrum ----
% --- Executes when selected object is changed in uipanel_MS.
function uipanel_MS_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uipanel_MS 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
 % handles    structure with handles and user data (see GUIDATA)

% 
%     switch get(get(handles.uipanel_MS, 'SelectedObject'), 'Tag')
%         case 'togglebutton_annotation'
%             get(handles.togglebutton_annotation, 'Value')
%             if get(handles.togglebutton_annotation, 'Value') == 1
%                 set(handles.togglebutton_annotation, 'Value', 0);
%                 handles.user.MS.pushbutton_action = 0;
%                 refresh(handles,'MS');
%             elseif get(handles.togglebutton_annotation, 'Value') == 0
%                 set(handles.togglebutton_annotation, 'Value', 1);
%                 handles.user.MS.pushbutton_action = 0;
%                 refresh(handles,'MS');
%             end
%         case 'radiobutton_species'
%             get(handles.togglebutton_annotation, 'Value')
%         
%             
%         case 'radiobutton_isotopes'
%              get(handles.togglebutton_annotation, 'Value')
%     end
%     
%     guidata(hObject, handles);
    
function pushbutton_unzoom_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_unzoom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    handles.user.MS.zoomtype = 'unzoom';
    handles.user.MS.pushbutton_action = 1;
    refresh(handles,'MS');

function pushbutton_zoomOut_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_zoomOut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    handles.user.MS.zoomtype = 'zoomOut';
    handles.user.MS.pushbutton_action = 1;
    refresh(handles,'MS');

function pushbutton_zoomIn_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_zoomIn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    handles.user.MS.zoomtype = 'zoomIn';
    handles.user.MS.pushbutton_action = 1;
    refresh(handles,'MS');

function togglebutton_annotation_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton_annotation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton_annotation
    handles.user.MS.pushbutton_action = 0;
    refresh(handles,'MS');

    
 % Controls to change MSMS plot
function togglebutton_annotation_MSMS_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton_annotation_MSMS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    if get(handles.togglebutton_annotation_MSMS, 'Value') == 0
        vis = 'off';
    else
        vis = 'on';
    end
    for i = 1:length(handles.user.MSMS.h_text)
        set(handles.user.MSMS.h_text(i), 'Visible', vis);
    end


function pushbutton_MSMS_previous_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_MSMS_previous (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    handles.user.MSMS.idx = handles.user.MSMS.idx-1;   
    
    % activate or deactivate buttons to select apomz value
    set(handles.pushbutton_MSMS_next, 'Enable', 'on');
    if handles.user.MSMS.idx > 1
        set(handles.pushbutton_MSMS_previous, 'Enable','on');
    else
        set(handles.pushbutton_MSMS_previous, 'Enable','off');
    end
    
    refresh(handles, 'MSMS');
   


function pushbutton_MSMS_next_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_MSMS_next (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    handles.user.MSMS.idx = handles.user.MSMS.idx+1;   
    
    % activate or deactivate buttons to select apomz value
    set(handles.pushbutton_MSMS_previous, 'Enable', 'on');
    if handles.user.MSMS.idx < handles.user.MSMS.maxidx
        set(handles.pushbutton_MSMS_next, 'Enable','on');
    else
        set(handles.pushbutton_MSMS_next, 'Enable','off');
    end
    
    refresh(handles, 'MSMS');


% Hint: get(hObject,'Value') returns toggle state of togglebutton_annotation_MSMS
% --- Pushbuttons to launch a figure in a new window for editing and saving
function pushbutton_launch_EIC_pattern_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_launch_EIC_pattern (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    launch_figure(handles.axes_EIC_pattern, 'Found patterns vs. found EIC peaks', handles);
    
function pushbutton_launch_EIC_species_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_launch_EIC_species (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    launch_figure(handles.axes_EIC_species, 'Related Species EICs', handles);

function pushbutton_launch_MS_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_launch_MS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    launch_figure(handles.axes_MS, 'Mass Spectrum (MS)', handles);

function pushbutton_launch_MSMS_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_launch_MSMS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    launch_figure([handles.axes_MSMS2 handles.axes_MSMS1], 'Mass Spectra (MS/MS)', handles);


% function to launch figure in new window; h = axis handle; name = figure name
function launch_figure(h, name, handles)
    if length(h) == 1
        undock_fig = figure;
        % customize data cursor tool
        dcm_obj = datacursormode(undock_fig);
        set(dcm_obj,'UpdateFcn',{@datacursorfcn, handles});

        undock_axes = copyobj(h, undock_fig);
        set(0,'CurrentFigure',undock_fig);
        set(gcf, 'Name', name);
        figpos = get(undock_fig, 'Position');
        set(undock_axes, 'Position', [50 50 figpos(3)-80 figpos(4)-80]);
        set(undock_axes, 'Units', 'normalized');
    else
        undock_fig = figure;
        % customize data cursor tool
        dcm_obj = datacursormode(undock_fig);
        set(dcm_obj,'UpdateFcn',{@datacursorfcn, handles});
        
        set(0,'CurrentFigure',undock_fig);
        set(gcf, 'Name', name);
        figpos = get(undock_fig, 'Position');
        
        for i = length(h):-1:1
            undock_axes(i) = copyobj(h(i), undock_fig);
            set(undock_axes(i), 'Position', [50 50+(i-1)*(figpos(4)-80)/2 figpos(3)-80 (figpos(4)-90)/length(h)]);
            set(undock_axes(i), 'Units', 'normalized');
        end
    end
        
 

% context menu to choose which EICs to plot in axes_EIC_pattern
function context_menu_EICptrn_showplot_required_Callback(hObject, eventdata, handles)
% hObject    handle to context_menu_EICptrn_showplot_required (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    if isequal(get(handles.context_menu_EICptrn_showplot_required,'Checked'), 'on');
        set(handles.context_menu_EICptrn_showplot_required, 'Checked', 'off');
        refresh(handles, 'EIC_pattern');
    else
        set(handles.context_menu_EICptrn_showplot_required, 'Checked', 'on');
        refresh(handles, 'EIC_pattern');
    end

function context_menu_EICptrn_showplot_exclude_Callback(hObject, eventdata, handles)
% hObject    handle to context_menu_EICptrn_showplot_exclude (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    if isequal(get(handles.context_menu_EICptrn_showplot_exclude,'Checked'), 'on');
        set(handles.context_menu_EICptrn_showplot_exclude, 'Checked', 'off');
        refresh(handles, 'EIC_pattern');
    else
        set(handles.context_menu_EICptrn_showplot_exclude, 'Checked', 'on');
        refresh(handles, 'EIC_pattern');
    end

function context_menu_EICptrn_showplot_Callback(hObject, eventdata, handles)
% hObject    handle to context_menu_EICptrn_showplot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% context menu to choose which EICs to plot in axes_EIC_species
function context_menu_EICspec_showplot_max_Callback(hObject, eventdata, handles)
% hObject    handle to context_menu_EICspec_showplot_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    if isequal(get(handles.context_menu_EICspec_showplot_max, 'Checked'), 'on')
       set(handles.context_menu_EICspec_showplot_max, 'Checked', 'off');
       set(handles.context_menu_EICspec_showplot_all, 'Checked', 'on');
       refresh(handles, 'EIC_species');
    elseif isequal(get(handles.context_menu_EICspec_showplot_max, 'Checked'), 'off')
       set(handles.context_menu_EICspec_showplot_max, 'Checked', 'on');
       set(handles.context_menu_EICspec_showplot_all, 'Checked', 'off');
       refresh(handles, 'EIC_species'); 
    end

function context_menu_EICspec_showplot_all_Callback(hObject, eventdata, handles)
% hObject    handle to context_menu_EICspec_showplot_all (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    if isequal(get(handles.context_menu_EICspec_showplot_all, 'Checked'), 'on')
       set(handles.context_menu_EICspec_showplot_max, 'Checked', 'on');
       set(handles.context_menu_EICspec_showplot_all, 'Checked', 'off');
       refresh(handles, 'EIC_species');
    elseif isequal(get(handles.context_menu_EICspec_showplot_all, 'Checked'), 'off')
       set(handles.context_menu_EICspec_showplot_max, 'Checked', 'off');
       set(handles.context_menu_EICspec_showplot_all, 'Checked', 'on');
       refresh(handles, 'EIC_species'); 
    end

function context_menu_EICspec_showplot_Callback(hObject, eventdata, handles)
% hObject    handle to context_menu_EICspec_showplot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes when figure_ChelomEx_peak is resized.
function figure_ChelomEx_peak_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to figure_ChelomEx_peak (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    fposnew = get(hObject, 'Position');      
    if ~isfield(handles, 'user')
        handles.user.fposold = fposnew;
        handles.user.fposold = get(hObject, 'Position');
        axes_MS = get(handles.axes_MS, 'Position');
        axes_MSMS = get(handles.axes_MSMS1, 'Position');
        handles.user.hratio = axes_MSMS(4)/axes_MS(4);
    end
    dypos = fposnew(4)-handles.user.fposold(4);
    dxpos = fposnew(3)-handles.user.fposold(3);
    
    % change y positions
    uicontrolist = {'pushbutton_previous' 'pushbutton_next'};
    for i = 1:length(uicontrolist)
        uipos = get(handles.(uicontrolist{i}), 'Position');
        uipos(2) = uipos(2) + dypos;
        set(handles.(uicontrolist{i}), 'Position', uipos);
    end      
    % change x positions
    uicontrolist = {'pushbutton_previous' 'pushbutton_next'};
    for i = 1:length(uicontrolist)
        uipos = get(handles.(uicontrolist{i}), 'Position');
        uipos(1) = uipos(1) + dxpos;
        set(handles.(uicontrolist{i}), 'Position', uipos);
    end     
    % adjust table size
    uipos = get(handles.uitable, 'Position');  
    uipos(2) = uipos(2) + dypos;
    set(handles.uitable, 'Position', [37 uipos(2) fposnew(3)-94 95]);
    % adjust size and position of axes 
    uipos = get(handles.axes_EIC_pattern, 'Position');
    xspace = handles.user.fposold(3) - 2*uipos(3);
    yspace = handles.user.fposold(4) - 2*uipos(4);
    dw = (fposnew(3)-xspace)/2 - uipos(3);
    dh = (fposnew(4)-yspace)/2 - uipos(4);
    
    uipos = get(handles.axes_EIC_pattern, 'Position');
    set(handles.axes_EIC_pattern, 'Position', uipos + [0 dh dw dh]);
    uipos = get(handles.static_EIC_pattern, 'Position');
    set(handles.static_EIC_pattern, 'Position', uipos + [dw dh*2 0 0]);
    uipos = get(handles.pushbutton_launch_EIC_pattern, 'Position');
    set(handles.pushbutton_launch_EIC_pattern, 'Position', uipos + [dw dh*2 0 0]);
    uipos = get(handles.popupmenu_EICptrn_normalize, 'Position');
    set(handles.popupmenu_EICptrn_normalize, 'Position', uipos + [0 dh*2 0 0]);   
    
    uipos = get(handles.axes_EIC_species, 'Position');
    set(handles.axes_EIC_species, 'Position', uipos + [0 0 dw dh]);  
    uipos = get(handles.static_EIC_species, 'Position');
    set(handles.static_EIC_species, 'Position', uipos + [dw dh 0 0]);
    uipos = get(handles.pushbutton_launch_EIC_species, 'Position');
    set(handles.pushbutton_launch_EIC_species, 'Position', uipos + [dw dh 0 0]);
    
    uipos = get(handles.axes_MS, 'Position');
    set(handles.axes_MS, 'Position', uipos + [dw dh dw dh]);
    uipos = get(handles.static_MS, 'Position');
    set(handles.static_MS, 'Position', uipos + [dxpos dh*2 0 0])
    uipos = get(handles.pushbutton_launch_MS, 'Position');
    set(handles.pushbutton_launch_MS, 'Position', uipos + [dxpos dh*2 0 0]);
    uipos = get(handles.uipanel_MS, 'Position');
    set(handles.uipanel_MS, 'Position', uipos + [dxpos dh*2 0 0]);
    uipos = get(handles.uipanel_MS_pushbuttons, 'Position');
    set(handles.uipanel_MS_pushbuttons, 'Position', uipos + [dxpos dh*2 0 0]);
    
    uipos = get(handles.axes_MSMS2, 'Position');
    set(handles.axes_MSMS2, 'Position', uipos + [dw 0 dw dh*handles.user.hratio]);   
    uipos = get(handles.static_MSMS, 'Position');
    set(handles.static_MSMS, 'Position', uipos + [dxpos dh 0 0]);
    uipos = get(handles.pushbutton_launch_MSMS, 'Position');
    set(handles.pushbutton_launch_MSMS, 'Position', uipos + [dxpos dh 0 0]);
    uipos = get(handles.pushbutton_MSMS_previous, 'Position');
    set(handles.pushbutton_MSMS_previous, 'Position', uipos + [dxpos dh 0 0]);
    uipos = get(handles.pushbutton_MSMS_next, 'Position');
    set(handles.pushbutton_MSMS_next, 'Position', uipos + [dxpos dh 0 0]);
        
    uipos = get(handles.axes_MSMS1, 'Position');
    set(handles.axes_MSMS1, 'Position', uipos + [dw dh*105/220 dw dh*handles.user.hratio]);  
    uipos = get(handles.togglebutton_annotation_MSMS, 'Position');
    set(handles.togglebutton_annotation_MSMS, 'Position', uipos + [dxpos dh 0 0]);
    
    uipos = get(handles.static_noMS2, 'Position');
    set(handles.static_noMS2, 'Position', uipos + [dxpos dh 0 0]);
    
    handles.user.fposold = fposnew;
    
    guidata(hObject, handles);

    
% datacursorfcn exists also as separate .m file. here slight modifications
% to allow display of MSMS spectra without axis labels
function txt = datacursorfcn(empty,event_obj,handles)
% --- executes when data selection tool is used in any of the plots ---
% customize text in data tip
    pos = get(event_obj,'Position');
    X_Label = get(get(gca, 'XLabel'), 'String');
    if isempty(X_Label) | isequal(X_Label, 'm/z')
        dmz = pos(1) - handles.user.MS.monoisotope_data(1,1);
        IRel = pos(2) / handles.user.MS.monoisotope_data(1,2) * 100;
        txt = {sprintf('%0s %8.4f','m/z= ', pos(1)), sprintf('%0s %1.2E', 'Intensity= ', pos(2)),...
               sprintf('%0s %8.4f','delta m/z= ', dmz), sprintf('%0s %5.1f %0s', 'Rel. Int.= ', IRel, ' %')};    
    elseif isequal(X_Label, 'time (s)')
        txt = {sprintf('%0s %4.1f','time (s)= ', pos(1)), sprintf('%0s %1.2E', 'Intensity= ', pos(2))};
    end    
    
       
% functions to use Matlab Toolbar if UIWAIT is activated
function uitoggletool_zoomIn_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uitoggletool_zoomIn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
  if isequal(get(handles.toolbar_zoom, 'Enable'), 'off') ||...
     isequal(get(handles.toolbar_zoom, 'Direction'), 'out')
        set(handles.toolbar_zoom, 'Enable','on', 'Direction', 'in')
        set(handles.toolbar_zoom, 'RightClickAction', 'InverseZoom');
  else
        set(handles.toolbar_zoom, 'Enable', 'off')
  end

  
function uitoggletool_zoomOut_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uitoggletool_zoomOut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
  if isequal(get(handles.toolbar_zoom, 'Enable'), 'off') ||...
     isequal(get(handles.toolbar_zoom, 'Direction'), 'in')
        set(handles.toolbar_zoom, 'Enable','on', 'Direction', 'out')
        set(handles.toolbar_zoom, 'RightClickAction', 'InverseZoom');
  else
        set(handles.toolbar_zoom, 'Enable', 'off')
  end
  
  
function uitoggletool5_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uitoggletool5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    pan

    
function uitoggletool_data_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uitoggletool_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    datacursormode toggle

    
function uipushtool_print_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uipushtool_print (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    printdlg(handles.figure_ChelomEx_peak);


function axes_MS_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axes_MS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
