function [nRestarts] = return_numRestarts(paramString)
% varLogStartString = strcat('thermo_',paramString,'_0T_r*.log');
varLogStartString = strcat('thermo_',paramString,'.log');
% varLogStartString = strcat('thermo_movie_',paramString,'_r*.log');

logFileList = dir(fullfile(pwd, varLogStartString));
nLogFiles = size(logFileList,1);
finalRestartIndex = 0;
for n = 1:1:nLogFiles
    logFileString = logFileList(n).name();
%     startCheckString = strcat('thermo_',paramString,'_0T');
    startCheckString = strcat('thermo_',paramString);
%     startCheckString = strcat('thermo_movie_',paramString);
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


