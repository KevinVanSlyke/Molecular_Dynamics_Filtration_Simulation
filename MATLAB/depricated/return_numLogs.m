function [nTrials, nRestarts] = return_numLogs(paramString)
%Reads pressure data from thermodynamic output in LAMMPS log files
%   Catenates each data column in the LAMMPS log files from multiple restarts

varLogStartString = strcat('log_',paramString,'_*T_r0.lmp');
logFileList = dir(fullfile(pwd, varLogStartString));
nLogFiles = size(logFileList,1); %number of dump files for current pore
nRestarts = 0;
nTrials = 0;
for n = 1:1:nLogFiles
    logFileString = logFileList(n).name();
    startCheckString = strcat('log_',paramString,'_0T');
    if startsWith(logFileString, startCheckString)
        logFileParts = strsplit(logFileString,'.');
        logParts = strsplit(logFileParts{1,1},'_');
        nLogParts = size(logParts,2);
        restartIndex = logParts(nLogParts);
        restartString = restartIndex{1,1};
        restartNum = str2double(restartString(1,2));
        if restartNum > nRestarts
            nRestarts = restartNum;
        end
        endCheckString = 'r0.lmp';
        if endsWith(logFileString, endCheckString)
            nTrials = nTrials + 1;
        end
    end
end

end