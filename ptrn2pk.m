function [results, h] = ptrn2pk(pattern, ptrnresult, parameters, pks, ts, makefigure, mzselect)
% Tests for match between chromatographic behavior and found individual patterns 

% input: 
% pattern = structure with isotope pattern definition
% ptrnresult = result of search_Pattern function
% parameters = parameter inputs including mass error ranges and chromatography filters
% pks, ts = LCMS data from mzxmlimport
% makefigure == 1 draws the eics for each compound; 0 does not. 
% mzselect = optional vector with [m/z z]; can be used to run ptrn2pk for only the given mz/z value pair. 

% output:
% results = structure with fields
%   data = matrix with results from ptrn2pk 
%   header = description of columns in data
%   flagID = string description of flag numbers
% h = handles to EICs if MakeFigure ==1


%% Parameters initialization
% Paramaeters that control peak recognition
    smooth_span = parameters.smooth; %number should be even, if its an even number 1 is subtracted! if < maxzeros number of 0 occur between two blocks of numbers, the blocks are connected
    if ~mod(smooth_span,2)
        smooth_span = smooth_span-1;
    end
    maxzeros = parameters.skip;  % maximum number of zeros allowed between found patterns to connect patterns
    minpkheight_factor = parameters.baseline;  % sets baseline to minpkheight_factor*mean intensity of found patterns
    minsignal = 2;    % need at least so many signals in a scoreblock
    minpeakwidth = 2;  % need at least so many singals in a peakblock

% mass errors
    ppmerr = parameters.relerr;
    minerr = parameters.minerr;
    
%% Load information about pattern and initialize parameters
pkct = 0;
ptrn = struct('pkct', [], 'mz', [], 'dmz', [], 'dmzerr', [], 'IRel', [], 'IRelerr', [], 'required',[], 'ID', []);    %peaks that are required for scoring are stored here
for m = 1:length(pattern)
    for n = 1:length(pattern(m).dmz)        
        pkct = pkct + 1;
        if pattern(m).required == 11 | pattern(m).required == 31
            ptrn.pkct = [ptrn.pkct pkct];
            ptrn.dmz = [ptrn.dmz pattern(m).dmz(n)]; 
            ptrn.dmzerr = [ptrn.dmzerr pattern(m).dmzerr(:,n)];
            ptrn.IRel = [ptrn.IRel pattern(m).IRel(n)];
            ptrn.IRelerr = [ptrn.IRelerr pattern(m).IRelerr(:,n)];
            ptrn.required = [ptrn.required pattern(m).required(n)];
            ptrn.ID = [ptrn.ID pattern(m).ID(n)];
        end
    end
end
numdpeaks = length(ptrn.dmz);
numpeaks = numdpeaks + 1;

mzcol = 2;     %mz column in ptrnresult.peaks
zcol = mzcol+1;
dmzcols = 4+ptrn.pkct*2;
dmzcolsreq = dmzcols(ptrn.required == 11 & ~isnan(ptrn.IRel)); %required dmz values with given IRel
numdpeaks_req = length(dmzcolsreq);
peaks = cell(numdpeaks_req+1,1);
peakends = cell(numdpeaks_req+1,1);
tMax = ts(length(ts));

