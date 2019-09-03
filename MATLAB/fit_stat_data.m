function [tauAvg, tauStd] = fit_stat_data( trialsDir, selectedVar, varNames, ensembleAvgVals, ensembleStdVals, outputDir, plotFit, plotFFT)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
cwd = pwd;

[parNames, parVars, parVals] = ensemble_parameters(trialsDir);
[parString] = catenate_parameters(parVars,parVals);
[varAvg, varStd] = select_thermo_var(varNames, ensembleAvgVals, ensembleStdVals, selectedVar);
[steps, ~] = select_thermo_var(varNames, ensembleAvgVals, ensembleStdVals, 'Step');

[ sampleFreq, fundSampleFreq, powerSpectrum ] = ensemble_variable_FFT( steps, varAvg );
if strcmp(plotFFT, 'off') == 0
    cd(outputDir);
    plot_variable_FFT(sampleFreq, fundSampleFreq, powerSpectrum, selectedVar, parNames, parVars, parVals, plotFFT);
    cd(cwd);
end

if strcmp(plotFit, 'LJ') == 1
    t = steps*0.005; %LJ dimensionless
elseif strcmp(plotFit, 'real') == 1
    t = steps*0.005*2.17*10^(-12)*10^9; %convert to ns
end

[ tauAvg, tauStd, expFitLine, tPeaks, varPeaks, varPeakStds, expRSquare, expAdjRSquare, expRMSE ] = ensemble_variable_fit(t, varAvg, varStd, fundSampleFreq, plotFit );
if strcmp(plotFit, 'off') == 0
    cd(outputDir);
    plot_variable_fit(t, varAvg, tPeaks, varPeaks, varPeakStds, expFitLine, selectedVar, parNames, parVars, parVals, plotFit);
    cd(cwd);
end
cd(outputDir);
save(strcat(parString,'_data.mat'));
cd(cwd);
end