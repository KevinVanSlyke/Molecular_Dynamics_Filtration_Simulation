function [tauAvgs,tauStds,W,D,H] = registry_shift_script(simStrings, ensembleData)
% [tauAvg, tauStd,W,D,H] = analyze_loaded_registry_ensemble_variable(ensembleAvgVals, ensembleStdVals, selectedVar, outputDir, plotFit, plotFFT);
plotFit = 'LJ';
plotFFT = 'LJ';
outputDir = 'E:\Data\Molecular_Dynamics_Data\Pending\DualLayer_MonoOrifice_Flow_Probes_03_2018\Registry_Shift\Figures_New';
vars = {'v_frontSlicePress','v_midSlicePress','v_rearSlicePress'};
for i = 1:1:size(ensembleData,1)
    [tauAvgs(i), tauStds(i),W(i),D(i),H(i)] = analyze_loaded_registry_ensemble_variable(simStrings{i,1}, ensembleData{1,1}(:,1), vars{1}, outputDir, plotFit, plotFFT);
end
% fixedVar = 'D';
% tau_parameter_fit( parList, tau_est, tau_std, outputDir, fixedVar, fixedVal, variedVar );