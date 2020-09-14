function [varNames, ensembleData] = collate_ensemble_data(paramString,nRestarts,nTrials,nLines,nVars)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
ensembleData = zeros(nLines, nVars, nTrials);
for trialIndex = 0 : 1 : nTrials-1
    [varNames, fullThermData] = catenate_thermo_data(paramString,trialIndex,nLines,nVars,nRestarts);
    ensembleData(:,:,trialIndex+1) = fullThermData(1:nLines,:); %LJ Dimensionless
    clear fullThermData varData;
end

end
