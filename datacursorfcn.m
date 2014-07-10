function txt = datacursorfcn(empty,event_obj,handles)
% customize text in GUI data tip
% executes when data selection tool is used in any of the plots ---

    pos = get(event_obj,'Position');
    X_Label = [get(get(gca, 'XLabel'), 'String') '= ']; if isempty(X_Label), X_Label='X= '; end
    Y_Label = [get(get(gca, 'YLabel'), 'String') '= ']; if isempty(Y_Label), Y_Label='Y= '; end
    if isequal(X_Label, 'm/z= '), Xformat = '%0s %8.4f';
    elseif isequal(X_Label, 'time (s)= '), Xformat = '%0s %4.1f';
    else Xformat = '%0s, %0.1f'; 
    end 
    txt = {sprintf(Xformat ,X_Label, pos(1)), sprintf('%0s %1.2E', Y_Label, pos(2))};    