function [ pool ] = peakAdaptM( pool )
pool.Mpeaks = cell(1,size(pool.filename,2));
pool.Mpeaks2 = cell(1,size(pool.filename,2));
%pks = y  locs = x;
%FOR each file
for i=1:1:size(pool.allFilesData,2)
    updateWB(pool,size(pool.allFilesData,2),i,1);
    pool.markFalseRange(i) = 1;
    [~,locs] = findpeaks(pool.allFilesData{i}.Data(5,:),...
        'MinPeakHeight',150);
    pool.plot.dPointsperBase(i) = (locs(size(locs,2))-locs(1)) / (pool.ladder(length(pool.ladder))-pool.ladder(1));
    
    [pks,locs] = findpeaks(pool.allFilesData{i}.Data(5,:),'MinPeakHeight',150,...
        'MinPeakDistance',pool.plot.dPointsperBase(i),...
        'MinPeakProminence',150);
    pool.Mpeaks{i}(:,2) = pks';%y
    pool.Mpeaks{i}(:,1) = locs';%x
end
updateWB(pool,size(pool.allFilesData,2),i,0);
%check highest peaks quality
for i=1:1:size(pool.allFilesData,2)
    %calc mean with all peaks
    while size(pool.Mpeaks{i},1)>size(pool.ladder,1)
    YmeanALL = mean(pool.Mpeaks{i}(:,2));
    YmeanHighR = (sum(pool.Mpeaks{i}(:,2))-max(pool.Mpeaks{i}(:,2)))./(size(pool.Mpeaks{i}(:,2),1)-1);
    diffpercent = 100*(YmeanALL-YmeanHighR)./YmeanALL;
    if (diffpercent>5)
        pool.Mpeaks{i}(find(pool.Mpeaks{i}(:,2)==max(pool.Mpeaks{i}(:,2))),:) = [];
    else
        break;
    end
    end
end
% debug_dispGROUPINGrange = pool.plot.dPointsperBase
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
    if (antiTHRESH(i)<(300))
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
for i=1:1:size(pool.allFilesData,2)
    peakremoved = 0;
    updateWB(pool,size(pool.allFilesData,2),i,1);
    [pks,locs] = findpeaks(pool.allFilesData{i}.Data(5,:),'MinPeakHeight',threshold(i),...
        'MinPeakDistance',pool.adapGRPrng(i),...
        'MinPeakProminence',threshold(i));
    pool.Mpeaks2{i}(:,2) = pks;%y
    pool.Mpeaks2{i}(:,1) = locs;%x
    while size(pool.Mpeaks2{i},1)<=size(pool.ladder,1)
        threshold(i) = threshold(i)-10;
        [pks,locs] = findpeaks(pool.allFilesData{i}.Data(5,:),'MinPeakHeight',threshold(i),...
            'MinPeakDistance',pool.adapGRPrng(i),...
            'MinPeakProminence',threshold(i));
        pool.Mpeaks2{i} = [];
        pool.Mpeaks2{i}(:,2) = pks;%y
        pool.Mpeaks2{i}(:,1) = locs;%x
    end
    pool = calcpeakqual(pool,i);
    while size(pool.Mpeaks2{i},1)>=size(pool.ladder,1)
        YmeanALL = mean(pool.Mpeaks2{i}(:,2));
        YmeanHighR = (sum(pool.Mpeaks2{i}(:,2))-max(pool.Mpeaks2{i}(:,2)))./(size(pool.Mpeaks2{i}(:,2),1)-1);
        diffpercent = 100*(YmeanALL-YmeanHighR)./YmeanALL;
        if (diffpercent>2.5)
            pool.Mpeaks2{i}(find(pool.Mpeaks2{i}(:,2)==max(pool.Mpeaks2{i}(:,2))),:) = [];
            peakremoved = 1;
        else
            break;
        end
    end
    if ~peakremoved && size(pool.Mpeaks2{i},1)>size(pool.ladder,1)
        pool.Mpeaks2{i}(find(pool.Mpeaks2{i}(:,2)==min(pool.Mpeaks2{i}(:,2))),:) = [];
    end
end
updateWB(pool,size(pool.allFilesData,2),i,0);
peakmatrix = [];
for i=1:1:size(pool.allFilesData,2)
    updateWB(pool,size(pool.allFilesData,2),i,1);
    peakmatrix{i} = zeros(length(pool.Mpeaks2{i}));
    for u=1:1:size(pool.Mpeaks2{i},1)
        for z=1:1:size(pool.Mpeaks2{i},1)
            peakmatrix{i}(u,z) = pool.Mpeaks2{i}(z,2)-pool.Mpeaks2{i}(u,2);
        end
    end
end
pool.TAGpos = [];
for i=1:1:size(pool.allFilesData,2)
    updateWB(pool,size(pool.allFilesData,2),i,1);
    %compare dist in size standard
    refPeak=pool.Mpeaks2{i}(length(pool.Mpeaks2{i}));
    filteredPeaks=zeros(length(pool.ladder),1);
    filteredPeaksY=zeros(length(pool.ladder),1);
    filteredPeaks(length(pool.ladder))=pool.Mpeaks2{i}(length(pool.Mpeaks2{i}));
    filteredPeaksY(length(pool.ladder))=pool.Mpeaks2{i}(length(pool.Mpeaks2{i}),2);
    maxDist = (pool.Mpeaks2{i}(length(pool.Mpeaks2{i})) - ...%x pos first peak rom right
        pool.Mpeaks2{i}(length(pool.Mpeaks2{i})-1)) / ...%x pos second peak from right
        (pool.ladder(length(pool.ladder))-pool.ladder(length(pool.ladder)-1)) * ...
        pool.ladder(length(pool.ladder));
    for u=length(pool.ladder)-1:-1:1 %FOR peaks we need
        refDist=(pool.ladder(u+1) - pool.ladder(u))/pool.ladder(length(pool.ladder));
        refMax = zeros(length(pool.Mpeaks2{i})-1,1);
        for z=length(pool.Mpeaks2{i})-1:-1:1 %FOR found peaks
            refMax(z)=(refPeak - pool.Mpeaks2{i}(z))/maxDist;
        end
        diff = refMax-refDist;
        diff(diff<0) = inf;
        [~,p] = min(abs(diff));
        filteredPeaks(u)=pool.Mpeaks2{i}(p);
        filteredPeaksY(u) = pool.Mpeaks2{i}(p,2);
        refPeak=pool.Mpeaks2{i}(p);
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
    set(0, 'DefaultFigureVisible', 'on')
    for i=1:1:size(pool.allFilesData,2)
        fig = figure;
        plot(pool.allFilesData{i}.Data(5,:));
        hold on;
        plot(pool.Mpeaks2{i}(:,1),pool.Mpeaks2{i}(:,2),'ro')
        hold off;
    end
    set(0, 'DefaultFigureVisible', 'off')
end
end