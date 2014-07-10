function [results, h_plot, h_lgd] = search_species(specieslist, ptrn2pkresult, parameters, pks, ts, MakeFigure, pksMS2, tsMS2, MS2err, MS2noise)        
% looks for related species using the functions FindSpecies and findapoMS2

% input:
% specieslist = structure with fields dmz: mass differences for the various
%    species and id: cell vector with string descriptions of the species
% ptrn2pkresult = results of ptrn2pk function
% ppmerr = relative mass error in ppm
% minerr = minimum mass error in amu
% speciesnoise = minimum chromatographic peak height of species to be included in results
% pks, ts = LCMS data from mzxmlimport
% MakeFigure == 1 creates figure of found species; MakeFigure == 0 shows not figure
%   if Makefigure is activated, calculation of correlations is deactivated to speed up
%   plotting
% pksMS2, tsMS2 = LCMSMS data from mzxmlimport; optional
% MS2err = constant mass error for peaks in MSMS spectra; required if
% pksMS2 and tsMS2 is given
% MS2noise = MSMS peaks below MS2noise are not used in analysis; required if
% pksMS2 and tsMS2 is given

% output:
% results = structure with fields
%   header = description of columns in results.data
%   data = matrix with results
%   speciesID = IDs of found species
%   foundspecies = cell array that contains info for all found species of
%       each provided m/z value
% h_plot contains handles to EICs if MakeFigure == 1
% h_lgd contains handles to plot legend if MakeFigure == 1

% initallization of paramters
ppmerr = parameters.relerr;
minerr = parameters.minerr;
speciesnoise = parameters.speciesnoise;
mincorrelation = 0.7;

%specify columns in inmatrix 
mzcol = 2; zcol = mzcol+1;
pkstartcol = 8; pkendcol = 9; pkmaxRTcol = 7;
tMax = ts(length(ts));
mznum = size(ptrn2pkresult,1);
results.header = {'#Found|Related|Species' 'Species|m/z' '#Related MS2|Signals Species' 'Species|Intensity|Correlation' 'Species|Intensity|Sum' 'Species|Peak|Intensity' 'Species|Ret. Time (s)|Int. Maximum' 'Species|Ret. Time (s)|Peakstart' 'Species|Ret. Time (s)|Peakend'};  
results.data = zeros(mznum,size(results.header,2));
results.speciesID = cell(mznum,1);
results.foundspecies = cell(mznum,1);

if mznum > 3 && MakeFigure == 0
    progbar = waitbar(0,sprintf('%3.1f %0s',0,' %'), 'Name', 'Searching related species...', 'CreateCancelBtn', 'setappdata(gcbf,''canceling'',1)');
    setappdata(progbar, 'canceling', 0);
end

