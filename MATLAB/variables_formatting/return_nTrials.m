function [ nTrials ] = return_nTrials(paramString)

% varLogStartString = strcat('thermo_',paramString,'_*T_r0.log');
varLogStartString = strcat('thermo_',paramString','_*T.log');
logFileList = dir(fullfile(pwd, varLogStartString));
nTrials = size(logFileList,1);
end