function [ pool ] = plotcorrmarks( pool )
if pool.plot.flagC == 0;%markerdata is plotted
    pool.plot.mPks = gobjects(1);
    for i=1:1:size(pool.corrFlag{pool.selF,size(pool.allFilesData{pool.selF}.Data,1)},1)
        if pool.corrFlag{pool.selF,size(pool.allFilesData{pool.selF}.Data,1)}(i,3) == 1
            x = pool.corrFlag{pool.selF,size(pool.allFilesData{pool.selF}.Data,1)}(i,1);
            y = pool.corrFlag{pool.selF,size(pool.allFilesData{pool.selF}.Data,1)}(i,2);
            pool.plot.mPks(i) = plot(x,y,'Marker','x',...
                'MarkerSize',6,...
                'Color','b',...
                'markerfacecolor','b');
        end
    end
else%dyedata is plotted
    pool.plot.mPks = gobjects(1);
    for i=1:1:size(pool.corrFlag{pool.selF,pool.selC})
        if pool.corrFlag{pool.selF,pool.selC}(i,3) == 1
            x = pool.corrFlag{pool.selF,pool.selC}(i,1);
            y = pool.corrFlag{pool.selF,pool.selC}(i,2);
            pool.plot.mPks(i) = plot(x,y,'Marker','x',...
                'MarkerSize',6,...
                'Color','b',...
                'markerfacecolor','b');
        end
    end
end
uistack(pool.plot.Pks,'top');
end