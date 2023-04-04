function [varNames, ensembleAvgVals, ensembleStdVals] = therm_variable(fileDir)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here

% [varTitle, ~] = format_variable_name(selectedVar);
[varNames, ensembleData] = read_therm_log(fileDir);
[ensembleAvgVals, ensembleStdVals] = ensemble_thermo_stats(ensembleData);
[parNames, parVars, parVals] = ensemble_parameters(fileDir);
if parVals(2) == 1
    varNames(11:13) = varNames(10:12);
    ensembleData(:,11:13) = ensembleData(:,10:12);
    varNames(10) = 'v_hopperImpurityCount';
    ensembleData(:,10) = zeros(size(ensembleData,1),1);
    varNames(14) = 'v_interLayerImpurityCount';
    ensembleData(:,14) = zeros(size(ensembleData,1),1);
end
[parString] = catenate_parameters(parVars,parVals);

save(strcat(parString,'_stat_data.mat'));

end