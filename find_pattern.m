function hits = find_pattern(pattern, zs, minInt, noise, pks, ts, makefigure, target_mz, polarity, err)  
% finds isotope patterns in LCMS datasets

% input:
% pattern = defined isotope pattern parameters
% zs = vector with z (charge) values to include (e.g. [1:4])
% minInt = only signals in the mass spectra that are > minInt are considered for the Monoisotope
% noise = only signals that are > noise are used in the pattern search
% pks and ts = LCMS data from mzxmlimport
% makefigure == 1 creates a chromatogram with the summed intensity of identified metal isotope signals at each timepoint
% target_mz = optional vector with m/z values; if given only these m/z
%    values are used as potential Monoisotopes in the pattern search
% polarity = optional string required if target_mz is given, can be 'Positive' or 'Negative'
% err = optional vector with error ranges for target_mz. in columns: error offset (1), relative ppm error (2), minimum error (3)

% results:
% hits is a structure with fields
% pattern = found isotope patterns using required isotopes for pattern search
% score = found isotope patterns using required isotopes for later pattern peak correlation by ptrn2pk function

%% Load information about pattern and initialize parameters
num_pgroups = length(pattern);     %number of peak groups
numpks = 0;
for m = 1:num_pgroups
    numpks = numpks + length(pattern(m).dmz);
end
hits.score = zeros(1000000,4+numpks*2);
hits.pattern = zeros(10000000,4+numpks*2);
hitcountp = 0;
hitcounts = 0;
znum = length(zs);
num_ms = size(ts,1);

if nargin == 10
    if strcmp(polarity,'Positive')
        polarity = 1.00728;
    elseif strcmp(polarity,'Negative')
        polarity = -1.00728;
    end
end

%minpkmono = minpkheight/minIntRel; %minimum intensity of most abundant isotope (monoisotope)
%minIntRel = 1;                   
% for i = 1:num_pgoups
%     isotopenum = isotopenum + find(disotope(i,:,1),1,'last');  %number of all isotopes
%     minIntRel =  min(minIntRel, min(disotope(i,(find(disotope(i,:,4))),4)));                %minimum relative intensity
% end

progbar = waitbar(0,sprintf('%0s %0i %7.1f %0s','z=',1,0,' %'), 'Name', 'Finding patterns...', 'CreateCancelBtn', 'setappdata(gcbf,''canceling'',1)');
setappdata(progbar, 'canceling', 0);

