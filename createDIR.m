function [ pool ] = createDIR( pool,x )
statusbox(pool,'Creating folder structure...');
pool.txtpathmkdir = strcat(pool.SELdir,'\Analysis');
pool.rawDATA = strcat(pool.SELdir,'\rawDATA');
pool.pixmkdir = strcat(pool.SELdir,'\PIC');
pool.figmkdir = strcat(pool.SELdir,'\FIG');
mkdir(pool.txtpathmkdir);
mkdir(pool.rawDATA);
mkdir(pool.pixmkdir);
mkdir(pool.figmkdir);
for i=1:1:length(pool.filename)
    if x == 0
        movefile(strcat(pool.Pathname,'\',pool.filename{i}),pool.rawDATA,'f');
    elseif x == 2
        copyfile(strcat(pool.Pathname,'\',pool.filename{i}),pool.rawDATA);
    end
end
statusbox(pool,'...done.');
end