function [stat_data] = calculate_ensemble_pressure_statistics(baseDir)
%Calculates average and standard deviation of pressure from multiple runs
%   For a given list of simulation ID's their pressure data is iteratively read from
%   multiple runs differing only by random seed. Statistical average and
%   standard deviation are then calculated and output.

[parStrings, nTrials, tMaxs] = determine_ensemble_pressure_parameter_limits(baseDir);
nParDir = size(parStrings,2);

nPressures = 1;

for nPar = 1 : 1 : nParDir
    parEnsembleAvgP = zeros(tMaxs(nParDir),nPressures);
    parEnsembleStdP = zeros(tMaxs(nParDir),nPressures);
    parString = parStrings{1,nPar};
    parPData = zeros(tMaxs(nParDir),nPressures,nTrials(nPar));
    trialList = dir(fullfile(baseDir,parString));
    nTrialDirs(nPar) = size(trialList,1);
    nTrial = 0;
    for n = 1 : 1 : nTrialDirs(nPar)
        if (trialList(n).isdir() && not(strcmp(trialList(n).name(),'.')) && not(strcmp(trialList(n).name(),'..')))
            nTrial = nTrial + 1;
            trialString = trialList(n).name();
            directory = fullfile(baseDir,parString,trialString);
            cd(directory);
            % rawThermData = read_therm_data();
            % rawPressData = selectCols(rawThermData,'Step','v_P');
            % rawTime = rawPressData.t;
            % rawPress = rawPressData.P;
            % tIndexMax = returnTimeIndex(rawTime, tMaxs(nPar));
            % times = rawTime(1:tIndexMax);
            % press = rawPress(1:tIndexMax);
            rawPData = read_pressure_data();
            P(:,:) = rawPData.P; %LJ Dimensionless
            parPData(:,:,nTrial) = P(1:tMaxs,:);
        end
    end
    parEnsembleAvgP(:,:,nPar) = mean(parPData,3);
    parEnsembleStdP(:,:,nPar) = std(parPData,0,3);
end
cd(baseDir);
%----------Outputs-------------
%OUTPUTS IN SAME VARIABLE STRUCTURE
stat_data = {parameterStrings; tMaxs; ensembleAvgP; ensembleStdP};
%------------------------------
end

