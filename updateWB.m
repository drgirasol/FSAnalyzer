function [ pool ] = updateWB( pool,varargin )
if varargin{3}
    axes(pool.WB)
    maxsteps = varargin{1};
    step = varargin{2};
    k=100;
    i = (100./maxsteps)*(maxsteps-step);
    cla
    rectangle('Position',[0,0,1001-(round(1000*i/k)),20],'FaceColor','b');
    text(500,10,[num2str(100-round(100*i/k)),'%']);
    pause(0.01);
    axes(pool.plotwindow)
else
    axes(pool.WB)
    cla
    axes(pool.plotwindow)
end
end