%if mz list is given: get scores only for those mz values --> find and use only those mz values in condense.peaks 
if nargin == 7         
    pkrows = zeros(size(mzselect,1),1);
    for i = 1:size(mzselect,1)
        %err = max(minerr,mzselect(i,1)*ppmerr*(10^-6));
        %find(ptrnresult.pks(:,mzcol) >= (mzselect(i,1) - err) & ptrnresult.pks(:,mzcol) <= (mzselect(i,1) + err)
        zptrnrows = find(ptrnresult.pks(:,zcol) == mzselect(i,2));
        temp = zptrnrows(abs(ptrnresult.pks(zptrnrows,mzcol)-mzselect(i,1))==min(abs(ptrnresult.pks(zptrnrows,mzcol)-mzselect(i,1))));  
        pkrows(i) = temp(1);
    end
    % only those found mz values that also have the right z 
    ptrnresult.pks = ptrnresult.pks(pkrows,:);
    ptrnresult.pkspattern = ptrnresult.pkspattern(pkrows,:);
    ptrnresult.pkscore = ptrnresult.pkscore(pkrows,:);
end

mzlength = size(ptrnresult.pks,1);
zs = ptrnresult.pks(:,zcol);
timelength = length(ts);

results.header = {'Passed|Chromatography|Criteria' 'm/z|Mono-|isotope' 'z|Mono-|isotope' 'Intensity|Total' 'Intensity Sum|Peaks With|Found Patterns' 'Intensity|Peak|Maximum' 'Ret. Time|(s)|Peak Maximum' 'Ret. Time|(s)|Peakstart' 'Ret. Time|(s)|Peakend' 'Relative Int.|Passed|Criteria' 'Fraction|Found|Patterns' '#|Found Peaks|in Chromatogram'};
results.flagID = {1 'passed all criteria'; 2 'check (low intensities)'; 3 'check (few found patterns)'; 4 'check (low peak-pattern coverage)'; 5 'check (few found patterns)'; 6 'check (intensities)'; 7 'check (correlation)'; 8 'check (correlation)'; 9 'check (exclusion peak present)'; 9999 'failed criteria'}; 
        %1=all defined dpeaks meet all criteria; 
        %2=all criteria except lower IRel
        %3=all criteria except low number of found patterns in peak (<5)
        %4=all criteria except lower intfraction (0.25 <= intfraction <=0.5)
        %5=all criteria except fraction of found patterns in peak is small  (0.25-0.5)
        %6=all criteria except >25% of points have higher IRel outside pattern block boundary within peak
        %7 and 8 =all criteria except lower correlation (0.5<=R<0.75)
        %9=all criteria except  exclusion isotope present

for i=1:numdpeaks
   results.header{1,size(results.header,2)+1} = ['delta m/z|' ptrn.ID{i}];
   results.header{1,size(results.header,2)+1} = ['Correlation (R)|' ptrn.ID{i}];
   results.header{1,size(results.header,2)+1} = ['delta m/z error|' ptrn.ID{i}];
   results.header{1,size(results.header,2)+1} = ['Relative Intensity|' ptrn.ID{i}];
   results.header{1,size(results.header,2)+1} = ['Rel. Int. error|' ptrn.ID{i}];
end
results.data = zeros(mzlength,size(results.header,2));

if mzlength > 10
    progbar = waitbar(0,sprintf('%3.1f %0s',0,' %'), 'Name', 'Evaluating pattern peak correlation...', 'CreateCancelBtn', 'setappdata(gcbf,''canceling'',1)');
    setappdata(progbar, 'canceling', 0);
end

%% start algorithm - loop for each mz value
for i=1:mzlength  
    % progress bar
    if mzlength > 10
        if getappdata(progbar, 'canceling')
            break
        end      
        done = i/mzlength;
        waitbar(done, progbar, sprintf('%3.1f %0s',done*100,' %'));        
    end
    
    %initialization of variables  
    z = zs(i);
    %calculate m/z value for each isotope 
    zerocols = (ptrnresult.pks(i,dmzcols) == 0);
    if ~isempty(find(zerocols,1))
        ptrnresult.pks(i,dmzcols(zerocols)) = ptrn.dmz(zerocols)./z;
    end
    ptrn.mz = [ptrnresult.pks(i,mzcol) ptrnresult.pks(i,dmzcols)+ptrnresult.pks(i,mzcol)];
    
    % hits = found patterns in chromatogram
    hits = ptrnresult.pkscore{i,3}(:,[1,4,2,3 dmzcolsreq]);
    
    clear int chrom
    
    %get EICs
    [int,~,eics, h] = eic(ptrn.mz, ppmerr, minerr, pks, ts, makefigure);  %int contains integrals for each m/z; eics contains chromatogram info with (1)m/z values, (2)intensities, (3) times; h contains handles if MakePlot==1
     
    % 1) For each required isotope find peaks > baseline (=mean of
    % intensities of found patterns for that isotope * minpkheight_factor)
    % 2) Identify most intense peak with isotope patterns that cover the
    % peakmaximum (isotope pattern times are connected if found at least 1
    % time in number of smooth_span connected spectra
    % 3) find EIC peaks for other defined required isotopes with a known expected
    % relative Intensity that is smaller than that of the Monoisotope. If
    % any of the EIC peaks for the lower intensity isotopes is
    % wider than that of the Monoisotope, then adjust peakwidth
    % 4) calculate parameters to check for coherence of isotopic signal in
    % chromatogram
    
    blocks = [];
    pknum = 0;

