function [] = collate_array_ensemble_stats(ensemblesDir, selectedVar, outputDir)
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
        calculate_array_ensemble_stats(trialsDir, selectedVar, outputDir);
    end
end

end

