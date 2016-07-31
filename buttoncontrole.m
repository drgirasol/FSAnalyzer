% buttoncontrole.m enables or disables the GUI buttons depending on the 
% performed action
function buttoncontrole( pool,x )
if x && pool.anarunning
    set(pool.selDATA,'enable','on');
    set(pool.saveDS,'enable','on');
    set(pool.loadDS,'enable','on');
    set(pool.anamar,'enable','on');
    set(pool.anacol,'enable','on');
    set(pool.closeFIG,'enable','on');
    set(pool.figopen,'enable','on');
    set(pool.GRA,'enable','on');
    set(pool.ANA,'enable','on');
    set(pool.anaCOMP,'enable','on');
    set(pool.prevFIG,'enable','on');
    set(pool.nextFIG,'enable','on');
    set(pool.tCorrButton,'enable','on');
    set(pool.userSelPoint,'enable','on');
elseif x && ~pool.anarunning
    set(pool.selDATA,'enable','on');
    set(pool.closeFIG,'enable','on');
    set(pool.figopen,'enable','on');
elseif pool.debug == 0
    set(pool.selDATA,'enable','off');
    set(pool.saveDS,'enable','off');
    set(pool.loadDS,'enable','off');
    set(pool.anamar,'enable','off');
    set(pool.anacol,'enable','off');
    set(pool.closeFIG,'enable','off');
    set(pool.figopen,'enable','off');
    set(pool.GRA,'enable','off');
    set(pool.ANA,'enable','off');
    set(pool.anaCOMP,'enable','off');
    set(pool.prevFIG,'enable','off');
    set(pool.nextFIG,'enable','off');
    set(pool.tCorrButton,'enable','off');
    set(pool.userSelPoint,'enable','off');
else
    if pool.debug == 0
        set(pool.selDATA,'enable','off');
        set(pool.saveDS,'enable','off');
        set(pool.loadDS,'enable','off');
        set(pool.anamar,'enable','off');
        set(pool.anacol,'enable','off');
        set(pool.closeFIG,'enable','off');
        set(pool.figopen,'enable','off');
        set(pool.GRA,'enable','off');
        set(pool.ANA,'enable','off');
        set(pool.anaCOMP,'enable','off');
        set(pool.prevFIG,'enable','off');
        set(pool.nextFIG,'enable','off');
        set(pool.tCorrButton,'enable','off');
        set(pool.userSelPoint,'enable','off');
    end
end
end