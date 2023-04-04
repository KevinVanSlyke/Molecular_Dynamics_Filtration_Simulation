function [parNames,parVars,parVals,dataLabels,fullAvgPhi,earlyAvgPhi,regionLabels,phiAValues,phiIValues] = Phi_vel_mean_trends(ensembleDir, figDir, stats)
%Collates outflow angles and internal flow angle calculated from mean
%velocity components.
%   Iterates over simulation folders to calculate the flow angle in various
%   regions.

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
            if stats == 0 && endsWith(fileList(j).name,'.mat') && (startsWith(fileList(j).name,'Mesh_Raw') || startsWith(fileList(j).name,'Mesh_Data'))
                load(fileList(j).name);
                break;
            elseif stats == 1 && endsWith(fileList(j).name,'.mat') && startsWith(fileList(j).name,'Mesh_Stat')
                load(fileList(j).name);
                break;
            end
        end
        [parNames, parVars, parVals(n,:)] = ensemble_parameters(rootList(i).name);
        for k=1:1:size(parNames,2)
            if strcmp(parNames(k),'Impurity Diameter')
                dVal = parVals(n,k);
            elseif strcmp(parNames(k),'Orifice Separation')
                separation = parVals(n,k);
            elseif strcmp(parNames(k),'Filter Spacing')
                spacing = parVals(n,k);
            elseif strcmp(parNames(k),'Orifice Offset')
                offset = parVals(n,k);
            end
        end
        if dVal == 1
            countI = 0;
        end
        if stats == 1
            [regionLabels,phiAValues(n,:,:),phiIValues(n,:,:)] = Phi_vel_SL_vs_time(rootList(i).name,x,y,t,countMeanA,uMeanA,vMeanA,countMeanI,uMeanI,vMeanI,figDir);
        elseif stats == 0
            [regionLabels,phiAValues(n,:,:),phiIValues(n,:,:)] = Phi_vel_SL_vs_time(rootList(i).name,x,y,t,countA,uA,vA,countI,uI,vI,figDir);
        end
        [dataLabels,fullAvgPhi(n,:),earlyAvgPhi(n,:)] = mean_flow_angle(phiAValues(n,:,:),phiIValues(n,:,:),regionLabels, spacing, dVal, 20, 200);
%         [fullPhi(n,:),earlyPhi(n,:),dataLabels] = mean_flow_angle(phiAValues,phiIValues,regionLabels, separation, dVal, 20, 200);
    end
end
% fullPhi = sortrows(fullPhi);
% earlyPhi = sortrows(earlyPhi);
cd(ensembleDir);
if stats == 1
    save('Phi_Vel_Mean_Data.mat','parNames','parVars','parVals','dataLabels','fullAvgPhi','earlyAvgPhi','regionLabels','phiAValues','phiIValues');
elseif stats == 0
    save('Phi_Vel_Data.mat','parNames','parVars','parVals','dataLabels','fullAvgPhi','earlyAvgPhi','regionLabels','phiAValues','phiIValues');
end
end
