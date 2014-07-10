function [intsum, eicsum, hit, handles] = eic(mz, ppmerror, minerror, mzint, time, makeplot)
% Extracts Ion Chromatograms and creates EIC figure

% Input: 
% mz = vector with mz values of ions to extract 
% ppmerror = relative mass error in ppm
% minerror = minimum mass error in amu
% mzint = Cell array with an mz vs intensity spectrum from mzxmlimport function
% time = vector with a time value in each row from mzxmlimport function
% makeplot == 1: Plot of the eic is drawn; makeplot == 0: No Plot is made

% Output: 
% intsum = vector of sum of intensities for each mz value
% eicsum = sum of intensities (column 1) of all mz values for each time point (column 2)
% hit = cell array; each cell contains matrix for one mz value with 3 columns:
%   column1: with mz values that were found within error range
%   column2: vector with according intensities
%   column3: vector with according times (same as input time vector)
% handles = vector with handles to all EICs if makeplot==1

mzlength = length(mz);
timelength = length(time);
hit = cell(mzlength,1);
intsum = zeros(mzlength,1);
eicsum = zeros(timelength,2);
eicsum(:,2) = time;
intplot = zeros(timelength, mzlength);
handles = NaN(mzlength,1);

DataLegend = cell(mzlength,1);

if mzlength > 50
    progbar = waitbar(0,sprintf('%3.1f %0s',0,' %'), 'Name', 'getting EICs, please wait...', 'CreateCancelBtn', 'setappdata(gcbf,''canceling'',1)');
    setappdata(progbar, 'canceling', 0);
end

for j=1:mzlength
    % progress bar
    if mzlength > 50
        done = j/mzlength;
        waitbar(done, progbar, sprintf('%3.1f %0s',done*100,' %'));        
    end
    hit{j}(1:length(time),1) = NaN;
    hit{j}(:,2) = 0;
    hit{j}(:,3) = time;
    error = max(minerror, ppmerror*10^-6*mz(j));
    
    highmz = mz(j)+error;
    lowmz = mz(j)-error;
    for i=1:timelength
        r = (mzint{i}(:,1) <= highmz & mzint{i}(:,1) >= lowmz);
        if ~isempty(find(r,1))  % if more than 1 m/z is found per spectrum as a result of the given ppm error then use average weighed by intensity             
          foundmz=mzint{i}(r,1);
          foundint=mzint{i}(r,2);
          hit{j}(i,2) = sum(foundint);
          hit{j}(i,1) = sum(foundmz'*foundint./hit{j}(i,2));         
        end
    end
    
    intsum(j) = sum(hit{j}(:,2));    
    intplot(1:length(time),j) = hit{j}(:,2);
    DataLegend{j} = num2str(mz(j));
end

if mzlength > 50
    delete(progbar);
end

for j=1:timelength            %calcules sumeic
    for k = 1:mzlength
        eicsum(j,1) = eicsum(j,1) + hit{k}(j,2);
    end
end
    
if makeplot == 1
    handles = plot(time, intplot,'.-','linewidth',1.25); 
    %addaxisplot(time/60, intplot,2,'-','linewidth',1.25, 'color', [0 0 1]); 
    legend(DataLegend); 
end

end

 