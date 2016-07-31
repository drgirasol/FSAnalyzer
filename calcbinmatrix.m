% calcbinmatrix.m calculates the binmatrix for every file while TBP data is
% analyzed. because of the limted amount of data points in dye channel 5 
% (marker) a Piecewise Cubic Hermite Interpolating Polynomial (PCHIP) is
% performed. the length of the largest fragment divided by the stepsize
% defines the total amount of steps and the possible "resolution" of
% analysed fragments bp size.
function [ pool,x ] = calcbinmatrix( pool )
ladder = pool.ladder';
stepsize = 0.01;
vector = 0:stepsize:(max(ladder)-stepsize);
lfm = 1:1:ladder(size(ladder,2));
pool.binmatrix = [];
pool.binmatrix = zeros(length(lfm),length(pool.filename));
for i=1:1:size(pool.corrPeakData,1)
    pool.fcc(i) = size(pool.ladder,1) ~= size(pool.corrPeakData{i,size(pool.corrPeakData,2)},1);
end
if sum(pool.fcc) == 0
    statusbox(pool,'Calculating binmatrix...');
    pool.interpolation = [];
    pool.fragmentsize = [];
    for i=1:1:size(pool.filename,2)
        updateWB(pool,size(pool.filename,2),i,1);
        statusbox(pool,strcat('...for File No. ',num2str(i),'...'));
        pool.interpolation{i} = pchip(ladder,pool.corrPeakData{i,size(pool.corrPeakData,2)}(:,1),vector);
        for u=1:1:size(pool.corrPeakData{i,pool.selC},1)
            if (u==1)
                c=1;
            end
            if (pool.corrPeakData{i,pool.selC}(u,1)<min(pool.interpolation{i}))
                continue;
            end
            if (pool.corrPeakData{i,pool.selC}(u,1)>max(pool.interpolation{i}))
                continue;
            end
            calengthbp = [];
            calengthbp = find((pool.interpolation{i}>[pool.corrPeakData{i,pool.selC}(u,1)-0.5] & pool.interpolation{i}<[pool.corrPeakData{i,pool.selC}(u,1)+0.5]));
            calengthbp1 = [];
            calengthbp1 = sum(calengthbp);
            xlengthbp = [];
            xlengthbp = [round(calengthbp1./length(calengthbp))];
            pool.fragmentsize{i}(c) = xlengthbp*stepsize;
            c=c+1;
        end
        if ~isempty(pool.fragmentsize)
            for z=1:1:length(pool.fragmentsize{i})
                if ~round(pool.fragmentsize{i}(z))
                else
                    pool.binmatrix(round(pool.fragmentsize{i}(z)),i) = 1;
                end
            end
        end
    end
    updateWB(pool,size(pool.filename,2),i,0);
    if pool.pcr
        for i=1:1:length(pool.filename)
            for z=1:pool.ignbasesV
                pool.binmatrix(z,i) = 0;
            end
        end
    end
    x=sum(arrayfun(@str2num, num2str(349701)));%cross sum - for the lulz
    statusbox(pool,'...done.');
else
    x=1;
    statusbox(pool,'Error: Inconsistency found between markerdata and reference ladder.');
end
end