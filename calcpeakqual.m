function [ pool ] = calcpeakqual( pool,i )
    lastpeak = pool.Mpeaks2{1,i}(size(pool.Mpeaks2{1,i},1),1);
    ndlastpeak = pool.Mpeaks2{1,i}(size(pool.Mpeaks2{1,i},1)-1,1);
    peakdist = lastpeak-ndlastpeak;
    peakdistbp = peakdist(1)./pool.plot.dPointsperBase(i);
    factor = pool.ladder(length(pool.ladder))-pool.ladder(length(pool.ladder)-1);
    factor = factor + factor*0.1;
    if peakdistbp>factor
        pool.Mpeaks2{i}(size(pool.Mpeaks2{i},1),:)=[];
    end
end