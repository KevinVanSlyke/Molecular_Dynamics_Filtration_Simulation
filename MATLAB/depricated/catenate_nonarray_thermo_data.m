function [thermNameStrings, fullThermData ] = catenate_thermo_data(~)
%Reads in all thermo data from a single log file in current directory
%   Parses into outputs: columns of doubles, row of column id

% dirParts = strsplit(trialDir,'/');
% nDirParts = size(dirParts,2);
% simDir = dirParts(nDirParts);
% simString = simDir{1,1};

% logFileList = dir(fullfile(fPath, strcat('log_',simString,'_restart_*.lmp')));
% nLogFiles = size(logFileList,1); %number of dump files for current pore
% if nLogFiles > 0
%     fullThermData = [];
% end

logFileList =  dir(strcat('log_*.lmp'));
nLogFiles = size(logFileList,1); %number of dump files for current pore
if nLogFiles > 0
    fullThermData = [];
end

for n = 1 : 1 : nLogFiles
%    thermLogFile = fullfile(fPath, strcat('log_',simString,'_restart_',num2str(n-1),'.lmp'));
    thermLogFile = logFileList(n).name;
    try
        logData = readlog(thermLogFile);
    catch
        error(strcat('ERROR: readlog.m failed to read ', thermLogFile, ' presumably due to improper file format.'));
    end
    if n == 1
        dataIndex = 2;
    else
        dataIndex = 1;
    end
    numThermTypes = max(size(logData.Chead))-1;
    thermNameStrings = strings(1, numThermTypes);
    for c = 1 : 1 : numThermTypes
        cString = convertCharsToStrings(logData.Chead{dataIndex,c});
        thermNameStrings(c) = cString;
    end
    thermValueStrings = logData.data{1,dataIndex};
    nTimes = size(thermValueStrings,1)-1;
    thermData = zeros(nTimes,numThermTypes);
    for i = 1 : 1 : nTimes
        thermValueString = strtrim(thermValueStrings(i,:));
        thermValueWords = strsplit(thermValueString);
        nWords = size(thermValueWords,2);
        for j = 1 : 1 : nWords
            thermData(i,j) = str2double(thermValueWords(1,j));
        end
    end

    if n == 1 %If restart_0 (start), copy single file output to head of output
        fullThermData = thermData;
    elseif n >= 2  %If restart dump, find index of matching times and append later times to single file data
        tIndex = 0; 
        tMaxIndex = max(size(fullThermData));
        tMax = fullThermData(tMaxIndex,1);
        for i = 1 : 1 : nTimes %For all number of times in current log file
            if thermData(i,1) == tMax %If time at index i equals final time in output vector
            	tIndex = i;  %Record index of matching time
                break;
            end
        end
        for i = 1 : 1 : nTimes-tIndex %For the difference in matching index to total times in current log file
            fullThermData(tMaxIndex + i,:) = thermData(i+tIndex,:); %Append next output thermo row to output vector
        end
    end
end
end

