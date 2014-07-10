function [Output, h_plot, h_lgd] = FindSpecies(specieslist, mzvector,z, ppmerr, minerr, absnoise, pks, ts, small, MakeFigure, RTstart, RTend)
% searches for other species of found isotope patterns 

% input:
% specieslist = structure with fields dmz: mass differences for the various
%    species and id: cell vector with string descriptions of the species
% mzvector = vector with m/z values for the Monoisotopes; 
% z = charge for the m/zs given in mzvector 
% ppmerr = relative mass error in ppm
% minerr = minimum mass error in amu
% absnoise = minimum chromatographic peak height of species to be included in results
% pks, ts = LCMS data from mzxmlimport
% small == 0 includes a dimers, trimers, bis complexes, tris complexes etc
%   in the search; small == 1 uses only provided mass differences to search
%   for other species
% MakeFigure == 1 creates figure of found species; MakeFigure == 0 shows not figure
%   if Makefigure is activated, calculation of correlations is deactivated to speed up
%   plotting
% RTstart, RTend = vectors for retention time windows that shall be
%   applied in looking for related species; these parameters are optional and
%   if not provided, the whole chromatogram will be searched. Setting both
%   parameters to 0 is equal to having to RT window limitation. Provide only
%   one value, if same RT window is to be used for all mz values

% output:
% Output = structure 
%    Output.all = all found species for the parent species in mzvector
%       contains info if evidence for related species was found
%    Output.selected = contains all related species
%    Output.allRT = as above but only in retention time window
%    Output.selectedRT = as above but only in retention time window
% h_plot = handles to EICs if MakeFigure == 1 
% h_lgd = handle to legend if MakeFigure == 1


h_plot = []; h_lgd = [];

deltaM_num = specieslist.dmz; deltaM_str = specieslist.id;  %specieslist is created by [~,specieslist] = LoadPattern(metalID)
num_hits = length(mzvector);
num_species = length(deltaM_num)+1; %+1 because parent ion is also included in output list for reference
m.Hp = 1.00728/z; %mz proton
m.Fe2 = 55.93384/z;            %mz iron(II)
m.Fe3 = 55.9333/z;            %mz iron(III)
m.Nap = 22.98922/z;            %mz Na+
m.H = 1.00783/z; %mz hydrogen
m.Fe = 55.93494/z; %mz iron

if length(RTstart) == 1
    RTstart(1:num_hits) = RTstart(1);
    RTend(1:num_hits) = RTend(1);
end
    
deltaM_str(2:num_species) = deltaM_str;
deltaM_str(1) = {'Parent'};
if small == 0
    deltaM_str(num_species+1:num_species+16)={'m/z=2';'m/z=3';'dimer';'trimer';'trimer m/z=2'; 'monomer from dimer'; 'monomer from trimer'; 'bis complex from mono, apo2-';'bis complex from mono, apo2-, 1Na';'bis complex from mono, apo3-';'bis complex from mono, apo3-, 1Na';'bis complex from mono, apo3-,2Na';'mono complex from bis, apo2-'; 'mono complex from bis, apo3-'; 'tris complex from mono, 2apo2-'; 'tris complex from mono 3apo2-'};
end

% Results for whole chromatogram
Output.all= cell(3,1); %in rows: different parent species; in columns: intensities relative to parent species intensity (index 1) or masses of species (index 2)
Output.selected = cell(4, num_species+16, num_hits);
Output.all{1}(1) = deltaM_str(1);
Output.all{1}(2) = {'Significant'};
Output.all{1}(3:num_species+1)= deltaM_str(2:num_species);
if ~isempty(RTstart) || ~(RTstart == 0 && RTend == 0)
% Results only for selected retention time range
    Output.allRT= cell(3,1); 
    Output.selectedRT = cell(4, num_species+16, num_hits);
    Output.allRT{1}(1) = deltaM_str(1);
    Output.allRT{1}(2) = {'Significant'};
    Output.allRT{1}(3:num_species+1)= deltaM_str(2:num_species);
