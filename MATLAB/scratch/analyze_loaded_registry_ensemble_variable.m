function [tauAvg, tauStd,W,D,H] = analyze_loaded_registry_ensemble_variable(parString, steps, varAvg, selectedVar, outputDir, plotFit, plotFFT)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
cwd = pwd;
varStd = 
simPars = strsplit(parString, '_');
nPars = size(simPars,2);
%Format is assumed to be W -> D -> L -> F -> S -> H
for i = 1 : 1 : nPars
    nChar = size(simPars{1,i},2);
    parVals(i) = str2double(simPars{1,i}(1,1:nChar-1));
    parVars(i) = convertCharsToStrings(simPars{1,i}(1,nChar));
    if parVars(i) == 'W'
        parNames(i) = "Orifice Width";
        W = parVals(i);
    elseif parVars(i) == 'D'
        parNames(i) = "Impurity Diameter";
        D = parVals(i);
    elseif parVars(i) == 'L'
        parNames(i) = "Filter Thickness";
    elseif parVars(i) == 'S'
        parNames(i) = "Orifice Separation";
    elseif parVars(i) == 'F'
        parNames(i) = "Filter Spacing"; 
    elseif parVars(i) == 'H'
        parNames(i) = "Orifice Offset";
        H = parVals(i);
    end
end

%steps = steps(1:2000);
%varAvg = varAvg(1:2000);
%varStd = varStd(1:2000);
[ sampleFreq, fundSampleFreq, normSpectrum ] = ensemble_variable_FFT( steps, varAvg );
if strcmp(plotFFT, 'off') == 0
    cd(outputDir);
    plot_variable_FFT(sampleFreq, fundSampleFreq, normSpectrum, selectedVar, parNames, parVars, parVals, plotFFT);
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
