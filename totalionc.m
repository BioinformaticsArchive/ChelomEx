function [intsum] = totalionc(peaks, times, makeplot)
% calculates and plots total ion chromatogram 
% input: 
% peaks = cell array with spectra (each cell one spectrum containing in columns mz and intensity)
% time = vector with according times for each spectrum
% makeplot == 1 creates a TIC plot; makeplot == 0 does not

% output: 
% intsum = matrix with time and total ion intensity in columns


timelength = length(times);
intsum = zeros(timelength,2);


for j=1:timelength
    intsum(j,1) = times(j);
    intsum(j,2) = sum(peaks{j}(:,2));
end
 
if makeplot == 1
    plot(intsum(:,1), intsum(:,2)); 
end


end

 