function [ pool ] = convertFSA( pool )
pool.prgpath = strcat(pwd,'\');
if ~strcmp(pool.prgpath,pool.Pathname);
    for i=1:1:length(pool.filename)
        copymerge = strcat(pool.Pathname,pool.filename{i});
        copyfile(copymerge,pool.prgpath,'f');
    end
end
%Version 1.0 – July 2006 ©Applied Biosystems
%only allowed usage of this software: for own internal, non-commercial
%for own internal, non-commercial research only
statusbox(pool,'Converting files...');
batpath = strcat(pool.prgpath,'\converter\FSAtoTXTandXML.bat');
system(batpath);%run converter, generates TXT and XML from FSA in root
statusbox(pool,'...done.');

statusbox(pool,'Creating Folders...');
%fsapathmkdir = strcat(pool.prgpath,'rawDATA');%create folderpaths for datafolders
pool.txtpathmkdir = strcat(pool.prgpath,'Analysis');
pool.xmlpathmkdir = strcat(pool.prgpath,'rawDATA');
pool.pixmkdir = strcat(pool.prgpath,'PIC');
pool.figmkdir = strcat(pool.prgpath,'FIG');

%mkdir(fsapathmkdir);%create folders for data | mkdir('folderName')
mkdir(pool.txtpathmkdir);
mkdir(pool.xmlpathmkdir);
mkdir(pool.pixmkdir);
mkdir(pool.figmkdir);
statusbox(pool,'...done.');

pool.txt_claim = [];
pool.claimXML = [];
pool.claimfsa = [];
for i=1:1:length(pool.filename)%create pathstrings for TXT and XML files
    updateWB(pool,length(pool.filename),i,1);
    caps = strsplit(pool.filename{i},'.');
    if (strcmp(caps{2},'fsa'))
        pool.txt_claim{i} = strrep(pool.filename{i}, '.fsa', '.fsa.txt');
        pool.claimXML{i} = strrep(pool.filename{i}, '.fsa', '.fsa.xml');
        pool.claimfsa{i} = pool.filename{i};
    end
    if (strcmp(caps{2},'FSA'))
        pool.txt_claim{i} = strrep(pool.filename{i}, '.FSA', '.fsa.txt');
        pool.claimXML{i} = strrep(pool.filename{i}, '.FSA', '.fsa.xml');
        pool.claimfsa{i} = strrep(pool.filename{i}, '.FSA', '.fsa');
    end
end
updateWB(pool,length(pool.filename),i,0);
statusbox(pool,'Moving files to created folders...');
for i=1:1:length(pool.filename)%move FSA
    updateWB(pool,length(pool.filename),i,1);
    movefsamerge = strcat(pool.prgpath,pool.filename{i});
    movefile(movefsamerge,pool.xmlpathmkdir,'f');
end
updateWB(pool,length(pool.filename),i,0);
for i=1:1:length(pool.filename)%move txt
    updateWB(pool,length(pool.filename),i,1);
    movetxtmerge = strcat(pool.prgpath,pool.txt_claim{i});
    movefile(movetxtmerge,pool.xmlpathmkdir,'f');
end
updateWB(pool,length(pool.filename),i,0);
for i=1:1:length(pool.filename)%move xml
    updateWB(pool,length(pool.filename),i,1);
    movexmlmerge = strcat(pool.prgpath,pool.claimXML{i});
    movefile(movexmlmerge,pool.xmlpathmkdir,'f');
end
updateWB(pool,length(pool.filename),i,0);
statusbox(pool,'...done.');
end