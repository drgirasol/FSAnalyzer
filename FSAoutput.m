function [ pool ] = FSAoutput( pool )
if strcmp(pool.anaMode,'SSR')
    pool.binmatrix = pool.ssr.binmatrix;
    pool.fragmentsize = pool.ssr.fragmentsize;
end
if isempty(pool.fragmentsize)
    statusbox(pool,'Error: Analysis failed.');
    return;
end
statusbox(pool,'Printing data to analysis folder...');
%% print binmatrix
statusbox(pool,'...binmatrix...');
samplenames = strrep(pool.filename, '.fsa', '');
for i=1:1:size(pool.allFilesData{1}.DyeName,1)
    updateWB(pool,size(pool.allFilesData{1}.DyeName,1),i,1);
    dyenames(i,:) =  pool.allFilesData{1}.DyeName(i,(2:size(pool.allFilesData{1}.DyeName(i,:),2)));
end
updateWB(pool,size(pool.allFilesData{1}.DyeName,1),i,0);
fname = strcat(pool.Date,'Binmatrix.',pool.dyenames(pool.selC,:),'.txt');
fid=fopen(fullfile(pool.txtpathmkdir,fname),'w');
if strcmp(pool.anaMode,'SSR')
    for i=1:1:size(pool.binmatrix,2)
        updateWB(pool,size(pool.binmatrix,2),i,1);
        fprintf(fid,'%s', samplenames{i});
        fprintf(fid, '\r\n');
        for u=1:1:size(pool.binmatrix{i}.locus,2)
            locus=strcat('Locus',{' '},num2str(u),{' '},'"',pool.ssr.lociUI.NAME{u},'":',{' '});
            fprintf(fid,'%s', locus{1});
            fprintf(fid, '%g,', [pool.binmatrix{i}.locus{u}]');
            fprintf(fid, '\r\n');
        end
    end
else
    for i=1:1:size(pool.binmatrix,2)
        updateWB(pool,size(pool.binmatrix,2),i,1);
        fprintf(fid,'%s', samplenames{i});
        fprintf(fid, ',%g', pool.binmatrix(:,i)');
        fprintf(fid, '\r\n');
    end
end
updateWB(pool,size(pool.binmatrix,2),i,0);
fclose(fid);
statusbox(pool,'...done...');
%% print all Peaks
if strcmp(pool.anaMode,'TBP') || (strcmp(pool.anaMode,'SSR') && pool.selC==1)
    statusbox(pool,'...all peak positions...');
    fname = strcat(pool.Date,'PeakPos.txt');
    fid=fopen(fullfile(pool.txtpathmkdir,fname),'w');
    for i=1:1:size(samplenames,2)
        updateWB(pool,size(samplenames,2),i,1);
        if i~=1
            fprintf(fid, '\r\n');
            fprintf(fid, '\r\n');
        end
        fprintf(fid, 'File: %s',samplenames{i});
        fprintf(fid, '\r\n');
        for u=1:1:size(pool.corrPeakData,2)
            fprintf(fid, '\r\n');
            fprintf(fid, 'Peak Locations - %s',dyenames(u,:));
            fprintf(fid, '\r\n');
            fprintf(fid, 'X');
            fprintf(fid, '\t');
            fprintf(fid, '\t');
            fprintf(fid, 'Y');
            fprintf(fid, '\r\n');
            for z=1:1:size(pool.corrPeakData{i,u},1)
                fprintf(fid, '%g',pool.corrPeakData{i,u}(z,1));
                fprintf(fid, '\t');
                fprintf(fid, '\t');
                fprintf(fid, '%g',pool.corrPeakData{i,u}(z,2));
                fprintf(fid, '\r\n');
            end
        end
    end
    updateWB(pool,size(samplenames,2),i,0);
    fclose(fid);
    statusbox(pool,'...done...');
end
%% print Fragmentsize
statusbox(pool,'...fragmentsize of selected dye channel...');
fname = strcat(pool.Date,'FragmentsizeBasePairs.',pool.dyenames(pool.selC,:),'.txt');
fid=fopen(fullfile(pool.txtpathmkdir,fname),'w');
if strcmp(pool.anaMode,'SSR')
    fprintf(fid, 'Color: %s',dyenames(pool.selC,:));
    fprintf(fid, ' || bp = base pairs');
    fprintf(fid, '\r\n');
    fprintf(fid, '-------------------------------');
    fprintf(fid, '\r\n');
    for i=1:1:size(samplenames,2)
        updateWB(pool,size(samplenames,2),i,1);
        if i~=1%&& i~=size(samplenames,2) für später... hehe
            fprintf(fid, '\r\n');
            fprintf(fid, '\r\n');
        end
        fprintf(fid, 'File: %s',samplenames{i});
        fprintf(fid, '\r\n');
        for u=1:1:size(pool.fragmentsize{i}.locus,2)
            locus=strcat('Locus',{' '},num2str(u),{' '},'"',pool.ssr.lociUI.NAME{u},'":',{' '});
            fprintf(fid,'%s', locus{1});
            fprintf(fid, '\r\n');
            for z=1:1:size(pool.fragmentsize{i}.locus{u},2)
                fprintf(fid, '%g',pool.fragmentsize{i}.locus{u}(z));
                fprintf(fid, '\t');
                fprintf(fid, 'bp');
                fprintf(fid, '\r\n');
            end
        end
    end
else
    fprintf(fid, 'Color: %s',dyenames(pool.selC,:));
    fprintf(fid, ' || bp = base pairs');
    fprintf(fid, '\r\n');
    fprintf(fid, '-------------------------------');
    fprintf(fid, '\r\n');
    for i=1:1:size(samplenames,2)
        updateWB(pool,size(samplenames,2),i,1);
        if i~=1%&& i~=size(samplenames,2) für später... hehe
            fprintf(fid, '\r\n');
            fprintf(fid, '\r\n');
        end
        fprintf(fid, 'File: %s',samplenames{i});
        fprintf(fid, '\r\n');
        for u=1:1:size(pool.fragmentsize{i},2)
            fprintf(fid, '%g',pool.fragmentsize{i}(u));
            fprintf(fid, '\t');
            fprintf(fid, 'bp');
            fprintf(fid, '\r\n');
        end
    end
end
updateWB(pool,size(samplenames,2),i,0);
fclose(fid);
statusbox(pool,'...done...');

%% print Jaccard distance and index
if strcmp(pool.anaMode,'TBP')
    if isempty(pool.statistics)
        statusbox(pool,'Error: Analysis failed.');
        return;
    end
    statusbox(pool,'...jaccard distance and index...');
    sqJD = squareform(pool.statistics.JD);%percental equality
    sqJI = squareform(pool.statistics.JI);%percental defference
    fnameJD = strcat(pool.Date,'JaccardDistance.',pool.dyenames(pool.selC,:),'.txt');
    fidJD=fopen(fullfile(pool.txtpathmkdir,fnameJD),'w');
    for i=1:1:size(sqJD,1)
        updateWB(pool,size(sqJD,1),i,1);
        for u=1:1:length(sqJD)
            fprintf(fidJD, '%.4g\t\t', sqJD(i,u));
        end
        fprintf(fidJD, '\r\n');
    end
    updateWB(pool,size(sqJD,1),i,0);
    fclose(fidJD);
    fnameJI = strcat(pool.Date,'JaccardIndex.',pool.dyenames(pool.selC,:),'.txt');
    fidJI=fopen(fullfile(pool.txtpathmkdir,fnameJI),'w');
    for i=1:1:size(sqJI,1)
        updateWB(pool,size(sqJI,1),i,1);
        for u=1:1:length(sqJI)
            fprintf(fidJI, '%.4g\t\t', sqJI(i,u));
        end
        fprintf(fidJI, '\r\n');
    end
    updateWB(pool,size(sqJI,1),i,0);
    fclose(fidJI);
    fnameJ = strcat(pool.Date,'JaccardValues.',pool.dyenames(pool.selC,:),'.txt');
    fidJ=fopen(fullfile(pool.txtpathmkdir,fnameJ),'w');
    fprintf(fid, '"Jaccard Index"');
    fprintf(fidJ, '\r\n');
    fprintf(fidJ, 'Percentage share of non-zero positions that differ');
    fprintf(fidJ, '\r\n');
    for i=1:1:size(sqJI,1)
        updateWB(pool,size(sqJI,1),i,1);
        for u=1:1:length(sqJI)
            fprintf(fidJ, '%.4g\t\t', sqJI(i,u));
        end
        fprintf(fidJ, '\r\n');
    end
    updateWB(pool,size(sqJI,1),i,0);
    fprintf(fidJ, '\r\n');
    fprintf(fidJ, '\r\n');
    fprintf(fid, '"Jaccard Distance"');
    fprintf(fidJ, '\r\n');
    fprintf(fidJ, 'Percentage share of non-zero positions that are the same (1 - Jaccard Index)');
    fprintf(fidJ, '\r\n');
    for i=1:1:size(sqJI,1)
        updateWB(pool,size(sqJI,1),i,1);
        for u=1:1:length(sqJD)
            fprintf(fidJ, '%.4g\t\t', sqJD(i,u));
        end
        fprintf(fidJ, '\r\n');
    end
    updateWB(pool,size(sqJI,1),i,0);
    fclose(fidJ);
    statusbox(pool,'...done...');
end
%% print statistics
if strcmp(pool.anaMode,'TBP')
    statusbox(pool,'...statistical data...');
    fname = strcat(pool.Date,'StatisticalData.',pool.dyenames(pool.selC,:),'.txt');
    fid=fopen(fullfile(pool.txtpathmkdir,fname),'w');
    fprintf(fid, 'User Threshold:\t%0.f \r\n',pool.minTH);
    fprintf(fid, 'Color: %s \r\n',dyenames(pool.selC,:));
    fprintf(fid, '\r\n');
    fprintf(fid, 'Statistics: \r\n');
    fprintf(fid, '\r\n');
    fprintf(fid, 'Number of selected Dye Data:\t%0.f\r\n',pool.selC);
    fprintf(fid, '\r\n');
    fprintf(fid, 'Number of different Species:\t%0.f\r\n',pool.statistics.differentaccessionsC);
    fprintf(fid, '\r\n');
    fprintf(fid, 'Cophenetic correlation coefficient:\t%0.4f\r\n',pool.statistics.cophen);
    fprintf(fid, 'Expected Heterozygosity (EH):\t\t%0.4f\r\n',pool.statistics.H);
    fprintf(fid, 'Polymorphism Information Content (PIC):\t%0.4f\r\n',pool.statistics.PIC);
    fprintf(fid, '\r\n');
    fprintf(fid, 'Positions of Monomorphic Bands: \r\n');
    for j=1:1:length(pool.statistics.monoMbands)
        updateWB(pool,length(pool.statistics.monoMbands),i,1);
        specname(j) = pool.species(pool.statistics.specC{j}(1));
        fprintf(fid,'%s\t(%0.f)\t:\t',specname{j},length(pool.statistics.monoMbands{j}));
        for i=1:1:length(pool.statistics.monoMbands{j})
            fprintf(fid, '%0.f,',pool.statistics.monoMbands{j}(i));
        end
        fprintf(fid, '\r\n');
    end
    updateWB(pool,length(pool.statistics.monoMbands),i,0);
    fprintf(fid, '\r\n');
    fprintf(fid, 'Positions of Polymorphic Bands: \r\n');
    for j=1:1:length(pool.statistics.polyMbands)
        updateWB(pool,length(pool.statistics.polyMbands),j,1);
        fprintf(fid, '%s\t(%0.f)\t:\t',specname{j},length(pool.statistics.polyMbands{j}));
        for i=1:1:length(pool.statistics.polyMbands{j})
            fprintf(fid, '%0.f,',pool.statistics.polyMbands{j}(i));
        end
        fprintf(fid, '\r\n');
    end
    updateWB(pool,length(pool.statistics.polyMbands),i,0);
    fprintf(fid, '\r\n');
    fprintf(fid, 'Sum of all allels: %0.f \r\n',pool.statistics.allelc);
    fprintf(fid, '\r\n');
    fprintf(fid, 'Sum of allels in each Species: \r\n');
    for i=1:1:length(pool.statistics.specC)
        updateWB(pool,length(pool.statistics.specC),i,1);
        fprintf(fid, '%0.f\t:\t%s\r\n',length(pool.statistics.polyMbands{i}),specname{i});
    end
    updateWB(pool,length(pool.statistics.specC),i,0);
    fprintf(fid, '\r\n');
    fprintf(fid, 'Sum of allels in each Accession: \r\n');
    for i=1:1:length(pool.filename)
        updateWB(pool,length(pool.filename),i,1);
        fname = strsplit(pool.filename{i},'.');
        fprintf(fid, '%0.f\t:\t%s\r\n',pool.statistics.allelc2{i},fname{1});
    end
    updateWB(pool,length(pool.filename),i,0);
    fprintf(fid, '\r\n');
    fprintf(fid, 'Allelfrequency for each allel:\r\n');
    fprintf(fid, '\r\n');
    fprintf(fid, 'Length of fragment:\tAllelfrequency:\r\n');
    allelfreq = pool.statistics.allelfreq';
    for i=1:1:length(pool.statistics.allBands)
        updateWB(pool,length(pool.statistics.allBands),i,1);
        fprintf(fid, '%0.f \t\t\t',pool.statistics.allBands(i));
        fprintf(fid, '%0.5f',allelfreq(i));
        fprintf(fid, '\r\n');
    end
    updateWB(pool,length(pool.statistics.allBands),i,0);
    fprintf(fid, '=====================================\r\n');
    fprintf(fid, 'Sum of all frequencies:\t %0.6f \r\n',sum(allelfreq));
    fclose(fid);
    statusbox(pool,'...done.');
end
%%
statusbox(pool,'...SSR allel table...');
fname = strcat(pool.Date,'allelTable.',pool.dyenames(pool.selC,:),'.txt');
fid=fopen(fullfile(pool.txtpathmkdir,fname),'w');
for i=1:1:size(pool.filename,2)
    updateWB(pool,size(pool.filename,2),i,1);
    for u=1:1:size(pool.ssr.fragmentsizeREPh{i}.locus,2)
        fprintf(fid, '%s\t\t%s\t\tL%g\t\t',samplenames{i},pool.ssr.lociUI.NAME{u},u);
        if (size(pool.ssr.fragmentsizeREPh{i}.locus{u},2)==1 && pool.ssr.fragmentsizeREPh{i}.locus{u} ~= 0)
            fprintf(fid, '%g\t\t%g',pool.ssr.fragmentsizeREPh{i}.locus{u}(1),pool.ssr.fragmentsizeREPh{i}.locus{u}(1));
        else
            for z=1:1:size(pool.ssr.fragmentsizeREPh{i}.locus{u},2)
                if pool.ssr.fragmentsizeREPh{i}.locus{u}(z)
                    fprintf(fid, '%g\t\t',pool.ssr.fragmentsizeREPh{i}.locus{u}(z));
                else
                    fprintf(fid, 'NO PEAKS \t NO PEAKS');
                end
            end
        end
        fprintf(fid, '\r\n');
    end
%     fprintf(fid, '\r\n');
end
fclose(fid);
updateWB(pool,length(pool.filename),i,0);
statusbox(pool,'...done.');
end