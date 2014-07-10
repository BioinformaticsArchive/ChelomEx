function varargout = ChelomEx_pattern_figure(varargin)
% CHELOMEX_PATTERN_FIGURE MATLAB code for ChelomEx_pattern_figure.fig
%      CHELOMEX_PATTERN_FIGURE, by itself, creates a new CHELOMEX_PATTERN_FIGURE or raises the existing
%      singleton*.
%
%      H = CHELOMEX_PATTERN_FIGURE returns the handle to a new CHELOMEX_PATTERN_FIGURE or the handle to
%      the existing singleton*.
%
%      CHELOMEX_PATTERN_FIGURE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CHELOMEX_PATTERN_FIGURE.M with the given input arguments.
%
%      CHELOMEX_PATTERN_FIGURE('Property','Value',...) creates a new CHELOMEX_PATTERN_FIGURE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ChelomEx_pattern_figure_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ChelomEx_pattern_figure_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ChelomEx_pattern_figure

% Last Modified by GUIDE v2.5 02-Feb-2014 15:06:39

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ChelomEx_pattern_figure_OpeningFcn, ...
                   'gui_OutputFcn',  @ChelomEx_pattern_figure_OutputFcn, ...
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


% --- Executes just before ChelomEx_pattern_figure is made visible.
function ChelomEx_pattern_figure_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ChelomEx_pattern_figure (see VARARGIN)

% Choose default command line output for ChelomEx_pattern_figure
handles.output = hObject;

% initialize uicontrols
% set(handles.axes_histogram, 'FontSize', 8);
% set(handles.axes_chromatogram, 'FontSize', 8);
% set(handles.axes_EIC, 'FontSize', 8);
% set(handles.axes_MS, 'FontSize', 8);

% read varargin input from ChelomEx_Menu
% (handles.user and selected table rows)
handles.user = varargin{1};
handles.user.row.slct = varargin{2};

% get initial figure size (required when resizing window)
handles.user.fposold = get(hObject, 'Position');

% currently selected data in handles.user.data.results.pattern.pks
handles.user.row.index = 1;      %initally set to first selected cell in ChelomEx_menu table
handles.user.row.rownum = length(handles.user.row.slct);
handles.user.row.current = handles.user.row.slct(handles.user.row.index);

% initally select species radiobutton to isotopes
set(handles.uipanel_MS, 'SelectedObject', handles.radiobutton_isotopes);
handles.user.MS.zoomtype = 'zoomIn';
% by defalut, plot mass spectrum at time of peak max of detected patterns
handles.user.MS.pksptrn = handles.user.data.results.pattern.pkspattern{handles.user.row.current,3};
handles.user.MS.time = handles.user.MS.pksptrn(find(handles.user.MS.pksptrn(:,4) == max(handles.user.MS.pksptrn(:,4)), 1, 'first'),1);
% find mass spectrum that is closest to a given time
handles.user.MS.tdiff = abs(handles.user.data.run.ts{1}-handles.user.MS.time);
% row number corresponding to this mass spectrum / time
handles.user.MS.timeidx = find(handles.user.MS.tdiff == min(handles.user.MS.tdiff),1,'first');
% set annotation in mass spec plot on
set(handles.togglebutton_annotation,'Value',1);

% style for total ion chromatogram area plots in background of figures
handles.user.ticstyle = {'FaceColor', [0.85 0.85 0.85], 'EdgeColor', 'none', 'LineStyle', 'none', 'Annotation', 'off'};
% style for mass spectrum time indicator line in chromatograms
handles.user.tidxstyle = {'Color', 'k', 'LineStyle', '--', 'LineWidth', 1};

% some column numbers for handles.user.data.results.pattern.pks
handles.user.col.z = 3;
handles.user.col.mz = 2;
handles.user.col.nptrn = 1;

% customize data cursor tool
handles.toolbar.dcm_obj = datacursormode(handles.figure_ChelomEx_pattern);
set(handles.toolbar.dcm_obj,'UpdateFcn',{@datacursorfcn, handles});


% Update handles structure
guidata(hObject, handles);

% refresh table and axes
refresh(handles, 'all');

% UIWAIT makes ChelomEx_pattern_figure wait for user response (see UIRESUME)
% uiwait(handles.figure_ChelomEx_pattern);
    

