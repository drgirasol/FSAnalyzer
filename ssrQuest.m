function [ lociUI ] = ssrQuest(loci,dyenames,selC)
% Create figure
name = strcat('SSR Loci',{' '},dyenames(selC,:));
h.f = figure('units','pixels','position',[50,100,830,700],...
    'toolbar','none','menu','none',...
    'name',name{1},...
    'NumberTitle','off',...
    'Resize','off');
closefun = get(h.f,'CloseRequestFcn');
set(h.f,'CloseRequestFcn','');
h.PAN = uipanel('units','pixels',...
    'Position',[0 70 830 630]);
if loci>3
    h.s = uicontrol('Parent',h.PAN,'style','slider','units','pixels','Value',1,...
        'position',[790,32,15,570],'callback',@ssrslider);
end
x = 430;
for i=1:1:loci
    panelT = strcat('Locus',{' '},num2str(i));
    h.pan(i) = uipanel('Parent',h.PAN,'Title',panelT{1},'FontSize',12,'units','pixels',...
        'Position',[40 x 725 180]);
    x = x-200;
    
    h.t(1,i) = uicontrol('Parent',h.pan(i),'style','text','units','pixels',...
        'position',[50,120,150,15],'string','Name:');
    h.e(1,i) = uicontrol('Parent',h.pan(i),'style','edit','units','pixels',...
        'position',[250,120,250,25]);
    h.t(2,i) = uicontrol('Parent',h.pan(i),'style','text','units','pixels',...
        'position',[50,90,150,15],'string','Expected number of peaks:');
    h.e(2,i) = uicontrol('Parent',h.pan(i),'style','edit','units','pixels',...
        'position',[250,90,150,25]);
    h.t(3,i) = uicontrol('Parent',h.pan(i),'style','text','units','pixels',...
        'position',[50,60,150,15],'string','Repeat Unit:');
    h.e(3,i) = uicontrol('Parent',h.pan(i),'style','edit','units','pixels',...
        'position',[250,60,150,25]);
    h.t(4,i) = uicontrol('Parent',h.pan(i),'style','text','units','pixels',...
        'position',[50,30,150,15],'string','Range:');
    h.t(5,i) = uicontrol('Parent',h.pan(i),'style','text','units','pixels',...
        'position',[425,30,50,15],'string','to');
    h.e(4,i) = uicontrol('Parent',h.pan(i),'style','edit','units','pixels',...
        'position',[250,30,150,25]);
    h.e(5,i) = uicontrol('Parent',h.pan(i),'style','edit','units','pixels',...
        'position',[500,30,150,25]);
end
h.p(1) = uicontrol('style','pushbutton','units','pixels',...
    'position',[20,5,790,60],'string','Confirm',...
    'callback',@exe_call);

drawnow     % Necessary to print the message

waitfor(h.f,'Name');
set(h.f,'CloseRequestFcn',closefun)
lociUI=[];
if ~isempty(str2double(get(h.e(2,i),'String'))) && ~isempty(str2double(get(h.e(3,i),'String'))) && ~isempty(str2double(get(h.e(4,i),'String'))) && ~isempty(str2double(get(h.e(5,i),'String')))
    for i=1:1:size(h.e,2)
        lociUI.NAME{i} = get(h.e(1,i),'String');
        lociUI.expNumPeaks(i) = str2double(get(h.e(2,i),'String'));
        lociUI.repUnit(i) = str2double(get(h.e(3,i),'String'));
        lociUI.rangeF(i) = str2double(get(h.e(4,i),'String'));
        lociUI.rangeT(i) = str2double(get(h.e(5,i),'String'));
    end
end
close(h.f);
    function ssrslider(varargin)
        slider = varargin{1};
        Locipanelwidth = 430-200*(size(h.pan,2)-1);
        x = (Locipanelwidth - (Locipanelwidth) * (1-slider.Value))+10;
        for i=size(h.pan,2):-1:1
            set(h.pan(i),'Position',[40 x 725 180])
            x = x+200;
        end
    end
    function exe_call(varargin)
        set(gcf,'userdata',h)
        set(gcbf, 'Name', 'Executed')
    end
%h.e(1,x NAME
%h.e(2,x Expected number of peaks
%h.e(3,x REPEAT UNIT
%h.e(4,x RANGE from
%h.e(5,x RANGE to
%x = file index indicator
end