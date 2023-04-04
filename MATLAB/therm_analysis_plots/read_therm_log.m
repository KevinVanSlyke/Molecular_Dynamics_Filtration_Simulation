function [varNames, ensembleData] = read_therm_log(trialDir)
cd(trialDir)
[paramString] = return_paramString(trialDir);
[nTrials] = return_nTrials(paramString);
% [nRestarts] = return_numRestarts(paramString);
%%Single restart hardcode
nRestarts = 0;
[nLines, nVars] = return_thermDimensions(paramString, nRestarts, nTrials);
[varNames, ensembleData] = collate_ensemble_data(paramString,nRestarts,nTrials,nLines,nVars);
end