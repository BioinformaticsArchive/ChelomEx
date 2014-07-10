function [mzrange, yrange, tmz] = plot_pattern(pattern, mz, z, err, indx, diff, pks, ts, zoomtype, annotate)
% generates a plot of the expected isotope positions with error boundaries 
% (defined in pattern) at a given mz (within error err) and z and shows the experimental mass spectrum
% (pks, ts) with index (indx); if diff == 0 then absolute mass spectra are plotted;
% if diff == 1 then then peak differenes to the monoisotope (mz) are plotted
% returns the mzrange and yrange for the axis of the plot; can be used
% in the calling function; zoomtype defines which mzrange and yrange is
% returned; annotate==1 defines annotation of peaks; annotate==0 suppresses
% that annotation

mzrange = []; yrange = [];
tpks = pks{indx};


% get list of pattern mz values and parameters for plotting 
% color code lines to represent pattern.required category
% grouped peaks in pattern have dashed lines
% required = dark green (11) or light green (12)
% optional = grey (2)
% not allowed = red (31) or orange (32)

colors.dg = [0 120 0]./255; colors.lg = [0 200 0]./255;
colors.g = [0.5 0.5 0.5]; 
colors.dr = [200 0 0]./255; colors.lr = [240 120 0]./255;
num_pgroups = length(pattern);
numpks = 0;
for k = 1:num_pgroups
    numpks = numpks + length(pattern(k).dmz);
end
ptrn.m_expect = NaN(numpks+1,1); ptrn.m_found = NaN(numpks+1,1); ptrn.dmz = NaN(numpks+1,1); ptrn.err = NaN(numpks+1,1); 
ptrn.I = NaN(numpks+1,1); ptrn.IRel_expect = NaN(numpks+1,1); ptrn.IRel_found = NaN(numpks+1,1); ptrn.IRelerr = NaN (numpks+1,2); 
ptrn.linecolor = cell(numpks+1,1); ptrn.linestyle = cell(numpks+1,1);  %dashed if grouped, line if ungrouped
ptrn.ID = cell(numpks+1,1);

ptrn.m_expect(1) = mz;
% get mz and intensity of selected mz in given mass spectrum
mzpks = tpks(tpks(:,1) >= mz-err & tpks(:,1) <= mz+err, :);
if ~isempty(mzpks) 
    tmz = mzpks(mzpks(:,2) == max(mzpks(:,2)),:);
    mz = tmz(1,1);
else
    tmz = NaN(1,2); 
end


% calculate m/z values as differences to monoisotope, if diff==1
if diff == 1
    tpks(:,1) = tpks(:,1) - mz;
    mz = 0;
end

% monoisotope parameters
ptrn.m_found(1) = tmz(1,1);
ptrn.I(1) = tmz(1,2);
ptrn.IRel_expect(1) = Inf;
ptrn.IRel_found(1) = ptrn.I(1) / ptrn.I(1);
ptrn.dmz(1) = 0; ptrn.err(1) = err; ptrn.linecolor{1} = {'Color', [191 0 191]./255}; ptrn.linestyle{1} = {'LineStyle', '-'};
ptrn.required(1) = 11;
if z == 1
    ptrn.ID{1} = sprintf('%0s %8.4f','M^{+} =' ,mz);
else
    ptrn.ID{1} = sprintf('%0s %8.4f',['M^{' num2str(z) '+} ='] ,mz);
end

% other peak pattern parameters
k = 1;
for i = 1:num_pgroups
    num_ingroup = length(pattern(i).dmz);
    for j = 1:num_ingroup
        k = k+1;
        ptrn.m_expect(k) = mz + (pattern(i).dmz(j) / z);
        ptrn.dmz(k) = pattern(i).dmz(j);
        ptrn.err(k) = pattern(i).dmzerr(1,j) + max(mz*10^-6*pattern(i).dmzerr(2,j), pattern(i).dmzerr(3,j));
        ptrn.IRel_expect(k) = pattern(i).IRel(j);
        ptrn.IRelerr(k,:) = pattern(i).IRelerr(:,j)';
        ptrn.ID{k} = pattern(i).ID{j};
        ptrn.required(k) = pattern(i).required(1);
        switch pattern(i).required(1)
            case 11
                ptrn.linecolor{k} = {'Color', colors.dg};
            case 12
                ptrn.linecolor{k} = {'Color', colors.lg};
            case 2
                ptrn.linecolor{k} = {'Color', colors.g};
            case 31
                ptrn.linecolor{k} = {'Color', colors.dr};
            case 32
                ptrn.linecolor{k} = {'Color', colors.lr};
        end
        if num_ingroup > 1
            ptrn.linestyle{k} = {'LineStyle', '--'};
        else 
            ptrn.linestyle{k} = {'LineStyle', '-'};
        end
    end
    
end

