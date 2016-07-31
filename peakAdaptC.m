function pool = peakAdaptC( pool )
%pks = y | locs = x
pool.Cpeaks = [];
for i=1:1:size(pool.allFilesData,2)
    updateWB(pool,size(pool.allFilesData,2),i,1);
    for u=1:1:size(pool.allFilesData{i}.Data,1)-1
        pool.Cpeaks{i,u} = [];
        pool.Cpeaks{i,u} = [];
    end
end
updateWB(pool,size(pool.allFilesData,2),i,0);
%FOR each file
for i=1:1:size(pool.allFilesData,2)
    updateWB(pool,size(pool.allFilesData,2),i,1);
    %FOR each color
    for u=1:1:size(pool.allFilesData{i}.Data,1)-1
        threshFaktor = 1000;
        checkThreshold = (max(pool.allFilesData{i}.Data(u,:))/threshFaktor)>pool.minTH;
        threshold = checkThreshold*max(pool.allFilesData{i}.Data(u,:))/threshFaktor + ...
            (~checkThreshold)*pool.minTH;
        [pks,locs,w] = findpeaks(pool.allFilesData{i}.Data(u,:),...
            'MinPeakHeight',threshold,...
            'MinPeakDistance',pool.plot.dPointsperBase(i),...
            'MinPeakProminence',pool.plot.dPointsperBase(i)*3,...
            'WidthReference','halfheight');
        if isempty(locs)
            locs = 0;
        end
        if isempty(pks)
            pks = 0;
        end
        if isempty(w)
            w = 0;
        end
        pool.Cpeaks{i,u}(:,1) = locs;
        pool.Cpeaks{i,u}(:,2) = pks;
        pool.Cpeaks{i,u}(:,3) = w;
    end
end
updateWB(pool,size(pool.allFilesData,2),i,0);
for i=1:1:size(pool.allFilesData,2)
    updateWB(pool,size(pool.allFilesData,2),i,1);
    for u=1:1:size(pool.allFilesData{i}.Data,1)-1
        c = 0;
        for z=1:1:size(pool.Cpeaks{i,u},1)
            if pool.Cpeaks{i,u}(z,3)< (pool.plot.dPointsperBase(i)*3)
                widthcheckcolor{i,u}(z-c,:) = pool.Cpeaks{i,u}(z,:);
            else
                c = c+1;
            end
        end
    end
end
updateWB(pool,size(pool.allFilesData,2),i,0);
pool.Cpeaks = [];
pool.Cpeaks = widthcheckcolor;
% if 1
%     for i=1:1:size(pool.allFilesData,2)
%         fig = figure;
%         plot(pool.allFilesData{i}.Data(1,:));
%         hold on;
%         plot(pool.Cpeaks{i,1}(:,1),pool.Cpeaks{i,1}(:,2),'ro')
%         hold off;
%     end
% end
end