function results = search_Pattern(pattern, zs, minInt, noise, minerr, ppmerr, pks, ts, target_mz, polarity, offerr)   
% finds isotope patterns, combines found m/z values and sorts the results accoding to peak intensity
% calls to find_pattern, group_pattern and sort_results_pks functions

% input:
% pattern = structure with isotope pattern definition
% zs = z values to be included in pattern search (e.g. [1:4])
% minInt = only signals in the mass spectra that are > minInt are considered for the Monoisotope
% noise = only signals that are > noise are used in the pattern search
% minerr = minimum mass error in amu
% ppmerr = relative mass error in ppm
% pks and ts = LCMS data from mzxmlimport
% target_mz = optional vector with m/z values; if given only these m/z
%    values are used as potential Monoisotopes in the pattern search
% polarity = optional string required if target_mz is given, can be 'Positive' or 'Negative'
% offerr = mass error offset (used if target_mz is given)

% output:
% results = structure with fields
    % pks = matrix with grouped m/z values 
    % pks_header = header cell vector with description of each column in pks
    % pkspattern = contains the found m/z values for each grouped m/z value in pks
    % mzhistogram = can be used to generate plot of number of found m/z
    %   values for each species
    
%% 1) find pattern
fprintf('%0s\n', 'finding patterns...');
if nargin == 8       % untargeted search
    hits = find_pattern(pattern,zs,minInt,noise,pks, ts, 0);
elseif nargin == 11  % targeted search
    hits = find_pattern(pattern,zs,minInt,noise,pks, ts, 0, target_mz, polarity, [offerr ppmerr minerr]);
end    

%% 2) combine same m/z values
if ~isempty(hits.pattern)
    fprintf('%0s\n', 'grouping m/z values...');
    results = group_pattern(pattern, hits, minerr, ppmerr, 0); % col1: num hits; col2: average time; col3 sum of int; col4 average m/z; col5 z; col6,7: mz isotpope1 and rel int. isotope1; dito for  other isotopes  
    if ~isempty(results.pks)
        % sort results.pks and results.pkspattern
        results = sort_results_pks(results, [3 -4]);
    end
else 
    results.pks = []; results.pkspattern = [];
end