%% Find patterns. loop for each charge value - mass spectrum - m/z peak in mass spectrum
for i = 1:znum                                                           %for each charge value; may do parfor loop here to speed up
    z = zs(i);
       
    for k = 1:num_ms                                                     %for each mass spectrum
         if getappdata(progbar, 'canceling')
             % delete found patterns so far otherwise later analysis steps may
             % show faulty results
             hits.score = [];
             hits.pattern = [];
             break
         end      
         done = k/num_ms; 
         waitbar(done, progbar, sprintf('%0s %0i %7.1f %0s','z=',z,done*100,' %'));
        
         peaks = pks{k}(pks{k}(:,2) >= noise,:);       %delete all masses that are below minimum peak height 
         mzs = peaks(peaks(:,2) >= minInt,:); 
         
         if nargin == 10   % targeted search for a given m/z
             z_target_mz = (target_mz+(z-1)*polarity) ./ z;
             target_mzs = zeros(0,2);
             for t = 1:length(z_target_mz)
                error = err(1) + max(err(2)*z_target_mz(t)*10^-6, err(3)); 
                foundmzs = mzs(:,1) >= z_target_mz(t)-error &  mzs(:,1) <= z_target_mz(t)+error;
                target_mzs = [target_mzs; mzs(foundmzs,:)];
                mzs(foundmzs,:) = [];  %delete found mz values to exclude possibility of looking twice for one m/z value at larger errors
             end
             mzs = target_mzs;
         end
         num_mzs = size(mzs,1);
         
         if num_mzs > 0
             for l = 1:num_mzs                                               %for each m/z value in the mass spectrum 
                 mz = mzs(l,1);
                 dmz = peaks(:,1) - mz;                    %mass differences to potential monoisotope
                 m = 0; foundpknum=0; stop = 0;        % stop loop if a required isotope is not found

                 while m < num_pgroups && stop~=11                            %for each peak group in the pattern 
                    m = m+1;              
                    for n = 1:length(pattern(m).dmz)                         %for each peak in peak group
                       ddmz = abs(dmz-pattern(m).dmz(n)/z);
                       minddmz = min(ddmz);
                       minrow = find(ddmz == minddmz,1,'first');
                       mzerror = pattern(m).dmzerr(1,n) + max(mz*10^-6*pattern(m).dmzerr(2,n), pattern(m).dmzerr(3,n));    
                       if minddmz <= mzerror            %if found peak within mz error range                            
                         mzwindow(1:2) = peaks(minrow,:);
                         mzwindow(3) = dmz(minrow); %mzwindow contains only masses in error range of isotope pattern; in col1=m/z;col2=int;col3=mzdiff; col4=intratio; 
                         mzwindow(4) = mzwindow(2) ./ mzs(l,2); 

                         if isequal(isnan(pattern(m).IRelerr(:,n)), [1;1]) || ...
                            isequal(isnan(pattern(m).IRelerr(:,n)), [0;0]) && mzwindow(4) >= pattern(m).IRelerr(1,n) && mzwindow(4) <= pattern(m).IRelerr(2,n) || ...
                            isequal(isnan(pattern(m).IRelerr(:,n)), [0;1]) && mzwindow(4) >= pattern(m).IRelerr(1,n) || ...
                            isequal(isnan(pattern(m).IRelerr(:,n)), [1;0]) && mzwindow(4) <= pattern(m).IRelerr(2,n)

                                 pattern(m).hit(1:4,n) = mzwindow(1:4);                         %found hit for this peak; col1=m/z;col2=int;col3=mzdiff; col4=intratio;
                                 foundpknum = foundpknum + 1;                       
                         else
                                 pattern(m).hit(1:4,n) = 0;  
                         end
                       else
                         pattern(m).hit(1:4,n) = 0;                   
                       end
                    end
                    if pattern(m).required(1) == 11 & isempty(find(pattern(m).hit(1,:),1)) || pattern(m).required(1) == 31 & ~isempty(find(pattern(m).hit(1,:),1))
                       stop = 11;                                                  %stop if required peak is not found within peak group or if peak that may not be part of pattern is found
                    elseif pattern(m).required(1) == 12 & isempty(find(pattern(m).hit(1,:),1)) || pattern(m).required(1) == 32 & ~isempty(find(pattern(m).hit(1,:),1))
                       stop = 12;                                                  %this indicates that not the whole pattern is found but that the required peaks for scoring are there
                    end
                 end

                 %record found patterns in the matrix hits    
                 if stop == 0 || stop == 12
                     hitcounts = hitcounts + 1;
                     hits.score(hitcounts,1:4) = [ts(k) mzs(l,2) mz z];  %hits: col(1) = Time, col(2)=Int, col(3)=m/z, col(4)=z, col(5)=dmz peak1, col(6)=IRel pk1, ...
                     pkct = 0;
                     for m = 1:num_pgroups
                        for n = 1:length(pattern(m).dmz)
                            pkct = pkct + 1;
                            hits.score(hitcounts,3+pkct*2:3+pkct*2+1) = [pattern(m).hit(3,n) pattern(m).hit(4,n)];
                        end
                     end

                     if foundpknum >= pattern(1).minpknum && stop == 0;
                        hitcountp = hitcountp + 1;
                        hits.pattern(hitcountp,:) = hits.score(hitcounts,:);
                     end
                 end
             end
         end
    end         
end

delete(progbar)

if ~isempty(hits.pattern)
    %mz difference for not found mass differences is 0 and needs to be set
    %to NaN (otherwise averaging in bin_pattern function gives wrong results)
    pkct = 0;
    for m = 1:num_pgroups
                    for n = 1:length(pattern(m).dmz)
                        pkct = pkct+1;
                        nomzdiff = hits.pattern(:,3+pkct*2) == 0;
                        hits.pattern(nomzdiff, 3+pkct*2) = NaN;
                    end
    end
    %delete empty rows in hits
    hits.pattern(hits.pattern(:,3)==0,:) = [];
    hits.score(hits.score(:,3)==0,:) = [];
    %sort according to mz value
    hits.pattern = sortrows(hits.pattern,3);
    hits.score = sortrows(hits.score,3);
end

%% Generate plot of found patterns (time vs. sum of intensities)
%calculate matrix with summed peak intensities for each timepoint with found patterns
if makefigure == 1
    temp = sortrows(hits.pattern,1);
    sumhits = [];
    while isempty(temp) == 0
        times = temp(:,1) == temp(1,1);
        sumhits(size(sumhits,1)+1,:) = [temp(1,1) sum(temp(times,2))];
        temp(times,:) = [];
    end

    figure;
    plot(sumhits(:,1),sumhits(:,2),'bo');
    figure;
    plot3(hits.pattern(:,1),hits.pattern(:,3),hits.pattern(:,2),'bo');
end

end
