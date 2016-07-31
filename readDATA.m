function [ pool ] = readDATA( pool )
pool.allFilesData = [];
samplenames = strrep(pool.filename, '.fsa', '');
for i=1:1:size(pool.filename,2)
    fsapath = strcat(pool.rawDATA,'\',pool.filename{i});
    pool.allFilesData{i} = loadFSA( fsapath );
    sboxs = strcat(num2str(i),{'. '},samplenames{i},{' | '},'MVN:',{' '},num2str(pool.allFilesData{i}.CKversion),{' | '},'Fileformat:',{' '},pool.allFilesData{i}.CKformat);
    statusbox(pool,sboxs{1});
    updateWB(pool,size(pool.filename,2),i,1);
    if strcmpi(pool.allFilesData{i}.CKformat,'ABIF')
        pool.CKformat(i) = 1;
    else
        pool.CKformat(i) = 0;
    end
end
updateWB(pool,size(pool.filename,2),i,0);
for i=1:1:size(pool.allFilesData{1}.DyeName,1)-1
    pool.dyenames(i,:) =  pool.allFilesData{1}.DyeName(i,(2:size(pool.allFilesData{1}.DyeName(i,:),2)));
end
for i=1:1:size(pool.allFilesData,2)
    pool.allFilesData{i}.Data = double(pool.allFilesData{i}.Data);
end
pool.datalength = pool.allFilesData{1}.Size;
end