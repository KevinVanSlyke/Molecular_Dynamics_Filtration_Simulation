function [parNames,parVars,parVals,dataLabels,phiStatData] = Phi_vel_SL_mean_trends(ensembleDir, figDir, stats) %, parVar, parCol)
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
                shift = parVals(n,k);
            end
        end
        if dVal == 1
            countI = 0;
            uI = 0;
            vI = 0;
        end
        if stats == 1
            [regionLabels, phiAValues, phiIValues] = Phi_vel_SL_vs_time(rootList(i).name,x,y,t,countMeanA,uMeanA,vMeanA,countMeanI,uMeanI,vMeanI,figDir);
        elseif stats == 0
            [regionLabels, phiAValues, phiIValues] = Phi_vel_SL_vs_time(rootList(i).name,x,y,t,countA,uA,vA,countI,uI,vI,figDir);
        end
        tStart = 1000;
%         tEnd = 6000;
%         tStart = 1;
        tEnd = max(size(t));
        [dataLabels, phiStatData(n,:)] = Phi_vel_SL_mean(phiAValues, phiIValues, shift, dVal, tStart, tEnd);
%         [fullPhi(n,:),earlyPhi(n,:),dataLabels] = mean_flow_angle(phiAValues,phiIValues,regionLabels, separation, dVal, 20, 200);
    end
end
% fullPhi = sortrows(fullPhi);
% earlyPhi = sortrows(earlyPhi);
cd(ensembleDir);
% [SL1AFitCurve,SL1AFitGoodness,SL1IFitCurve,SL1IFitGoodness] = Phi_vel_SL_mean_trends_plot(phiStatData,dataLabels,parVar,parCol,figDir);
% save('Phi_Vel_Mean_Data.mat', 'parNames', 'parVars', 'parVals', 'dataLabels', 'phiStatData', 'tStart', 'tEnd','SL1AFitCurve','SL1AFitGoodness','SL1IFitCurve','SL1IFitGoodness');
save('Phi_Vel_Mean_Data.mat', 'parNames', 'parVars', 'parVals', 'dataLabels', 'phiStatData', 'tStart', 'tEnd');

% cd(figDir);
% [SL1AFitCurve,SL1AFitGoodness,SL1IFitCurve,SL1IFitGoodness] = Phi_vel_SL_mean_trends_plot(phiStatData,dataLabels,parVar,parCol,figDir);
% save('Phi_Vel_Mean_Data.mat', 'parNames', 'parVars', 'parVals', 'dataLabels', 'phiStatData', 'tStart', 'tEnd','SL1AFitCurve','SL1AFitGoodness','SL1IFitCurve','SL1IFitGoodness');

% 
end
