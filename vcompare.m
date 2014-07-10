function [hits, nohits] = vcompare(invector1,zcol1, invector2, zcol2, consterror, error)
% compares if one of each element in 'invector1' is present in 'invector2'
% invector consists of matrix with: column1 = m/z; zcol = z; 
% if z column is not provided it is assumed that z=1 for all m/z values

% hits = entries of invector1 that are present in both, invector1 and invector 2 
% nohits = entries that are present only in invector1

if size(invector1,2) == 1  %no z column provided
    invector1(:,2) = 1;
    zcol1 = 2;
end
if size(invector2,2) == 1
    invector2(:,2) = 1;
    zcol2 = 2;
end
if isempty(invector2) == 1 && isempty(invector1) == 0          %if invector2 is empty but invector 1 contains values
    hits = []; nohits = invector1;
elseif isempty(invector1) == 1
    hits = []; nohits = [];
else
    hits = []; nohits = [];
    num_mzs = size(invector1,1);
    for i=1:num_mzs
        %percent = round(i/num_mzs*100);
        %progress_bar(percent);
        if consterror == 0   %ppm error
            [hit] = find(invector2(:,1) <= (invector1(i,1)+error*10^-6*invector1(i,1)) & invector2(:,1) >= (invector1(i,1)-error*10^-6*invector1(i,1)) & invector2(:,zcol2) == invector1(i,zcol1));
        elseif consterror == 1  %absolute amu error
            [hit] = find(invector2(:,1) <= (invector1(i,1)+error) & invector2(:,1) >= (invector1(i,1)-error) & invector2(:,zcol2) == invector1(i,zcol1));
        end
        if find(hit) > 0
            hits(size(hits,1)+1,:) = invector1(i,:);
        else 
            nohits(size(nohits,1)+1,:) = invector1(i,:);
        end

    end
end
end