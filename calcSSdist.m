function [ pool ] = calcSSdist( pool )
for i=size(pool.ladder,1):-1:2
    ladmin(i-1) = pool.ladder(i)-pool.ladder(i-1);
end
for i=1:1:size(pool.allFilesData,2)
    pool.adapGRPrng(i) = (pool.plot.dPointsperBase(i) * min(ladmin)./3)*2;
end
end