function plotfsa( pool )
%disable figure display
end
set(0, 'DefaultFigureVisible', 'off')
%loop iterating over every file
for i=1:1:size(pool.filename,2)
    statusbox(pool,strcat('Plotting Data from file No.',num2str(i),'...'));
    dataset = pool.allFilesData{i};
    h = figure;
    hold on
    %loop iterating over every dye
    for j=1:1:size(dataset.Data)
        if (j==3 || j==4)
            L{j} = ' ';
            continue;
        end
        x = dataset.Data(j,:);
        y = 0:dataset.Size/length(x):dataset.Size-1;
        set(groot,'CurrentFigure',h);
        plot(y,x)
        dyen1 = strsplit(dataset.DyeName(j,:),'.');
        L{j} = dyen1{1};
    end
    %label axis
    xlabel('Relative Fragment Position')
    ylabel('Relative Fluorescence Units')
    legend(L,'Orientation','horizontal');
    legend('boxoff');
    figname = strrep(pool.filename, '.fsa', '.fig');
    picname = strrep(pool.filename, '.fsa', '.png');
    hold off
    set(h, 'Position', get(0,'Screensize'));
    saveas(h,fullfile(pool.figmkdir,figname{i}));
    saveas(h,fullfile(pool.pixmkdir,picname{i}),'png');
    close(h);
    statusbox(pool,'...done.');
    updateWB(pool,size(pool.filename,2),i,1);
end
updateWB(pool,size(pool.filename,2),i,0);
set(0, 'DefaultFigureVisible', 'on')
end