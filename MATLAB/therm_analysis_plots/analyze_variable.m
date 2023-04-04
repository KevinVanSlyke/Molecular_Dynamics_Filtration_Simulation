function [tauAvg, tauStd, ensembleAvgVals, ensembleStdVals, varNames] = analyze_variable(trialsDir, selectedVar, outputDir, plotFit, plotFFT)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here

[varNames, ensembleData] = read_therm_log(trialsDir);
[parNames, parVars, parVals] = ensemble_parameters(trialsDir);
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
cd(outputDir);
save(strcat(parString,'_stat_data.mat'));
% cd(trialsDir);
[steps, ~] = select_thermo_var(varNames, ensembleAvgVals, ensembleStdVals, 'Step');
% cutIndex = size(steps,1)/2;
% time = steps(1:cutIndex)/200;
time = steps/200;
clear steps
[varAvg, varStd] = select_thermo_var(varNames, ensembleAvgVals, ensembleStdVals, selectedVar);

rawPlots = 0;
if rawPlots == 1
    %Make this extensible
    [varTitle, varSym] = format_variable_name(selectedVar);
    titleString = strcat(varTitle, " adjoining Filter with ");
    for i = 1 : 1 : size(parVars,2)
    %     titleString = strcat(titleString, parNames(1,i), " ", parVars(1,i), "=", num2str(parVals(1,i)), "r*");
        titleString = strcat(titleString, " ", parVars(1,i), "=", num2str(parVals(1,i)), "r*");
        if i < size(parNames,2)
            titleString = strcat(titleString, ", ");
        end
    end

    rawFig = figure('Visible','on');
    ax = axes('Visible','off');
    plot(time, varAvg, '.');
    hold on;
    title(titleString, 'Interpreter', 'LaTex', 'FontSize', 8 );
    ylabel(strcat(varTitle, ', $', varSym,'~(P^*)$'),'Interpreter','Latex');
    %legend("Data", "Exp. Decay Fit");
    legend("Mean", "Std. Dev.", "Exponential Fit",'Interpreter','Latex');
    %axis([0 max(t) 0.9*min(P) 1.1*max(P)]);
    axis([0 max(time) 0.9*min(varAvg) 1.1*max(varAvg)]);
    if strcmp(plotFit, 'LJ') == 1
        xlabel("Time, $t~(t^*)$",'Interpreter','Latex');
    elseif strcmp(plotFit, 'real') == 1
        xlabel("Time, $t~(ns)$",'Interpreter','Latex');
    end 
    cd(outputDir);
    print(strcat(varTitle,"_vs_Time_",parString,"_",plotFit), '-dpng');
    savefig(rawFig, strcat(varTitle,"_vs_Time_",parString,"_",plotFit,".fig"));
    close(rawFig);
    cd(trialsDir);
end
% varAvg = varAvg(1:cutIndex);
% varStd = varStd(1:cutIndex);
[ sampleFreq, fundSampleFreq, powerSpectrum ] = ensemble_variable_FFT( time, varAvg );
if strcmp(plotFFT, 'off') == 0
    cd(outputDir);
    plot_variable_FFT(sampleFreq, fundSampleFreq, powerSpectrum, selectedVar, parNames, parVars, parVals, plotFFT);
    cd(trialsDir);
end

[ tauAvg, tauStd, bestFitCurve, bestFitGoodness, expShiftFitCurve, expShiftFitGoodness, tPeaks, varPeaks, varPeakStds ] = ensemble_variable_fit( time, varAvg, varStd, fundSampleFreq );
if strcmp(plotFit, 'off') == 0
    cd(outputDir);
%     plot_variable_fit(time, varAvg, tPeaks, varPeaks, varPeakStds, expShiftFitCurve, selectedVar, parNames, parVars, parVals, plotFit);
    plot_variable_fit(time, varAvg, tPeaks, varPeaks, varPeakStds, bestFitCurve, selectedVar, parNames, parVars, parVals, plotFit);
    cd(trialsDir);
end

end