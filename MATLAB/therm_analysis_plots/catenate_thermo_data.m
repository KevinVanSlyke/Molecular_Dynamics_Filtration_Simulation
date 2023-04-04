function [varNames, fullThermData ] = catenate_thermo_data(paramString,trialIndex,nLines,nVars,nRestarts)
%Reads in all thermo data from a single log file in current directory
%   Parses into outputs: columns of doubles, row of column id
% logFileList = dir(fullfile(fPath, strcat('log_',simString,'_restart_*.lmp')));
% nLogFiles = size(logFileList,1); %number of dump files for current pore
% if nLogFiles > 0
%     fullThermData = [];
% end
fullThermData = zeros(nLines, nVars);

for n = 0 : 1 : nRestarts
%TODO: Make this modular so it can read with/without num2str(trialIndex),'T'
%    thermLogFile = fullfile(fPath, strcat('log_',simString,'_restart_',num2str(n-1),'.lmp'));
%     nRestartLogString = strcat('thermo_',paramString,'_',num2str(trialIndex),'T_r',num2str(n),'.log');
    nRestartLogString = strcat('thermo_',paramString,'_',num2str(trialIndex-1),'T.log');
%     nRestartLogString = strcat('thermo_',paramString,'.log');
    try
        logData = readlog(nRestartLogString);
    catch
        error(strcat('ERROR: readlog.m failed to read ', nRestartLogString, ' presumably due to improper file format.'));
    end
    if n == 0
        dataIndex = 2;
    else
        dataIndex = 1;
    end

    for c = 1 : 1 : nVars
        cString = convertCharsToStrings(logData.Chead{dataIndex,c});
        varNames(c,1) = cString;
    end
    if size(logData.data,2)<2
        disp(paramString)
        disp(trialIndex)
    end
    thermValueStrings = logData.data{1,dataIndex};
    nTimes = size(thermValueStrings,1);
    thermData = zeros(nTimes,nVars);
    for i = 1 : 1 : nTimes
        thermValueString = strtrim(thermValueStrings(i,:));
        thermValueWords = strsplit(thermValueString);
        nWords = size(thermValueWords,2);
        for j = 1 : 1 : nWords
            thermData(i,j) = str2double(thermValueWords(1,j));
        end
    end

    if n == 0 %If restart_0 (start), copy single file output to head of output
        fullThermData(1:nTimes,:) = thermData;
    elseif n >= 1  %If restart dump, find index of matching times and append later times to single file data
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

