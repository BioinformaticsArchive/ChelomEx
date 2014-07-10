function plotms(PeakList, linecolor, annotation)
% Plots centroided MS spectrum and annotates 10 most intense peaks if annotation == 1

if nargin < 2
    linecolor = 'b';
end

pks = sortrows(PeakList,-2);

plotms(2:3:3*length(PeakList),2)=PeakList(:,2);
plotms(1:3:3*length(PeakList),1)=PeakList(:,1);
plotms(2:3:3*length(PeakList),1)=PeakList(:,1);
plotms(3:3:3*length(PeakList),1)=PeakList(:,1);
plot(plotms(:,1),plotms(:,2), linecolor);

if annotation == 1
    annotate = min(10, size(PeakList,1));
    for i = 1:annotate
       text(double(pks(i,1)),double(pks(i,2)),num2str(roundn(pks(i,1),-4)))
    end
end

end