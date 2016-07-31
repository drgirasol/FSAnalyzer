% applyRepUnitSSR applies the size of the repeat unit as given by userinput
% in the ssrQuest dialogue. 
function [ pool ] = applyRepUnitSSR( pool )
for i=1:1:size(pool.ssr.fragmentsize,2)
    for u=1:1:size(pool.ssr.fragmentsize{i}.locus,2)
        c=1;
        for z=1:1:size(pool.ssr.fragmentsize{i}.locus{u},2)
            a = round(pool.ssr.fragmentsize{i}.locus{u}(z))-pool.ssr.lociUI.rangeF(u);
            b = pool.ssr.lociUI.repUnit(u);
            if (~rem(a,b)*a/b) || a==0
                pool.ssr.fragmentsizeREP{i}.locus{u}(c) = round(pool.ssr.fragmentsize{i}.locus{u}(z));
                pool.ssr.peakIDREP{i}.locus{u}(c) = pool.ssr.peakID{i}.locus{u}(z);
                c=c+1;
            end
        end
    end
end
end