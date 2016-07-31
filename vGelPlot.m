function [ pool ] = vGelPlot( pool )
statusbox(pool,'Plotting virtual Gel...');
set(0, 'DefaultFigureVisible', 'off')
ladder = pool.ladder';
lfm = 1:1:ladder(size(ladder,2));
rgb = [0.2 0.5 0.2
    0.5 0.2 0.2
    0.2 0.2 0.5
    0.7 0.7 0];
pool.gelplot = figure;
set(pool.gelplot,'name','Virtual Gel','numbertitle','off');
pool.gelplotS = get(pool.gelplot,'Position');
set(pool.gelplot, 'Position', get(0,'Screensize'));
hold on;
xlabel('Sample')
ylabel('Fragment Size')
for m=1:1:size(ladder,2)
    my = [-1+0.1 0-0.1];
    mx= [ladder(1,m) ladder(1,m)];
    plot(my,mx,'LineWidth',1,'Color',[0 0 0]);
end
q=1;
col=1;
loopcounter = 0;
for i=1:1:size(pool.binmatrix,2)
    loopcounter= loopcounter+1;
    if (loopcounter > 1)
        loopcounter = 1;
        q=q+1;
        col=1;
    end
    for u=1:1:size(pool.binmatrix(:,i),1)
        if (pool.binmatrix(u,i))
            b = [0+q-0.1 -1+q+0.1];
            a1= [lfm(u) lfm(u)];
            plot(b,a1,'LineWidth',1,'Color',rgb(col,:));
        end
    end
    col=col+1;
end
figname = strcat(pool.Date,'vGel.',num2str(pool.selC),'.fig');
picname = strcat(pool.Date,'vGel.',num2str(pool.selC),'.png');
saveas(pool.gelplot,fullfile(pool.figmkdir,figname));
saveas(pool.gelplot,fullfile(pool.pixmkdir,picname),'png');
set(pool.gelplot, 'Position', pool.gelplotS);
set(0, 'DefaultFigureVisible', 'on')
statusbox(pool,'...done');
end