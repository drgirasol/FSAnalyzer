function [ filename,ladderpath,sampleIDpath,savefilename,p ] = scanfolder( SELdir )
filename = '';
savefilename = '';
ladderpath = '';
sampleIDpath = '';
txtfilename = '';
listing = dir(SELdir);
c=1;
x=1;
y=1;
p=0;
for i=1:1:size(listing,1)
    if size(listing(i).name,2)>4
        Fextension = listing(i).name(1,(size(listing(i).name,2)-3):size(listing(i).name,2));
    else
        Fextension = 0;
    end
    %% check for rawDATA
    if strcmp(Fextension,'DATA')
        p=1;
        rawDATAdir = fullfile(strcat(SELdir,'\','rawDATA'));
        listing2 = dir(rawDATAdir);
        for u=1:1:size(listing2,1)
            if size(listing2(u).name,2)>4
                Fextension2 = listing2(u).name(1,(size(listing2(u).name,2)-3):size(listing2(u).name,2));
            else
                Fextension2 = 0;
            end
            %% look for fsa files
            if strcmp(Fextension2,'.fsa')
                filename{y} = listing2(u).name;
                y=y+1;
            end
        end
    end
    %% look for fsa files
    if strcmp(Fextension,'.fsa')
        filename{y} = listing(i).name;
        y=y+1;
    end
    %% look for saves
    if strcmp(Fextension,'.mat')
        savefilename{c} = listing(i).name;
        c=c+1;
    end
    %% look for sizestandard and sampleids
    if strcmp(Fextension,'.txt')
        txtfilename{x} = listing(i).name;
        x=x+1;
    end
end
%% separate sizestandard and sampleids
for i=1:1:size(txtfilename,2)
    txtname='';
    if size(txtfilename{i},2)>=16
        txtname = txtfilename{i}(1:12);
    end
    if strcmp(txtname,'SizeStandard')
        ladderpath = fullfile(SELdir,txtfilename{i});
    end
    txtname='';
    if size(txtfilename{i},2)>=13
        txtname = txtfilename{i}(1:9);
    end
    if strcmp(txtname,'SampleIDs')
        sampleIDpath = fullfile(SELdir,txtfilename{i});
    end
end
end