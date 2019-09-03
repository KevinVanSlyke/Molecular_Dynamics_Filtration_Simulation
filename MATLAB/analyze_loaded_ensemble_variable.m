function [tauAvg, tauStd] = analyze_loaded_ensemble_variable(ensembleAvgVals, ensembleStdVals, varNames, parNames, parVars, parVals, selectedVar, outputDir, plotFit, plotFFT)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
cwd = pwd;

[steps, ~] = select_thermo_var(varNames, ensembleAvgVals, ensembleStdVals, 'Step');

[varAvg, varStd] = select_thermo_var(varNames, ensembleAvgVals, ensembleStdVals, selectedVar);
%steps = steps(1:2000);
%varAvg = varAvg(1:2000);
%varStd = varStd(1:2000);
[ sampleFreq, fundSampleFreq, powerSpectrum ] = ensemble_variable_FFT( steps, varAvg );
if strcmp(plotFFT, 'off') == 0
    cd(outputDir);
    plot_variable_FFT(sampleFreq, fundSampleFreq, powerSpectrum, selectedVar, parNames, parVars, parVals, plotFFT);
    cd(cwd);
end

if strcmp(plotFit, 'real') == 1
    time = steps/200*2.17*10^(-12)*10^9; %convert to ns
else
    time = steps/200; %LJ dimensionless
end
[tauAvg, tauStd, expFitLine, tPeaks, varPeaks, varPeakStds, expRSquare, expAdjRSquare, expRMSE ] = ensemble_variable_fit( time, varAvg, varStd, fundSampleFreq );
if strcmp(plotFit, 'off') == 0
    cd(outputDir);
    plot_variable_fit(time, varAvg, tPeaks, varPeaks, varPeakStds, expFitLine, selectedVar, parNames, parVars, parVals, plotFit);
    cd(cwd);
end


end