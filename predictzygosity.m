function [ pool ] = predictzygosity( pool )
for i=1:1:size(pool.ssr.fragmentsizeREPh,2)
    for u=1:1:size(pool.ssr.fragmentsizeREPh{2}.locus,2)
        if (size(pool.ssr.fragmentsizeREPh{i}.locus{u},2)==1)
            pool.ssr.zygosity{i}(u) = 0; %homo
        else
            pool.ssr.zygosity{i}(u) = 1; %hetero
        end
    end
end
end

% for i=1:1:size(pool.ssr.fragmentsizeREPh,2)
%     i
%     pool.ssr.fragmentsizeREPh{i}
% pool.ssr.zygosity{i}
% end