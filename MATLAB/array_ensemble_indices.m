function [nTrials, nLines, nVars, nRestarts] = array_ensemble_indices(trialsDir)
%Iteratres through a parameter space ensemble to determine the minimum
%timestep reached of all simulations in the set, which then becomes the
%maximum timestep for analysis.

%TODO: Can make function that determines the fullpath for the folders I'm
%actually interested in.

%baseDir = '/home/Kevin/Documents/Simulation_Data/Molecular/.../';
%baseDir = '/home/Kevin/Documents/Simulation_Data/Molecular/May_2018_Width_Statistics/1D_Width';

fileList = dir(trialsDir);
nFiles = size(fileList,1);
nTrials = 0;
nLines = Inf;
for n = 1 : 1 : nFiles
    if (startsWith(fileList(n).name(), 'thermo') && endsWith(fileList(n).name(), 'r0.log'))
        [trialLines, nVars, nRestarts] = array_trial_indices(nTrials);
        if trialLines < nLines
            nLines = trialLines;
        end
        nTrials = nTrials + 1;
    end
end
cd(trialsDir);

end