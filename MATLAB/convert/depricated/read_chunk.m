function [chunkData] = read_chunk(varargin)
%[chunkData] = read_chunk(varargin) Takes .chunk file name and reads in
%data as 'chunk' format, a series of value lists ordered by timestep
%   Input is name of .chunk file, output is a chunk data series.
%   Chunk data is a series of lists containing simulation values, lists are
%   ordered sequentially by timestep. Bin values are ordered as
%   (x1,y1),(x1,y2),(x1,y3)...(x2,y1),(x2,y2),(x2,y3)... such that
%   y is the most rapidly varying bin coordinate/index

debug = 0;

chunkFile = varargin{1};
try %Open file
    fid = fopen(chunkFile,'r');
catch
    error('Log file not found!');
end

%Get simulation ID string from .chunk file name
fileParts = strsplit(chunkFile, '.');
nameParts = strsplit(fileParts{1,1}, '_');
dataName = nameParts{1,1};
for i=2:1:size(nameParts,2)-1
    dataName = strcat(dataName, '_', nameParts{1,i});
end

if isunix %Unix OS, read 'head' and 'tail' terminal outputs as strings
    [~,chars] = system(strcat({'head -n '},num2str(4),{' '},chunkFile));
    chunkHead = convertCharsToStrings(chars);
    headStrings = strsplit(chunkHead,'\n');
    for i=3:1:4
        headWords = strsplit(headStrings(i),' ');
        if i == 3
            nVars = size(headWords,2)-2; %Third line in .chunk file lists the variable names
        elseif i == 4
            nChunks = str2double(headWords{1,2}); %Fourth line in .chunk file includes number of bins
        end
    end
    clear chars headStrings chunkHead headWords;
    
    [~,chars] = system(strcat({'tail -n '},num2str(nChunks+1),{' '},chunkFile)); %Read in timestep variable line for last list output
    chunkTail = convertCharsToStrings(chars);
    tailWords = strsplit(chunkTail,' ');
    nTimes = str2double(tailWords{1,1})/1000+1; %Convert final timestep to MATLAB list index
    if debug == 1
        nTimes = 101; %Read fewer times for debugging
    end
    clear chars chunkTail tailWords;
    
elseif ispc %Windows OS, read first four lines to get num variables and bins.
    numLines = 4;
    headChars = cell(numLines,1);
    for i = 1:numLines
        headChars(i) = {fgetl(fid)};
    end
    headStrings = convertCharsToStrings(headChars);
    for i=3:1:4
        headWords = strsplit(headStrings(i),' ');
        if i == 3
            nVars = size(headWords,2)-2;
        elseif i == 4
            nChunks = str2double(headWords{1,2});
        end
    end
    clear chars headStrings chunkHead headWords;
    nTimes = 1; %Initialize nTimes which will be updated later since Windows must read entire file
end
chunkData = zeros(nTimes,nChunks,nVars); %Create chunk data series
tIndex = 1;
while feof(fid) == 0 %Read file line by line
    chunkLine = fgetl(fid);
    chunkWords = strsplit(chunkLine,' ');
    [~,isNum]=str2num(chunkWords{1,1});
    if isNum == 1
        if strcmp(chunkWords{1,2},num2str(nChunks)) %If line is the number of bins the following data will be at next output time
            tIndex = tIndex + 1;
            if debug == 1 && index == 101 %Shorten read for debugging
                break;
            end
        else
            chunkID = str2double(chunkWords{1,1}); %First column is chunk list index
            varWords = chunkWords(2:end); %Following columns are data values
            for i=1:1:nVars
                var = varWords{1,i};
                chunkData(tIndex,chunkID,i) = str2double(var); %Convert read string to double, assign to 'chunkData'
            end
        end
    end
end
fclose(fid);
%Optional save during run to supplement function return
% save(strcat(dataName, '.mat'), 'chunkFile', 'chunkData');
% clear chunkLine chunkWords isNum step index chunkID varWords var;
end
