function [num_MSMS, MS2slct]  = existMSMS(mz, error, TimesMS2)
% find MSMS spectra for given precursor m/zs within error range

% input:
% mz = vector with precursor m/z value(s)
% error = constant error in amu
% TimesMS2 = matrix with times for MSMS events (column1) with according mz
%   precursor masses (column2) and precursor intensities (column3). This
%   matrix is generated during import of an mzxml file with mzxmlimport.

% output:
% num_MSMS = number of found MS2 spectra
% MS2slct =  cell array; each cell contains in cols: row number in TimesMS2, time, m/z, precursor intensity

num_pre = length(mz);
num_MSMS = zeros(num_pre,1);
MS2slct = cell(num_pre,1); 

for i=1:num_pre 
    for j = 1:length(TimesMS2(:,2))
        if (TimesMS2(j,2) >= mz(i) - error) && (TimesMS2(j,2) <= mz(i) + error)
            num_MSMS(i) = num_MSMS(i)+1;
            MS2slct{i}(num_MSMS(i),1:4) = [j TimesMS2(j,:)];
        end
    end
end
end