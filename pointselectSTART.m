function [ pool ] = pointselectSTART( varargin )
pool.plot = get(gcf,'userdata');
if length(varargin)>0
    powerswitch=varargin{1};
else
    powerswitch=1;
end
if (powerswitch==1)
    set(pool.plot.dD, 'ButtonDownFcn',['pointselectCALC']);
else
    set(pool.plot.dD, 'ButtonDownFcn',['']);
end
set(gcf,'userdata',pool.plot)
end