%% 1) find connected regions of nonzero intensities in EICs (peaks) and in found patterns (blocks)
 
    % Peakblocks for Monoisotope and lower abundance isotopes
    minpkheight(1) = mean(hits(:,2))*minpkheight_factor;   %minpkheight is equal to the baseline used for figuring out the peakends
    if numdpeaks_req > 0
        for j = 1:numdpeaks_req
            minpkheight(j+1) = mean(hits(:,j+4).*hits(:,2))*minpkheight_factor; 
        end
    end
    
    for j = 1:numdpeaks_req+1
        smoothchrom = smooth(eics{j}(:,2),smooth_span);
        %trimend = round(smooth_span/2); %used to trim ends of smoothed peaks 
        peakends{j} = find((smoothchrom - minpkheight(j)) <= 0);
        if length(peakends{j}) > 1
            peakendlength = length(peakends{j});
            peaks{j} = zeros(peakendlength-1,2);
            for k = 1:(peakendlength-1)
                if peakends{j}(k+1)-peakends{j}(k) > minpeakwidth %min number of signals above baseline in a peak
                    pknum = pknum + 1;
                    peaks{j}(pknum,:) = [peakends{j}(k)+1 peakends{j}(k+1)-1];  %peaks contains number of collected spectrum for start and end of peak.
                end
            end
            if (timelength - peakends{j}(peakendlength)) > minpeakwidth
                pknum = pknum + 1;
                peaks{j}(pknum,:) = [peakends{j}(peakendlength)+1 timelength];
            end
            peaks{j}(peaks{j}(:,1) == 0,:) = [];
        else
            peaks{j} = [1 timelength];
        end
    end

 %% 2) Goodpeaks: Test if
    %a) found connected times of patterns (blocks) 
    %b) is the peakmaximum within a block?
    
    % Scoreblocks    (invector1,zcol1, invector2, zcol2, consterror, error
    [~,nohits] = vcompare(ts,2,[hits ones(size(hits,1),1)],size(hits,2)+1,1,0.01); nohits(:,2:4+numdpeaks_req) = 0; hits = sortrows([hits(:,:);nohits],1);
    
    SmoothScore = smooth(hits(:,2),maxzeros+1);        %smoothing with window 5: zeros are retained in between blocks of numbers if >4x Zero occurs
    trimend = round((maxzeros+1)/2); %used to trim ends of smoothed peaks 
    blockends = find(SmoothScore == 0);
    if length(blockends) > 1
        for k = 1:(length(blockends)-1)
            if blockends(k+1) - blockends(k) > (minsignal+trimend*2) %min number of nonzero scores in each block
                blocks(size(blocks,1)+1,:) = [blockends(k)+trimend blockends(k+1)-trimend];  %blocks contains number of collected spectrum for start and end of score block. these blocks are then tested if they correspond to a peak
            end
        end
        if (timelength-blockends(length(blockends))) > (minsignal+trimend)  %Test separate for last element if it is further away from end of chromatogram than minsignal
            blocks(size(blocks,1)+1,:) = [blockends(length(blockends))+trimend timelength];
        end
    end
    
    goodpeaks = [];

    if ~isempty(blocks) && ~isempty(peaks{1})
        peaknumber = length(peaks{1}(:,1));
        for k = 1:peaknumber
            peakmaxrow = find(eics{1}(:,2) == max(eics{1}(peaks{1}(k,1):peaks{1}(k,2),2)), 1, 'first');
            foundblock = blocks(blocks(:,1) <= peakmaxrow & blocks(:,2) >= peakmaxrow,:);
            if ~isempty(foundblock)
               peakmax = eics{1}(peakmaxrow,:);
               goodpeaks(size(goodpeaks,1)+1,:) = [peakmax(1,2) peakmax(1,3) ts(peaks{1}(k,1)) ts(peaks{1}(k,2)) peaks{1}(k,1) peaks{1}(k,2)];
            end

        end
    end

    pkptrn_intfraction = 0;
    pkptrn_fraction = 0;
    pkptrn_num = 0;
    peakmaxRT = 0;
    peakmaxStart = 0;
    peakmaxEnd = 0;
    peakmaxeic = 0;
    peakchrom = cell(numpeaks,1);
    numgdpeaks = 0;
    goodint = 0;
    pass.flag = 9999;
     
    if isempty(goodpeaks)
        for k=numpeaks:-1:1
            chrom.mz(k) = mean(eics{k}(~isnan(eics{k}(:,1)),1));
            chrom.Int(k) = sum(eics{k}(~isnan(eics{k}(:,1)),2));
        end
        for k = numdpeaks:-1:1
            chrom.dmz(k) = chrom.mz(k+1) - chrom.mz(1);
            chrom.ddmz(k) = chrom.dmz(k) - ptrn.dmz(k)/z;
            chrom.IRel(k) = roundn(chrom.Int(k+1)/chrom.Int(1),-2);
            chrom.IRelerr(k) = chrom.IRel(k) - ptrn.IRel(k);
            %correlation between intensities within peak
            %covariation(k) = regression(peakchrom{1}(:,2),peakchrom{k}(:,2),'one');
            IntV1 = eics{1}(:,2);
            IntV2 = eics{k+1}(:,2);
            delrows = (IntV1==0 & IntV2==0); IntV1(delrows) = []; IntV2(delrows) = [];
            if ~isempty(IntV2)
                if max(IntV2) > 0
                    %[~,~,~,~,~,chrom.cor(k),~,~] = ols(IntV1,IntV2,0);  %regression through the origin, ols is a function of a MatLab package by Kevin Sheppard (http://www.kevinsheppard.com/wiki/MFE_Toolbox)
                    [chrom.cor(k),~,~] = regression(IntV1,IntV2,'one');  %= R
                else 
                    chrom.cor(k) = NaN;
                end
            else
                 chrom.cor(k) = NaN;
            end
        end
    else
%% If found goodpeak
        pkptrn_intfraction = 0;
        pkptrn_fraction = 0;
        pkptrn_num = 0;            
        numgdpeaks = size(goodpeaks,1);
        peakmaxrow = find((goodpeaks(:,1)) == max(goodpeaks(:,1)),1,'first');
              
        isoflagsum = 1;    % counts how many isotopes were found that did not fit in the found peak of the monoisotope, if any are found then adjust the monoisotope peakwidth
        while isoflagsum > 0   
%% 3) Test if other isotopes are within the found (good) peak of monoisotope otherwise need to adjust peakwidth to include all isotopes
            goodint = sum(goodpeaks(:,1));
            peakmaxint = goodpeaks(peakmaxrow,1);
            peakmaxRT = goodpeaks(peakmaxrow,2);
            peakmaxStart = goodpeaks(peakmaxrow,3);
            peakmaxEnd = goodpeaks(peakmaxrow,4);
            peakmaxeic = eics{1}(ts == peakmaxRT,2);
            peakstartrow = goodpeaks(peakmaxrow,5);
            peakendrow = goodpeaks(peakmaxrow,6);
        
            isoflagsum = 0;
            if numdpeaks_req > 0 & numgdpeaks > 0
                pklength = peakmaxEnd - peakmaxStart;
                RTstart= max(0, peakmaxStart - pklength);          
                RTend= min(tMax, peakmaxEnd + pklength);
                % convert RTstart and RTend times to row numbers in ts vector
                rowpkmaxStart_new = goodpeaks(peakmaxrow,5);
                rowpkmaxEnd_new = goodpeaks(peakmaxrow,6);
                RTstart = find(abs(RTstart-ts) == min(abs(RTstart-ts)));
                RTend = find(abs(RTend-ts) == min(abs(RTend-ts)));
                for k = 2:numdpeaks_req+1          
                    if ~isempty(peaks{k})
                        for m = 1:size(peaks{k},1)
                            flag = 0;
                            % if any required isotope peak is nonzero outside monoisotope peak within one peakwidth boundary
                            if size(vcompare([peaks{k}(m,1):peaks{k}(m,2)]',2,[RTstart:goodpeaks(peakmaxrow,5)-1 goodpeaks(peakmaxrow,6)+1:RTend]',2,1,0.1),1) > 0 
                                flag = 8;
                                if numgdpeaks > 1                              
                                    % check if the found signal outside main monoisotope peak may be part of a 
                                    % secondary monoisotope peak: find closest peakstart    
                                    goodpks2nd = goodpeaks; goodpks2nd(peakmaxrow,:) = []; 
                                    tdiff = [peaks{k}(m,1)-goodpks2nd(:,5) [1:numgdpeaks-1]'];
                                    tdiff = tdiff(tdiff(:,1) >= 0,:);
                                    if ~isempty(tdiff)
                                        nearestgdpk = goodpks2nd(tdiff(tdiff(:,1) == min(tdiff(:,1)),2),:);
                                        if nearestgdpk(6) >= peaks{k}(m,2)
                                            flag = 0;
                                        end
                                    end
                                end
                            end
                            if flag > 0
                                isoflagsum = isoflagsum + 1;
                                rowpkmaxStart_new = min(rowpkmaxStart_new, peaks{k}(m,1));
                                rowpkmaxEnd_new = max(rowpkmaxEnd_new, peaks{k}(m,2));
                                %pass.failsum = pass.failsum + 1; pass.flag = 8;
                            end          
                        end
                    end
                    
                end
                if isoflagsum > 0
                    peakmaxRT = eics{1}(eics{1}(:,2) == max(eics{1}(rowpkmaxStart_new:rowpkmaxEnd_new,2)),3);
                    peakmaxRT = peakmaxRT(peakmaxRT >= ts(rowpkmaxStart_new) & peakmaxRT <= ts(rowpkmaxEnd_new));
                    peakmaxRT = peakmaxRT(1);
                    goodpeaks(peakmaxrow,:) = [sum(eics{1}(rowpkmaxStart_new:rowpkmaxEnd_new,2)) peakmaxRT ts(rowpkmaxStart_new) ts(rowpkmaxEnd_new) rowpkmaxStart_new rowpkmaxEnd_new];
                end
            end
        end
            
            
%% 4) calculate correlation and other parameters                     
        if ~isempty(blocks)
           blocktimes = [];
           for k=1:size(blocks,1)
            blocktimes = [blocktimes blocks(k,1):1:blocks(k,2)];
           end
        % get intensity fraction of peak area that contains score blocks
            foundpkblocktimes = blocktimes >= peakstartrow & blocktimes <= peakendrow;
            if ~isempty(foundpkblocktimes)
                pkptrn_intfraction = sum(eics{1}(blocktimes(foundpkblocktimes),2)) / sum(eics{1}(peakstartrow:peakendrow,2)) * 100;
            end
        % get fraction of found patterns in peak over total number of recorded spectra in peak
            pkptrn_num = sum(~isnan(hits(hits(peakstartrow:peakendrow,2)~=0)));
            pkptrn_fraction = pkptrn_num / (peakendrow-peakstartrow+1-(smooth_span-1)) * 100;
        end

        %get chromatogram of eics for selected peak retention times and
        %calculate mean mz values, intensities, correlation 
        for k=numpeaks:-1:1
            peakchrom{k} = eics{k}(peakstartrow:peakendrow,:);   
            chrom.Int(k) = sum(peakchrom{k}(~isnan(peakchrom{k}(:,1)),2));
            chrom.mz(k) = sum(peakchrom{k}(~isnan(peakchrom{k}(:,1)),1).*(peakchrom{k}(~isnan(peakchrom{k}(:,1)),2)/chrom.Int(k)));
        end
        for k = numdpeaks:-1:1
            chrom.dmz(k) = chrom.mz(k+1) - chrom.mz(1);
            chrom.ddmz(k) = chrom.dmz(k) - ptrn.dmz(k)/z;
            chrom.IRel(k) = roundn(chrom.Int(k+1)/chrom.Int(1),-3);
            chrom.IRelerr(k) = chrom.IRel(k) - ptrn.IRel(k);
            %correlation between intensities within peak
            %covariation(k) = regression(peakchrom{1}(:,2),peakchrom{k}(:,2),'one');
            if max(peakchrom{k+1}(:,2)) > 0 
                % delete those timepoints where both intensities are 0
                % (e.g. lost spray)
                IntV1 = peakchrom{1}(:,2);
                IntV2 = peakchrom{k+1}(:,2);
                delrows = (IntV1==0 & IntV2==0); IntV1(delrows) = []; IntV2(delrows) = [];
                %[~,~,~,~,~,chrom.cor(k),~,~] = ols(IntV1,IntV2,0);  %regression through the origin, ols is a function of a MatLab package by Kevin Sheppard (http://www.kevinsheppard.com/wiki/MFE_Toolbox)
                [chrom.cor(k),~,~] = regression(IntV1,IntV2,'one');  %=R
%                     % fraction of times outside of block but within peak that
%                     % have too high IRel for low abundance peaks (IRel < 0.5)
%                     if ptrn.required(k) == 11
%                         inblocks = []; 
%                         if ptrn.IRel(k) < 0.5
%                             for idx = 1:length(blockrows)
%                                 inblocks = [inblocks blocks(blockrows,1):blocks(blockrows,2)]; 
%                             end
%                             [~,notinblocks] = vcompare([peakstartrow:peakendrow]', 0, inblocks', 0, 1, 0.1);
%                             if ~isempty(notinblocks)
%                                 notinblocks = notinblocks(:,1);
%                                 HighIRel = eics{k+1}(notinblocks,2)./eics{k}(notinblocks,2);
%                                 HighIRel=HighIRel(~isnan(HighIRel));
%                                 chrom.HighIRelFraction = length(HighIRel(HighIRel > ptrn.IRelerr(2,k))) / length(notinblocks);
%                             else 
%                                 chrom.HighIRelFraction = 0;
%                             end
%                         else
%                             chrom.HighIRelFraction(k) = 0;
%                         end
%                     else 
%                         chrom.HighIRelFraction(k) = 0;
%                     end         
            else
                chrom.cor(k) = NaN;
%                     chrom.HighIRelFraction(k) = 0;
            end
        end
    
    
        
%% Test if criteria for good pattern match are fulfilled
        %pass flags: 
        %1=all defined dpeaks meet all criteria; 
        %2=all criteria except lower IRel
        %3=all criteria except low number of found patterns in peak (<5)
        %4=all criteria except lower intfraction (0.25 <= intfraction <=0.5)
        %5=all criteria except fraction of found patterns in peak is small  (0.25-0.5)
        %6=all criteria except >25% of points have higher IRel outside pattern block boundary within peak
        %7=all criteria except lower correlation (0.5<=R<0.75)
        %8=all criteria except significant peak of lower abundance isotope
        %is found outside the peak of the monoisotope (within one PeakWidth
        %Range)
        %9=all criteria except one exclusion isotope present
        %9999=all other cases     
        pass.failsum = 0; pass.flag = 1;
        if pkptrn_num < parameters.filters.number(2)
            pass.flag = 9999;
        elseif pkptrn_num >=parameters.filters.number(2) & pkptrn_num < parameters.filters.number(1)
            pass.flag = 3;
        end
        if pass.flag < 9999
            if pkptrn_fraction > parameters.filters.fraction1(1)*100 
            elseif pkptrn_fraction >= parameters.filters.fraction1(2)*100 & pkptrn_fraction <= parameters.filters.fraction1(1)*100 
                pass.flag = 5;
            else 
                pass.flag = 9999;
            end
        end
        if pass.flag < 9999
            if pkptrn_intfraction > parameters.filters.fraction2(1)*100 
            elseif pkptrn_intfraction >= parameters.filters.fraction2(2)*100 & pkptrn_intfraction <= parameters.filters.fraction2(1)*100 
                pass.failsum = pass.failsum + 1; pass.flag = 4; 
            else
                pass.flag = 9999;
            end
        end
        
        if pass.flag < 9999
            for k = 1:numdpeaks
                if ptrn.required(k) == 11 
                    if abs(chrom.ddmz(k)) <= (ptrn.dmzerr(1,k)+ptrn.dmzerr(3,k)+ptrn.dmzerr(2,k)*chrom.mz(1)*(10^-6));
                    else
                        pass.flag = 9999; break
                    end
                    if chrom.IRel(k) >= ptrn.IRelerr(1,k) & chrom.IRel(k) <= ptrn.IRelerr(2,k) 
                    elseif chrom.IRel(k) < ptrn.IRelerr(1,k)
                        pass.failsum = pass.failsum + 1; pass.flag = 2;
                    else 
                        pass.flag = 9999; break
                    end
                    if chrom.cor(k) >= parameters.filters.correlation(1) 
                    elseif chrom.cor(k) >= parameters.filters.correlation(2) & chrom.cor(k) < parameters.filters.correlation(1)
                        pass.failsum = pass.failsum + 1; pass.flag = 7;
                    else 
                        pass.flag = 9999; break
                    end
%                     if chrom.HighIRelFraction(k) <= 0.25
%                     elseif chrom.HighIRelFraction(k) > 0.25 & chrom.HighIRelFraction(k) <= 0.5
%                         pass.failsum = pass.failsum + 1; pass.flag = 6;
%                     else
%                         pass.flag = 9999; break
%                     end
                elseif ptrn.required(k) == 31
                    if abs(chrom.ddmz(k)) <= (ptrn.dmzerr(1,k)+ptrn.dmzerr(3,k)+ptrn.dmzerr(2,k)*chrom.mz(1)*(10^-6)) &...
                       chrom.IRel(k) >= ptrn.IRelerr(1,k) & chrom.IRel(k) <= ptrn.IRelerr(2,k)&...
                       chrom.cor(k) >= 0.7
                       pass.flag = 9; 
                    end
                end
            end
        end
        if pass.failsum > 1
            pass.flag = 9999;
        end
    end
      
%% Output
  %   columns 1-11:   'pass flag'     'mz'        'z'    'PeakMax'  'goodint'    'totalint'  'RT Max'    'RT start'   'RT end'   'good%'    'numpeaks'
  %   columns 12-16: 'dmz2' 'ddmz2' 'IRel2' 'IRelerr2' 'cor2'    
  %   ... for other isotopes

  results.data(i,1:12) = [pass.flag chrom.mz(1) z int(1) goodint peakmaxeic peakmaxRT peakmaxStart peakmaxEnd pkptrn_intfraction pkptrn_fraction numgdpeaks];
  for k = numdpeaks:-1:1
      results.data(i,13+(k-1)*5:17+(k-1)*5) = [chrom.dmz(k) chrom.cor(k) chrom.ddmz(k), chrom.IRel(k), chrom.IRelerr(k) ];
  end
 
  % plot option
  if makefigure == 1
      hold on;
      plot(hits(hits(:,2) > 0,1),hits(hits(:,2) > 0,2),'r.');
      %plot(ptrnresult.pkspattern{i,3}(ptrnresult.pkspattern{i,3}(:,2) > 0,1),ptrnresult.pkspattern{i,3}(ptrnresult.pkspattern{i,3}(:,2) > 0,2),'ro');
      
      % plot final peak feature boundaries
      if ~isempty(goodpeaks)
          plot([ts(goodpeaks(peakmaxrow,5)) ts(goodpeaks(peakmaxrow,5):goodpeaks(peakmaxrow,6))', ts(goodpeaks(peakmaxrow,6))],...
               [0 1.2*peakmaxeic.*ones(1,goodpeaks(peakmaxrow,6)-goodpeaks(peakmaxrow,5)+1) 0], 'Color', [205/255 140/255 0/255], 'LineWidth', 1.5);
      end
      % plot found peaks of monoisotope
      if size(peaks{1},1) > 0
             for j=1:length(peaks{1}(:,1));
                 plot([ts(peaks{1}(j,1)) ts(peaks{1}(j,1):peaks{1}(j,2))' ts(peaks{1}(j,2))], [0 1.2*peakmaxeic.*ones(1,peaks{1}(j,2)-peaks{1}(j,1)+1) 0],'Color', [205/255 140/255 0/255]);
             end
      end
      % plot times of connected found isotope patterns
      if size(blocks,1) > 0
             for j=1:length(blocks(:,1));
                 plot([ts(blocks(j,1)) ts(blocks(j,1):blocks(j,2))' ts(blocks(j,2))], [0 1.1*peakmaxeic.*ones(1,blocks(j,2)-blocks(j,1)+1) 0],'r-');
             end
      end
      % plot found peaks of required isotopes
      if numdpeaks_req > 0
          for k=2:numdpeaks_req+1
            if size(peaks{k},1) > 0
                linecolor = get(h(k), 'Color');
                for j=1:length(peaks{k}(:,1));
                    eicmax = min(peakmaxeic*1.05, max(eics{k}(:,2)));
                    plot([ts(peaks{k}(j,1)) ts(peaks{k}(j,1):peaks{k}(j,2))' ts(peaks{k}(j,2))], [0 1.1*eicmax.*ones(1,peaks{k}(j,2)-peaks{k}(j,1)+1) 0],'Color', linecolor);
                end
            end
          end
      end
%       results.data(i,:)
%       input('Press Key   ');
%       if i > 10 
%           close(gcf);
%       end
  end

end

if mzlength > 10
    if getappdata(progbar, 'canceling')   % cancel button was activated
        results.data = results.data(1:i-1,:);
    end
    delete(progbar);
end

%Sort output
results.data= sortrows(results.data,[1 3 -6 2]); %pass/z/int/mz

end

