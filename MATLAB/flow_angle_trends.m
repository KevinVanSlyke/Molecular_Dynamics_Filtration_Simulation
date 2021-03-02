function [fullMeanPhi,earlyMeanPhi,dataLabels ] = flow_angle_trends(ensembleDir, figDir)
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
            if endsWith(fileList(j).name,'.mat') && startsWith(fileList(j).name,'Mesh')
                load(fileList(j).name);
                break;
            end
        end
        [parNames, parVars, parVals] = ensemble_parameters(rootList(i).name);
        separation = parVals(4);
        for k=1:1:size(parVars,2)
            if strcmp(parVars(k),'D')
                dVal = parVals(k);
                break;
            end
        end
        if dVal == 1
            countI = 0;
        end
        
        [phiAValues,phiIValues,regionLabels] = flow_angle_from_vel(rootList(i).name,x,y,t,countA,uA,vA,countI,uI,vI,figDir);
        [fullMeanPhi(n,:),earlyMeanPhi(n,:),dataLabels] = mean_flow_angle(phiAValues,phiIValues,regionLabels, separation, dVal, 20, 200);
    end
    
end
cd(ensembleDir);
save('Phi_Data.mat','fullMeanPhi','earlyMeanPhi','dataLabels');
end

