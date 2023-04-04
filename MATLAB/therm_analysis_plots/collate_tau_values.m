function [tauAvgs, tauStds, ensembleAvgs, ensembleStds, parNames, parVars, parVals, varNames] = collate_tau_values(ensemblesDir, selectedVar, outputDir, plotFit, plotFFT)
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here
% cwd = ensemblesDir;
ensembleDirList = dir(fullfile(ensemblesDir));
nEnsembleDirs = size(ensembleDirList,1);
nEnsemble = 0;
parVals = zeros(nEnsemble,6);
for n = 1 : 1 : nEnsembleDirs
    if (ensembleDirList(n).isdir() && not(strcmp(ensembleDirList(n).name(),'.')) && not(strcmp(ensembleDirList(n).name(),'..')) && not(startsWith(ensembleDirList(n).name(),'Figures')))
        nEnsemble = nEnsemble + 1;
        parString = ensembleDirList(n).name();
        trialsDir = fullfile(ensemblesDir,parString);
%         cd(trialsDir);
        [parNames(nEnsemble,:), parVars(nEnsemble,:), parVals(nEnsemble,:)] = ensemble_parameters(trialsDir);
        [tauAvgs(nEnsemble), tauStds(nEnsemble), ensembleAvgs(:,:,nEnsemble), ensembleStds(:,:,nEnsemble), varNames] = analyze_variable(trialsDir, selectedVar, outputDir, plotFit, plotFFT);
    end
end

clear ensembleDirList nEnsembleDirs n;

cd(outputDir);
save(strcat('ensemble_tau_data.mat'));
cd(ensemblesDir);

end

