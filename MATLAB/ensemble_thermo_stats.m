function [ensembleAvgVals, ensembleStdVals] = ensemble_thermo_stats(ensembleData)
%Calculates and outputs statistical average and standard deviation of all thermo log variables from multiple runs

ensembleAvgVals(:,:) = mean(ensembleData,3);
ensembleStdVals(:,:) = std(ensembleData,0,3);
clear ensembleData;

end

