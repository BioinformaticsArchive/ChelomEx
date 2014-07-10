function save_results(filename, results, tableID)
% saves the currently shown ChelomEx results table to an ASCII file

% input:
% filename = filename string from uiputfile dialog
% results = results structure variable  
% tableID = string - 'Pattern', 'Untargeted' or 'Database' depending on the
%   type of data currently displayed in the GUI table
    
    fileID = fopen(filename, 'w');   %create new file for writing
    
    switch tableID
        case 'Untargeted'
            table = results.peak.table.data(:,1:size(results.peak.table.data,2));
            header = results.peak.table.header;
            numcol = size(table,2)-1;
            numrow = size(table,1);
            numisotopes = (numcol-24)/5;
        
            if ~isempty(header)
                for i = 1:numcol-1
                    fprintf(fileID, '%0s\t', header{1,i});
                end
                fprintf(fileID, '%0s\n', header{1,numcol});
            else
                for i = 1:numcol-1
                    fprintf(fileID, '%0s\t', ['col' num2str(i)]);
                end
                fprintf(fileID, '%0s\n', ['col' num2str(numcol)]);
            end

            for i=1:numrow
                fprintf(fileID, ['%0s\t %0s\t %0.5f\t %0i\t %0i\t %0s\t %0.5f\t %0i\t %0.3f\t %0s\t'...
                                 '%0.3e\t %0.3e\t %0.3e\t %0.3e\t %0s\t'...
                                 '%0.1f\t %0.1f\t %0.1f\t %0.1f\t %0.1f\t %0.1f\t %0s\t'...
                                 '%0.1f\t %0.1f\t'], table{i,1:24});
                for j=1:numisotopes
                    fprintf(fileID, '%0.5f\t %0.3f\t %0.5f\t %0.4f\t %0.4f\t', table{i,(25+(j-1)*5):(29+(j-1)*5)});
                end
                fprintf(fileID, '%0s\n', '');
            end
            
            case 'Database'
                table = results.peak.table.data(:,1:size(results.peak.table.data,2));
                header = results.peak.table.header;
                numcol = size(table,2)-1;
                numrow = size(table,1);
                numisotopes = (numcol-26)/5;

                if ~isempty(header)
                    for i = 1:numcol-1
                        fprintf(fileID, '%0s\t', header{1,i});
                    end
                    fprintf(fileID, '%0s\n', header{1,numcol});
                else
                    for i = 1:numcol-1
                        fprintf(fileID, '%0s\t', ['col' num2str(i)]);
                    end
                    fprintf(fileID, '%0s\n', ['col' num2str(numcol)]);
                end

                for i=1:numrow
                    fprintf(fileID, ['%0s\t %0s\t %0s\t %0s\t %0.5f\t %0i\t %0i\t %0s\t %0.5f\t %0i\t %0.3f\t %0s\t'...
                                     '%0.3e\t %0.3e\t %0.3e\t %0.3e\t %0s\t'...
                                     '%0.1f\t %0.1f\t %0.1f\t %0.1f\t %0.1f\t %0.1f\t %0s\t'...
                                     '%0.1f\t %0.1f\t'], table{i,1:26});
                    for j=1:numisotopes
                        fprintf(fileID, '%0.5f\t %0.3f\t %0.5f\t %0.4f\t %0.4f\t', table{i,(27+(j-1)*5):(31+(j-1)*5)});
                    end
                    fprintf(fileID, '%0s\n', '');
                end
            
        case 'Pattern'
            table = results.pattern.pks;
            header = results.pattern.pks_header;
            numcol = size(table,2);
            numrow = size(table,1);
            numisotopes = (numcol-5)/2;
            
            if ~isempty(header)
                for i = 1:numcol-1
                    fprintf(fileID, '%0s\t', header{1,i});
                end
                fprintf(fileID, '%0s\n', header{1,numcol});
            else
                for i = 1:numcol-1
                    fprintf(fileID, '%0s\t', ['col' num2str(i)]);
                end
                fprintf(fileID, '%0s\n', ['col' num2str(numcol)]);
            end

            for i=1:numrow
                fprintf(fileID, '%0i\t %0.3e\t %0.2e\t %0.5f\t %0i\t', table(i,1:5));
                for j=1:numisotopes
                    fprintf(fileID, '%0.5f\t %0.2f\t', table(i,(6+(j-1)*2):(7+(j-1)*2)));
                end  
                fprintf(fileID, '%0s\n','');
            end
    end
            

    fclose(fileID);
    
end

