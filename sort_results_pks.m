function pattern_sorted = sort_results_pks(pattern, sortcols)
% sorts results.pks matrix and the corresponding results.pkspattern cell array. 
% sortcols is a column vector with columns to sort for in pks

pattern_sorted = pattern;
if ~isempty(pattern.pks)
    cols_pks = size(pattern.pks,2);
    rows_pks = size(pattern.pks,1);
    pattern.pks(:,cols_pks+1) = [1:rows_pks]';
    pattern.pks = sortrows(pattern.pks, sortcols);
    for i=1:rows_pks
        pattern_sorted.pkspattern(i,:) = pattern.pkspattern(pattern.pks(i,cols_pks+1),:);
        pattern_sorted.pkscore(i,:) = pattern.pkscore(pattern.pks(i,cols_pks+1),:);
    end
    pattern_sorted.pks = pattern.pks(:,1:cols_pks);
end


end

