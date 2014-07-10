function [found, data] = findapoMS2(mz1,RT1, mz2, RT2, MS1err, MS2err, minInt, pksMS2, tsMS2, MakePlot)
% uses MS/MS data to find chemically related species
% searches MS/MS spectra of two precursors for common fragements or fragments with a mass difference that equals that of the two precursors

% input:
% mz1, mz2 = m/z values of precursors
% RT1, RT2 = retention time boundary of precursors
% abserror = constant mass error in amu for comparison of MS/MS features
% minInt = minimum intensity for MS2 peaks to consider. if minint < 1 it is
%   interpreted as relative intensity to max peak if it is > 1 it is
%   interpreted as needed absolute intensity
% pksMS2, tsMS2 = LCMSMS dataset from mzxmlimport
% MakePlot == 1 creates a plot of found MSMS spectra and found common
%   features; MakePlot == 0 does not create a plot

% output:
% found = number of found related MS2 signals
% data = structure with fields 
%   MS2(n).precursor = precursor information 
%   MS2(n).spectrum = MS2 spectra of both precursors
%   common.maxMS2pk = maximum intensity of MS2 spectrum signals
%   common.spectrum = common MS2 signfals; matrix contains in col1 = mz1; col2=IRel1; col3=mz2; col4=IRel2
%   common.s = selected MS2 spectrum of one precursor which the other
%     spectrum is compared to 

[numMSMS, MS2slct] = existMSMS([mz1 mz2], MS1err, tsMS2);
mz = [mz1 mz2];
RT= [RT1;RT2];
%extend RT window to include the base of the peak
RT(1,1) = max(0,RT(1,1)-(0.5*(RT(1,2)-RT(1,1)))); RT(1,2) = min(tsMS2(length(tsMS2)),RT(1,2) + (0.5*(RT(1,2)-RT(1,1))));
RT(2,1) = max(0,RT(2,1)-(0.5*(RT(2,2)-RT(2,1)))); RT(2,2) = min(tsMS2(length(tsMS2)),RT(2,2) + (0.5*(RT(2,2)-RT(2,1))));
notinpk = zeros(2,1); %variable is set to 1 if MS/MS spectrum is found but spectrum was collected outside of peak retention time boundaries; NOT USED AT THE MOMENT

%if MSMS spectra for both mz values are found
if numMSMS(1) * numMSMS(2) > 0
    for i = 2:-1:1
        slct = MS2slct{i}(MS2slct{i}(:,1) >= RT(i,1) & MS2slct{i}(:,1) <= RT(i,2),:);
        if isempty(slct)
            notinpk(i) = 1;
            slct = MS2slct{i};
        end
        data.MS2(i).precursor = slct(find(slct(:,4) == max(slct(:,4)),1),:);  %choose MSMS spectrum with highest intensity
        data.MS2(i).spectrum = pksMS2{data.MS2(i).precursor(1)};
        %for MS2 spectra comparison use only MS2 peaks with mz difference
        %to precursor > 50 and intensity > minint 
        compareMS2{i} = data.MS2(i).spectrum; 
        dmz = compareMS2{i}(:,1) - mz(i); 
        dmz(dmz>50) = dmz(dmz > 50) - mz(i);  %species with lower charges
        dmz(dmz>50) = dmz(dmz > 50) - mz(i);
        maxMS2pk(i) = max(compareMS2{i}(:,2));
        compareMS2{i}(:,3) = compareMS2{i}(:,2) ./ maxMS2pk(i); %relative intensities
        if minInt < 1
            compareMS2{i} = compareMS2{i}(abs(dmz)>50 & compareMS2{i}(:,3) >= minInt,:);    
        else
            compareMS2{i} = compareMS2{i}(abs(dmz)>50 & compareMS2{i}(:,2) >= minInt,:);               
        end
        numMS2pks(i) = size(compareMS2{i},1);
    end

%compare spectra 
    s = find(numMS2pks == min(numMS2pks),1);
    data.common.s = s; data.common.maxMS2pk = maxMS2pk;
    if s==1
        n = 2;
    elseif s==2
        n = 1;
    end
    dprec = data.MS2(n).precursor(3) - data.MS2(s).precursor(3); %mz difference between precursors
    data.common.spectrum = zeros(length(compareMS2{i}),4); %col1 = mz1; col2=IRel1; col3=mz2; col4=IRel2;
    for i = 1:numMS2pks(s)
        dmz = compareMS2{n}(:,1) - compareMS2{s}(i,1);
        dmz2 = compareMS2{n}(:,1) - dprec - compareMS2{s}(i,1);
        hits = compareMS2{n}(abs(dmz) <= MS2err | abs(dmz2) <= MS2err,:);
        if ~isempty(hits)
            hits = hits(hits(:,2) == max(hits(:,2)),:); 
            if s == 1
                data.common.spectrum(i,1:2) = compareMS2{s}(i,[1 3]);
                data.common.spectrum(i,3:4) = hits(1,[1 3]);
            elseif s == 2
                data.common.spectrum(i,3:4) = compareMS2{s}(i,[1 3]);
                data.common.spectrum(i,1:2) = hits(1,[1 3]);
            end
            data.common.spectrum(i,5) = abs(data.common.spectrum(i,1) - data.common.spectrum(i,3));
            if data.common.spectrum(i,5) > MS2err
                data.common.spectrum(i,5) = data.common.spectrum(i,5) + dprec;
            end
        end
    end
    data.common.spectrum(data.common.spectrum(:,1) == 0,:) = [];
    found = size(data.common.spectrum,1);
    
    
    if MakePlot == 1
        subplot(2,1,1); plotms(data.MS2(1).spectrum, 'b', 1); range = xlim; hold on;
        if ~isempty(data.common.spectrum)
            for i = 1:size(data.common.spectrum,1)
                if s == 1
                    plot([data.common.spectrum(i,1) data.common.spectrum(i,1)], [(data.common.spectrum(i,2)+0.1)*maxMS2pk(1) maxMS2pk(1)], 'r-'); 
                elseif s == 2 
                    plot([data.common.spectrum(i,1)-MS2err data.common.spectrum(i,1)-MS2err], [(data.common.spectrum(i,2)+0.1)*maxMS2pk(1) maxMS2pk(1)], 'r-'); 
                    plot([data.common.spectrum(i,1)+MS2err data.common.spectrum(i,1)+MS2err], [(data.common.spectrum(i,2)+0.1)*maxMS2pk(1) maxMS2pk(1)], 'r-'); 
                end
            end
        end
        subplot(2,1,2); plotms(data.MS2(2).spectrum, 'r', 1); xlim(range); hold on;
        if ~isempty(data.common.spectrum)
            for i = 1:size(data.common.spectrum,1)
                if s == 2
                    plot([data.common.spectrum(i,3) data.common.spectrum(i,3)], [(data.common.spectrum(i,4)+0.1)*maxMS2pk(2) maxMS2pk(2)], 'b-'); 
                elseif s == 1 
                    plot([data.common.spectrum(i,3)-MS2err data.common.spectrum(i,3)-MS2err], [(data.common.spectrum(i,4)+0.1) maxMS2pk(2)], 'b-'); 
                    plot([data.common.spectrum(i,3)+MS2err data.common.spectrum(i,3)+MS2err], [(data.common.spectrum(i,4)+0.1) maxMS2pk(2)], 'b-'); 
                end
            end
        end
    end
    
else
    found = 0;
    data = [];
%    if numMSMS(1) == 0
%        disp('no MS2 spectrum for precursor #1');
%    end
%    if numMSMS(2) == 0
%        disp('no MS2 spectrum for precursor #2');
%    end
end

end
