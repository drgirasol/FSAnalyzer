function [ pool ] = saloDataset( pool,x )
if x
    pool.DSsave.currFILE = get(pool.currFILE, 'String');
    pool.DSsave.statusBOX = cellstr(get(pool.statusBOX,'String'));
    pool.DSsave.PCRpur = get(pool.PCRpur, 'value');
    pool.DSsave.ignbases = get(pool.ignbases, 'String');
    pool.DSsave.minTHRESH = get(pool.minTHRESH, 'String');
    pool.DSsave.plot = pool.plot;
    pool.DSsave.ignbasesV = pool.ignbasesV;
    pool.DSsave.pcr = pool.pcr;
    pool.DSsave.minTH = pool.minTH;
    pool.DSsave.selC = pool.selC;
    pool.DSsave.filename = pool.filename;
    %pool.Pathname
    pool.DSsave.species = pool.species;
    pool.DSsave.ladder = pool.ladder;
    pool.DSsave.fragmentcount = pool.fragmentcount;
    pool.DSsave.anaMode = pool.anaMode;
    pool.DSsave.hash = pool.hash;
    pool.DSsave.allFilesData = pool.allFilesData;
    pool.DSsave.dyenames = pool.dyenames;
    pool.DSsave.datalength = pool.datalength;
    pool.DSsave.selF = pool.selF;
    pool.DSsave.Mpeaks = pool.Mpeaks;
    pool.DSsave.Mpeaks2 = pool.Mpeaks2;
    %markFalseRange
    pool.DSsave.TAGpos = pool.TAGpos;
    pool.DSsave.corrFlag = pool.corrFlag;    
    pool.DSsave.Cpeaks = pool.Cpeaks;
else
    set(pool.currFILE, 'String',pool.DSsave.currFILE);
    set(pool.statusBOX,'String',pool.DSsave.statusBOX);
    set(pool.statusBOX,'Value',size(pool.DSsave.statusBOX,1));
    set(pool.PCRpur, 'value',pool.DSsave.PCRpur);
    set(pool.ignbases,'String',pool.DSsave.ignbases);
    set(pool.minTHRESH,'String',pool.DSsave.minTHRESH);
    pool.plot = pool.DSsave.plot;
    pool.ignbasesV = pool.DSsave.ignbasesV;
    pool.pcr = pool.DSsave.pcr;
    pool.minTH = pool.DSsave.minTH;
    pool.selC = pool.DSsave.selC;
    pool.filename = pool.DSsave.filename;
    %pool.Pathname
    pool.species = pool.DSsave.species;
    pool.ladder = pool.DSsave.ladder;
    pool.fragmentcount = pool.DSsave.fragmentcount;
    pool.anaMode = pool.DSsave.anaMode;
    pool.hash = pool.DSsave.hash;
    pool.allFilesData = pool.DSsave.allFilesData;
    pool.dyenames = pool.DSsave.dyenames;
    set(pool.DyeNoDend,'String',pool.dyenames);
    pool.datalength = pool.DSsave.datalength;
    pool.selF = pool.DSsave.selF;
    pool.Mpeaks = pool.DSsave.Mpeaks;
    pool.Mpeaks2 = pool.DSsave.Mpeaks2;
    %markFalseRange
    pool.TAGpos = pool.DSsave.TAGpos;
    pool.corrFlag = pool.DSsave.corrFlag;
    pool.Cpeaks = pool.DSsave.Cpeaks;
end
end