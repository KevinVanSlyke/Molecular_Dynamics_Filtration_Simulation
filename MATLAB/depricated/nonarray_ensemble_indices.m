function [nLines, nVars] = nonarray_ensemble_indices(trialsDir)
%Iteratres through a parameter space ensemble to determine the minimum
%timestep reached of all simulations in the set, which then becomes the
%maximum timestep for analysis.

%TODO: Can make function that determines the fullpath for the folders I'm
%actually interested in.

%baseDir = '/home/Kevin/Documents/Simulation_Data/Molecular/.../';
%baseDir = '/home/Kevin/Documents/Simulation_Data/Molecular/May_2018_Width_Statistics/1D_Width';

trialList = dir(trialsDir);
nTrialDirs = size(trialList,1);
nTrials = 0;
nLines = Inf;
for n = 1 : 1 : nTrialDirs
    if (trialList(n).isdir() && not(strcmp(trialList(n).name(),'.')) && not(strcmp(trialList(n).name(),'..')))
        nTrials = nTrials + 1;
        trialString = trialList(n).name();
        directory = fullfile(trialsDir,trialString);
        cd(directory);
        [trialLines, nVars] = trial_indices();
        if trialLines < nLines
            nLines = trialLines;
        end
    end
end
cd(trialsDir);

end