end



for i=1:num_hits
    %init
    %---------------
    species(1) = mzvector(i);                      %parent species
    
    species(2:num_species) = mzvector(i) + deltaM_num/z(i); %other species
    if small == 0                %include these species only if function is called with parameter small==0
        %TO DO: these species do not make all sense or work for mz>1
        species(num_species+1) = (mzvector(i)+m.Hp)./2;  %m/z=2
        species(num_species+2) = (mzvector(i)+2*m.Hp)/3;  %m/z=3
        species(num_species+3) = mzvector(i)*2-m.Hp;  %dimer
        species(num_species+4) = mzvector(i)*3-2*m.Hp/3;  %trimer
        species(num_species+5) = (mzvector(i)*3-m.Hp/3)/2;  %trimer m/z=2
        species(num_species+6) = mzvector(i)/2+m.Hp;  %monomer from dimer
        species(num_species+7) = mzvector(i)/3+2*m.Hp;  %monomer from trimer
        species(num_species+8) = mzvector(i)+(mzvector(i)-m.Fe2+1*m.Hp);  %bis complex from mono, apo2-
        species(num_species+9) = mzvector(i)+(mzvector(i)-m.Fe2+1*m.Nap);  %bis complex from mono, apo2-, 1Na
        species(num_species+10) = mzvector(i)+(mzvector(i)-m.Fe3+2*m.Hp);  %bis complex from mono, apo3-
        species(num_species+11) = mzvector(i)+(mzvector(i)-m.Fe3+1*m.Nap+1*m.Hp);  %bis complex from mono, apo3-, 1Na
        species(num_species+12) = mzvector(i)+(mzvector(i)-m.Fe3+2*m.Nap);  %bis complex from mono, apo3-, 2Na
        species(num_species+13) = (mzvector(i)+m.Fe2-1*m.Hp)/2;  %mono complex from bis, apo2-
        species(num_species+14) = (mzvector(i)+m.Fe3-2*m.Hp)/2;  %mono complex from bis, apo3-
        species(num_species+15) = mzvector(i)+2*(mzvector(i)-m.Fe2+1*m.Hp);  %tris complex from mono, 2xapo2-
        species(num_species+16) = mzvector(i)+2*(mzvector(i)-m.Fe3+2*m.Hp);  %tris complex from mono, 2xapo3-
    end
    num_species = length(species);
    mspecies = zeros(1, num_species);
    sumintspecies = zeros(1,num_species);
    maxintspecies = zeros(1,num_species);
    meanmspecies = zeros(1,num_species);
    covariation = zeros(1,num_species);
    %----------------
     
    [intspecies,~,intchrom] = eic(species,ppmerr,minerr,pks,ts,0);
    
    tstartrow = 1;
    tendrow = length(ts);
    
    for k=1:size(intchrom,1)
        intchrom{k} = intchrom{k}(tstartrow:tendrow,:);
        intspecies(k) = sum(intchrom{k}(:,2));
    end
    
    for k=1:num_species
        foundm = find(~isnan(intchrom{k}(:,1)));
        if ~isempty(foundm)
            mspecies(k) = (intchrom{k}(foundm,2)' * intchrom{k}(foundm,1)) / sum(intchrom{k}(foundm,2));
            meanmspecies(k) = meanmspecies(k) + mspecies(k).*intspecies(k);
            sumintspecies(k) = sumintspecies(k)+intspecies(k);
            maxintspecies(k) = max(intchrom{k}(:,2));
            IntV1 = intchrom{1}(:,2);
            IntV2 = intchrom{k}(:,2);
            delrows = (IntV1==0 & IntV2==0); IntV1(delrows) = []; IntV2(delrows) = [];
            if ~isempty(IntV2) && MakeFigure == 0
                if max(IntV1) > 0
                    %[~,~,~,~,~,covariation(k),~,~] = ols(IntV1,IntV2,0);  %regression through the origin, ols is a function of a MatLab package by Kevin Sheppard (http://www.kevinsheppard.com/wiki/MFE_Toolbox); need to exclude all timepoints for which all intensities are zero (e.g. because of lost spray)
                    [covariation(k),~,~] = regression(IntV1,IntV2,'one');    %=R
                else
                    covariation(k) = NaN;
                end
            end
        end
    end
    
    meanmspecies = meanmspecies ./ sumintspecies;
    speciesfound = find(maxintspecies(2:length(maxintspecies)) >= absnoise);
    num_speciesfound = length(speciesfound);
    
    if MakeFigure == 1
        if num_species <= 3 | num_speciesfound == 0     %if number of species is smaller than 3, plot all 
            speciesfoundplot = find(maxintspecies(2:length(maxintspecies)) > 0);
        else
            speciesfoundplot = speciesfound; %if number of species is greater than 5, plot all that have high enough absolute intensity 
        end
        num_speciesfoundplot = length(speciesfoundplot);
        speciesplot = [1 speciesfoundplot+1];
        DataLegend = cell(num_speciesfoundplot+1,1);
        DataLegend{1} = num2str(mzvector(i));
        for j=1:num_speciesfoundplot
            DataLegend{j+1} = [deltaM_str{speciesfoundplot(j)+1} ' (' num2str(species(speciesfoundplot(j)+1)) ')'];
        end
        intplot = zeros(length(intchrom{1}(:,3)),num_speciesfoundplot+1);  
        maxint = zeros(num_speciesfoundplot+1,1);
        for j = 1:num_speciesfoundplot+1
            intplot(:,j) = intchrom{speciesplot(j)}(:,2);
            maxint(j) = max(intplot(:,j)); 
        end
        if num_speciesfoundplot > 1
        % sort data display (highest intensity first)
            maxint(1) = []; maxint(:,2) = 2:length(maxint)+1; maxint=sortrows(maxint,-1); 
            temp_intchrom = intchrom; temp_intplot = intplot; DataLegend_temp = DataLegend;
            for j = 2:num_speciesfoundplot+1
                intchrom(j) = temp_intchrom(maxint(j-1,2));
                intplot(:,j) = temp_intplot(:,maxint(j-1,2));
                DataLegend(j) = DataLegend_temp(maxint(j-1,2));
            end
        end
        h_plot = plot(intchrom{1}(:,3), intplot, '.-','linewidth',1.25);
        h_lgd = legend(DataLegend);
    end
       
    Output.selected(1,1,i) = deltaM_str(1);
    Output.selected(2,1,i) = num2cell(sumintspecies(1));
    Output.selected(3,1,i) = num2cell(mzvector(i));
    if num_speciesfound > 0
        Output.selected(1,2:num_speciesfound+1,i) = deltaM_str(speciesfound+1);
        Output.selected(2,2:num_speciesfound+1,i) = num2cell(sumintspecies(speciesfound+1)./sumintspecies(1));
        Output.selected(3,2:num_speciesfound+1,i) = num2cell(meanmspecies(speciesfound+1));
        Output.selected(4,2:num_speciesfound+1,i) = num2cell(covariation(1,speciesfound+1));
        Output.selected(5,2:num_speciesfound+1,i) = num2cell(maxintspecies(1,speciesfound+1));
    else
        Output.selected(1,2,i) = {'No species found'};
        Output.selected(2:4,2,i) = num2cell(0);
    end
    
    Output.all{2}(i,1:2) = [sumintspecies(1) num_speciesfound];
    Output.all{3}(i,1:2) = [mzvector(i) num_speciesfound];
    Output.all{4}(i,1:2) = [1 num_speciesfound];
    Output.all{2}(i,3:num_species+1) = sumintspecies(2:num_species)./sumintspecies(1);
    Output.all{3}(i,3:num_species+1) = meanmspecies(2:num_species);
    Output.all{4}(i,3:num_species+1) = covariation(1,2:num_species);
    Output.all{5}(i,3:num_species+1) = maxintspecies(2:num_species);

% To do: repetitive code - transfer into nested function
    % if RT window is given
    if ~isempty(RTstart) || ~(RTstart == 0 && RTend == 0)
        mspecies = zeros(1, num_species);
        sumintspecies = zeros(1,num_species);
        maxintspecies = zeros(1,num_species);
        meanmspecies = zeros(1,num_species);
        covariation = zeros(1,num_species);
    
        tstartrowRT = find(ts-RTstart(i) >= 0, 1, 'first');
        tendrowRT = find(ts-RTend(i) <= 0, 1, 'last');
        
        for k=1:size(intchrom,1)
            intchrom{k} = intchrom{k}(tstartrowRT:tendrowRT,:);
            intspecies(k) = sum(intchrom{k}(:,2));
        end

        for k=1:num_species
            foundm = find(~isnan(intchrom{k}(:,1)));
            if ~isempty(foundm)
                mspecies(k) = (intchrom{k}(foundm,2)' * intchrom{k}(foundm,1)) / sum(intchrom{k}(foundm,2));
                meanmspecies(k) = meanmspecies(k) + mspecies(k).*intspecies(k);
                sumintspecies(k) = sumintspecies(k)+intspecies(k);
                maxintspecies(k) = max(intchrom{k}(:,2));
                IntV1 = intchrom{1}(:,2);
                IntV2 = intchrom{k}(:,2);
                delrows = (IntV1==0 & IntV2==0); IntV1(delrows) = []; IntV2(delrows) = [];
                if ~isempty(IntV2) && MakeFigure == 0
                    if max(IntV1) > 0
                        %[~,~,~,~,~,covariation(k),~,~] = ols(IntV1,IntV2,0);  %regression through the origin, ols is a function of a MatLab package by Kevin Sheppard (http://www.kevinsheppard.com/wiki/MFE_Toolbox); need to exclude all timepoints for which all intensities are zero (e.g. because of lost spray)
                        [covariation(k),~,~] = regression(IntV1,IntV2,'one');    %=R
                    else
                        covariation(k) = NaN;
                    end
                end
            end
        end

        meanmspecies = meanmspecies ./ sumintspecies;
        speciesfound = find(maxintspecies(2:length(maxintspecies)) >= absnoise);
        num_speciesfound = length(speciesfound);
        
        Output.selectedRT(1,1,i) = deltaM_str(1);
        Output.selectedRT(2,1,i) = num2cell(sumintspecies(1));
        Output.selectedRT(3,1,i) = num2cell(mzvector(i));
        if num_speciesfound > 0
            Output.selectedRT(1,2:num_speciesfound+1,i) = deltaM_str(speciesfound+1);
            Output.selectedRT(2,2:num_speciesfound+1,i) = num2cell(sumintspecies(speciesfound+1)./sumintspecies(1));
            Output.selectedRT(3,2:num_speciesfound+1,i) = num2cell(meanmspecies(speciesfound+1));
            Output.selectedRT(4,2:num_speciesfound+1,i) = num2cell(covariation(1,speciesfound+1));
            Output.selectedRT(5,2:num_speciesfound+1,i) = num2cell(maxintspecies(1,speciesfound+1));
        else
            Output.selectedRT(1,2,i) = {'No species found'};
            Output.selectedRT(2:4,2,i) = num2cell(0);
        end

        Output.allRT{2}(i,1:2) = [sumintspecies(1) num_speciesfound];
        Output.allRT{3}(i,1:2) = [mzvector(i) num_speciesfound];
        Output.allRT{4}(i,1:2) = [1 num_speciesfound];
        Output.allRT{2}(i,3:num_species+1) = sumintspecies(2:num_species)./sumintspecies(1);
        Output.allRT{3}(i,3:num_species+1) = meanmspecies(2:num_species);
        Output.allRT{4}(i,3:num_species+1) = covariation(1,2:num_species);
        Output.allRT{5}(i,3:num_species+1) = maxintspecies(2:num_species);
    end
end


end
