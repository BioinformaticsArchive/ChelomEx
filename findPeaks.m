function [OutPeaks] = findPeaks(mz, ppmerr, minerr, baseline, Runs, Times, Draw)        
% Finds chromatographic peaks of eics 
% defines constant baseline level, peaks start where signal increases above baseline and end where they fall below
% baseline; peak retention time is the time of absolute maximum within the peak window.

% input: 
% mz = m/z of species
% ppmerr = relative mass error in ppm
% minerr = minimum mass error in amu
% baseline = intensity of baseline for peak determination
% Runs, Times = LCMS data from mzxmlimport
% Draw == 1 creates figure; Draw == 0 does not show figure

% output:
% OutPeaks = cell array with peak information; row one contains the header 

%Initialization parameters
maxzeros = 4; %must be an even number!
minpeakwidth = 6;

OutPeaks(1,:) = {'Peak%' 'RTStart' 'RTEnd' 'RTMax' 'PeakMax' 'PeakSum' 'mz'};       
out = zeros(1,size(OutPeaks,2));
peaklist = [];

%EIC and find peaks
[int,~,chrom] = eic(mz, ppmerr, minerr, Runs, Times, Draw);  %int{j} contains integrals for m/z; chrom contains chromatogram info with (1)m/z values, (2)intensities, (3) times
smoothchrom = smooth(chrom{1}(:,2),maxzeros+1);
peakends = find((smoothchrom - baseline) <= 0);
if ~isempty(peakends)
    for k = 1:(length(peakends)-1)
        if peakends(k+1) - peakends(k) > minpeakwidth %min three signals above baseline in a peak 
            peaklist(size(peaklist,1)+1,:) = [peakends(k)+1 peakends(k+1)-1];  %peaks contains number of collected spectrum for start and end of peak. 
        end
    end
    if (length(Times) - peakends(length(peakends))) > minpeakwidth  
         peaklist(size(peaklist,1)+1,:) = [peakends(length(peakends))+1 length(Times)]; 
    end
else 
    peaklist = [1 length(Times)];
end

peak_num = size(peaklist,1);

if peak_num > 0 
    PeakRelInt = zeros(peak_num,1); RTStart = zeros(peak_num,1); RTEnd = zeros(peak_num,1); RTMax = zeros(peak_num,1); PeakMax = zeros(peak_num,1); PeakSum = zeros(peak_num,1); mz = zeros(peak_num,1); 
    for i = 1:peak_num
       PeakSum(i) = sum(chrom{1}(peaklist(i,1):peaklist(i,2),2));
       PeakRelInt(i) = round(PeakSum(i) / int(1) * 100);
       PeakMax(i) = max(chrom{1}(peaklist(i,1):peaklist(i,2),2));
       RTMax(i) = min(chrom{1}(chrom{1}(:,2) == PeakMax(i),3)); %the min is necessary to make sure that if 2 peaks have the same height, only one is chosen (the first one)
       RTStart(i) = chrom{1}(peaklist(i,1),3);
       RTEnd(i) = chrom{1}(peaklist(i,2),3);
       mzrows = find(~isnan(chrom{1}(peaklist(i,1):peaklist(i,2),1))) + peaklist(i,1) - 1;
       mz(i) =  chrom{1}(mzrows,2)' * chrom{1}(mzrows,1) / sum(chrom{1}(mzrows,2));
       out(i,:) = [PeakRelInt(i) RTStart(i) RTEnd(i) RTMax(i) PeakMax(i) PeakSum(i) mz(i)];
       if Draw == 1
           hold on;
           y = get(gca,'YLim');
           plot([RTStart(i) RTEnd(i)], [y(2) y(2)],'r-');
           plot([RTStart(i) RTStart(i)], y,'r-');
           plot([RTEnd(i) RTEnd(i)], y,'r-');
       end
    end
end

out = sortrows(out, -1);
if peak_num > 0
    OutPeaks(2:peak_num+1,:) = num2cell(out); 
else
    OutPeaks(2,:) = num2cell(out); 
end
        
end