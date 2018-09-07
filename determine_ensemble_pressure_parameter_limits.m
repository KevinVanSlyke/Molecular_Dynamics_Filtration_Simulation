function [parStrings, nTrials, tMaxs] = determine_ensemble_pressure_parameter_limits(baseDir)
%Iteratres through a parameter space ensemble to determine the minimum
%timestep reached of all simulations in the set, which then becomes the
%maximum timestep for analysis.

%TODO: Can make function that determines the fullpath for the folders I'm
%actually interested in.

%baseDir = '/home/Kevin/Documents/Simulation_Data/Molecular/.../';
%baseDir = '/home/Kevin/Documents/Simulation_Data/Molecular/May_2018_Width_Statistics/1D_Width';

parameterList = dir(baseDir);
nParDir = size(parameterList,1);
nPar = 0;
for i = 1 : 1 : nParDir
    if (parameterList(i).isdir() && not(strcmp(parameterList(i).name(),'.')) && not(strcmp(parameterList(i).name(),'..')))
        nPar = nPar + 1;
        parameterString = parameterList(i).name();
        parStrings{1,nPar} = parameterString;
        trialList = dir(fullfile(baseDir,parameterString));
        nTrialDirs(nPar) = size(trialList,1);
        nTrials(nPar) = 0;
        nTimeMax = Inf;
        tMaxs(nPar) = Inf;
        for n = 1 : 1 : nTrialDirs(nPar)
            if (trialList(n).isdir() && not(strcmp(trialList(n).name(),'.')) && not(strcmp(trialList(n).name(),'..')))
                nTrials(nPar) = nTrials(nPar) + 1;
                trialString = trialList(n).name();
                directory = fullfile(baseDir,parameterString,trialString);
                cd(directory);
                tTrialMax = read_log_time_limit();
                if tTrialMax < nTimeMax
                    tCount = (tTrialMax-1)/1000;
                    tMaxs(nPar) = tCount;
                end
            end
        end
    end
end

cd(baseDir);
end