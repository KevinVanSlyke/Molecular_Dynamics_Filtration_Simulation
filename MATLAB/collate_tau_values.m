function [tauAvgs, tauStds, parNames, parVars, parVals, nEnsemble] = collate_tau_values(ensemblesDir, selectedVar, outputDir, plotFit, plotFFT)
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here
cwd = ensemblesDir;
ensembleDirList = dir(fullfile(ensemblesDir));
nEnsembleDirs = size(ensembleDirList,1);
nEnsemble = 0;
for n = 1 : 1 : nEnsembleDirs
    if (ensembleDirList(n).isdir() && not(strcmp(ensembleDirList(n).name(),'.')) && not(strcmp(ensembleDirList(n).name(),'..')))
        nEnsemble = nEnsemble + 1;
        parString = ensembleDirList(n).name();
        trialsDir = fullfile(ensemblesDir,parString);
        cd(trialsDir);
        %[tauAvg(nEnsemble), tauStd(nEnsemble), parNames, parVars, parVals(nEnsemble)] = analyze_ensemble_variable(trialsDir, selectedVar, outputDir, plotFit, plotFFT);
        [parNames, parVars, parVals] = ensemble_parameters(trialsDir);
        [tauAvgs(nEnsemble), tauStds(nEnsemble)] = analyze_ensemble_variable(trialsDir, selectedVar, outputDir, plotFit, plotFFT);
    end
end
cd(ensemblesDir);

end

