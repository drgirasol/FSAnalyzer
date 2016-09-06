function [ pool ] = callplotM( pool )
x = size(pool.allFilesData{pool.selF}.Data,1);
ladder = pool.ladder';
figname = strsplit(pool.filename{pool.selF},'.');
currFILE = strcat('Current File:',{' '},figname(1),{'   '},'(','Selected file:',{' '},num2str(pool.selF),{' '},'/',{' '},num2str(length(pool.filename)),')');
set(pool.currFILE,'String',currFILE)
axes(pool.plotwindow)
hold off;pool.plot.dD = plot(pool.allFilesData{pool.selF}.Data(x,:));hold on;

pool.plot.Pks = plot(pool.corrFlag{pool.selF,size(pool.corrFlag,2)}(:,1),pool.corrFlag{pool.selF,size(pool.corrFlag,2)}(:,2),'ro');

axis([0+pool.Mpeaks2{pool.selF}(1)-500 pool.Mpeaks2{pool.selF}(length(pool.Mpeaks2{pool.selF}))+500 -250 (max(pool.Mpeaks2{pool.selF}(:,2)))+(max(pool.Mpeaks2{pool.selF}(:,2))/20)]);
[ pool ] = calcTAGpos( pool );
for label=1:1:size(pool.sTAGpos,1)
    tags(label) = text(pool.sTAGpos(label),pool.sTAGpos(label)-pool.sTAGpos(label)-100,num2str(pool.ladder(label)),'fontsize',5);
    set(tags(label),'Clipping','on');
end
pool.plot.tags = tags;
if ~isnumeric(pool.plot.pnote)
    delete(pool.plot.pnote)
end
if size(pool.ladder,1)==(size(pool.plot.corrFlag{pool.selF,size(pool.plot.corrFlag,2)},1)-sum(pool.plot.corrFlag{pool.selF,size(pool.plot.corrFlag,2)}(:,3)))
    pool.plot.pnote = annotation('textbox',...
        [0.75 0.8 0.152 0.05],...
        'String',strcat('Peaks found:',{' '},num2str((size(pool.plot.corrFlag{pool.selF,size(pool.plot.corrFlag,2)},1)-sum(pool.plot.corrFlag{pool.selF,size(pool.plot.corrFlag,2)}(:,3))))),...
        'HorizontalAlignment','center',...
        'VerticalAlignment','middle',...
        'FontSize',14,...
        'FontName','Arial',...
        'EdgeColor',[0 0 0],...
        'LineWidth',2,...
        'BackgroundColor',[0.9 0.9 0.9],...
        'FitBoxToText','on',...
        'Tag',strcat(num2str(pool.selF),'.','markerpinfo'),...
        'Color',[0.2 0.6 0.2]);%green
else
    pool.plot.pnote = annotation('textbox',...
        [0.75 0.8 0.152 0.05],...
        'String',strcat('Peaks found:',{' '},num2str((size(pool.plot.corrFlag{pool.selF,size(pool.plot.corrFlag,2)},1)-sum(pool.plot.corrFlag{pool.selF,size(pool.plot.corrFlag,2)}(:,3))))),...
        'HorizontalAlignment','center',...
        'VerticalAlignment','middle',...
        'FontSize',14,...
        'FontName','Arial',...
        'EdgeColor',[0 0 0],...
        'LineWidth',2,...
        'BackgroundColor',[0.9 0.9 0.9],...
        'FitBoxToText','on',...
        'Tag',strcat(num2str(pool.selF),'.','markerpinfo'),...
        'Color',[0.85 0.20 0]);%red
end
pool.plot.flagC = 0;
pool.tPlotCorr = 0;
pool.plot.ladder = pool.ladder';
pool.plot.selF = pool.selF;
pool.plot.selC = pool.selC;
[ pool ] = plotcorrmarks(pool);
set(gcf,'userdata',pool.plot);
pool = showbpdel(pool);
hold off;
end