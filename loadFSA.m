%simple and fast script for reading data inside ABIF *.fsa data
%the output can be adjusted as needed
%please refer to this file https://goo.gl/kKT3dJ for more information
%it sure can be fast transferred to *.ab1 or expanded in *.fsa functionalty
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function [ intval ] = b2d( x )             %Create a new function,
% intval = sum(x .* 2.^(size(x,2)-1:-1:0));  %copy this and save.
% end                                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%by Patrick Thimm, 2016 - iifsanalyzer@gmail.com
function [ FSAdata ] = loadFSA( fullpath )
fsabinID = fopen(fullpath);
fsabinFULL = fread(fsabinID,'*ubit1','b')';
fsabinFULL = double(fsabinFULL);
fclose(fsabinID);
%% verify file format and version
c=1; %%check for file format b1 32bit
for i=1:1:4
    FSAdata.CKformat(i) = char(b2d(fsabinFULL(c:c+7)));
    c=c+8;
end
%%check for version number b5 16bit
FSAdata.CKversion = b2d(fsabinFULL(c:c+15));
%% read dataoffset and numelements
c=18*8+1; %%number of elements in one element
CKnumelements = b2d(fsabinFULL(c:c+31));
c=26*8+1; %%item's data, or offsetin file
CKdataoffset = b2d(fsabinFULL(c:c+31));
%% read out directories
c=(CKdataoffset)*8+1; %%tag name of first entry  32bit
tagnames = '';
for i=1:1:CKnumelements
    %TAGNAMES
    for u=1:1:4
        tagnames(i,u) = char(b2d(fsabinFULL(c:c+7)));
        c=c+8;
    end
    %TAGNUMBER
    tagnumber(i) = b2d(fsabinFULL(c:c+31));
    c=c+32;
    %     %ELEMENTTYPE
%     elementtype(i) = b2d(fsabinFULL(c:c+15));
    c=c+16;
    %     %ELEMENTSIZE
%     elementsize(i) = b2d(fsabinFULL(c:c+15));
    c=c+16;
    %NUMELEMENTS
     numelements(i) = b2d(fsabinFULL(c:c+31));
    c=c+32;
    %     %SIZE OF DATA
%     datasize(i) = b2d(fsabinFULL(c:c+31));
    c=c+32;
    %DATAOFFSET
    dataoffset(i) = b2d(fsabinFULL(c:c+31));
    dataoffsetS(i) = c;
    c=c+32;
    %     %DATAHANDLE
%      datahandle(i) = b2d(fsabinFULL(c:c+31));
    c=c+32;
end
%% extract desired data
for i=1:1:size(tagnames,1) % get position of datablocks for dyes
    DATAposTMP(i) = strcmp(tagnames(i,:),'DATA');
end
DATApos = find(DATAposTMP==1);
for i=1:1:4 %get starting points dyes
    dyeoffset(i) = dataoffset(DATApos(i));
end

for z=1:1:size(dyeoffset,2) %% dye extraction
    c=dyeoffset(z)*8+1;
    for i=1:1:numelements(DATApos(z))
        dyedata(z,i) = typecast(uint16(b2d(fsabinFULL(c:c+15))),'int16');
        c=c+16;
    end
end

markeroffset = dataoffset(find(tagnumber==105)); %% starting point marker
c=markeroffset*8+1;
for i=1:1:numelements(DATApos(z)) %% marker extraction
    dyedata(5,i) = typecast(uint16(b2d(fsabinFULL(c:c+15))),'int16');
    c=c+16;
end

for i=1:1:size(tagnames,1) % get position of datablocks for names
    NAMEposTMP(i) = strcmp(tagnames(i,:),'DyeN');
end
NAMEpos = find(NAMEposTMP==1);

dyenames='';
for z=1:1:size(NAMEpos,2) %% name
    if (numelements(NAMEpos(z))>4)
        c=dataoffset(NAMEpos(z))*8+1;
    else
        c=dataoffsetS(NAMEpos(z));
    end
    for i=1:1:numelements(NAMEpos(z))
        dyenames(z,i) = char(b2d(fsabinFULL(c:c+7)));
        c=c+8;
    end
end

dsize = numelements(DATApos(1));

FSAdata.Data = dyedata;
FSAdata.DyeName = dyenames; 
FSAdata.Size = dsize;
end