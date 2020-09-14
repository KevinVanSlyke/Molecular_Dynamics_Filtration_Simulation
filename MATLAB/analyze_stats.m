function [varNames, ensembleAvgVals, ensembleStdVals] = analyze_stats(trialsDir, outputDir)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
cwd = pwd;

[varNames, ensembleData] = collate_ensemble_data(trialsDir);
[ensembleAvgVals, ensembleStdVals] = ensemble_thermo_stats(ensembleData);
[parNames, parVars, parVals] = ensemble_parameters(trialsDir);
[parString] = catenate_parameters(parVars,parVals);

cd(outputDir);
save(strcat(parString,'_stat_data.mat'));
cd(cwd);

end