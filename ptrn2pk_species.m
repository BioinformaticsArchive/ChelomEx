function results = ptrn2pk_species(pattern, ptrnresult, parameters, pksMS1, tsMS1, pksMS2, tsMS2, MS2err, MS2noise)   
% calls the functions ptrn2pk and search_species and combines the results
% of both functions

% input:
% pattern = structure with isotope pattern definition
% ptrnresult = result from search_Pattern function
% parameters = structure with parameters used in called functions, including mass errors, minimum chromatographic peak height for found species etc.
% pksMS1, tsMS1 = LCMS data from mzxmlimport
% pksMS2, tsMS2 = LCMS/MS data from mzxmlimport
% MS2err = constant mass error in amu used in analysis of MS/MS spectra
% MS2noise = minimum intensity of MS2 signals to be considered

% output:
% results = structure with fields
%   header = description of data contained in columns of results.data
%   data = matrix with combined results of both functions
%   flagID = string descriptions of flag numbers
%   scores = results of ptrn2pk function
%   apos = results of search_species function


%% 1) get scores for mz values in ptrnresult
    if ~isempty(ptrnresult.pks)
        fprintf('%0s\n', 'calculating scores...');
        ptrn2pk_results = ptrn2pk(pattern.pattern,ptrnresult,parameters, pksMS1,tsMS1,0);
        
%% 2) find species
        fprintf('%0s\n','finding species...');
        if nargin == 5
            species = search_species(pattern.species, ptrn2pk_results.data, parameters, pksMS1, tsMS1, 0);
        elseif nargin == 9
            species = search_species(pattern.species, ptrn2pk_results.data, parameters, pksMS1, tsMS1, 0, pksMS2, tsMS2, MS2err, MS2noise);
        end
        % if cancel button pressed during species search-> use only
        % entries in ptrn2pk results for which species search was completed
        ptrn2pk_results.data = ptrn2pk_results.data(1:size(species.data,1),:);  
        
        results.header = [ptrn2pk_results.header(1:3) species.header(1:4) cell(1) ptrn2pk_results.header(5:6) species.header(5:6) cell(1) ptrn2pk_results.header(7:9) species.header(7:9) cell(1) ptrn2pk_results.header(10:11) ptrn2pk_results.header(13:length(ptrn2pk_results.header)) cell(1) ptrn2pk_results.header(12)];
        results.data = [ptrn2pk_results.data(:,1:3) species.data(:,1:4) NaN(size(ptrn2pk_results.data,1),1) ptrn2pk_results.data(:,5:6) species.data(:,5:6) NaN(size(ptrn2pk_results.data,1),1) ptrn2pk_results.data(:,7:9) species.data(:,7:9) NaN(size(ptrn2pk_results.data,1),1) ptrn2pk_results.data(:,10:11) ptrn2pk_results.data(:,13:length(ptrn2pk_results.header)) NaN(size(ptrn2pk_results.data,1),1) ptrn2pk_results.data(:,12)];
        
        % flag peaks that failed ptrn2pk criteria but show high correlation with
        % apo or common MSMS peaks with apo or high intensity within peak retention time; 
        results.flagID = [ptrn2pk_results.flagID; {11 'check (found related species)'}]; 
        col.MS2hits = [5 7];  col.apocor = 8;
        results.data(results.data(:,1) == 9999 & results.data(:,4) > 0,1) = 11;
        results.scores = ptrn2pk_results;
        results.apos = species;
    else 
        results.header = 'no entries in ptrn2pk matrix'; 
        results.data = [];
    end
   
end