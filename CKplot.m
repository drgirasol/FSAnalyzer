function CKplot( pool )
set(0, 'DefaultFigureVisible', 'off')
statusbox(pool,'Plotting calibration curve...');
if strcmp(pool.anaMode,'SSR')
    pool.interpolation = pool.ssr.interpolation;
end
for i=1:1:size(pool.interpolation,2)
    statusbox(pool,strcat('...for File No.',num2str(i),'...'));
    pool.CKplot{i} = figure;
    tagoffset = pool.corrPeakData{i,size(pool.corrPeakData,2)}(1,1)-(pool.corrPeakData{i,size(pool.corrPeakData,2)}(1,1)./15);
    axis([tagoffset-500 pool.interpolation{i}(size(pool.interpolation{i},2))+100 -300 size(pool.interpolation{i},2)+300]);
    hold on
    set(pool.CKplot{i},'name','Controle Plot','numbertitle','off');
    pool.CKplotS{i} = get(pool.CKplot{i},'Position');
    set(pool.CKplot{i}, 'Position', get(0,'Screensize'));
    plot(pool.interpolation{i},1:size(pool.interpolation{i},2))
    xlabel('Relative migration Time')
    ylabel('Relative Fragment Size')
    for u=1:1:size(pool.corrPeakData{i,size(pool.corrPeakData,2)}(:,1),1)
        if u~=size(pool.corrPeakData{i,size(pool.corrPeakData,2)}(:,1),1)
            plot(pool.corrPeakData{i,size(pool.corrPeakData,2)}(u,1),...
                find(pool.interpolation{i}==pool.corrPeakData{i,size(pool.corrPeakData,2)}(u,1)),...
                'Marker','x',...
                'MarkerSize',6,...
                'Color','b',...
                'markerfacecolor','b')
            tags(u) = text(tagoffset,find(pool.interpolation{i}==pool.corrPeakData{i,size(pool.corrPeakData,2)}(u,1)),num2str(pool.ladder(u)),'fontsize',5);
            plot([tagoffset+250 pool.corrPeakData{i,size(pool.corrPeakData,2)}(u,1)-50],[find(pool.interpolation{i}==pool.corrPeakData{i,size(pool.corrPeakData,2)}(u,1)) find(pool.interpolation{i}==pool.corrPeakData{i,size(pool.corrPeakData,2)}(u,1))],...
                'Color','k')
        else
            plot(pool.corrPeakData{i,size(pool.corrPeakData,2)}(u,1),...
                size(pool.interpolation{i},2),...
                'Marker','x',...
                'MarkerSize',6,...
                'Color','b',...
                'markerfacecolor','b')
            tags(u) = text(tagoffset,size(pool.interpolation{i},2),num2str(pool.ladder(u)),'fontsize',5);
            plot([tagoffset+250 pool.corrPeakData{i,size(pool.corrPeakData,2)}(u,1)-50],[size(pool.interpolation{i},2) size(pool.interpolation{i},2)],...
                'Color','k')
        end
    end
    hold off
    figname = strcat(pool.Date,'calibcurve.',num2str(i),'.fig');
    picname = strcat(pool.Date,'calibcurve.',num2str(i),'.png');
    saveas(pool.CKplot{i},fullfile(pool.figmkdir,figname));
    saveas(pool.CKplot{i},fullfile(pool.pixmkdir,picname),'png');
    set(pool.CKplot{i}, 'Position', pool.CKplotS{i});
    updateWB(pool,size(pool.interpolation,2),i,1);
end
updateWB(pool,size(pool.interpolation,2),i,0);
statusbox(pool,'...done.');
set(0, 'DefaultFigureVisible', 'on')
end