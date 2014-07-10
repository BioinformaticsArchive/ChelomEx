function results = group_pattern(pattern, hits, minerr, ppmerr, makeplot)   
% groups m/z values from LCMS run within experimental error 

% inputs: 
% pattern = defined isotope pattern
% hits = results from find_pattern function
% minerr = minimum error at low m/z values in amu 
% err_ppm = relative m/z error in ppm
% makeplot = if '1' creates a plot with number of found m/z values
% for each species; if '0' does not create a plot

% results:
% structure with fields
% pks = matrix with grouped m/z values 
% pks_header = header cell vector with description of each column in pks
% pkspattern = contains the found m/z values for each grouped m/z value in pks
% mzhistogram = can be used to generate histogram plot (number of found m/z
% values in each m/z bin)

results.score = hits.score; 
results.score(:,[2,3]) = results.score(:,[3,2]);
results.score(:,[3,4]) = results.score(:,[4,3]);
results.pattern = hits.pattern;
results.pattern(:,[2,3]) = results.pattern(:,[3,2]);
results.pattern(:,[3,4]) = results.pattern(:,[4,3]);

hitspattern = results.pattern; 
hitscore = results.score;
mzrow = 2;   %mzrow in hits matrix
zrow = mzrow+1;
introw = mzrow+2;

pks = []; 
hitgroups = cell(0,3);
zhitgroups = cell(0,3);
hitgroupscore = cell(0,3);
zhitgroupscore = cell(0,3);

for i=max(hitspattern(:,zrow)):-1:min(hitspattern(:,zrow))
    if find(hitspattern(:,zrow) == i,1,'first') 
        zs(i) = i;
    else zs(i) = [];
    end
end
mzhistogram = cell(1,max(zs));
   
for a = 1:length(zs);
        % for each z value
        z = zs(a);
        zhitspattern = hitspattern(hitspattern(:,zrow) == z,:);     
        zhitscore = hitscore(hitscore(:,zrow) == z,:);
        %sort decreasing intensity
        zhitspattern = sortrows(zhitspattern, -introw); 
        zhitscore = sortrows(zhitscore, -introw); 
        zpks = zeros(0,size(zhitspattern,2)+1);
        i = 0; 
        
        while ~isempty(zhitspattern)
            i = i + 1;
            mz = zhitspattern(1,mzrow);
            int = zhitspattern(1,introw);
            err = max(minerr, ppmerr*mz*10^-6);
            
            % hitspattern and hitscore
            foundgroupnew = zhitspattern(:,mzrow) >= (mz-err) & zhitspattern(:,mzrow) <= (mz + err); 
            foundgroup_score = zhitscore(:,mzrow) >= (mz-err) & zhitscore(:,mzrow) <= (mz + err);
            foundgroupold = [];
            group = [];
            while sum(foundgroupnew) > sum(foundgroupold)
                foundgroupold = foundgroupnew;
                group = [group;zhitspattern(foundgroupnew, :)];
                
                %sum of intensities
                intsum = sum(group(~isnan(group(:,introw)),introw));                            
                %intensity weighed averages
                for k = size(group,2):-1:1
                    weighted(k) = sum((group(:,k) ./ intsum) .* group(:,introw));           
                end
                mz = weighted(mzrow);
                foundgroupnew = foundgroupold | (zhitspattern(:,mzrow) >= (mz-err) & zhitspattern(:,mzrow) <= (mz + err));
                foundgroup_score = foundgroup_score | (zhitscore(:,mzrow) >= (mz-err) & zhitscore(:,mzrow) <= (mz + err));
            end
            foundgroup = foundgroupnew;
            
            zhitgroups{i,1} = weighted(mzrow);
            zhitgroups{i,2} = z;
            zhitgroups{i,3} = zhitspattern(foundgroup, :);
            
            zhitgroupscore{i,1} = zhitgroups{i,1};
            zhitgroupscore{i,2} = zhitgroups{i,2};
            zhitgroupscore{i,3} = zhitscore(foundgroup_score, :);
            
            zhitspattern(foundgroup,:) = [];
            zhitscore(foundgroup_score,:) = [];
            
            % new entry in pks
            zpks(i,1) = sum(foundgroup);
            zpks(i,2:size(weighted,2)+1) = weighted;
            zpks(i, introw +1) = int;
            zpks(i, zrow+1) = z;            
        end
        if ~isempty(zhitgroups)
            zmzhistogram = [zpks(:,mzrow+1) zpks(:,1)];

            if makeplot == 1
                figure;
                plot(zmzhistogram(:,1), zmzhistogram(:,2), 'ro-');
            end

            pks = [pks; zpks];
            hitgroups = [hitgroups; zhitgroups];
            hitgroupscore = [hitgroupscore; zhitgroupscore];
            mzhistogram{z} = sortrows(zmzhistogram,1);
        end
                  
end
pks(:,[2,3]) = pks(:,[3,2]);
pks(:,[3,4]) = pks(:,[4,3]);
pks(:,[4,5]) = pks(:,[5,4]);
  
results.pks = pks;
results.pks_header(1:5) = {'# Found|Patterns' 'm/z|Monoisotope' 'z|Monoisotope' 'Max. Intensity|Monoisotope' 'Ret. Time (s)|Weighted Average'};

m=0;
for i = 1:length(pattern)
   for j = 1:length(pattern(i).dmz)
       m=m+1;
       patternID(m) = pattern(i).ID(j);
   end
end
j=0;
for i = 6:2:size(results.pks,2)
    j = j+1;
    results.pks_header(i:i+1) = {['delta m/z|' patternID{j}] ['Relative Intensity|' patternID{j}]};
end
results.pkspattern = hitgroups;
results.pkscore = hitgroupscore;
results.mzhistogram = mzhistogram;

end
