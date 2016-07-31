function [ pool ] = peakAdaptM( pool )
pool.Mpeaks = cell(1,size(pool.filename,2));
%pks = y  locs = x;
%FOR each file
for i=1:1:size(pool.allFilesData,2)
    updateWB(pool,size(pool.allFilesData,2),i,1);
    pool.markFalseRange(i) = 1;
    [pks,locs] = findpeaks(pool.allFilesData{i}.Data(5,:),...
        'MinPeakHeight',150);
    pool.plot.dPointsperBase(i) = (locs(size(locs,2))-locs(1)) / (pool.ladder(length(pool.ladder))-pool.ladder(1));
    
    [pks,locs] = findpeaks(pool.allFilesData{i}.Data(5,:),'MinPeakHeight',150,...
        'MinPeakDistance',pool.plot.dPointsperBase(i),...
        'MinPeakProminence',pool.plot.dPointsperBase(i));
    pool.Mpeaks{i}(:,2) = pks';%y
    pool.Mpeaks{i}(:,1) = locs';%x
end
updateWB(pool,size(pool.allFilesData,2),i,0);
% debug_dispGROUPINGrange = pool.plot.dPointsperBase
pool = calcpeakqual(pool);
%create distance matrix of all detected peaks
for i=1:1:size(pool.allFilesData,2)
    updateWB(pool,size(pool.allFilesData,2),i,1);
    peakmatrix{i} = zeros(length(pool.Mpeaks{i}));
    for u=1:1:size(pool.Mpeaks{i},1)
        for z=1:1:size(pool.Mpeaks{i},1)
            peakmatrix{i}(u,z) = pool.Mpeaks{i}(z,2)-pool.Mpeaks{i}(u,2);
        end
    end
end
updateWB(pool,size(pool.allFilesData,2),i,0);
for i=1:1:size(pool.allFilesData,2)
    updateWB(pool,size(pool.allFilesData,2),i,1);
    offset = 50;
    posROWsum = [];%clear
    ROWsum = sum(peakmatrix{i},2);%sum each coloum
    sortROWsum = sort(ROWsum);%sort by size
    %only consider positive values
    posROWsum = sortROWsum(length(pool.ladder)-floor(length(pool.ladder)./4):length(sortROWsum));
    posROWsum = posROWsum(posROWsum>0);
    posROWsum = posROWsum';%transpose vector
    diff = [0 posROWsum] - [posROWsum 0];%derivative of sorted sum
    [~,p] = min(diff);
    v=posROWsum(p);
    maxLowerPeak{i} = pool.Mpeaks{i}(find(ROWsum==abs(v)),:);
    antiTHRESH(i) = min(pool.Mpeaks{i}(:,2));
    if (antiTHRESH(i)<(500))
        threshold(i) = maxLowerPeak{i}(1,2) + offset;
    else
        threshold(i) = pool.minTH;
    end
    %protect last peak assuming it's high qual
    while( pool.Mpeaks{i}(length(pool.Mpeaks{i})-1,2)<=threshold(i)...
            || pool.Mpeaks{i}(length(pool.Mpeaks{i}),2)<=threshold(i) )
        offset=offset - 10;
        threshold(i) = maxLowerPeak{i}(1,2) + offset;
    end
end
updateWB(pool,size(pool.allFilesData,2),i,0);
pool = calcSSdist(pool);%calc minimum bp distance in marker fragments and adaptive grouping range
%apply low adaptive threshold
pool.Mpeaks = [];
for i=1:1:size(pool.allFilesData,2)
    updateWB(pool,size(pool.allFilesData,2),i,1);
    [pks,locs] = findpeaks(pool.allFilesData{i}.Data(5,:),'MinPeakHeight',threshold(i),...
        'MinPeakDistance',pool.adapGRPrng(i),...
        'MinPeakProminence',pool.adapGRPrng(i));
    pool.Mpeaks{i}(:,2) = pks;%y
    pool.Mpeaks{i}(:,1) = locs;%x
