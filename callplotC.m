function [ pool ] = callplotC( pool )
delete(pool.plot.pnote);
figname = strsplit(pool.filename{pool.selF},'.');
currFILE = strcat('Current File:',{' '},figname(1),{'   '},'(','Selected file:',{' '},num2str(pool.selF),{' '},'/',{' '},num2str(size(pool.filename,2)),')');
set(pool.currFILE,'String',currFILE)
axes(pool.plotwindow)
hold off;pool.plot.dD = plot(pool.allFilesData{pool.selF}.Data(pool.selC,:));hold on;

if ~isnumeric(pool.plot.pnote)
    delete(pool.plot.pnote)
end

[ pool ] = calcTAGpos( pool );
for label=1:1:size(pool.sTAGpos,1)
    tags(label) = text(pool.sTAGpos(label),pool.sTAGpos(label)-pool.sTAGpos(label)-100,num2str(pool.ladder(label)),'fontsize',5);
    set(tags(label),'Clipping','on');
end
pool.plot.tags = tags;

pool.plot.Pks = plot(pool.corrFlag{pool.selF,pool.selC}(:,1),pool.corrFlag{pool.selF,pool.selC}(:,2),'ro');

pool.plot.flagC = 1;
pool.tPlotCorr = 0;
pool.plot.selF = pool.selF;
pool.plot.selC = pool.selC;
[ pool ] = plotcorrmarks(pool);
set(gcf,'userdata',pool.plot);
pool = showbpdel(pool);
end