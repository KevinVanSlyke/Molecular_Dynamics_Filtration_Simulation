function [outFlowAngleLabels,sortedOutFlowAngleData] = separation_ensemble_outflow_count(ensembleDir, figDir, doPlot)
%[outFlowAngleLabels,sortedOutFlowAngleData] = separation_ensemble_outflow_count(ensembleDir, figDir, doPlot)
%Given mesh data, calculate outflow count by distance and angle, optionally plot histograms
%   Inputs are directory of simulation ensemble, directory to save figures,
%   and a boolean flag for if plots should be performed. Output is label of
%   data sets and sorted outflow angles. Looping through ensemble directory
%   we perform analysis counting the number of particles some distance from
%   the far filter edge. Optionally plot histograms and gaussian fit of the
%   aforementioned data.

debug = 0;

rootDir = ensembleDir;

if debug == 1
    % rootDir = 'E:\Data\Molecular_Dynamics_Data\Focused_Mesh_07_2020\Assymetric_Dual_Layer_Periodic_Ensemble';
    rootDir = pwd;
end

rootList = dir(rootDir);
n=0;
for i=1:1:size(rootList,1) %Loop through folders in root directory
    fileDir = fullfile(rootList(i).folder,rootList(i).name);
    if not(startsWith(rootList(i).name,'.')) && isfolder(fileDir) && not(startsWith(rootList(i).name,'Figures')) && not(endsWith(rootList(i).name,'.mat'))
        n = n + 1;
        cd(fileDir);
        fileList = dir(pwd);
        for j=1:1:size(fileList,1) %Load the collated mesh data .mat file
            if endsWith(fileList(j).name,'.mat') && startsWith(fileList(j).name,'Mesh')
                load(fileList(j).name);
                break;
            end
        end
        [parNames, parVars, parVals] = ensemble_parameters(rootList(i).name); %Get parameter info
        for k=1:1:size(parVars,2)
            if strcmp(parVars(k),'D')
                dVal = parVals(k);
                break;
            end
        end
        if dVal == 1 %Make impurity count 0 if no impurity
            countI = 0;
        end
        [orificeIndices] = get_orifice_indices(countA); %Calculate orifice indices
        [argonEdgeCounts,impurityEdgeCounts] = get_particle_count_distance(countA, countI); %Cut mesh data to just edge data
        [lowTheta,upTheta,centeredX,centeredY] = get_angles_centeredEdges(orificeIndices, x, y); %Get particle angle counts from spatial bins
        
        if size(lowTheta,1) < 5 %Set what distance from second filter to use for plotting
            sliceIndx = 3;
        else
            sliceIndx = 5;
        end
        if debug == 1
            sliceIndx = 3;
        end
        %Plot the histograms and gaussian fits for outflow distance
        %and angle calculated from spatial bins
        [outFlowAngleLabels,outFlowAngleData(n,:)] = plot_edge_count_grid(rootList(i).name,argonEdgeCounts,impurityEdgeCounts,lowTheta,upTheta,centeredX,centeredY,sliceIndx,figDir,parVals(4),parVals(2),doPlot);
    end
    
end
sortedOutFlowAngleData = sortrows(outFlowAngleData,[2 1]); %Sort data series by D and S
end