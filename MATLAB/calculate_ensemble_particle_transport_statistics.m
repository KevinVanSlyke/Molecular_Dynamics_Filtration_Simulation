function [stat_data] = calculate_ensemble_particle_transport_statistics()
%Calculates average and standard deviation of particle transport
%   For a given list of simulation ID's their particle transport data is iteratively read from
%   multiple runs differing only by random seed. Statistical average and
%   standard deviation are then calculated and output.



nTimeMax = Inf;
%baseDir = '/home/Kevin/Documents/Dust_Data/Molecular/.../';
baseDir = '/home/Kevin/Documents//Simulation_Data/Molecular/April_2018_Impurity_Statistics/High_Average_Data/D1_thru_D20';
parameterList = dir(baseDir);
nParDir = size(parameterList,1);
%TODO: Replace with function that reads much less and only outputs total
%with error if mid simulation timesteps are missing.

%TODO: Can add a second function that determines the fullpath for the folders I'm
%actually interested in.

%TODO: Replace with function to figure out how many unique pore outputs there are
twoLayers = true;
if twoLayers == true
    pores = {'pore'; 'pore1'; 'pore2'};
else
    pores = {'pore'};
end
nPores = size(pores,1);

nPar = 0;
for i = 1 : 1 : nParDir
    if (parameterList(i).isdir() && not(strcmp(parameterList(i).name(),'.')) && not(strcmp(parameterList(i).name(),'..')))
        nPar = nPar + 1;
        parameterStrings{nPar,1} = parameterList(i).name();
        trialList = dir(fullfile(baseDir,parameterString));
        nTrialDirs = size(trialList,1);
        nTrials(nPar) = 0;
        for n = 1 : 1 : nTrialDirs
            if (trialList(n).isdir() && not(strcmp(trialList(n).name(),'.')) && not(strcmp(trialList(n).name(),'..')))
                for j = 1 : 1 : nPores
                    pore = pores{j,1};
                    nTrials(nPar) = nTrials(nPar) + 1;
                    trialString = trialList(n).name();
                    directory = fullfile(baseDir,parameterString,trialString);
                    cd(directory);
                    rawTransportData = read_particle_transport_data(pore);
                    trialT = rawTransportData.t; %timesteps
                    %%Need to make seperate function to read only time from files
                    if max(size(trialT)) < nTimeMax
                        nTimeMax = max(size(trialT))-1;
                        t = trialT(1:nTimeMax);
                    end
                end
            end
        end
    end
end
ensembleAvgArgonCount = zeros(nPar, nPores, nTimeMax);
ensembleAvgArgonSum = zeros(nPar, nPores, nTimeMax);
ensembleAvgImpurityCount = zeros(nPar, nPores, nTimeMax);
ensembleAvgImpuritySum = zeros(nPar, nPores, nTimeMax);
ensembleStdArgonCount = zeros(nPar, nPores, nTimeMax);
ensembleStdArgonSum = zeros(nPar, nPores, nTimeMax);
ensembleStdImpurityCount = zeros(nPar, nPores, nTimeMax);
ensembleStdImpuritySum = zeros(nPar, nPores, nTimeMax);
nPar = 0;
for i = 1 : 1 : nParDir
    if (parameterList(i).isdir() && not(strcmp(parameterList(i).name(),'.')) && not(strcmp(parameterList(i).name(),'..')))
        nPar = nPar + 1;
        parameterString = parameterList(i).name();
        parameterStrings{nPar,1} = parameterString;
        trialList = dir(fullfile(baseDir,parameterString));
        nTrialDirs = size(trialList,1);
        nTrials(nPar) = 0;
        for n = 1 : 1 : nTrialDirs
            if (trialList(n).isdir() && not(strcmp(trialList(n).name(),'.')) && not(strcmp(trialList(n).name(),'..')))
                for j = 1 : 1 : nPores
                    pore = pores{j,1};
                    nTrials(nPar) = nTrials(nPar) + 1;
                    trialString = trialList(n).name();
                    directory = fullfile(baseDir,parameterString,trialString);
                    cd(directory);
                    %TODO: For some reason some trials only have N-1 particle transport data points but N times.
                    %Possibly because the last particle data is zero..?
                    rawTransportData = read_particle_transport_data(pore);
                    argonCount = rawTransportData.ptclTrans(:,1);
                    argonSum = rawTransportData.netPtclTrans(:,1);
                    impurityCount = rawTransportData.ptclTrans(:,2);
                    impuritySum = rawTransportData.netPtclTrans(:,2);
                    parArgonCountData(nTrials(nPar),j,:) = argonCount(1:nTimeMax);
                    parArgonSumData(nTrials(nPar),j,:) = argonSum(1:nTimeMax);
                    parImpurityCountData(nTrials(nPar),j,:) = impurityCount(1:nTimeMax);
                    parImpurityCountData(nTrials(nPar),j,:) = impuritySum(1:nTimeMax);
                end
            end
        end
        ensembleAvgArgonCount(nPar,:,:) = mean(ensembleAvgArgonCount,1);
        ensembleStdArgonCount(nPar,:,:) = std(ensembleAvgArgonCount,0,1);
        ensembleAvgArgonSum(nPar,:,:) = mean(ensembleAvgArgonSum,1);
        ensembleStdArgonSum(nPar,:,:) = std(ensembleAvgArgonSum,0,1);
        ensembleAvgImpurityCount(nPar,:,:) = mean(ensembleAvgImpurityCount,1);
        ensembleStdImpurityCount(nPar,:,:) = std(ensembleAvgImpurityCount,0,1);
        ensembleAvgImpuritySum(nPar,:,:) = mean(ensembleAvgImpuritySum,1);
        ensembleStdImpuritySum(nPar,:,:) = std(ensembleAvgImpuritySum,0,1);
    end
end
cd(baseDir);
%----------Outputs-------------
%OUTPUTS IN SAME VARIABLE STRUCTURE
stat_data = {parameterStrings; t; ensembleAvgArgonCount; ensembleStdArgonCount; ensembleAvgArgonSum; ensembleStdArgonSum; ensembleAvgImpurityCount; ensembleStdImpurityCount; ensembleAvgImpuritySum; ensembleStdImpuritySum};
%------------------------------
end