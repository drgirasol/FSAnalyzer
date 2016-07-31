function [ pool ] = DendPlot( pool )
set(0, 'DefaultFigureVisible', 'off')
c = 1;
emptybinMat = [];
binMatT = pool.binmatrix';
for b=1:1:size(binMatT,1)
    if (sum(binMatT(b,:)) == 0)
        emptybinMat(c) = b;
        c = c + 1;
    end
end
filename = pool.filename;
binmatrix = pool.binmatrix;
species = pool.species;
if ~isempty(emptybinMat)
    for c=length(emptybinMat):-1:1
        filename(emptybinMat(c)) = [];
        binmatrix(emptybinMat(c),:) = [];
        species(emptybinMat(c)) = [];
    end
end
leafs = strrep(strrep(pool.filename,'_',' '),'.fsa','');
species = species';
tree = linkage(binMatT,'average','jaccard');
if sum(isnan(tree(:,3)))
    statusbox(pool,'Error: Cannot calculate distances for dendrogram.');
    return;
end
D = pdist(binMatT);
leafOrder = optimalleaforder(tree,D);
statusbox(pool,'Plotting dendrogram with Filenames...');
pool.DendrogrammData = figure;
set(pool.DendrogrammData,'name','Dendrogram with Filenames','numbertitle','off');
dendrogram(tree,0,...
    'Orientation','left',...
    'Labels',leafs,...
    'reorder',leafOrder,...
    'ColorThreshold','default');
DDs = get(pool.DendrogrammData, 'Position');
set(pool.DendrogrammData, 'Position', get(0,'Screensize'));
figname = strcat(pool.Date,'DendrogrammFilenames.',num2str(pool.selC),'.fig');
picname = strcat(pool.Date,'DendrogrammFilenames.',num2str(pool.selC),'.png');
saveas(pool.DendrogrammData,fullfile(pool.figmkdir,figname));
saveas(pool.DendrogrammData,fullfile(pool.pixmkdir,picname),'png');
set(pool.DendrogrammData, 'Position', DDs);
statusbox(pool,'...done');
statusbox(pool,'Plotting dendrogram with Speciesnames...');
pool.DendrogrammSpecies = figure;
set(pool.DendrogrammSpecies,'name','Dendrogram with Speciesnames','numbertitle','off');
dendrogram(tree,0,...
    'Orientation','left',...
    'Labels',species,...
    'reorder',leafOrder,...
    'ColorThreshold','default');
DSs = get(pool.DendrogrammSpecies, 'Position');
set(pool.DendrogrammSpecies, 'Position', get(0,'Screensize'));
figname = strcat(pool.Date,'DendrogrammSpeciesname.',num2str(pool.selC),'.fig');
picname = strcat(pool.Date,'DendrogrammSpeciesname.',num2str(pool.selC),'.png');
saveas(pool.DendrogrammSpecies,fullfile(pool.figmkdir,figname));
saveas(pool.DendrogrammSpecies,fullfile(pool.pixmkdir,picname),'png');
set(pool.DendrogrammSpecies, 'Position', DSs);
statusbox(pool,'...done');
set(0, 'DefaultFigureVisible', 'on')
end