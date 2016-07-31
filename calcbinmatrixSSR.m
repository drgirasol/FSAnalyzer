function [ pool ] = calcbinmatrixSSR( pool )
for i=1:1:size(pool.ssr.fragmentsizeREPh,2)
    for u=1:1:size(pool.ssr.fragmentsizeREPh{i}.locus,2)
        if (pool.ssr.fragmentsizeREPh{i}.locus{u}(1))
            for z=1:1:size(pool.ssr.fragmentsizeREPh{i}.locus{u},2)
                pool.ssr.binmatrix{i}.locus{u}(pool.ssr.fragmentsizeREPh{i}.locus{u}(z),1) = 1;
            end
            pool.ssr.peaksYN{i}.locus{u} = 1;
        else
            pool.ssr.peaksYN{i}.locus{u} = 0;
        end
    end
end
end