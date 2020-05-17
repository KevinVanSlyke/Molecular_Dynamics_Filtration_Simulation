function [nTrials] = num_ensembles(trialsDir)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
trialList = dir(fullfile(trialsDir));
nTrialDirs = size(trialList,1);
nTrials = 0;
for n = 1 : 1 : nTrialDirs
    if (trialList(n).isdir() && not(strcmp(trialList(n).name(),'.')) && not(strcmp(trialList(n).name(),'..')))
        nTrials = nTrials + 1;
    end
end

end

