function [ pool ] = calcpeakqual( pool )
for i=1:1:size(pool.allFilesData,2)
    lastpeak{i} = pool.Mpeaks{1,i}(size(pool.Mpeaks{1,i},1),:);
    ndlastpeak{i} = pool.Mpeaks{1,i}(size(pool.Mpeaks{1,i},1)-1,:);
    peakdist{i} = lastpeak{i}-ndlastpeak{i};
    peakdistbp(i) = peakdist{i}(1)./pool.plot.dPointsperBase(i);
    factor = pool.ladder(length(pool.ladder))-pool.ladder(length(pool.ladder)-1);
    factor = factor + factor*0.5;
    if peakdistbp(i)>factor
        pool.Mpeaks{i} = pool.Mpeaks{i}(1:size(pool.Mpeaks{i},1)-1,:);
    end
end
end