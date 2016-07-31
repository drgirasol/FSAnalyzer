function [ pool ] = createDIR( pool )
statusbox(pool,'Creating folder structure...');
prgpath = strcat(pwd,'\');
pool.txtpathmkdir = strcat(prgpath,'Analysis');
pool.rawDATA = strcat(prgpath,'rawDATA','\');
pool.pixmkdir = strcat(prgpath,'PIC');
pool.figmkdir = strcat(prgpath,'FIG');
mkdir(pool.txtpathmkdir);
mkdir(pool.rawDATA);
mkdir(pool.pixmkdir);
mkdir(pool.figmkdir);

if ~strcmpi(pool.rawDATA,pool.Pathname);
    for i=1:1:length(pool.filename)
        copyfile(strcat(pool.Pathname,pool.filename{i}),pool.rawDATA,'f');
    end
end
claimfsa = [];
for i=1:1:length(pool.filename)%create pathstrings for TXT and XML files
    updateWB(pool,length(pool.filename),i,1);
    caps = strsplit(pool.filename{i},'.');
    if (strcmp(caps{2},'fsa'))
        claimfsa{i} = pool.filename{i};
    end
    if (strcmp(caps{2},'FSA'))
        claimfsa{i} = strrep(pool.filename{i}, '.FSA', '.fsa');
    end
end
updateWB(pool,length(pool.filename),i,0);
statusbox(pool,'...done.');
end