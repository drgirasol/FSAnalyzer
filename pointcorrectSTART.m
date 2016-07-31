function pointcorrectSTART( varargin )
pool.plot = get(gcf,'userdata');
if length(varargin)>0
    powerswitch=varargin{1};
else
    powerswitch=1;
end
if (powerswitch==1)
    pool.plot.corrFlagint = [];
    set(pool.plot.Pks, 'ButtonDownFcn',['pointcorrectCALC']);
    if ~(pool.plot.flagC)
        pool.plot.corrFlagint = pool.plot.corrFlag{pool.plot.selF,5};
    else
        pool.plot.corrFlagint = pool.plot.corrFlag{pool.plot.selF,pool.plot.selC};
    end
else
    set(pool.plot.Pks, 'ButtonDownFcn',['']);
end
set(gcf,'userdata',pool.plot)
end