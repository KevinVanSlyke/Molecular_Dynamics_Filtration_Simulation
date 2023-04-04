function [tauAvg, tauStd, ensembleAvgVals, ensembleStdVals, varNames, expFitLine, expAdjRSquare, expRMSE] = analyze_therm_variable(fileDir, selectedVar)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here

[varTitle, ~] = format_variable_name(selectedVar);
[varNames, ensembleData] = read_therm_log(fileDir);
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

[ensembleAvgVals, ensembleStdVals] = ensemble_thermo_stats(ensembleData);
save(strcat(parString,'_stat_data.mat'));
% cd(trialsDir);
[steps, ~] = select_thermo_var(varNames, ensembleAvgVals, ensembleStdVals, 'Step');
% cutIndex = size(steps,1)/2;
% time = steps(1:cutIndex)/200;
time = steps/200;
clear steps
[varAvg, varStd] = select_thermo_var(varNames, ensembleAvgVals, ensembleStdVals, selectedVar);
% varAvg = varAvg(1:cutIndex);
% varStd = varStd(1:cutIndex);
[ sampleFreq, fundSampleFreq, powerSpectrum ] = ensemble_variable_FFT( time, varAvg );
   
%Convert from sample frequency to inverse timestep
freq = sampleFreq/1000; %Units of 1/timestep
fundFreq = fundSampleFreq/1000; %Units of 1/timestep
nMax = size(freq,1);

freq = freq*200; %1/t* LJ dimensionless Unit
fundFreq = fundFreq*200;

normPower = powerSpectrum(1:nMax);
[tauAvg, tauStd, expFitLine, tPeaks, varPeaks, varPeakStds, expAdjRSquare, expRMSE] = therm_variable_fit( time, varAvg, varStd, fundSampleFreq );
end