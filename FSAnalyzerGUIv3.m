%FSAnalyzer can be used to plot and analyze fragment sequenz analysis
%data. This main function contains the information for the GUI and the
%scripts that are executed when pressing a button in the GUI. Below you can
%see the matlab preset initialization code which shall stay untouched to
%maintain functionality.
function varargout = FSAnalyzerGUIv3(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @FSAnalyzerGUIv3_OpeningFcn, ...
    'gui_OutputFcn',  @FSAnalyzerGUIv3_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end
if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

%The opening function creates the GUI and makes it visible for the user,
%every persistent setting is defined here, such as the in the GUI displayed
%figure toolbars, if debug mode is activated or not and the expiration date
%of this version. The expiration date will be removed in a future final version.
function FSAnalyzerGUIv3_OpeningFcn(hObject, eventdata, pool, varargin)
warning('off','all')
[ pool ] = setbugreport( pool );
pool.SELdir = '';
pool.plot.pcrB = 0;
pool.plot.pnote = 0;
pool.plot.flagC = 0;
pool.plot.corrFlag = [];
pool.ignbasesV = str2num(get(pool.ignbases, 'string'));%editbox pool
pool.pcr = get(pool.PCRpur, 'value');
pool.minTH = str2num(get(pool.minTHRESH, 'string'));
pool.selC = get(pool.DyeNoDend, 'value');%editbox pool
%1 activates debug mode (disables buttoncontrole function in most cases)
%0 disables debug mode - ALLWAYS set debug mode to 0 before compiling a
%unstable version
pool.debug = 1;
set( gcf, 'toolbar', 'none' )
%for a better overview all buttons are shown here, for initalisation most
%buttons will be disabled to avoid program crashes
set(pool.selDATA,'enable','on');
set(pool.anamar,'enable','on');
set(pool.anacol,'enable','on');
set(pool.GRA,'enable','on');
set(pool.ANA,'enable','on');
set(pool.anaCOMP,'enable','on');
set(pool.closeFIG,'enable','on');
set(pool.figopen,'enable','on');
%graphic buttons
set(pool.prevFIG,'enable','on');
set(pool.nextFIG,'enable','on');
set(pool.tCorrButton,'enable','on');
%enable buttons
set(pool.anamar,'enable','off');
% set(pool.loadDS,'enable','off');
% set(pool.saveDS,'enable','off');
set(pool.anacol,'enable','off');
set(pool.GRA,'enable','off');
set(pool.ANA,'enable','off');
set(pool.anaCOMP,'enable','off');
%graphic buttons
set(pool.prevFIG,'enable','off');
set(pool.nextFIG,'enable','off');
set(pool.tCorrButton,'enable','off');
set(pool.userSelPoint,'enable','off');
%disable buttons
pool.anarunning = 0;
pool.abcheck = lifetime;
pool.reset = pool;
pool.output = hObject;
%lifetime is a function that checks the system time and compares it with a
%preset date. Newer versions get expanded lifetimes.
guidata(hObject, pool);

function varargout = FSAnalyzerGUIv3_OutputFcn(hObject, eventdata, pool)
varargout{1} = pool.output;

%This function is executed when pressing the [<-] Button. The functions
%checks "colorflag" which is binary
%1 - dye data is displayed
%0 - marker data is displayed
%and plots the corresponding data previous file in alphabetical order, if
%the first file is displayed already and this function is executed, the
%last file in alphabetical order is shown
function prevFIG_Callback(hObject, eventdata, pool)
try
    buttoncontrole(pool,0);
    if (pool.plot.flagC==1)
        if (pool.selF-1)==0
            pool.selF = size(pool.filename,2);
        else
            pool.selF = pool.selF-1;
        end
        pool = callplotC(pool);
        buttoncontrole(pool,1);
    else
        if (pool.selF-1)==0
            pool.selF = size(pool.filename,2);
        else
            pool.selF = pool.selF-1;
        end
        [ pool ] = callplotM( pool );
        buttoncontrole(pool,1);
    end
catch exception
    sendbugreport( exception,pool );
end
guidata(hObject, pool);
%This function is executed when pressing the [->] Button. The functions
%checks "colorflag" which is binary
%1 - dye data is displayed
%0 - marker data is displayed
%and plots the corresponding data next file in alphabetical order, if
%the last file is displayed already and this function is executed, the
%first file in alphabetical order is shown
function nextFIG_Callback(hObject, eventdata, pool)
try
    buttoncontrole(pool,0);
    if (pool.plot.flagC==1)
        if (pool.selF)==size(pool.filename,2)
            pool.selF = 1;
        else
            pool.selF = pool.selF+1;
        end
        pool = callplotC( pool );
        buttoncontrole(pool,1);
    else
        if (pool.selF==size(pool.filename,2))
            pool.selF = 1;
        else
            pool.selF = pool.selF+1;
        end
        pool = callplotM( pool );
        buttoncontrole(pool,1);
    end
catch exception
    sendbugreport( exception,pool );
end
guidata(hObject, pool);

%This function is executed when pressing the [Correct] Button.
%This function activates the feature to deselect (and later on select)
%specific peaks. Again first is checked if marker or dye data is displayed
%and the corresponding BUTTONDOWNfnct are activated.
function tCorrButton_Callback(hObject, eventdata, pool)
try
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
    set(pool.userSelPoint,'enable','off');
    CKzoom = zoom;
    CKpan = pan;
    if (pool.tPlotCorr==0)%toggle on
        if strcmp(CKzoom.Enable,'on')
            zoom off;
            pool.zoom = 1;
        else
            pool.zoom = 0;
        end
        if strcmp(CKpan.Enable,'on')
            pan off;
            pool.pan = 1;
        else
            pool.pan = 0;
        end
        pool.tPlotCorr = 1;
        pointcorrectSTART(1);
    else%toggle off / read modified data
        if pool.zoom
            zoom on;
        end
        if pool.pan
            pan on;
        end
        pool.tPlotCorr = 0;
        pool.plot = get(gcf,'userdata');
        pool.corrFlag = pool.plot.corrFlag;
        pointcorrectSTART(0);
        buttoncontrole(pool,1);
    end
catch exception
    statusbox(pool,'Undefinded Error occured. A bugreport has been sent.');
    sendbugreport( exception,pool );
end
guidata(hObject, pool);

function userSelPoint_Callback(hObject, eventdata, pool)
try
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
CKzoom = zoom;
CKpan = pan;
if (pool.tPlotSel==0)%toggle on
    if strcmp(CKzoom.Enable,'on')
        zoom off;
        pool.zoom = 1;
    else
        pool.zoom = 0;
    end
    if strcmp(CKpan.Enable,'on')
        pan off;
        pool.pan = 1;
    else
        pool.pan = 0;
    end
    pool.tPlotSel = 1;
    pointselectSTART(1);
else%toggle off / read modified data
    if pool.zoom
        zoom on;
    end
    if pool.pan
        pan on;
    end
    pool.tPlotSel = 0;
    pointselectSTART(0);
    pool.plot = get(gcf,'userdata');
    pool.corrFlag = pool.plot.corrFlag;
    buttoncontrole(pool,1);
end
catch exception
    sendbugreport( exception,pool );
end
guidata(hObject, pool);

%Callbacks are possible user inputs, minTHRESH (minimum threshold)
%is the user input in the box behind "Minimum threshold"
%this value is only used for the calculation of peaks in dye data.
%peak calculation in marker data is carried out by an selfadaptive
%threshold.
function minTHRESH_Callback(hObject, eventdata, pool)
try
    buttoncontrole(pool,0);
    if (str2num(get(pool.minTHRESH, 'string')) < 1)
        set(pool.minTHRESH, 'string','1');
        pool.minTH = 1;
    else
        if pool.anarunning == 1
            if isempty(str2num(get(pool.minTHRESH, 'string')))
                statusbox(pool,'Error: Only numbers allowed.');
                str = strcat('Minimum threshold:',{' '},num2str(pool.minTH));
                statusbox(pool,str{1});
            else
                pool.minTH = str2num(get(pool.minTHRESH, 'string'));
                str = strcat('New minimum threshold:',{' '},get(pool.minTHRESH, 'string'));
                statusbox(pool,str{1});
                pool.hash = calchash(pool);
                for i=1:1:size(pool.corrFlag,1)
                    corrFlagTMP{i} = pool.corrFlag{i,size(pool.corrFlag,2)};
                end
                pool.corrFlag = cell(size(pool.allFilesData,2),size(pool.allFilesData{pool.selF}.Data,1));
                for i=1:1:size(pool.corrFlag,1)
                    pool.corrFlag{i,size(pool.corrFlag,2)} = corrFlagTMP{i};
                end
                [ pool ] = peakAdaptC( pool );%save dye peaks
                for i=1:1:size(pool.corrFlag,1)
                    for u=1:1:size(pool.corrFlag,2)-1
                        if u==size(pool.corrFlag,2)
                            pool.corrFlag{i,u} = pool.Mpeaks2{i};
                            pool.corrFlag{i,u}(:,3) = 0;
                        else
                            pool.corrFlag{i,u} = pool.Cpeaks{i,u};
                            pool.corrFlag{i,u}(:,3) = 0;
                        end
                    end
                end
                pool.plot.corrFlag = pool.corrFlag;
                if pool.plot.flagC == 0;
                    pool = callplotM( pool );
                else
                    hold off;
                    pool = callplotC( pool );
                    hold on;
                end
            end
        else
            pool.minTH = str2num(get(pool.minTHRESH, 'string'));
        end
    end
    buttoncontrole(pool,1);
catch exception
    sendbugreport( exception,pool );
end
guidata(hObject, pool);

function minTHRESH_CreateFcn(hObject, eventdata, pool)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%This function is executed when pressing the [Select Data] Button.
%First the abcheck (abandom check) is carried out and after confirmation
%the existence of previous data is checked. The user can decide if he wants
%to abort the execution, delete all data from previous analysis or save new
%data into the existing folders. If no folders exist this query isnt
%processed. After this dialogue the user is requested to select following data:
%1. marker file: a *.txt file containing all possible DNA fragments in
%analysis data i.e. LIZ1200, LIZ500 etc.
%2. speciesnames: A *.txt file containing the accession names in !!!
%alphabetical order of the filenames used !!! NOT !!! the alphabetical order of the
%accession names !!!
function selDATA_Callback(hObject, eventdata, pool)
try
    if pool.abcheck
        statusbox(pool,'Error: Version expired.');
        guidata(hObject, pool);
        return
    end
    if isempty(pool.SELdir)
        pool.SELdir = uigetdir;
        if pool.SELdir == 0
            statusbox(pool,'Error: No folder choosen.');
            return;
        end
    else
        SELdir = uigetdir;
        if SELdir == 0
            statusbox(pool,'Error: No folder choosen.');
            return;
        end
        if ~strcmp(pool.SELdir,SELdir)
           pool.anarunning = 0;
           pool.SELdir = SELdir;
           pool.reset.SELdir = SELdir;
        end
    end
    if pool.anarunning == 0
        [pool] = updatereset( pool );
    end
    buttoncontrole(pool,0);
    if ( exist(fullfile(pool.SELdir,'PIC'),'dir') == 7 || ...
            exist(fullfile(pool.SELdir,'FIG'),'dir') == 7 || ...
            exist(fullfile(pool.SELdir,'Analysis'),'dir') == 7)
        
        choice = questdlg('Delete all data before starting a new analysis?', ...
            'New analysis', ...
            'Delete ALL and continue','Delete NONE and continue','Do nothing','Do nothing');
        switch choice
            case 'Delete ALL and continue'
                if (exist(fullfile(pool.SELdir,'PIC'),'dir'))
                    rmdir(fullfile(pool.SELdir,'PIC'),'s');
                end
                if (exist(fullfile(pool.SELdir,'FIG'),'dir'))
                    rmdir(fullfile(pool.SELdir,'FIG'),'s');
                end
                if (exist(fullfile(pool.SELdir,'Analysis'),'dir'))
                    rmdir(fullfile(pool.SELdir,'Analysis'),'s');
                end
                set(pool.currFILE,'String','Current File:');
                h=get(gcf,'userdata');
                delete(h.pnote);
                cla;
                pool.reset.anarunning = 0;
                [pool] = updatereset( pool );
                resetpulldown = ['1'
                    '2'
                    '3'
                    '4'];
                set(pool.DyeNoDend,'String',resetpulldown);
            case 'Delete NONE and continue'
            case 'Do nothing'
                if pool.anarunning == 1
                    set(pool.anamar,'enable','on');
                    set(pool.anacol,'enable','on');
                    set(pool.GRA,'enable','on');
                    set(pool.ANA,'enable','on');
                    set(pool.anaCOMP,'enable','on');
                    set(pool.prevFIG,'enable','on');
                    set(pool.nextFIG,'enable','on');
                    set(pool.tCorrButton,'enable','on');
                end
                set(pool.selDATA,'enable','on');
                set(pool.closeFIG,'enable','on');
                set(pool.figopen,'enable','on');
                guidata(hObject, pool);
                return;
        end
    end
    statusbox(pool,'Choose type of analysis...');
    [ h ] = anaQuest;
    anaModeTags = get(h.f,'Userdata');
    close(h.f);
    pool.anaMode = '';
    if find(anaModeTags==1)==1
        pool.anaMode = 'TBP';
    else
        pool.anaMode = 'SSR';
        pool.reset.ssr.lociUI = [];
    end
    statusbox(pool,'...done.');
    [ filename,ladderpath,sampleIDpath,savefilename,x ] = scanfolder( pool.SELdir );
    if isempty(filename)
        filename = '';
        set(pool.figopen,'enable','on');
        set(pool.closeFIG,'enable','on');
        set(pool.selDATA,'enable','on');
        statusbox(pool,'Note: No FSA-files detected.')
        [filename, Pathname] = uigetfile(strcat(pool.SELdir,'\','*.fsa'), 'Select .FSA files','Multiselect','on');
        x=2;
        fnvar = 0;
        fnvar = iscell(filename);
        if (length(filename) == 1)
            set(pool.figopen,'enable','on');
            set(pool.closeFIG,'enable','on');
            set(pool.selDATA,'enable','on');
            statusbox(pool,'Error: No FSA-files selected.');
        elseif (length(filename) > 1 && fnvar == 0)
            set(pool.figopen,'enable','on');
            set(pool.closeFIG,'enable','on');
            set(pool.selDATA,'enable','on');
            statusbox(pool,'Error: Please select a minimum of two FSA-files.');
        else
            pool.filename = [];
            pool.filename = filename;
            pool.Pathname = [];
            pool.Pathname = Pathname;
        end
    elseif (size(filename,2) == 1)
        set(pool.figopen,'enable','on');
        set(pool.closeFIG,'enable','on');
        set(pool.selDATA,'enable','on');
        statusbox(pool,'Error: A minimum of two FSA-files is required.');
    else
        pool.filename = [];
        pool.filename = filename;
        pool.Pathname = [];
        pool.Pathname = pool.SELdir;
        pool.hash = calchash( pool );
    end
    [ pool ] = createDIR( pool,x );
    if isempty(ladderpath)
        set(pool.selDATA,'enable','on');
        set(pool.closeFIG,'enable','on');
        set(pool.figopen,'enable','on');
        statusbox(pool,'Note: No >SizeStandard< detected.');
        [markerfilename, markerPathname] = uigetfile(strcat(pool.SELdir,'\','*.txt'), 'Select >SizeStandard< file.','Multiselect','off');
        if (markerfilename == 0)
            set(pool.selDATA,'enable','on');
            set(pool.closeFIG,'enable','on');
            set(pool.figopen,'enable','on');
            statusbox(pool,'Error: No markerfile selected.');
            if pool.anarunning == 1
                set(pool.anamar,'enable','on');
                set(pool.anacol,'enable','on');
                set(pool.GRA,'enable','on');
                set(pool.ANA,'enable','on');
                set(pool.anaCOMP,'enable','on');
                set(pool.prevFIG,'enable','on');
                set(pool.nextFIG,'enable','on');
                set(pool.tCorrButton,'enable','on');
            end
            guidata(hObject, pool);
            return;
        else
            fIDladder = fopen(strcat(markerPathname,markerfilename),'r');
            pool.ladder = [];
            pool.ladder = fscanf(fIDladder,'%d');
            fclose(fIDladder);
            copyfile(fullfile(markerPathname,markerfilename),pool.SELdir);
            pool.fragmentcount = length(pool.ladder);
        end
    else
        fIDladder = fopen(ladderpath,'r');
        pool.ladder = [];
        pool.ladder = fscanf(fIDladder,'%d');
        fclose(fIDladder);
        pool.fragmentcount = length(pool.ladder);
    end
    if ~strcmp(pool.anaMode,'SSR')
        if isempty(sampleIDpath)
            set(pool.selDATA,'enable','on');
            set(pool.closeFIG,'enable','on');
            set(pool.figopen,'enable','on');
            statusbox(pool,'Note: No SampleIDs file detected.');
            [speciesname, speciesPathname] = uigetfile(strcat(pool.SELdir,'\','*.txt'), 'Select >SampleIDs< file.','Multiselect','off');
            if (speciesname == 0)
                set(pool.selDATA,'enable','on');
                set(pool.closeFIG,'enable','on');
                set(pool.figopen,'enable','on');
                statusbox(pool,'Error: No species description file selected.');
                if pool.anarunning == 1
                    set(pool.anamar,'enable','on');
                    set(pool.anacol,'enable','on');
                    set(pool.GRA,'enable','on');
                    set(pool.ANA,'enable','on');
                    set(pool.anaCOMP,'enable','on');
                    set(pool.prevFIG,'enable','on');
                    set(pool.nextFIG,'enable','on');
                    set(pool.tCorrButton,'enable','on');
                end
                guidata(hObject, pool);
                return;
            else
                copyfile(fullfile(speciesPathname,speciesname),pool.SELdir);
                pool.species = importdata(strcat(speciesPathname,speciesname));
                if isnumeric(pool.species)
                    tempspec = pool.species;
                    pool.species = [];
                    for i=1:1:size(tempspec,1)
                        pool.species{i,1} = num2str(tempspec(i));
                    end
                end
            end
        else
            pool.species = importdata(sampleIDpath);
            if isnumeric(pool.species)
                tempspec = pool.species;
                pool.species = [];
                for i=1:1:size(tempspec,1)
                    pool.species{i,1} = num2str(tempspec(i));
                end
            end
        end
    end
    if isempty(savefilename)
        set(pool.selDATA,'enable','on');
        set(pool.closeFIG,'enable','on');
        set(pool.figopen,'enable','on');
        statusbox(pool,'Note: No Saves detected.');
        [savefilename, savePathname] = uigetfile(strcat(pool.SELdir,'\','*.mat'), 'Select Save *.mat','Multiselect','off');
        if (savefilename == 0)
            statusbox(pool,'Note: No Save selected.');
        else
            copyfile(strcat(savePathname,savefilename),pool.SELdir)
            dsfpath = strcat(savePathname,savefilename);
            DSsave = load(dsfpath);
            pool.DSsave = DSsave.DSsave;
            if strcmp(pool.hash,pool.DSsave.hash)
                [ pool ] = saloDataset( pool,0 );
                statusbox(pool,'Load successful.');
                if pool.plot.flagC == 0;
                    [ pool ] = callplotM( pool );
                else
                    hold off;
                    [ pool ] = callplotC( pool );
                    hold on;
                end
            else
                statusbox(pool,'Wrong Dataset Hash.');
            end
            pool.selF = 1;
            pool.tPlotCorr = 0;
            pool.tPlotSel = 0;
            pool.anarunning = 1;
            buttoncontrole(pool,1);
            guidata(hObject, pool);
            return;
        end
    else
        savePathname = pool.SELdir;
        if (length(savefilename) == 1)
            dsfpath = strcat(savePathname,'\',savefilename);
            DSsave = load(dsfpath{1});
            pool.DSsave = DSsave.DSsave;
            if strcmp(pool.hash,pool.DSsave.hash)
                [ pool ] = saloDataset( pool,0 );
                statusbox(pool,'Load successful.');
                if pool.plot.flagC == 0;
                    [ pool ] = callplotM( pool );
                else
                    hold off;
                    [ pool ] = callplotC( pool );
                    hold on;
                end
            else
                statusbox(pool,'Wrong Dataset Hash.');
            end
            pool.selF = 1;
            pool.tPlotCorr = 0;
            pool.tPlotSel = 0;
            pool.anarunning = 1;
            buttoncontrole(pool,1);
            guidata(hObject, pool);
            return;
        elseif (length(savefilename) > 1)
            [savefilename, savePathname] = uigetfile(strcat(pool.SELdir,'\','*.mat'), 'Select Save *.mat','Multiselect','off');
            if (savefilename == 0)
                statusbox(pool,'Note: No Save selected.');
            else
                dsfpath = strcat(savePathname,savefilename);
                DSsave = load(dsfpath);
                pool.DSsave = DSsave.DSsave;
                if strcmp(pool.hash,pool.DSsave.hash)
                    [ pool ] = saloDataset( pool,0 );
                    statusbox(pool,'Load successful.');
                    if pool.plot.flagC == 0;
                        [ pool ] = callplotM( pool );
                    else
                        hold off;
                        [ pool ] = callplotC( pool );
                        hold on;
                    end
                else
                    statusbox(pool,'Wrong Dataset Hash.');
                end
                pool.selF = 1;
                pool.tPlotCorr = 0;
                pool.tPlotSel = 0;
                pool.anarunning = 1;
                buttoncontrole(pool,1);
                guidata(hObject, pool);
                return;
            end
        end
        
    end
    statusbox(pool,'Reading data...');
    [ pool ] = readDATA( pool );
    statusbox(pool,'...done.');
    set(pool.DyeNoDend,'String',pool.dyenames);
    pool.selF = 1;
    pool.tPlotCorr = 0;
    pool.tPlotSel = 0;
    pool.anarunning = 1;
    
    statusbox(pool,'Initialising preanalysis...');
    
    [ pool ] = peakAdaptM( pool );
    
    pool.corrFlag = cell(size(pool.allFilesData,2),size(pool.allFilesData{pool.selF}.Data,1));
    [ pool ] = peakAdaptC( pool );%save dye peaks
    for i=1:1:size(pool.corrFlag,1)
        updateWB(pool,size(pool.allFilesData,2),i,1);
        for u=1:1:size(pool.corrFlag,2)
            if u==size(pool.corrFlag,2)
                pool.corrFlag{i,u} = pool.Mpeaks2{i};
                pool.corrFlag{i,u}(:,3) = 0;
            else
                pool.corrFlag{i,u} = pool.Cpeaks{i,u};
                pool.corrFlag{i,u}(:,3) = 0;
            end
        end
    end
    updateWB(pool,size(pool.allFilesData,2),i,0);
    
    pool.plot.corrFlag = pool.corrFlag;
    
    [ pool ] = callplotM( pool );
    
    buttoncontrole(pool,1);
    
    statusbox(pool,'...you may now continue.');
catch exception
    sendbugreport( exception,pool );
end
guidata(hObject, pool);

function anaCOMP_Callback(hObject, eventdata, pool)
try
    statusbox(pool,'Initialising full analysis...');
    buttoncontrole(pool,0);
    plotfsa( pool );
    [ pool ] = dateofanalysis( pool );
    [ pool ] = saveUsercorr( pool );%save user corrected data for analysis
    %     debug_marker_peaks_before_user_corr =  pool.Mpeaks2
    %     debug_dye_peaks_before_user_corr = pool.Cpeaks
    %     debug_peaks_after_user_corr = pool.corrPeakData
    if strcmp(pool.anaMode,'TBP')
        statusbox(pool,'Initialising analysis of data...');
        buttoncontrole(pool,0);
        [ pool,x ] = calcbinmatrix( pool );
        if x==1
            statusbox(pool,'...u may now continue.');
            guidata(hObject, pool);
            return;
        end
        [ pool ] = vGelPlot( pool );%calculates a binmatrix with length of largest fragment in marker and plots a virtual gel out of this binmatrix
        [ pool ] = DendPlot( pool );
        pool.statistics = [];
        [ pool ] = calcstatistics( pool );%calculate statistical data
        FSAoutput( pool );
        buttoncontrole(pool,1);
        statusbox(pool,'...u may now continue.');
        %
        %elseif strcmp(pool.anaMode,'your mode')
        %
    else
        TMPselC = pool.selC;
        for x=1:1:size(pool.dyenames,1)
            pool.selC = x;
            loci = inputdlg('How many Loci?');
            if ~isempty(loci)
                if ~isempty(str2num(loci{1}))
                    [ pool.ssr.lociUI ] = ssrQuest(str2num(loci{1}),pool.dyenames,pool.selC);
                    if ~isempty(pool.ssr.lociUI)
                        for i=1:1:str2num(loci{1})
                            a = pool.ssr.lociUI.rangeT(i)-pool.ssr.lociUI.rangeF(i);
                            b = pool.ssr.lociUI.repUnit(i);
                            if ~(~rem(a,b)*a/b)
                                pool.ssr.lociUI = [];
                            end
                        end
                    end
                    if ~isempty(pool.ssr.lociUI)
                        [ pool ] = calcfragmentsizeSSR( pool );
                        [ pool ] = predictzygosity( pool );
                        [ pool ] = calcbinmatrixSSR( pool );
                    else
                        statusbox(pool,'Error: Loci data cannot be correct.');
                    end
                else
                    statusbox(pool,'Error: Loci count is NaN.');
                end
            else
                statusbox(pool,'Error: Loci count cant be empty.');
            end
            if ~isempty(loci)
                if ~isempty(str2num(loci{1}))
                    FSAoutput( pool );
                end
            end
        end
        pool.selC = TMPselC;
    end
    CKplot( pool );
    buttoncontrole(pool,1);
    statusbox(pool,'...u may now continue.');
catch exception
    sendbugreport( exception,pool );
end
guidata(hObject, pool);

function closeFIG_Callback(hObject, eventdata, pool)
try
    statusbox(pool,'Closing all open figures...');
    buttoncontrole(pool,0);
    set(pool.figure1, 'HandleVisibility', 'off');
    close all;
    set(pool.figure1, 'HandleVisibility', 'on');
    buttoncontrole(pool,1);
    statusbox(pool,'...u may now continue.');
catch exception
    sendbugreport( exception,pool );
end
guidata(hObject, pool);

function figopen_Callback(hObject, eventdata, pool)
try
    [figname, figpath] = uigetfile('*.fig', 'Select .FIG files','Multiselect','on');
    set(pool.figopen,'enable','off');
    if (ischar(figname))
        fign = strcat(figpath,figname);
        openfig(fign,'visible');
    end
    if (iscell(figname))
        for figs=1:length(figname)
            fign = strcat(figpath,figname{figs});
            openfig(fign,'visible');
        end
    end
    set(pool.figopen,'enable','on');
catch exception
    sendbugreport( exception,pool );
end
guidata(hObject, pool);

function GRA_Callback(hObject, eventdata, pool)
try
    statusbox(pool,'Initialising plotting of data...');
    buttoncontrole(pool,0);
    plotfsa( pool );
    buttoncontrole(pool,1);
    statusbox(pool,'...u may now continue.');
catch exception
    sendbugreport( exception,pool );
end
guidata(hObject, pool);

function ANA_Callback(hObject, eventdata, pool)
try
    pool.ssr = pool.reset.ssr;
    [ pool ] = dateofanalysis( pool );
    [ pool ] = saveUsercorr( pool );
    if strcmp(pool.anaMode,'TBP')
        statusbox(pool,'Initialising analysis of data...');
        buttoncontrole(pool,0);
        [ pool,x ] = calcbinmatrix( pool );
        if x==1
            statusbox(pool,'...u may now continue.');
            guidata(hObject, pool);
            return;
        end
        [ pool ] = vGelPlot( pool );%calculates a binmatrix with length of largest fragment in marker and plots a virtual gel out of this binmatrix
        [ pool ] = DendPlot( pool );
        pool.statistics = [];
        [ pool ] = calcstatistics( pool );%calculate statistical data
        FSAoutput( pool );
        buttoncontrole(pool,1);
        statusbox(pool,'...u may now continue.');
        %
        %elseif strcmp(pool.anaMode,'your mode')
        %
    else
        TMPselC = pool.selC;
        for x=1:1:size(pool.dyenames,1)
            pool.selC = x;
            loci = inputdlg('How many Loci?');
            if ~isempty(loci)
                if ~isempty(str2num(loci{1}))
                    [ pool.ssr.lociUI ] = ssrQuest(str2num(loci{1}),pool.dyenames,pool.selC);
                    if ~isempty(pool.ssr.lociUI)
                        for i=1:1:str2num(loci{1})
                            a = pool.ssr.lociUI.rangeT(i)-pool.ssr.lociUI.rangeF(i);
                            b = pool.ssr.lociUI.repUnit(i);
                            if ~(~rem(a,b)*a/b)
                                pool.ssr.lociUI = [];
                            end
                        end
                    end
                    if ~isempty(pool.ssr.lociUI)
                        [ pool ] = calcfragmentsizeSSR( pool );
                        [ pool ] = predictzygosity( pool );
                        [ pool ] = calcbinmatrixSSR( pool );
                    else
                        statusbox(pool,'Error: Loci data cannot be correct.');
                    end
                else
                    statusbox(pool,'Error: Loci count is NaN.');
                end
            else
                statusbox(pool,'Error: Loci count cant be empty.');
            end
            if ~isempty(loci)
                if ~isempty(str2num(loci{1}))
                    FSAoutput( pool );
                end
            end
        end
        pool.selC = TMPselC;
    end
    CKplot( pool );
catch exception
    sendbugreport( exception,pool );
end
guidata(hObject, pool);

function statusBOX_Callback(hObject, eventdata, pool)

function statusBOX_CreateFcn(hObject, eventdata, pool)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press [D].
function anacol_Callback(hObject, eventdata, pool)
try
    statusbox(pool,'Plotting dye data...');
    buttoncontrole(pool,1);
    pool = callplotC( pool );
    statusbox(pool,'...done.');
    buttoncontrole(pool,1);
catch exception
    sendbugreport( exception,pool );
end
guidata(hObject, pool);

% --- Executes on button press [M].
function anamar_Callback(hObject, eventdata, pool)
try
    buttoncontrole(pool,0);
    statusbox(pool,'Plotting marker data...');
    pool = callplotM( pool );
    statusbox(pool,'...done.');
    buttoncontrole(pool,1);
catch exception
    sendbugreport( exception,pool );
end
guidata(hObject, pool);

function loadDS_Callback(hObject, eventdata, pool)
try
    buttoncontrole(pool,0);
    [dsname, dspath] = uigetfile(strcat(pool.SELdir,'\','*.mat'), 'Select fitting saved Dataset','Multiselect','off');
    if dsname~=0;
        dsfpath = strcat(dspath,dsname);
        DSsave = load(dsfpath);
        pool.DSsave = DSsave.DSsave;
        if strcmp(pool.hash,pool.DSsave.hash)
            [ pool ] = saloDataset( pool,0 );
            statusbox(pool,'Load successful.');
            if pool.plot.flagC == 0;
                [ pool ] = callplotM( pool );
            else
                hold off;
                [ pool ] = callplotC( pool );
                hold on;
            end
        else
            statusbox(pool,'Wrong Dataset Hash.');
        end
    else
        statusbox(pool,'Error: No dataset selected.');
    end
    buttoncontrole(pool,1);
catch exception
    sendbugreport( exception,pool );
end
guidata(hObject, pool);

function saveDS_Callback(hObject, eventdata, pool)
try
    [ pool ] = saloDataset( pool,1 );
    DSsave = pool.DSsave;
    [putname, ~] = uiputfile(strcat(pool.SELdir,'\','*.mat'), 'Name your dataset');
    if putname == 0
        statusbox(pool,'Save aborted.');
    else
        save(strcat(pool.SELdir,'\',putname),'DSsave')
        statusbox(pool,'Save successful.');
    end
catch exception
    sendbugreport( exception,pool );
end
guidata(hObject, pool);

function DyeNoDend_Callback(hObject, eventdata, pool)
try
    pool.selC = get(pool.DyeNoDend, 'value');
    buttoncontrole(pool,0);
    if pool.anarunning == 1
        if pool.plot.flagC == 0
            [ pool ] = callplotM( pool );
        else
            hold off;
            [ pool ] = callplotC( pool );
            hold on;
        end
    end
    buttoncontrole(pool,1);
catch exception
    sendbugreport( exception,pool );
end
guidata(hObject, pool);

function DyeNoDend_CreateFcn(hObject, eventdata, pool)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function ignbases_Callback(hObject, eventdata, pool)
try
    if isempty(str2num(get(pool.ignbases, 'string')))
        statusbox(pool,'Error: Only numbers allowed.');
        return;
    end
    if (str2num(get(pool.ignbases, 'string')) < 1)
        set(pool.ignbases, 'string','1');
        pool.ignbasesV = 1;
        if pool.anarunning == 1
            pool = showbpdel(pool);
        end
    else
        pool.ignbasesV = str2num(get(pool.ignbases, 'string'));
        pool.pcr = get(pool.PCRpur, 'value');
        if pool.anarunning == 1
            pool = showbpdel(pool);
        end
    end
catch exception
    sendbugreport( exception,pool );
end
guidata(hObject, pool);

function ignbases_CreateFcn(hObject, eventdata, pool)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function PCRpur_Callback(hObject, eventdata, pool)
try
    pool.pcr = get(pool.PCRpur, 'value');
    if pool.anarunning == 1
        buttoncontrole(pool,0)
        pool = showbpdel(pool);
        buttoncontrole(pool,1)
    end
    if pool.debug == 1
        buttoncontrole(pool,1)
    end
catch exception
    sendbugreport( exception,pool );
end
guidata(hObject, pool);