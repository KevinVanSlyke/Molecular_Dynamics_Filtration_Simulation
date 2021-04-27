function [tauAvg, tauStd] = analyze_ensemble_variable(selectedVar, outputDir, plotFit, plotFFT)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
cwd = pwd;

[varNames, ensembleData] = collate_ensemble_data(trialsDir);

[ensembleAvgVals, ensembleStdVals] = ensemble_thermo_stats(ensembleData);

[parNames, parVars, parVals] = ensemble_parameters(trialsDir);
[parString] = catenate_parameters(parVars,parVals);

cd(outputDir);
clear ensembleData;
save(strcat(parString,'_stats_data.mat'));
cd(cwd);

[steps, ~] = select_thermo_var(varNames, ensembleAvgVals, ensembleStdVals, 'Step');

[varAvg, varStd] = select_thermo_var(varNames, ensembleAvgVals, ensembleStdVals, selectedVar);
steps = steps(1:5000);
varAvg = varAvg(1:5000);
varStd = varStd(1:5000);
[ sampleFreq, fundSampleFreq, powerSpectrum ] = ensemble_variable_FFT( steps, varAvg );
if strcmp(plotFFT, 'off') == 0
    cd(outputDir);
    plot_variable_FFT(sampleFreq, fundSampleFreq, powerSpectrum, selectedVar, parNames, parVars, parVals, plotFFT);
    cd(cwd);
end

if strcmp(plotFit, 'LJ') == 1
    time = steps/200; %LJ dimensionless, 0.005*t^*=step, 0.005 t^*/step=1, N*step*(0.005*t^*/step) = N*0.005*t^*
elseif strcmp(plotFit, 'real') == 1
    time = steps/200*2.17*10^(-12)*10^9; %convert to ns with t^* = 2.17*10^(-12)s
end
[tauAvg, tauStd, expFitLine, tPeaks, varPeaks, varPeakStds, expRSquare, expAdjRSquare, expRMSE ] = ensemble_variable_fit( time, varAvg, varStd, fundSampleFreq );
if strcmp(plotFit, 'off') == 0
    cd(outputDir);
    plot_variable_fit(time, varAvg, tPeaks, varPeaks, varPeakStds, expFitLine, selectedVar, parNames, parVars, parVals, plotFit);
    cd(cwd);
end


end