% --- Outputs from this function are returned to the command line.
function varargout = ChelomEx_pattern_figure_OutputFcn(hObject, eventdata, handles) 
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
    
function pushbutton_launch_chromatogram_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton_launch_chromatogram (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
    set(hObject, 'CData', imread('Arrow_LaunchFigure.jpg','jpg'));

function pushbutton_launch_EIC_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton_launch_EIC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
    set(hObject, 'CData', imread('Arrow_LaunchFigure.jpg','jpg'));

function pushbutton_launch_MS_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton_launch_MS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
    set(hObject, 'CData', imread('Arrow_LaunchFigure.jpg','jpg'));

function pushbutton_launch_histogram_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton_launch_histogram (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
    set(hObject, 'CData', imread('Arrow_LaunchFigure.jpg','jpg'));
        

    
% user function to generate the different plots 
function handles = refresh(handles, type)
% udpate table and axes; 
% type is a string: 'all' or 'MS'; 
% if type is set to MS only axes_MS will be updated
    
    % temporary variables to make referencing easier
    mzhistogram = handles.user.data.results.pattern.mzhistogram;
    pattern.pks = handles.user.data.results.pattern.pks;
    pattern.pkspattern = handles.user.data.results.pattern.pkspattern;
    pattern.header = handles.user.data.results.pattern.pks_header;
    currentPattern = handles.user.parameters.patternID.(handles.user.parameters.currentPattern).pattern;
    mz = pattern.pks(handles.user.row.current, handles.user.col.mz);
    z = pattern.pks(handles.user.row.current, handles.user.col.z);
    err = max([handles.user.parameters.search.minerr mz*10^-6*handles.user.parameters.search.relerr]); 
    
    if isequal(type, 'MS')              % update axes_MS after left or right arrow key is presed
        cla(handles.axes_MS); hold(handles.axes_MS);
        % set axes labels
        xlabel(handles.axes_MS, 'm/z', 'FontSize', 8); ylabel(handles.axes_chromatogram, 'Intensity', 'FontSize', 8);
        % plot pattern
        set(handles.figure_ChelomEx_pattern,'CurrentAxes',handles.axes_MS);
        % axis limits
        if handles.user.MS.pushbutton_action == 1   % if function was called by pushbutton then use the xrange and yrange provided from plot_pattern function
            [xrange, yrange, handles.user.MS.monoisotope_data] = plot_pattern(currentPattern, mz, z, err, handles.user.MS.timeidx, 0, handles.user.data.run.pks{1}, handles.user.data.run.ts{1}, handles.user.MS.zoomtype, get(handles.togglebutton_annotation,'Value'));
            set(gca, 'XLim', xrange, 'YLim', yrange);
            zoom reset;
        elseif handles.user.MS.pushbutton_action == 0  % if function was called by left or right arrow buttons then use existing axes limits
            xrange = get(handles.axes_MS, 'XLim');
            yrange = get(handles.axes_MS, 'YLim');
            [~, ~, handles.user.MS.monoisotope_data] = plot_pattern(currentPattern, mz, z, err, handles.user.MS.timeidx, 0, handles.user.data.run.pks{1}, handles.user.data.run.ts{1}, handles.user.MS.zoomtype, get(handles.togglebutton_annotation,'Value'));
            set(gca, 'XLim', xrange, 'YLim', yrange);
        end
        
        % change position of line in axes_chromatogram and axes_EIC
        set(handles.user.t_chromatogram, 'XData', [handles.user.data.run.ts{1}(handles.user.MS.timeidx) handles.user.data.run.ts{1}(handles.user.MS.timeidx)], 'YData', [handles.user.mi_EIC{1}(handles.user.MS.timeidx,2) handles.user.chromatogram_ymax]);
        set(handles.user.t_EIC, 'XData', [handles.user.data.run.ts{1}(handles.user.MS.timeidx) handles.user.data.run.ts{1}(handles.user.MS.timeidx)], 'YData', [0 handles.user.EIC_ymax]);
        % set pushbutton_activation off
        handles.user.MS.pushbutton_action = 0;
        hold(handles.axes_MS);
        
    elseif isequal(type, 'EIC')         % update axes_EIC if context_menu_slctplot items are activated 
        num_pgroups = length(currentPattern);
        numpks = 0;
        for m = 1:num_pgroups
            numpks = numpks + length(currentPattern(m).dmz);
        end
        slctlgd = zeros(length(handles.user.EIC.legend),1); slctlgd(1) = 1;
        m = 1;  % do not hide monoisotope (index 1)
        for i = 1:num_pgroups
           switch currentPattern(i).required(1)
               case 11       %required isotope
                   vis = get(handles.context_menu_EIC_showplot_required, 'Checked');
               case 12       %required isotope
                   vis = get(handles.context_menu_EIC_showplot_required, 'Checked');
               case 2        %optional
                   vis = get(handles.context_menu_EIC_showplot_optional, 'Checked');
               case 31       %exclude
                   vis = get(handles.context_menu_EIC_showplot_exclude, 'Checked');
           end       
           for j = 1:length(currentPattern(i).dmz)
               m = m + 1;
               set(handles.user.EIC.h(m), 'Visible', vis);
               if isequal(vis, 'on')
                   slctlgd(m) = 1;
               end 
           end
        end
        legend(handles.axes_EIC, handles.user.EIC.h(slctlgd == 1), handles.user.EIC.legend(slctlgd==1));
         
    elseif isequal(type, 'all')
        % by defalut, plot mass spectrum at time of peak max of detected patterns
        handles.user.MS.pksptrn = handles.user.data.results.pattern.pkspattern{handles.user.row.current,3};
        handles.user.MS.time = handles.user.MS.pksptrn(find(handles.user.MS.pksptrn(:,4) == max(handles.user.MS.pksptrn(:,4)), 1, 'first'),1);
        % find mass spectrum index that is closest to a given time
        handles.user.MS.tdiff = abs(handles.user.data.run.ts{1}-handles.user.MS.time);
        handles.user.MS.timeidx = find(handles.user.MS.tdiff == min(handles.user.MS.tdiff),1,'first');
        
        % clear all axes and hold axes for multiple plots
        cla(handles.axes_histogram); cla(handles.axes_chromatogram); cla(handles.axes_EIC); cla(handles.axes_MS);
        hold(handles.axes_histogram); hold(handles.axes_chromatogram); hold(handles.axes_EIC); hold(handles.axes_MS);
            
        % pattern histogram plot (axes_histogram)           
        % set axes labels
        xlabel(handles.axes_histogram, 'm/z', 'FontSize', 8); ylabel(handles.axes_histogram, '# patterns','FontSize', 8);
        % histogram plot
        zmzhistogram = mzhistogram{pattern.pks(handles.user.row.current, handles.user.col.z)};
        plot(handles.axes_histogram, zmzhistogram(:,1), zmzhistogram(:,2), 'k.', 'MarkerSize', 7); 
        % indicate selected mz in plot    
        nptrn = pattern.pks(handles.user.row.current, handles.user.col.nptrn);
        nptrnmax = max(pattern.pks(pattern.pks(:,handles.user.col.z) == z, handles.user.col.nptrn)) * 1.07;
        plot(handles.axes_histogram, [mz mz], [nptrn+0.05 nptrnmax], handles.user.tidxstyle{:});     

        % pattern chromatogram plot (axes_chromatogram)
        % set axes labels
        xlabel(handles.axes_chromatogram, 'time (s)', 'FontSize', 8); ylabel(handles.axes_chromatogram, 'Intensity', 'FontSize', 8);
        % get TIC
        tc = totalionc(handles.user.data.run.pks{1}, handles.user.data.run.ts{1}, 0);
        % calculate matrix with summed peak intensities for each timepoint with found patterns
%        temp = sortrows(handles.user.data.results.pattern.pattern,1);
%         sumhits = [];
%         while isempty(temp) == 0
%             times = temp(:,1) == temp(1,1);
%             sumhits(size(sumhits,1)+1,:) = [temp(1,1) sum(temp(times,2))];
%             temp(times,:) = [];
%         end
        % get EIC     
        [~,~,handles.user.mi_EIC] = eic(mz, handles.user.parameters.search.minerr, handles.user.parameters.search.minerr,handles.user.data.run.pks{1}, handles.user.data.run.ts{1} ,0);
        % int max 
        chromatogram_intmax = max(handles.user.data.results.pattern.pattern(:,2));
        % plot TIC scaled to max of found pattern peak int max
        area(handles.axes_chromatogram, tc(:,1),tc(:,2).*(chromatogram_intmax/max(tc(:,2))), handles.user.ticstyle{:}); 
        % plot summed pattern hits
        plot(handles.axes_chromatogram, handles.user.data.results.pattern.pattern(:,1),handles.user.data.results.pattern.pattern(:,2), '.', 'MarkerEdgeColor', [0.5 0.5 0.5], 'MarkerSize', 5);
        % plot EIC of the selected mz
        plot(handles.axes_chromatogram, handles.user.mi_EIC{1}(:,3), handles.user.mi_EIC{1}(:,2), 'b-', 'Marker', '.', 'MarkerSize', 5, 'MarkerEdgeColor', 'b');
        % plot pattern belonging to the selected mz 
        plot(handles.axes_chromatogram, pattern.pkspattern{handles.user.row.current,3}(:,1), pattern.pkspattern{handles.user.row.current,3}(:,4), 'r.', 'MarkerSize', 5);
        % y max
        handles.user.chromatogram_ymax = get(handles.axes_chromatogram, 'YLim'); handles.user.chromatogram_ymax = handles.user.chromatogram_ymax(2);
        % plot line that indicates time of displayed mass spectrum
        set(handles.figure_ChelomEx_pattern,'CurrentAxes',handles.axes_chromatogram);
        handles.user.t_chromatogram = line([handles.user.data.run.ts{1}(handles.user.MS.timeidx) handles.user.data.run.ts{1}(handles.user.MS.timeidx)], [handles.user.mi_EIC{1}(handles.user.MS.timeidx,2) handles.user.chromatogram_ymax], handles.user.tidxstyle{:});
        
        % EICs plot (axes_EIC)
        % set axes labels
        xlabel(handles.axes_EIC, 'time (s)', 'FontSize', 8); ylabel(handles.axes_EIC, 'Intensity','FontSize', 8);

        % get mz values with dmz values from parameters.currentPattern.pattern 
        num_pgroups = length(currentPattern);
        numpks = 0;
        for m = 1:num_pgroups
            numpks = numpks + length(currentPattern(m).dmz);
        end
        mzs = zeros(numpks+1,1); mzs(1) = mz;
        mzerr = zeros(numpks+1,1); mzerr(1) = err;
        all_EIC = cell(numpks+1,1); all_EIC{1} = handles.user.mi_EIC;
        handles.user.EIC.legend = cell(numpks+1,1); handles.user.EIC.legend{1} = ['m/z= ' num2str(mzs(1),'%8.4f')];
        m = 0;
        for i = 1:num_pgroups
            for j = 1:length(currentPattern(i).dmz)
                m = m + 1;
                mzs(m+1) = mz + currentPattern(i).dmz(j)/z;
                mzerr(m+1) = currentPattern(i).dmzerr(1,j) + max(mz*10^-6*currentPattern(i).dmzerr(2,j), currentPattern(i).dmzerr(3,j));
                %get EIC x y data and store handles is handles.user.EIC.h
                [~,~,all_EIC{m+1}] = eic(mzs(m+1), 0, mzerr(m+1), handles.user.data.run.pks{1}, handles.user.data.run.ts{1}, 0); 
                handles.user.EIC.legend{m+1} = currentPattern(i).ID{j};
            end
        end
        colors = colormap(lines(numpks+1));
        % int max
        EIC_intmax = 0;
        for i = 1:numpks+1
            EIC_intmax = max([EIC_intmax max(all_EIC{i}{1}(:,2))]);
        end
        
        % plot TIC scaled to max of monoisotope EIC (handles.user.mi_EIC)
        area(handles.axes_EIC, tc(:,1),tc(:,2).*(EIC_intmax(1)/max(tc(:,2))), handles.user.ticstyle{:});     
        % plot EICs 
        handles.user.EIC.h = zeros(numpks+1,1);
        for i = 1:numpks+1        
            handles.user.EIC.h(i) = plot(handles.axes_EIC, all_EIC{i}{1}(:,3), all_EIC{i}{1}(:,2), 'Color', colors(i,:));
        end
        % plot line that indicates time of displayed mass spectrum
        % ymax
        handles.user.EIC_ymax = get(handles.axes_EIC, 'YLim'); handles.user.EIC_ymax = handles.user.EIC_ymax(2);
        set(handles.figure_ChelomEx_pattern,'CurrentAxes',handles.axes_EIC);
        handles.user.t_EIC = line([handles.user.data.run.ts{1}(handles.user.MS.timeidx) handles.user.data.run.ts{1}(handles.user.MS.timeidx)], [0 handles.user.EIC_ymax], handles.user.tidxstyle{:});
        % plot legend
        legend(handles.user.EIC.h(:), handles.user.EIC.legend(1:numpks+1));
      
        % Mass specrum plot (axes_MS)
        % set axes labels
        xlabel(handles.axes_MS, 'm/z', 'FontSize', 8); ylabel(handles.axes_MS, 'Intensity', 'FontSize', 8);
       
        % plot mass spectrum
        set(handles.figure_ChelomEx_pattern,'CurrentAxes',handles.axes_MS);
        [xrange, yrange, handles.user.MS.monoisotope_data] = plot_pattern(currentPattern, mz, z, err, handles.user.MS.timeidx, 0, handles.user.data.run.pks{1}, handles.user.data.run.ts{1}, handles.user.MS.zoomtype, get(handles.togglebutton_annotation,'Value'));
        set(gca, 'XLim', xrange, 'YLim', yrange);
        zoom reset;
               
        %release hold
        hold(handles.axes_histogram); hold(handles.axes_chromatogram); hold(handles.axes_EIC); hold(handles.axes_MS);

        % udpate table with current row
        set(handles.uitable, 'Data', pattern.pks(handles.user.row.current,:), 'ColumnName', pattern.header);
        
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
    
    % update handles for data cursor function
    set(handles.toolbar.dcm_obj,'UpdateFcn',{@datacursorfcn, handles});
    guidata(handles.figure_ChelomEx_pattern, handles);
    
    
% --- controls to select a species from the table to display ---
% pushbuttons
function pushbutton_previous_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_previous (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    if handles.user.row.index > 1 
        handles.user.row.index = handles.user.row.index - 1;      
        handles.user.row.current = handles.user.row.slct(handles.user.row.index);
        handles = refresh(handles, 'all');  
        handles = refresh(handles, 'EIC'); 
        guidata(hObject, handles);
    end
    
function pushbutton_next_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_next (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    if handles.user.row.index < handles.user.row.rownum
        handles.user.row.index = handles.user.row.index + 1;      
        handles.user.row.current = handles.user.row.slct(handles.user.row.index);
        handles = refresh(handles, 'all');  
        handles = refresh(handles, 'EIC'); 
        guidata(hObject, handles);
    end
    
    
% keyboard control, also to select currently displayed mass spectrum 
function figure_ChelomEx_pattern_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to figure_ChelomEx_pattern (see GCBO)
% eventdata  structure with the following fields (see FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
%  handles    structure with handles and user data (see GUIDATA)

    keycode = double(get(handles.figure_ChelomEx_pattern, 'CurrentCharacter'));
    
    switch keycode
        case 30     % up arrow: previous m/z
            pushbutton_previous_Callback(hObject, [], handles);
        case 31     % down arrow: next m/z
            pushbutton_next_Callback(hObject, [], handles);
        case 28     % left arrow: previous mass spectrum
            if handles.user.MS.timeidx > 1
                
                handles.user.MS.timeidx = handles.user.MS.timeidx - 1;
                handles.user.MS.pushbutton_action = 0;
                refresh(handles, 'MS'); 
            end        
        case 29     % right arrow: next mass spectrum
            if handles.user.MS.timeidx < size(handles.user.data.run.ts{1},1)
                handles.user.MS.timeidx = handles.user.MS.timeidx + 1;
                handles.user.MS.pushbutton_action = 0;
                refresh(handles, 'MS'); 
            end
    end
    
    guidata(hObject, handles);
    
    
% --- Controls to change Mass Spectrum ----
% % --- Executes when selected object is changed in uipanel_MS.
function uipanel_MS_SelectionChangeFcn(hObject, eventdata, handles)
% % hObject    handle to the selected object in uipanel_MS 
% % eventdata  structure with the following fields (see UIBUTTONGROUP)
% %	EventName: string 'SelectionChanged' (read only)
% %	OldValue: handle of the previously selected object or empty if none was selected
% %	NewValue: handle of the currently selected object
% % handles    structure with handles and user data (see GUIDATA)
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

function pushbutton_zoomout_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_zoomout (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
            handles.user.MS.zoomtype = 'zoomOut';
            handles.user.MS.pushbutton_action = 1;
            refresh(handles,'MS');

function pushbutton_zoomin_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_zoomin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
            handles.user.MS.zoomtype = 'zoomIn';
            handles.user.MS.pushbutton_action = 1;
            refresh(handles,'MS');

function togglebutton_annotation_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_zoomin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
                handles.user.MS.pushbutton_action = 0;
                refresh(handles,'MS');
           

% --- Pushbuttons to launch a figure in a new window for editing and saving
function pushbutton_launch_chromatogram_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_launch_chromatogram (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    launch_figure(handles.axes_chromatogram, 'Identified Patterns', handles);
    
function pushbutton_launch_EIC_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_launch_EIC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    launch_figure(handles.axes_EIC, 'Extracted Ion Chromatograms', handles);

function pushbutton_launch_histogram_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_launch_histogram (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    launch_figure(handles.axes_histogram, 'Pattern Histogram', handles);

function pushbutton_launch_MS_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_launch_MS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    launch_figure(handles.axes_MS, 'Mass Spectrum', handles);

% function to launch figure in new window; h = axis handle; name = figure name
function launch_figure(h, name, handles)
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
 

% context menu to choose which EICs to plot in axes_EIC
function context_menu_EIC_showplot_Callback(hObject, eventdata, handles)
% hObject    handle to context_menu_EIC_showplot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)     
        
function context_menu_EIC_showplot_optional_Callback(hObject, eventdata, handles)
% hObject    handle to context_menu_EIC_showplot_optional (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    if isequal(get(handles.context_menu_EIC_showplot_optional, 'Checked'), 'on');
        set(handles.context_menu_EIC_showplot_optional, 'Checked', 'off');
        refresh(handles, 'EIC');
    else
        set(handles.context_menu_EIC_showplot_optional, 'Checked', 'on');
        refresh(handles, 'EIC');
    end

function context_menu_EIC_showplot_exclude_Callback(hObject, eventdata, handles)
% hObject    handle to context_menu_EIC_showplot_exclude (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    if isequal(get(handles.context_menu_EIC_showplot_exclude, 'Checked'), 'on');
        set(handles.context_menu_EIC_showplot_exclude, 'Checked', 'off');
        refresh(handles, 'EIC');
    else
        set(handles.context_menu_EIC_showplot_exclude, 'Checked', 'on');
        refresh(handles, 'EIC');
    end
  
function context_menu_EIC_showplot_required_Callback(hObject, eventdata, handles)
% hObject    handle to context_menu_EIC_showplot_required (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    if isequal(get(handles.context_menu_EIC_showplot_required, 'Checked'), 'on');
        set(handles.context_menu_EIC_showplot_required, 'Checked', 'off');
        refresh(handles, 'EIC');
    else
        set(handles.context_menu_EIC_showplot_required, 'Checked', 'on');
        refresh(handles, 'EIC');
    end
    
    
% % context menu to choose which isotope to plot in axes_MS
% function context_menu_MS_showplot_Callback(hObject, eventdata, handles)
% % hObject    handle to context_menu_MS_showplot (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% 
% function context_menu_MS_showplot_required_Callback(hObject, eventdata, handles)
% % hObject    handle to context_menu_MS_showplot_required (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
%     if isequal(handles.user.MS.vis_required, 'on');
%         handles.user.MS.vis_required = 'off';
%         set(handles.context_menu_MS_showplot_required, 'Checked', 'off');
%         refresh(handles, 'MS');
%     elseif isequal(handles.user.MS.vis_required, 'off');
%         handles.user.MS.vis_required = 'on';
%         set(handles.context_menu_MS_showplot_required, 'Checked', 'on');
%         refresh(handles, 'MS');
%     end
% 
% function context_menu_MS_showplot_optional_Callback(hObject, eventdata, handles)
% % hObject    handle to context_menu_MS_showplot_optional (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
%     if isequal(handles.user.MS.vis_optional, 'on');
%         handles.user.MS.vis_optional = 'off';
%         set(handles.context_menu_MS_showplot_optional, 'Checked', 'off');
%         refresh(handles, 'MS');
%     elseif isequal(handles.user.MS.vis_optional, 'off');
%         handles.user.MS.vis_optional = 'on';
%         set(handles.context_menu_MS_showplot_optional, 'Checked', 'on');
%         refresh(handles, 'MS');
%     end
% 
% function context_menu_MS_showplot_exclude_Callback(hObject, eventdata, handles)
% % hObject    handle to context_menu_MS_showplot_exclude (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
%     if isequal(handles.user.MS.vis_exclude, 'on');
%         handles.user.MS.vis_exclude = 'off';
%         set(handles.context_menu_MS_showplot_exclude, 'Checked', 'off');
%         refresh(handles, 'MS');
%     elseif isequal(handles.user.MS.vis_exclude, 'off');
%         handles.user.MS.vis_exclude = 'on';
%         set(handles.context_menu_MS_showplot_exclude, 'Checked', 'on');
%         refresh(handles, 'MS');
%     end


% datacursorfcn exists also as separate .m file. here slight modifications
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
    


% --- Executes when figure_ChelomEx_pattern is resized.
function figure_ChelomEx_pattern_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to figure_ChelomEx_pattern (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    fposnew = get(hObject, 'Position');      
    if ~isfield(handles, 'user')
        handles.user.fposold = fposnew;
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
    set(handles.uitable, 'Position', [37 uipos(2) fposnew(3)-94 75]);
    % adjust size and position of axes 
    uipos = get(handles.axes_chromatogram, 'Position');
    xspace = handles.user.fposold(3) - 2*uipos(3);
    yspace = handles.user.fposold(4) - 2*uipos(4);
    dw = (fposnew(3)-xspace)/2 - uipos(3);
    dh = (fposnew(4)-yspace)/2 - uipos(4);
    
    uipos = get(handles.axes_chromatogram, 'Position');
    set(handles.axes_chromatogram, 'Position', uipos + [0 dh dw dh]);
    uipos = get(handles.static_chromatogram, 'Position');
    set(handles.static_chromatogram, 'Position', uipos + [dw dh*2 0 0]);
    uipos = get(handles.pushbutton_launch_chromatogram, 'Position');
    set(handles.pushbutton_launch_chromatogram, 'Position', uipos + [dw dh*2 0 0]);
    
    uipos = get(handles.axes_EIC, 'Position');
    set(handles.axes_EIC, 'Position', uipos + [0 0 dw dh]);  
    uipos = get(handles.static_EIC, 'Position');
    set(handles.static_EIC, 'Position', uipos + [dw dh 0 0]);
    uipos = get(handles.pushbutton_launch_EIC, 'Position');
    set(handles.pushbutton_launch_EIC, 'Position', uipos + [dw dh 0 0]);
    
    uipos = get(handles.axes_histogram, 'Position');
    set(handles.axes_histogram, 'Position', uipos + [dw dh dw dh]);
    uipos = get(handles.static_histogram, 'Position');
    set(handles.static_histogram, 'Position', uipos + [dxpos dh*2 0 0])
    uipos = get(handles.pushbutton_launch_histogram, 'Position');
    set(handles.pushbutton_launch_histogram, 'Position', uipos + [dxpos dh*2 0 0]);
    
    uipos = get(handles.axes_MS, 'Position');
    set(handles.axes_MS, 'Position', uipos + [dw 0 dw dh]);  
    uipos = get(handles.uipanel_MS, 'Position');
    set(handles.uipanel_MS, 'Position', uipos + [dxpos dh 0 0]);
    uipos = get(handles.uipanel_MS_pushbuttons, 'Position');
    set(handles.uipanel_MS_pushbuttons, 'Position', uipos + [dxpos dh 0 0]);
    uipos = get(handles.static_MS, 'Position');
    set(handles.static_MS, 'Position', uipos + [dxpos dh 0 0]);
    uipos = get(handles.pushbutton_launch_MS, 'Position');
    set(handles.pushbutton_launch_MS, 'Position', uipos + [dxpos dh 0 0]);
      
    handles.user.fposold = fposnew;
    
    guidata(hObject, handles);

% --- Executes on mouse press over axes background.
function axes_MS_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axes_MS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
