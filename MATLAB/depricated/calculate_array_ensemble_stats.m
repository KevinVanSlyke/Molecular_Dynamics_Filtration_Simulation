function [] = calculate_array_ensemble_stats(trialsDir, selectedVar, outputDir)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
cwd = pwd;

[parNames, parVars, parVals] = ensemble_parameters(trialsDir);
[parString] = catenate_parameters(parVars,parVals);
[varNames, ensembleData] = collate_array_ensemble_data(trialsDir, parString);

[ensembleAvgVals, ensembleStdVals] = ensemble_thermo_stats(ensembleData);

[steps, ~] = select_thermo_var(varNames, ensembleAvgVals, ensembleStdVals, 'Step');
[varAvg, varStd] = select_thermo_var(varNames, ensembleAvgVals, ensembleStdVals, selectedVar);

cd(outputDir);
clear ensembleData;
save(strcat(parString,'_stats_data.mat'));
cd(cwd);

end