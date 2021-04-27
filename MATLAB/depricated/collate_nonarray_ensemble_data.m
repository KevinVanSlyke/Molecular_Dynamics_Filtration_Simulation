function [varNames, ensembleData] = collate_nonarray_ensemble_data(trialsDir)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
[nLines, nVars] = ensemble_indices(trialsDir);
nTrials = num_trials(trialsDir);
nLines = round(nLines);
ensembleData = zeros(nLines, nVars, nTrials);
trialList = dir(fullfile(trialsDir));
nTrialDirs = size(trialList,1);
nTrial = 0;
for n = 1 : 1 : nTrialDirs
    if (trialList(n).isdir() && not(strcmp(trialList(n).name(),'.')) && not(strcmp(trialList(n).name(),'..')))
        nTrial = nTrial + 1;
        trialString = trialList(n).name();
        directory = fullfile(trialsDir,trialString);
        cd(directory);
        [varNames, fullThermData] = catenate_thermo_data();
        ensembleData(:,:,nTrial) = fullThermData(1:nLines,:); %LJ Dimensionless
        clear fullThermData varData;
    end
end

end