% get ptrn.m_found and ptrn.IRel_found for each entry in pattern
for i = 2:numpks+1  % monoisotope parameters (i=1) were defined above
    ipks = tpks(tpks(:,1) >= ptrn.m_expect(i)-ptrn.err(i) & tpks(:,1) <= ptrn.m_expect(i) + ptrn.err(i), :);
    if ~isempty(ipks)                                                                   % found m/z peaks within error range
        if ~isnan(ptrn.I(1))                                                            % monoisotope peak was found
            ipks(:,3) = ipks(:,2) ./ ptrn.I(1); 
            ihits = ipks(ipks(:,3) >= ptrn.IRelerr(i,1) & ipks(:,3) <= ptrn.IRelerr(i,2),:); 
            if ~isempty(ihits)                                                          % peaks with correct IRel
                IRelerr = abs(ihits(:,3) - ptrn.IRel_expect(i));
                hit = ihits(IRelerr == min(IRelerr), :);
                ptrn.m_found(i) = hit(1,1);
                ptrn.I(i) = hit(1,2);
                ptrn.IRel_found(i) = hit(1,3);
            else                                                                        % no peaks with correct IRel
                IRelerr = abs(ipks(:,3)-ptrn.IRel_expect(i));
                hit = ipks(IRelerr == min(IRelerr), :);
                ptrn.m_found(i) = hit(1,1);
                ptrn.I(i) = hit(1,2);
                ptrn.IRel_found(i) = hit(1,3);
            end
        else                                                                            % monoisotope peak was not found
            mzerr = abs(ipks(:,1)-ptrn.m_expect(i));
            hit = ipks(mzerr == min(mzerr), :);
            ptrn.m_found(i) = hit(1,1);
            ptrn.I(i) = hit(1,2);
            ptrn.IRel_found(i) = NaN;
        end
    else                                                                                % no found peaks within m/z error range
        ptrn.m_found(i) = NaN;
        ptrn.IRel_found(i) = NaN;
    end
end

% get axis limits to zoom on 'species' or 'isotopes' 
switch zoomtype
    case 'unzoom'
        mzrange = [min(tpks(:,1))-10 max(tpks(:,1))+10];
    case 'zoomOut'
        mzrange = [min(ptrn.m_expect)-5 max(ptrn.m_expect)+5];                           
    case 'zoomIn'
        % min and max of pattern mzs and intensities within that mz
        % range in the spectrum
        mzrange = [min(ptrn.m_expect(ptrn.dmz > -7))-1 max(ptrn.m_expect(ptrn.dmz < 6))+3];
end
ymax = max(tpks((tpks(:,1) >= mzrange(1) & tpks(:,1) <= mzrange(2)),2))*1.15;
if isempty(ymax)   % no peaks found in mzrange)
    yrange = get(gca, 'YLim');
else
    yrange = [0 ymax];
end


% plot lines for pattern parameters
for i = 1:numpks+1 
    % vertical lines to represent error range of mz: from top and bottom of
    % plot reaching 5% of scale and 2 % of monoisotope intensity
    line([ptrn.m_expect(i)-ptrn.err(i) ptrn.m_expect(i)-ptrn.err(i)], [0.95*yrange(2) yrange(2)], ptrn.linecolor{i}{:}, ptrn.linestyle{i}{:});
    line([ptrn.m_expect(i)+ptrn.err(i) ptrn.m_expect(i)+ptrn.err(i)], [0.95*yrange(2) yrange(2)], ptrn.linecolor{i}{:}, ptrn.linestyle{i}{:});
    if ~isnan(ptrn.I(1))
        line([ptrn.m_expect(i)-ptrn.err(i) ptrn.m_expect(i)-ptrn.err(i)], [0 0.035*ptrn.I(1)], ptrn.linecolor{i}{:}, ptrn.linestyle{i}{:});
        line([ptrn.m_expect(i)+ptrn.err(i) ptrn.m_expect(i)+ptrn.err(i)], [0 0.035*ptrn.I(1)], ptrn.linecolor{i}{:}, ptrn.linestyle{i}{:});
    else
        line([ptrn.m_expect(i)-ptrn.err(i) ptrn.m_expect(i)-ptrn.err(i)], [0 0.02*yrange(2)], ptrn.linecolor{i}{:}, ptrn.linestyle{i}{:});
        line([ptrn.m_expect(i)+ptrn.err(i) ptrn.m_expect(i)+ptrn.err(i)], [0 0.02*yrange(2)], ptrn.linecolor{i}{:}, ptrn.linestyle{i}{:});
    end
    % horizontal 'ticks' to represent expected intensity and intensity range
    if ~isnan(tmz(1,2))
        % expected intensity
        line([ptrn.m_expect(i)-ptrn.err(i) ptrn.m_expect(i)-ptrn.err(i)+0.2*ptrn.err(i)], [ptrn.IRel_expect(i)*tmz(1,2) ptrn.IRel_expect(i)*tmz(1,2)], ptrn.linecolor{i}{:}, 'LineWidth', 5);
        line([ptrn.m_expect(i)+ptrn.err(i) ptrn.m_expect(i)+ptrn.err(i)-0.2*ptrn.err(i)], [ptrn.IRel_expect(i)*tmz(1,2) ptrn.IRel_expect(i)*tmz(1,2)], ptrn.linecolor{i}{:}, 'LineWidth', 5);
        % intensity range
        if ~isnan(ptrn.IRelerr(i,1)) % min Intensity
            line([ptrn.m_expect(i)-ptrn.err(i) ptrn.m_expect(i)-ptrn.err(i)+0.2*ptrn.err(i)], [ptrn.IRelerr(i,1)*tmz(1,2) ptrn.IRelerr(i,1)*tmz(1,2)], ptrn.linecolor{i}{:},'LineWidth', 2);
            line([ptrn.m_expect(i)+ptrn.err(i) ptrn.m_expect(i)+ptrn.err(i)-0.2*ptrn.err(i)], [ptrn.IRelerr(i,1)*tmz(1,2) ptrn.IRelerr(i,1)*tmz(1,2)], ptrn.linecolor{i}{:},'LineWidth', 2);
        end
        if ~isnan(ptrn.IRelerr(i,2)) % max Intensity
            line([ptrn.m_expect(i)-ptrn.err(i) ptrn.m_expect(i)-ptrn.err(i)+0.2*ptrn.err(i)], [ptrn.IRelerr(i,2)*tmz(1,2) ptrn.IRelerr(i,2)*tmz(1,2)], ptrn.linecolor{i}{:},'LineWidth', 2);
            line([ptrn.m_expect(i)+ptrn.err(i) ptrn.m_expect(i)+ptrn.err(i)-0.2*ptrn.err(i)], [ptrn.IRelerr(i,2)*tmz(1,2) ptrn.IRelerr(i,2)*tmz(1,2)], ptrn.linecolor{i}{:},'LineWidth', 2);
        end
    end
