function [tauAvgs, tauStds, parNames, parVars, parValList] = analyze_loaded_tau_values()
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here

ensemblesDir = pwd;
outputDir = pwd;
plotFit = 'LJ';
plotFFT = 'LJ';
selectedVar = 'P';
ensembleDirList = dir(fullfile(ensemblesDir));
nEnsembleDirs = size(ensembleDirList,1);
nEnsemble = 0;
for n = 1 : 1 : nEnsembleDirs
    if endsWith(ensembleDirList(n).name(), '.mat')
        nEnsemble = nEnsemble + 1;
        parString = ensembleDirList(n).name();
        trialData = fullfile(ensemblesDir,parString);
        load(trialData, 'ensembleAvgVals', 'ensembleStdVals', 'varNames', 'parNames', 'parVars', 'parVals');
        [tauAvg, tauStd] = analyze_loaded_ensemble_variable(ensembleAvgVals, ensembleStdVals, varNames, parNames, parVars, parVals, selectedVar, outputDir, plotFit, plotFFT);    
        parValList(nEnsemble,:) = parVals;
        tauAvgs(nEnsemble) = tauAvg;
        tauStds(nEnsemble) = tauStd;
    end
end

clear ensembleDirList nEnsembleDirs n ensembleAvgVals ensembleStdVals;

save('tau_data.mat', 'tauAvgs', 'tauStds', 'parNames', 'parVars', 'parValList');

end

