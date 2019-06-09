function [nRestarts] = return_numRestarts(paramString)
varLogStartString = strcat('log_',paramString,'_0T_r*.lmp');
logFileList = dir(fullfile(pwd, varLogStartString));
nLogFiles = size(logFileList,1);
finalRestartIndex = 0;
for n = 1:1:nLogFiles
    logFileString = logFileList(n).name();
    startCheckString = strcat('log_',paramString,'_0T');
    if startsWith(logFileString, startCheckString)
        logFileParts = strsplit(logFileString,'.');
        logParts = strsplit(logFileParts{1,1},'_');
        nLogParts = size(logParts,2);
        restartIndex = logParts(nLogParts);
        restartString = restartIndex{1,1};
        nRestarts = str2double(restartString(1,2));
        if nRestarts > finalRestartIndex
            nRestarts = finalRestartIndex;
        end
    end
end

end


