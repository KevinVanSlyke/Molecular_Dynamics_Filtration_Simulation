function [tauAvg, tauStd] = analyze_variable(trialsDir, selectedVar, outputDir, plotFit, plotFFT)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
cwd = pwd;

[varNames, ensembleData] = collate_ensemble_data(trialsDir);

[ensembleAvgVals, ensembleStdVals] = ensemble_thermo_stats(ensembleData);
cd(outputDir);
save(strcat(parString,'_stat_data.mat'));
cd(cwd);
[steps, ~] = select_thermo_var(varNames, ensembleAvgVals, ensembleStdVals, 'Step');
time = steps/200;
[varAvg, varStd] = select_thermo_var(varNames, ensembleAvgVals, ensembleStdVals, selectedVar);

[parNames, parVars, parVals] = ensemble_parameters(trialsDir);
[parString] = catenate_parameters(parVars,parVals);

[ sampleFreq, fundSampleFreq, powerSpectrum ] = ensemble_variable_FFT( time, varAvg );
if strcmp(plotFFT, 'off') == 0
    cd(outputDir);
    plot_variable_FFT(sampleFreq, fundSampleFreq, powerSpectrum, selectedVar, parNames, parVars, parVals, plotFFT);
    cd(cwd);
end
%fundSampleFreq = 0.005;
[ tauAvg, tauStd, expFitLine, tPeaks, varPeaks, varPeakStds, expRSquare, expAdjRSquare, expRMSE ] = ensemble_variable_fit( time, varAvg, varStd, fundSampleFreq );
if strcmp(plotFit, 'off') == 0
    cd(outputDir);
    plot_variable_fit(time, varAvg, tPeaks, varPeaks, varPeakStds, expFitLine, selectedVar, parNames, parVars, parVals, plotFit);
    cd(cwd);
end

end