function [ nTrials ] = return_nTrials(paramString)

varLogStartString = strcat('log_',paramString,'_*T_r0.lmp');
logFileList = dir(fullfile(pwd, varLogStartString));
nTrials = size(logFileList,1);

end