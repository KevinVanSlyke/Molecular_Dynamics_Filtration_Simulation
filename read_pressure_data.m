function [ varargout ] = get_press_merge_11_13_17( varargin )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

files = dir('log_*');
nFiles = size(files,1);
thermData = {};
for i = 1:1:nFiles
    fileName = files(i).name;
    nameParts = strsplit(fileName,{'_'});
    if strcmp(nameParts{1,2},'start')
        logIndx = 1;
    elseif strcmp(nameParts{1,2},'restart')
        logIndx = 2;
    else
        logIndx = str2num(nameParts{1,2}) + 1;
    end
    
    try
        logData = readlog(fileName);
    catch
        print 'Readlog failed.';
    end
    if logIndx == 1
        cThermStrings = logData.data{1,2};
    else
        cThermStrings = logData.data{1,1};
    end
    cTimes = size(cThermStrings,1)-1;
    cThermData = zeros(cTimes,7);
    for n = 1 : 1 : cTimes
        cThermString = strtrim(cThermStrings(n,:));
        cThermWords = strsplit(cThermString);
        cWords = size(cThermWords,2);
        for j = 1 : 1 : cWords
            cThermData(n,j) = str2double(cThermWords(1,j));
        end
    end
    thermData{logIndx,1} = cThermData(:,1);
    thermData{logIndx,2} = cThermData(:,7);
end
tCat(:,1) = thermData{1,1};
PCat(:,1) = thermData{1,2};
for i=2:1:nFiles
    catTimes = size(tCat,1);
    tCur(:,1) = thermData{i,1};
    PCur(:,1) = thermData{i,2};
    curTimes = size(tCur,1);
    curStrtIndx = 1;
    
    for j = 1 : 1 : curTimes
        if tCur(j) == tCat(catTimes)
            curStrtIndx = j;
            break;
        end
    end
    
    for j = 1 : 1 : curTimes-curStrtIndx
        tCat(catTimes + j,1) = tCur(j+curStrtIndx,1);
        PCat(catTimes + j,1) = PCur(j+curStrtIndx,1);
    end
end

%----------Outputs-------------
%OUTPUTS IN SAME VARIABLE STRUCTURE
varargout{1}.P = PCat;
varargout{1}.t = tCat;
%------------------------------
end

