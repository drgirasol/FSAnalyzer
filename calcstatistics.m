function [ pool ] = calcstatistics( pool )
statusbox(pool,'Calculating...');
if pool.fcc ~= 0
    pool.statistics = 0;
else
    binMatT = pool.binmatrix';
    count = 1;
    emptybin = [];
    for b=1:1:size(binMatT,1)
        updateWB(pool,size(binMatT,1),b,1);
        if (sum(binMatT(b,:)) == 0)
            emptybin(count) = b;
            count = count + 1;
        end
    end
    updateWB(pool,size(binMatT,1),b,0);
    if ~isempty(emptybin)
        for i=length(emptybin):-1:1
            binMatT(emptybin(i),:) = [];
        end
    end
    statusbox(pool,'...cophenetic correlation coefficient...');
    X = binMatT;
    Y = pdist(X, 'jaccard');
    if isempty(Y)
        statusbox(pool,'...Error: cannot calculate cophenetic correlation coefficient.');
        return;
    end
    Z = linkage(Y,'average');
    pool.statistics.cophen = cophenet(Z,Y);
    statusbox(pool,'...done...');
    binMat = pool.binmatrix;
    statusbox(pool,'...allels...');
    c = 1;
    for i=1:1:length(binMat)
        if (find(binMat(i,:)==1))
            allallel{c} = binMat(i,:);
            c=c+1;
        end
    end
    c = 1;
    for i=1:1:size(binMat,2)
        allallel2{c} = length(find(binMat(:,i)==1));
        c=c+1;
    end
    pool.statistics.allelc2 = allallel2;
    statusbox(pool,'...done...');
    statusbox(pool,'...assign species to files...');
    pool.statistics.specC=[];
    specCtemp=[];
    c = 1;
    for i=1:1:length(pool.species)
        updateWB(pool,length(pool.species),i,1);
        specCtemp = find(strcmp(pool.species{i},pool.species))';
        if i==1
            pool.statistics.specC{c} = specCtemp;
            c = c + 1;
        else
            tester=[];
            for t=1:1:length(pool.statistics.specC)
                tester(t) = sum(find(specCtemp(1)==pool.statistics.specC{t}))./length(pool.statistics.specC{t});
            end
            if find(tester)
                continue;
            else
                pool.statistics.specC{c} = specCtemp;
                c = c + 1;
            end
        end
    end
    updateWB(pool,length(pool.species),i,0);
    pool.statistics.differentaccessionsC = size(pool.statistics.specC,2);
    statusbox(pool,'...done...');
    statusbox(pool,'...poly- and monomorphic bands...');
    for i=1:1:size(pool.statistics.specC,2)%sum all alleles per accession
        updateWB(pool,size(pool.statistics.specC,2),i,1);
        polymonoCksum = 0;
        for j=1:1:length(pool.statistics.specC{i})%sum every binmatrix from one accession
            singleBinmatrix = binMat(:,pool.statistics.specC{i}(j));
            polymonoCksum = polymonoCksum + singleBinmatrix;
        end
        pool.statistics.polyMbands{i}=find(polymonoCksum>1);%find polymorphic bands
        pool.statistics.monoMbands{i}=find(polymonoCksum==1);%find monomorphic bands
    end
    updateWB(pool,size(pool.statistics.specC,2),i,0);
    allBands = 0;
    for i=1:1:size(binMat,2)
        updateWB(pool,size(binMat,2),i,1);
        singleBinmatrix = binMat(:,i);
        allBands = allBands + singleBinmatrix;
    end
    updateWB(pool,size(binMat,2),i,0);
    statusbox(pool,'...done...');
    statusbox(pool,'...allel frequency...');
    pool.statistics.allBands = find(allBands>0);
    for i=1:1:length(allallel)
        updateWB(pool,length(allallel),i,1);
        allelsum(i) = sum(allallel{i});
    end
    updateWB(pool,length(allallel),i,0);
    sumallelsum = sum(allelsum);
    allelfreq=[];
    for i=1:1:length(allelsum)
        updateWB(pool,length(allelsum),i,1);
        updateWB(pool,length(allallel),i,1);
        allelfreq(i)=allelsum(i)./sumallelsum;
    end
    updateWB(pool,length(allelsum),i,0);
    statusbox(pool,'...done...');
    statusbox(pool,'...expected heterozygosity...');
    pool.statistics.allelfreq = allelfreq;
    pool.statistics.H = 1 - sum(allelfreq.^2); %expected heterozygosity
    
    for i=1:1:length(allelfreq)-1
        updateWB(pool,length(allelfreq)-1,i,1);
        if i==1
            sumI=0;
        end
        for j=2:1:length(allelfreq)
            if j==2
                sumJ=0;
            end
            sumJ(j) = 2*allelfreq(i).^2 * allelfreq(j).^2;
        end
        sumI(i) = sum(sumJ);
    end
    updateWB(pool,length(allelfreq)-1,i,0);
    statusbox(pool,'...done...');
    statusbox(pool,'...polymorphic information content...');
    pool.statistics.sumPIC = sum(sumI);
    pool.statistics.PIC = 1 - sum(allelfreq.^2) - pool.statistics.sumPIC;%polymorphic information content
    statusbox(pool,'...done...');
    pool.statistics.allelc = length(allelfreq);
    statusbox(pool,'...jaccard index and distance...');
    pool.statistics.JI = pdist(binMatT,'jaccard');
    pool.statistics.JD = 1 - pdist(binMatT,'jaccard');
    statusbox(pool,'...done.');
end
end