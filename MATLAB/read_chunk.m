function [chunkData] = read_chunk(varargin)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
chunkFile = varargin{1};
try
    fid = fopen(chunkFile,'r');
catch
    error('Log file not found!');
end

fileParts = strsplit(chunkFile, '.');
nameParts = strsplit(fileParts{1,1}, '_');
dataName = nameParts{1,1};

for i=2:1:size(nameParts,2)-1
    dataName = strcat(dataName, '_', nameParts{1,i});
end

%unix way
% [~,chars] = system(['head -n ',num2str(4),' ',chunkFile]); 
% chunkHead = convertCharsToStrings(chars);
% headStrings = strsplit(chunkHead,'\n');
% for i=3:1:4
%     headWords = strsplit(headStrings(i),' ');
%     if i == 3
%         nVars = size(headWords,2)-2;
%     elseif i == 4
%         nChunks = str2double(headWords{1,2});
%     end
% end
% clear chars headStrings chunkHead headWords;
% 
% [~,chars] = system(['tail -n ',num2str(nChunks+1),' ',chunkFile]);
% chunkTail = convertCharsToStrings(chars);
% tailWords = strsplit(chunkTail,' ');
% nTimes = str2double(tailWords{1,1})/1000;
% % nTimes = 101;
% clear chars chunkTail tailWords;

%general way
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
nTimes = 1+1;

chunkData = zeros(nTimes,nChunks,nVars);
tIndex = 1;
while feof(fid) == 0
    chunkLine = fgetl(fid);
    chunkWords = strsplit(chunkLine,' ');
    [~,isNum]=str2num(chunkWords{1,1});
    if isNum == 1
        if strcmp(chunkWords{1,2},num2str(nChunks))
%             step = str2double(chunkWords{1,1});
%             tIndex = step/1000+1;
            tIndex = tIndex + 1;
            %Shorten read for debugging
%             if index == 101
%                 break;
%             end
        else
            chunkID = str2double(chunkWords{1,1});
            varWords = chunkWords(2:end);
            for i=1:1:nVars
                var = varWords{1,i};
                chunkData(tIndex,chunkID,i) = str2double(var);
            end
        end
    end
end
fclose(fid);
clear chunkLine chunkWords isNum step index chunkID varWords var;
% save(strcat(dataName, '.mat'), 'chunkFile', 'chunkData');
end
