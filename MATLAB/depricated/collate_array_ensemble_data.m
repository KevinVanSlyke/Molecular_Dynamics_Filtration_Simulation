function [varNames, ensembleData] = collate_array_ensemble_data(trialsDir, parString)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
[nTrials, nLines, nVars, nRestarts] = array_ensemble_indices(trialsDir);
nLines = round(nLines);
ensembleData = zeros(nLines, nVars, nTrials);
trialList = dir(fullfile(trialsDir));
nFiles = size(trialList,1);
nTrial = 0;
for n = 1 : 1 : nFiles
    if (startsWith(trialList(n).name(), 'thermo') && endsWith(trialList(n).name(), '.log'))
        [varNames, fullThermData] = catenate_array_thermo_data(parString,nTrial,nLines,nVars,nRestarts);
        nTrial = nTrial + 1;
        ensembleData(:,:,nTrial) = fullThermData(1:nLines,:); %LJ Dimensionless
        clear fullThermData varData;
    end
end

end
