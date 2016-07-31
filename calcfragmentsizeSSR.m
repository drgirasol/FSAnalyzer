% calcfragmentsizeSSR.m 
function [ pool ] = calcfragmentsizeSSR( pool )
stepsize = 0.01;
ladder = pool.ladder';
lfm = 1:1:ladder(size(ladder,2));
for i=1:1:size(pool.filename,2)
    for u=1:1:size(pool.ssr.lociUI.NAME,2)
        pool.ssr.peakID{i}.locus = {0};
    end
    for u=1:1:size(pool.ssr.lociUI.NAME,2)
        pool.ssr.binmatrix{i}.locus{u} = zeros(length(lfm),1);
    end
end
vector = 0:stepsize:(max(ladder)-stepsize);
for i=1:1:size(pool.filename,2)
    pool.ssr.fragmentsize{i}.locus{1} = 0;
end
for i=1:1:size(pool.filename,2)
    pool.ssr.interpolation{i} = pchip(ladder,pool.corrPeakData{i,size(pool.corrPeakData,2)}(:,1),vector);
    for z=1:1:size(pool.ssr.lociUI.NAME,2)
        for u=1:1:size(pool.corrPeakData{i,pool.selC},1)
            if (u==1)
                c=1;
            end
            if (pool.corrPeakData{i,pool.selC}(u,1)<pool.ssr.interpolation{i}((pool.ssr.lociUI.rangeF(z)-1)./stepsize))
                continue;
            end
            if (pool.corrPeakData{i,pool.selC}(u,1)>pool.ssr.interpolation{i}((pool.ssr.lociUI.rangeT(z)+1)./stepsize))
                continue;
            end
            calengthbp = [];
            calengthbp = find((pool.ssr.interpolation{i}>[pool.corrPeakData{i,pool.selC}(u,1)-0.5] & pool.ssr.interpolation{i}<[pool.corrPeakData{i,pool.selC}(u,1)+0.5]));
            calengthbp1 = [];
            calengthbp1 = sum(calengthbp);
            xlengthbp = [];
            xlengthbp = round(calengthbp1./length(calengthbp));
            pool.ssr.fragmentsize{i}.locus{z}(c) = xlengthbp*stepsize;
            pool.ssr.peakID{i}.locus{z}(c) = u;
            c=c+1;
        end
    end
end

for i=1:1:size(pool.ssr.fragmentsize,2)
    pool.ssr.fragmentsizeREP{i}.locus = {0};
    pool.ssr.peakIDREP{i}.locus = {0};
end
for i=1:1:size(pool.ssr.fragmentsize,2)
    for u=1:1:size(pool.ssr.lociUI.NAME,2)
        pool.ssr.fragmentsizeREPh{i}.locus{u} = 0;
    end
end
[ pool ] = applyRepUnitSSR( pool );
for i=1:1:size(pool.ssr.fragmentsize,2) %file
    for u=1:1:size(pool.ssr.fragmentsizeREP{i}.locus,2) %loci
        c=1;
        if ~(size(pool.ssr.peakIDREP{i}.locus{u},2)==1)
            minHeight = max(pool.corrPeakData{i,pool.selC}(pool.ssr.peakIDREP{i}.locus{u},2))-max(pool.corrPeakData{i,pool.selC}(pool.ssr.peakIDREP{i}.locus{u},2))./3;
            for z=1:1:size(pool.ssr.fragmentsizeREP{i}.locus{u},2) %fragment
                currentpeakHeight = pool.corrPeakData{i,pool.selC}(pool.ssr.peakIDREP{i}.locus{u}(z),2);
                if minHeight<currentpeakHeight
                    pool.ssr.fragmentsizeREPh{i}.locus{u}(c) = pool.ssr.fragmentsizeREP{i}.locus{u}(z);
                    c=c+1;
                end
            end
        end
    end
end
end