for i = 1:mznum
    if mznum > 3 && MakeFigure == 0
        if getappdata(progbar, 'canceling')
            break
        end 
        done = i/mznum;
        waitbar(done, progbar, sprintf('%3.1f %0s',done*100,' %'));   
    end
    
    speciesrelated = [];
    mz = ptrn2pkresult(i,mzcol);
    z = ptrn2pkresult(i,zcol);  
    pkMaxRT = ptrn2pkresult(i,pkmaxRTcol);
    pkStart = ptrn2pkresult(i,pkstartcol);
    pkEnd = ptrn2pkresult(i,pkendcol);
    pkLength = pkEnd - pkStart;
    pkRange = [max(0,pkStart - pkLength) min(ts(length(ts)),pkEnd + pkLength)];
    
    [species, h_plot, h_lgd] = FindSpecies(specieslist, mz, z, ppmerr, minerr, speciesnoise, pks, ts,1,MakeFigure, pkRange(1), pkRange(2));
    speciesresult1 = species.all{2};  %sum intensities of found species (each row a different species)
    speciesresult2 = species.all{4};  %correlation between found species and "parent" ion
    speciesresult3 = species.all{3};  %masses of found species and parent
    speciesresult4 = species.all{5};  %maximum intensity of found species
    speciesresult1RT = species.allRT{2};  %relative intensities of found species (each row a different species)
    speciesresult2RT = species.allRT{4};  %correlation between found species and "parent" ion
    speciesresult3RT = species.allRT{3};  %masses of found species and parent
    speciesresult4RT = species.allRT{5};  %maximum intensity of found species
    
    num_species = length(speciesresult1);

    % test intensity, correlation and found common MS2 peaks
    k = 0;
    for j = num_species:-1:3    
        apoMS2num = NaN;
        apomz = [];
        
        if speciesresult4(j) > speciesnoise 
            if nargin == 10 
            % use whole chromatogram to search for MSMS spectrum then if
            % no common peaks use only MSMS spectra in RT window
                MS1err = max(ppmerr*10^-6*mz, minerr);
                [apoMS2num, apoMS2data] = findapoMS2(mz, [pkRange(1) pkRange(2)], speciesresult3(j), [0 tMax], MS1err, MS2err, MS2noise, pksMS2, tsMS2, 0);
                if apoMS2num > 0
                    apomz = speciesresult3(j);
                    RT = apoMS2data.MS2(2).precursor(2);
                else
                    [apoMS2num, apoMS2data] =  findapoMS2(mz, [pkRange(1) pkRange(2)], speciesresult3RT(j), [pkRange(1) pkRange(2)], MS1err, MS2err, MS2noise, pksMS2, tsMS2, 0);
                    if apoMS2num > 0
                        apomz = speciesresult3RT(j);
                        RT = apoMS2data.MS2(2).precursor(2);
                    end
                end
            end
            if nargin < 10 | apoMS2num == 0
                apomz = speciesresult3RT(j);
                RT = pkMaxRT;
            end
            
            apopeaks = findPeaks(apomz, ppmerr, minerr, speciesnoise/3, pks, ts, 0);
            if sum(cell2mat(apopeaks(2,:))) > 0     %found apo peaks (row 1 = header)
                    apopeaks = cell2mat(apopeaks(2:size(apopeaks,1),:));
                    apopeakslct = find(apopeaks(:,2) <= RT &...
                                       apopeaks(:,3) >= RT);
                    if isempty(apopeakslct)  % if no apo peaks at correct retention time: choose most intense apo peak
                        apopeakslct = 1;
                    end
                    % in columns: speciesID mz maxint sumint correlation
                    % RTMax RTstart RTend numMS2 related
                    k = k + 1;
                    if apoMS2num > 0 || speciesresult2RT(j) > mincorrelation || (speciesresult1RT(j) > 2 & pkEnd > 0)
%                        disp([num2str(apoMS2num) ' ' num2str(speciesresult2RT(j)) ' ' num2str(speciesresult1RT(j))])
                        related = 1;
                    else 
                        related = 0;
                    end
                    results.foundspecies{i}(k,:)= [specieslist.id{j-2} num2cell([apopeaks(apopeakslct,7)...
                                                       apopeaks(apopeakslct,5) apopeaks(apopeakslct,6)...
                                                       speciesresult2RT(j) apopeaks(apopeakslct,4)...
                                                       apopeaks(apopeakslct,2) apopeaks(apopeakslct,3)...
                                                       apoMS2num related])]; 
                   
            end           
        else
              % if intensity < speciesnoise: do nothing
        end
        
    end
    
    
    % now select the species with the highest intensity that, at the same time
    % meets the requirements for a related species
    if ~isempty(results.foundspecies{i})
        results.foundspecies{i} = sortrows(results.foundspecies{i},-3);
        speciesrelated = results.foundspecies{i}(cell2mat(results.foundspecies{i}(:,size(results.foundspecies{i},2))) == 1,:); % all that have found related MS2 signals or high enough correlation
        if ~isempty(speciesrelated)
            speciesslct = speciesrelated(cell2mat(speciesrelated(:,3)) == max(cell2mat(speciesrelated(:,3))),:);
            speciesslct = speciesslct(1,:);
        else
            speciesslct = results.foundspecies{i}(cell2mat(results.foundspecies{i}(:,3)) == max(cell2mat(results.foundspecies{i}(:,3))),:);
            speciesslct = speciesslct(1,:);
        end
    else
        speciesslct = cell(1,9); 
    end
    
    results.speciesID(i) = speciesslct(1);
    results.data(i,:) = [size(speciesrelated,1) cell2mat(speciesslct([2 9 5 4 3 6:8]))];
    
    
end   
  

if mznum > 3 && MakeFigure == 0
    if getappdata(progbar, 'canceling')   % cancel button was activated
        results.speciesID = results.speciesID(1:i-1,:);
        results.data = results.data(1:i-1,:);
        results.foundspecies = results.foundspecies(1:i-1,:);
    end
    delete(progbar);
end

end