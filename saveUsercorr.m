function [ pool ] = saveUsercorr( pool )
statusbox(pool,'Saving user correction...');
pool.corrPeakData = [];
for i=1:1:size(pool.allFilesData,2)
    updateWB(pool,size(pool.allFilesData,2),i,1);
    for u=1:1:size(pool.allFilesData{pool.selC}.Data,1)
        c = 1;
        for z=1:1:size(pool.corrFlag{i,u},1)
            if pool.corrFlag{i,u}(z,3)==0
                pool.corrPeakData{i,u}(c,:) = pool.corrFlag{i,u}(z,1:2);
                c = c+1;
            end
        end
        if isempty(pool.corrPeakData{i,u})
            pool.corrPeakData{i,u} = [0 0];
        end
    end
end
updateWB(pool,size(pool.allFilesData,2),i,0);
statusbox(pool,'...done.');
end