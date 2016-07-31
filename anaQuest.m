% This function calls up a new window with several buttons saved in h.p(x)
% to add a new button you not only have to copy paste, but also to adjust
% the 'position' of the figure defined in h.f.
% When a button is pressed the function ana_call is executed, saving the 
% value of UI in the 'userdata' field of the h.f figure
% then the function returns the figure handle.
function [ h ] = anaQuest
% Create figure
h.f = figure('units','pixels','position',[500,500,150,60],...
    'toolbar','none','menu','none');

h.p(1) = uicontrol('style','pushbutton','units','pixels',...
    'position',[20,5,50,50],'string','TBP',...
    'callback',@ana_call);
h.p(2) = uicontrol('style','pushbutton','units','pixels',...
    'position',[80,5,50,50],'string','SSR',...
    'callback',@ana_call);

drawnow     % Necessary to print the message

waitfor(h.f,'Name');
    function [ UI ] = ana_call(varargin)
        anaModeTag = get(h.p,'Value');
        for i=1:1:size(anaModeTag,1)
            UI(1,i) = anaModeTag{i};
        end
        set(gcf,'userdata',UI)
        set(gcbf, 'Name', 'Executed')
    end
end