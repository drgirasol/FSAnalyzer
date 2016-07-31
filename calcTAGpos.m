function [ pool ] = calcTAGpos( pool )
corrTagData = [];
corrTagDataTMP = [];
corrTagDataTMP = pool.corrFlag{pool.selF,size(pool.corrFlag,2)};
c=1;
for z=1:1:size(corrTagDataTMP,1)
    if corrTagDataTMP(z,3)==0
        corrTagData(c,:) = corrTagDataTMP(z,1:2);
        c = c+1;
    end
end
%compare dist in size standard
refPeak=corrTagData(size(corrTagData,1),1);
filteredPeaks=zeros(length(pool.ladder),1);
filteredPeaksY=zeros(length(pool.ladder),1);
filteredPeaks(length(pool.ladder))=corrTagData(size(corrTagData,1),1);
filteredPeaksY(length(pool.ladder))=corrTagData(size(corrTagData,1),2);
RfirstX = corrTagData(size(corrTagData,1),1);
RSfirstX = corrTagData(size(corrTagData,1)-1,1);
lFactor = (pool.ladder(length(pool.ladder))-pool.ladder(length(pool.ladder)-1)) * pool.ladder(length(pool.ladder));
maxDist = ((RfirstX - RSfirstX) / lFactor);
for i=length(pool.ladder)-1:-1:1 %FOR peaks we need
    refDist=(pool.ladder(i+1) - pool.ladder(i))/pool.ladder(length(pool.ladder));
    refDist2(i) = refDist;
    refMax = zeros(length(corrTagData)-1,1);
    for u=length(corrTagData)-1:-1:1 %FOR found peaks
        refMax(u)=(refPeak - corrTagData(u))/maxDist;
    end
    diff = refMax-refDist;
    diff(diff<0) = inf;
    [~,p] = min(abs(diff));
    filteredPeaks(i)=corrTagData(p);
    filteredPeaksY(i) = corrTagData(p,2);
    refPeak=corrTagData(p);
end
pool.sTAGpos = [];
pool.sTAGpos(:,1) = filteredPeaks;
pool.sTAGpos(:,2) = filteredPeaksY;
end