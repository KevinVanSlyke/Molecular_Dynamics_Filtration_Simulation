function [] = read_vcm_chunk()
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
dirParts = strsplit(pwd,'/');
simDir = dirParts(end);
parString = simDir{1,1};
chunkFile = strcat('avg_vcm_chunks_',parString,'_0T_r0.lmp');
outputFile = strcat('vcm_data_',parString,'_0T_r0.mat');
try
    fid = fopen(chunkFile,'r');
catch
    error('Log file not found!');
end
[~,chars] = system(['head -n ',num2str(4),' ',chunkFile]);
chunkHead = convertCharsToStrings(chars);
headStrings = strsplit(chunkHead,'\n');
for i=3:1:4
    headWords = strsplit(headStrings(i),' ');
    if i == 3
        %Ignore leading space, row id, and z component of vcm
        nVars = size(headWords,2)-3;
    elseif i == 4
        nChunks = str2double(headWords{1,2});
    end
end
clear chars headStrings chunkHead headWords;

[~,chars] = system(['tail -n ',num2str(nChunks+1),' ',chunkFile]);
chunkTail = convertCharsToStrings(chars);
tailWords = strsplit(chunkTail,' ');
nSteps = str2double(tailWords{1,1})/1000+1;
clear chars chunkTail tailWords;

vcmChunkData = zeros(nSteps,nChunks,nVars);
while feof(fid) == 0
    chunkLine = fgetl(fid);
    chunkWords = strsplit(chunkLine,' ');
    [~,isNum]=str2num(chunkWords{1,1});
    if isNum == 1
        if strcmp(chunkWords{1,2},num2str(nChunks))
            step = str2double(chunkWords{1,1});
            index = step/1000+1;
        else
            chunkID = str2double(chunkWords{1,1});
            varWords = chunkWords(2:end);
            for i=1:1:nVars
                var = varWords{1,i};
                vcmChunkData(index,chunkID,i) = str2double(var);
            end
        end
    end
end
fclose(fid);
clear chunkLine chunkWords isNum step index chunkID varWords var;
save(outputFile, 'vcmChunkData');
end
