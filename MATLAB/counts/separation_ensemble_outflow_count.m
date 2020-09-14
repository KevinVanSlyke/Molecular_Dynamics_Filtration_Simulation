function [outFlowAngleLabels,outFlowAngleData] = separation_ensemble_outflow_count(ensembleDir, figDir)
% rootDir = 'E:\Data\Molecular_Dynamics_Data\Focused_Mesh_07_2020\Assymetric_Dual_Layer_Periodic_Ensemble';
% rootDir = pwd;
rootDir = ensembleDir;
rootList = dir(rootDir);
n=0;
for i=1:1:size(rootList,1)
    fileDir = fullfile(rootList(i).folder,rootList(i).name);
    if not(startsWith(rootList(i).name,'.')) && isfolder(fileDir) && not(startsWith(rootList(i).name,'Figures')) && not(endsWith(rootList(i).name,'.mat'))
        n = n + 1;
        cd(fileDir);
        fileList = dir(pwd);
        for j=1:1:size(fileList,1)
            if endsWith(fileList(j).name,'.mat') && startsWith(fileList(j).name,'Mesh')
                load(fileList(j).name);
                break;
            end
        end
        [parNames, parVars, parVals] = ensemble_parameters(rootList(i).name);
        for k=1:1:size(parVars,2)
            if strcmp(parVars(k),'D')
                dVal = parVals(k);
                break;
            end
        end
        if dVal == 1
            countI = 0;
        end
        [orificeIndices] = get_orifice_indices(countA);
        [argonEdgeCounts,impurityEdgeCounts] = get_particle_count_distance(countA, countI);
        [lowTheta,upTheta,centeredX,centeredY] = get_angles_centeredEdges(orificeIndices, x, y);
        sliceIndx = 3;
%         if size(lowTheta,1) < 5
%             sliceIndx = 3;
%         else
%             sliceIndx = 5;
%         end
        [outFlowAngleLabels,outFlowAngleData(n,:)] = plot_edge_count_grid(rootList(i).name,argonEdgeCounts,impurityEdgeCounts,lowTheta,upTheta,centeredX,centeredY,sliceIndx,figDir,parVals(4),parVals(2),0);
    end
    
end

end