end  

% plot mass spectrum 
hold on;
plotms(tpks,'k', 0); 

% plot lines for found pattern peaks
% monoisotope
if ~isnan(ptrn.I(1))
    line([ptrn.m_found(1) ptrn.m_found(1)], [0 ptrn.I(1)], 'Color', 'b', 'LineWidth', 2);
    if annotate == 1
        text(ptrn.m_found(1),ptrn.I(1), sprintf('%0s', ptrn.ID{1}), 'FontSize', 7, 'Color', 'b', 'HorizontalAlignment', 'center',  'VerticalAlignment', 'bottom', 'Clipping', 'on');
    end
end
% other peaks
for i = 2:numpks+1 
   if ~isnan(ptrn.m_found(i))      %m/z of this isotope is found 
       if ~isnan(ptrn.IRel_found(i))    %also IRel is available (monoisotope is present)
           if ptrn.IRel_found(i) >= ptrn.IRelerr(i,1) & ptrn.IRel_found(i) <= ptrn.IRelerr(i,2) %intensity within error ranges -> plot in red annotate in red dmz, IRel, isotope.ID
               line([ptrn.m_found(i) ptrn.m_found(i)], [0 ptrn.I(i)], 'Color', 'b', 'LineWidth', 2);
               if annotate == 1
                text(ptrn.m_found(i),ptrn.I(i), sprintf('%0s %0s\n %0s %7.4f\n %0s %5.2f %0s','M ', ptrn.ID{i},'\Deltam =',ptrn.m_found(i)-ptrn.m_found(1),'I_{Rel}=',ptrn.IRel_found(i)*100,'%'), 'FontSize', 7, 'Color', 'b', 'HorizontalAlignment', 'center',  'VerticalAlignment', 'bottom','Clipping', 'on');
               end
              
           else                         %intensity not within error range -> plot in red annotate in blue dmz, IRel (isotope.ID)
               line([ptrn.m_found(i) ptrn.m_found(i)], [0 ptrn.I(i)], 'Color', [0.8 0 0.2], 'LineWidth', 2);
               if annotate == 1 
                text(ptrn.m_found(i),ptrn.I(i), sprintf('%0s %0s %0s\n %0s %7.4f\n %0s %5.2f %0s','(M ', ptrn.ID{i},')','\Deltam=',ptrn.m_found(i)-ptrn.m_found(1),'I_{Rel}=',ptrn.IRel_found(i)*100,'%'), 'FontSize', 7, 'Color', [0.8 0 0.2], 'HorizontalAlignment', 'center',  'VerticalAlignment', 'bottom','Clipping', 'on');
               end
           end
       else                             %IRel is not available -> plot in red annotate in red dmz (isotope.ID)
           line([ptrn.m_found(i) ptrn.m_found(i)], [0 ptrn.I(i)], 'Color', [0.8 0 0.2], 'LineWidth', 2);
           if annotate == 1
            text(ptrn.m_found(i),ptrn.I(i), sprintf('%0s %0s %0s\n %0s %7.4f','(M ', ptrn.ID{i},')','\Deltam=',ptrn.m_found(i)-ptrn.m_found(1)), 'FontSize', 7, 'Color', [0.8 0 0.2], 'HorizontalAlignment', 'center',  'VerticalAlignment', 'bottom','Clipping', 'on');
           end
       end
   else                           %m/z is not found -> do nothing
   end    
end
    


end

