function [parNames, parVars, parVals, tauAvg, tauStd] = analyze_array_ensemble_variable(trialsDir, selectedVar, outputDir, plotFit, plotFFT)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
cwd = pwd;

[parNames, parVars, parVals] = ensemble_parameters(trialsDir);
[parString] = catenate_parameters(parVars,parVals);
[varNames, ensembleData] = collate_array_ensemble_data(trialsDir, parString);

[ensembleAvgVals, ensembleStdVals] = ensemble_thermo_stats(ensembleData);

cd(outputDir);
clear ensembleData;
save(strcat(parString,'_stats_data.mat'));
cd(cwd);

[steps, ~] = select_thermo_var(varNames, ensembleAvgVals, ensembleStdVals, 'Step');
[varAvg, varStd] = select_thermo_var(varNames, ensembleAvgVals, ensembleStdVals, selectedVar);


[ sampleFreq, fundSampleFreq, powerSpectrum ] = ensemble_variable_FFT( steps, varAvg );
if strcmp(plotFFT, 'off') == 0
    cd(outputDir);
    plot_variable_FFT(sampleFreq, fundSampleFreq, powerSpectrum, selectedVar, parNames, parVars, parVals, plotFFT);
    cd(cwd);
end

plot_variable(steps, varAvg, selectedVar, parNames, parVars, parVals, plotFit);

[ tauAvg, tauStd, expFitLine, tPeaks, varPeaks, varPeakStds, expRSquare, expAdjRSquare, expRMSE ] = ensemble_variable_fit( steps, varAvg, varStd, fundSampleFreq );
if strcmp(plotFit, 'off') == 0
    cd(outputDir);
    plot_variable_fit(steps, varAvg, tPeaks, varPeaks, varPeakStds, expFitLine, selectedVar, parNames, parVars, parVals, plotFit);
    cd(cwd);
end

end