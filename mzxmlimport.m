function [OutMSSpectra, OutMSTimes] = mzxmlimport(Filename, MSLevel)
% import LC-MS data from .mzXML file 
% uses the matlab functions mzxmlread and mzxml2peaks

% input:
% Filename = string cell array with the mzxml file name(s)
% MSLevel = number specifiying the MS level to import (1 for MS, 2 for MSMS etc)

% output:
% OutMSSpectra = MS1 mass spectra for each time point 
% OutMSTimes = vector with the times each mass spectrum was acquired
%   (for MSLevel==2: OutMSSpectra = MS2 mass spectra for each time point 
%   and OutMSTimes = time, m/z precursor mass and precursor intensity
%   in columns for each timepoint (in rows)

    OutMSSpectra = cell(length(Filename),1);
    OutMSTimes = cell(length(Filename),1);

    
    for i=1:length(Filename)    
        if MSLevel == 1
            disp(['File ' num2str(i)]);
            MStruct = mzxmlread(Filename{i}, 'Levels', MSLevel);
            [OutMSSpectra{i}, OutMSTimes{i}] = mzxml2peaks(MStruct, 'Levels', MSLevel);
                
        elseif MSLevel > 1
            disp(['File ' num2str(i)]);
            MStruct = mzxmlread(Filename{i}, 'Levels', MSLevel);
            [OutMSSpectra{i}, OutMSTimes{i}] = mzxml2peaks(MStruct, 'Levels', MSLevel);     
            for j=1:length(OutMSTimes{i})
               OutMSTimes{i}(j,2) = MStruct.scan(j).precursorMz.value;
               OutMSTimes{i}(j,3) = MStruct.scan(j).precursorMz.precursorIntensity;
            end
         end
            
    end
    
end
