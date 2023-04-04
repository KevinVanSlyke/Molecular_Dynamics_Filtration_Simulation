function [] = collate_Na_Ni_Vcm_mesh_Na_Ni_therm()%ensembleDir, figDir, doPlot)
%[outFlowAngleLabels,sortedOutFlowAngleData] = separation_ensemble_outflow_count(ensembleDir, figDir, doPlot)
%Given mesh data, calculate outflow count by distance and angle, optionally plot histograms
%   Inputs are directory of simulation ensemble, directory to save figures,
%   and a boolean flag for if plots should be performed. Output is label of
%   data sets and sorted outflow angles. Looping through ensemble directory
%   we perform analysis counting the number of particles some distance from
%   the far filter edge. Optionally plot histograms and gaussian fit of the
%   aforementioned data.

% ensembleDir = 'E:\Data\Molecular_Dynamics_Data\FL1SL2O\DualLayer_MonoOrifice_Hopper_07_2020\Assymetric_DualLayer_Hopper_Ensemble';
% figDir = 'E:\Data\Molecular_Dynamics_Data\FL1SL2O\DualLayer_MonoOrifice_Hopper_07_2020\Assymetric_DualLayer_Hopper_Ensemble\Figures_FL1SL2O_Na_Ni_Vcm_5D_Varied_H';
ensembleDir = 'E:\Data\Molecular_Dynamics_Data\FL1SL2O\DualLayer_MonoOrifice_Hopper_07_2020\Reflective_Y_DualLayer_Hopper_Ensemble';
figDir = 'E:\Data\Molecular_Dynamics_Data\FL1SL2O\DualLayer_MonoOrifice_Hopper_07_2020\Reflective_Y_DualLayer_Hopper_Ensemble\Figures_Mesh';
% selectedVars = {'v_hopperArgonCount','v_hopperArgonCount'};
    
t1 = 21;
t2 = 201;
t3 = 2001;
% varList = {'Step'; 'TotEng'; 'KinEng'; 'PotEng'; 'c_gasTemp'; 'Press'; 'v_hopperPress'; 'c_hopperVx'; 'v_hopperArgonCount'; 'v_hopperImpurityCount'; 'v_interLayerPress'; 'c_interLayerVx'; 'v_interLayerArgonCount'; 'v_interLayerImpurityCount'};

% debug = 0;
% if debug == 1
%     % rootDir = 'E:\Data\Molecular_Dynamics_Data\Focused_Mesh_07_2020\Assymetric_Dual_Layer_Periodic_Ensemble';
%     rootDir = pwd;
% end

ensembleDirList = dir(fullfile(ensembleDir));
nEnsembleDirs = size(ensembleDirList,1);
nEnsemble = 0;
for n = 1 : 1 : nEnsembleDirs
    if (ensembleDirList(n).isdir() && not(strcmp(ensembleDirList(n).name(),'.')) && not(strcmp(ensembleDirList(n).name(),'..')) && not(startsWith(ensembleDirList(n).name(),'Figures')))
        nEnsemble = nEnsemble+1;
        cd(fullfile(ensembleDirList(n).folder, ensembleDirList(n).name));
        fileList = dir(pwd);
        for j=1:1:size(fileList,1) %Load the collated mesh data .mat file
            if endsWith(fileList(j).name,'.mat') && startsWith(fileList(j).name,'Mesh')
                load(fileList(j).name);
                break;
            end
        end
        [parNames, parVars, parVals] = ensemble_parameters(fileList(j).name); %Get parameter info
        for k=1:1:size(parVars,2)
            if strcmp(parVars(k),'D')
                dVal = parVals(k);
                break;
            end
        end
        if dVal > 1 %Make impurity count 0 if no impurity
            simString =ensembleDirList(n).name();
            [varNames, ensembleAvgVals, ensembleStdVals] = therm_variable(fullfile(ensembleDirList(n).folder, ensembleDirList(n).name));
%             plot_histogram_quiver_therm(simString,t,x,y,uA,vA,countA,uI,vI,countI,varNames, ensembleAvgVals, ensembleStdVals, figDir);
            plot_histogram_quiver_therm_full_panels(simString,t,x,y,uA,vA,countA,uI,vI,countI,varNames, ensembleAvgVals, ensembleStdVals, figDir);
    
        end
    end
end