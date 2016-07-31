function [ pool ] = showbpdel( pool )
if pool.pcr == 1;
    x = 1:pool.datalength;
    y1 = zeros(size(x));
    y2 = y1+250;
    baseLine = -250;
    bp = pool.TAGpos{pool.selF}(1,1) + pool.plot.dPointsperBase(pool.selF)*pool.ignbasesV;
    index = 1:bp;
    if ~isnumeric(pool.plot.pcrB)
        delete(pool.plot.pcrB)
    end
    hold on;
    pool.plot.pcrB =  fill(x(index([1 1:end end])),...
        [baseLine y2(index) baseLine],...
        'r','EdgeColor','none');
    set(pool.plot.pcrB,'FaceAlpha',0.25);
else
    if ~isnumeric(pool.plot.pcrB)
        delete(pool.plot.pcrB)
    end
end
end