end
updateWB(pool,size(pool.allFilesData,2),i,0);
peakmatrix = [];
for i=1:1:size(pool.allFilesData,2)
    updateWB(pool,size(pool.allFilesData,2),i,1);
    peakmatrix{i} = zeros(length(pool.Mpeaks{i}));
    for u=1:1:size(pool.Mpeaks{i},1)
        for z=1:1:size(pool.Mpeaks{i},1)
            peakmatrix{i}(u,z) = pool.Mpeaks{i}(z,2)-pool.Mpeaks{i}(u,2);
        end
    end
end
updateWB(pool,size(pool.allFilesData,2),i,0);
%check for runaway
pool.HpeakCk = pool.Mpeaks;
for i=1:1:size(pool.allFilesData,2)
    updateWB(pool,size(pool.allFilesData,2),i,1);
    if size(pool.Mpeaks{i},1)>size(pool.ladder,1)
        pool.HpeakCk{i}(find(pool.HpeakCk{i}(:,2)==max(pool.HpeakCk{i}(:,2))),:) = [];
        hPeakdeldist(i) = max(pool.Mpeaks{i}(:,2))-mean(pool.HpeakCk{i}(:,2));
        adaptMaxThresh(i) = max(pool.HpeakCk{i}(:,2))*...
            (max(pool.Mpeaks{i}(:,2))./...
            max(pool.HpeakCk{i}(:,2))-2);
    end
end
updateWB(pool,size(pool.allFilesData,2),i,0);
pool.TAGpos = [];
for i=1:1:size(pool.allFilesData,2)
    updateWB(pool,size(pool.allFilesData,2),i,1);
    %compare dist in size standard
    refPeak=pool.HpeakCk{i}(length(pool.HpeakCk{i}));
    filteredPeaks=zeros(length(pool.ladder),1);
    filteredPeaksY=zeros(length(pool.ladder),1);
    filteredPeaks(length(pool.ladder))=pool.HpeakCk{i}(length(pool.HpeakCk{i}));
    filteredPeaksY(length(pool.ladder))=pool.HpeakCk{i}(length(pool.HpeakCk{i}),2);
    maxDist = (pool.HpeakCk{i}(length(pool.HpeakCk{i})) - ...%x pos first peak rom right
        pool.HpeakCk{i}(length(pool.HpeakCk{i})-1)) / ...%x pos second peak from right
        (pool.ladder(length(pool.ladder))-pool.ladder(length(pool.ladder)-1)) * ...
        pool.ladder(length(pool.ladder));
    for u=length(pool.ladder)-1:-1:1 %FOR peaks we need
        refDist=(pool.ladder(u+1) - pool.ladder(u))/pool.ladder(length(pool.ladder));
        refMax = zeros(length(pool.HpeakCk{i})-1,1);
        for z=length(pool.HpeakCk{i})-1:-1:1 %FOR found peaks
            refMax(z)=(refPeak - pool.HpeakCk{i}(z))/maxDist;
        end
        diff = refMax-refDist;
        diff(diff<0) = inf;
        [~,p] = min(abs(diff));
        filteredPeaks(u)=pool.HpeakCk{i}(p);
        filteredPeaksY(u) = pool.HpeakCk{i}(p,2);
        refPeak=pool.HpeakCk{i}(p);
    end
    pool.TAGpos{i}(:,1)=filteredPeaks;
    pool.TAGpos{i}(:,2)=filteredPeaksY;
end
updateWB(pool,size(pool.allFilesData,2),i,0);
for i=1:1:size(pool.allFilesData,2)
    updateWB(pool,size(pool.allFilesData,2),i,1);
    a = pool.TAGpos{i}(1,1);
    b = pool.TAGpos{i}(size(pool.TAGpos{i},1),1);
    pool.plot.dPointsperBase(i) = (b-a)./pool.ladder(size(pool.ladder,1));
end
updateWB(pool,size(pool.allFilesData,2),i,0);
% debug_dispGROUPINGrange = pool.plot.dPointsperBase
if(0)
    for i=1:1:size(pool.allFilesData,2)
        fig = figure;
        plot(pool.allFilesData{i}.Data(5,:));
        hold on;
        plot(pool.HpeakCk{i}(:,1),pool.HpeakCk{i}(:,2),'ro')
        hold off;
    end
end
end