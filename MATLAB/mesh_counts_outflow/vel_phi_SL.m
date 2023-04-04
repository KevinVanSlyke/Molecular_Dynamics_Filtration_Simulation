function [regionLabels,phiAValues,phiIValues] = vel_phi_SL(simString,x,y,t,countA,uA,vA,countI,uI,vI,figDir)
%[phiAValues,phiIValues,regionLabels] =
%outflow_angle_from_vel(simString,x,y,t,countA,uA,vA,countI,uI,vI,figDir)
%Returns and potentially plots angle of outflow from each orifice from
%inputs of count and velocity component mesh
%   Inputs are simulation ID string, x/y mesh, timesteps, argon
%   count/x-vel/y-vel, impurity count/x-vel/y-vel, figure save directory.
%   Outputs are data series of argon/impurity orifice outflow angle from horizontal and
%   labels of spatially averaged regions. For regions above and below each
%   orifice extending to relevant midway points we calculate mean outflow
%   angle from spatially (optionally temporally) averaged velocity
%   components via arctan.

debug = 0;
if debug == 1
    figDir = pwd;
end
% figType = 'png';
figType = 'all';
nCells = size(x,1);

if debug == 1
    tCut = 1000;
else %TODO: needs adjustment
    %         tCut = size(t,1)/5;
    tCut = max(size(t));
end

[orificeIndices] = get_orifice_indices(countA); %Calculate orifice indices
nOrifice = size(orificeIndices,3);
if nOrifice == 3
    nWidth = orificeIndices(2,2,1)-orificeIndices(1,2,1)+1; %Width of orifice
    nSpacing = orificeIndices(1,2,3)-orificeIndices(2,2,2)-1; %Spacing of same layer orifices
    nSeparation = orificeIndices(2,1,1)-orificeIndices(1,1,2)+1; %Separation distance of layers
    %nShift = ... %Registry shift of layer 2
end
if nOrifice == 4
    nWidth = orificeIndices(2,2,1)-orificeIndices(1,2,1)+1; %Width of orifice
    nSpacing = orificeIndices(1,2,2)-orificeIndices(2,2,1)-1; %Spacing of same layer orifices
    nSeparation = orificeIndices(1,1,3)-orificeIndices(2,1,1)-1; %Separation distance of layers
    %nShift = ... %Registry shift of layer 2
end

nRegions = 2;
regionLabels = {'SL[1]','SL[2]'};
phiRegions = zeros(2,2,2);
phiRegions(:,:,1) = [orificeIndices(2,1,3)+1, 1; nCells, orificeIndices(2,2,3)+nSpacing/2];
phiRegions(:,:,2) = [orificeIndices(2,1,4)+1, orificeIndices(1,2,4)-nSpacing/2; nCells, nCells];

%Convert orifice indices to indices of regions in which to calculate
%average outflow angle, define labels accordingly


sumCountI = sum(countI,'all');
for i = 1:1:nRegions
    %     uAValues(i,1,:) = mean(countA(phiRegions(1,1,i):phiRegions(2,1,i),phiRegions(1,2,i):phiRegions(2,2,i),:).*uA(phiRegions(1,1,i):phiRegions(2,1,i),phiRegions(1,2,i):phiRegions(2,2,i),:), [1, 2]);
    %     vAValues(i,1,:) = mean(countA(phiRegions(1,1,i):phiRegions(2,1,i),phiRegions(1,2,i):phiRegions(2,2,i),:).*vA(phiRegions(1,1,i):phiRegions(2,1,i),phiRegions(1,2,i):phiRegions(2,2,i),:), [1, 2]);
    uAValues(i,1,:) = mean(uA(phiRegions(1,1,i):phiRegions(2,1,i),phiRegions(1,2,i):phiRegions(2,2,i),:), [1, 2]);
    vAValues(i,1,:) = mean(vA(phiRegions(1,1,i):phiRegions(2,1,i),phiRegions(1,2,i):phiRegions(2,2,i),:), [1, 2]);
    if sumCountI ~= 0 %Skip averaging impurity velocity if impurity count is empty
        %         uIValues(i,1,:) = mean(countI(phiRegions(1,1,i):phiRegions(2,1,i),phiRegions(1,2,i):phiRegions(2,2,i),:).*uI(phiRegions(1,1,i):phiRegions(2,1,i),phiRegions(1,2,i):phiRegions(2,2,i),:), [1, 2]);
        %         vIValues(i,1,:) = mean(countI(phiRegions(1,1,i):phiRegions(2,1,i),phiRegions(1,2,i):phiRegions(2,2,i),:).*vI(phiRegions(1,1,i):phiRegions(2,1,i),phiRegions(1,2,i):phiRegions(2,2,i),:), [1, 2]);
        uIValues(i,1,:) = mean(uI(phiRegions(1,1,i):phiRegions(2,1,i),phiRegions(1,2,i):phiRegions(2,2,i),:), [1, 2]);
        vIValues(i,1,:) = mean(vI(phiRegions(1,1,i):phiRegions(2,1,i),phiRegions(1,2,i):phiRegions(2,2,i),:), [1, 2]);
    end
end
% uAValues = reshape(uAValues,[],2);
% vAValues = reshape(vAValues,[],1);
% uIValues = reshape(uIValues,[],1);
% vIValues = reshape(vIValues,[],1);
t = reshape(t,[],1);
phiAValues = rad2deg(atan(vAValues./uAValues)); %Calculate phi as arctan of y-vel/x-vel converted to degree
phiAValues(isinf(phiAValues)|isnan(phiAValues)) = 0; %Replace NaN values with 0
phiAValues = reshape(phiAValues,nRegions,tCut);
phiAValues = phiAValues';

if sumCountI == 0 %Set impurity outflow angles to zero if no impurity
    phiIValues = NaN(nRegions,tCut);
else
    phiIValues = rad2deg(atan(vIValues./uIValues));
    phiIValues(isinf(phiIValues)|isnan(phiIValues)) = 0;
    phiIValues = reshape(phiIValues,nRegions,tCut);
    phiIValues = phiIValues';
end

%TODO: Make function for calculating phi over sliding/fixed time
%window instead of full series, something like:
%plot(t(tInd-tRange:tInd+tRange),reshape(phiAValues(i,1,tInd-tRange:tInd+tRange),[],1));
%TODO: Make plots extensible instead of hardcoded for specific pairs

% hFig = figure('Visible','on');
% hold on
% if strcmp(plotStyle,'Argon')
%     title('Argon Outflow Angles');
%     for i = 1:1:nRegions
%         plot(t(tInd-tRange:tInd+tRange),reshape(phiAValues(i,1,tInd-tRange:tInd+tRange),[],1));
%     end
%     legend(regionLabels);
%     ylabel('Argon Outflow Angle $\Phi_A~(Deg.)$','Interpreter','latex');
% elseif strcmp(plotStyle,'Impurity')
%     title('Impurity Outflow Angles');
%     for i = 1:1:nRegions
%         plot(t(tInd-tRange:tInd+tRange),reshape(phiAValues(i,1,tInd-tRange:tInd+tRange),[],1));
%     end
%     legend(regionLabels);
%     ylabel('Impurity Outflow Angle $\Phi_I~(Deg.)$','Interpreter','latex');
% end
% xlabel('Time $(t^*)$','Interpreter','latex');
% if saveplots ~= 0
%     set(hFig,'Units','Centimeters','Position',[0 0 8.6 8.6]);
%     set(findall(hFig,'-property','FontSize'),'FontSize',9);
%     exportgraphics(hFig,strcat(fileName,".png"));
%     exportgraphics(hFig,strcat(fileName,".eps"));
%     savefig(hFig,strcat(fileName,".fig"));
% end
% close(hFig);


if figDir ~= 0 %If figure directory exists, save figures in it
    cd(figDir);
    nameTags = {'Argon, SL[1]','Argon, SL[2]','Impurity, SL[1]','Impurity, SL[2]'};
    
    for i = 1:1:nRegions
        hFig = figure('Visible','on'); %Plot argon outflows vs time for single regions
        plot(t,phiAValues);
%         legend(nameTags{1,1:2},'Interpreter','latex');

        if sumCountI ~= 0
            hold on
            plot(t,phiIValues);
        end
        legend(nameTags,'Interpreter','latex');

        ylabel('Outflow Angle, $\Phi~(deg.)$','Interpreter','latex');
%         xlabel('Time $(t^*)$','Interpreter','latex');
        xlabel('$t$','Interpreter','latex');
        set(hFig,'Units','Centimeters','Position',[0 0 8.6 8.6]); %Format figure for PRL
        set(findall(hFig,'-property','FontSize'),'FontSize',9);
        fileName = strcat("Phi_SL_Time_",simString);
        exportgraphics(hFig,strcat(fileName,".png"));
        if strcmp(figType,'all')
            exportgraphics(hFig,strcat(fileName,".eps"));
            savefig(hFig,strcat(fileName,".fig"));
        end
        close(hFig);
    end
end
save(strcat(fileName,'_Data.mat'),'simString','phiAValues','phiIValues','regionLabels');

end

%     for plotFold = 1 %Block to fold plot routines
%         hFig = figure('Visible','off'); %Plot argon outflows vs time from 1 to tCut for Above Lower Left/Right
%         hold on
%         plot(t(1:tCut),phiAValues(4,1:tCut),'b');
%         plot(t(1:tCut),phiAValues(8,1:tCut),'r');
%         legend([regionLabels(4),regionLabels(8)]);
%         ylabel('Argon Outflow Angle $\Phi_A~(Deg.)$','Interpreter','latex');
%         xlabel('Time $(t^*)$','Interpreter','latex');
%         set(hFig,'Units','Centimeters','Position',[0 0 8.6 8.6]);
%         set(findall(hFig,'-property','FontSize'),'FontSize',9);
%         exportgraphics(hFig,strcat('Layer_Middle_Compare','_',simString,".png"));
%         if strcmp(figType,'all')
%             exportgraphics(hFig,strcat('Layer_Middle_Compare','_',simString,".eps"));
%             savefig(hFig,strcat('Layer_Middle_Compare','_',simString,".fig"));
%         end
%         close(hFig);
%         
%         hFig = figure('Visible','off'); %Plot argon outflows vs time from 1 to tCut for Above Lower Left/Right
%         hold on
%         plot(t(1:tCut),phiAValues(3,1:tCut),'b');
%         plot(t(1:tCut),phiAValues(7,1:tCut),'r');
%         legend([regionLabels(3),regionLabels(7)]);
%         ylabel('Argon Outflow Angle $\Phi_A~(Deg.)$','Interpreter','latex');
%         xlabel('Time $(t^*)$','Interpreter','latex');
%         set(hFig,'Units','Centimeters','Position',[0 0 8.6 8.6]);
%         set(findall(hFig,'-property','FontSize'),'FontSize',9);
%         exportgraphics(hFig,strcat('Layer_Boundary_Compare','_',simString,".png"));
%         if strcmp(figType,'all')
%             exportgraphics(hFig,strcat('Layer_Boundary_Compare','_',simString,".eps"));
%             savefig(hFig,strcat('Layer_Boundary_Compare','_',simString,".fig"));
%         end
%         close(hFig);
%         
%         hFig = figure('Visible','off'); %Plot argon outflows vs time from 1 to tCut for 'Below Lower Left' and 'Above Upper Left'
%         hold on
%         plot(t(1:tCut),phiAValues(3,1:tCut),'b');
%         plot(t(1:tCut),phiAValues(4,1:tCut),'r');
%         legend([regionLabels(3),regionLabels(4)]);
%         ylabel('Argon Outflow Angle $\Phi_A~(Deg.)$','Interpreter','latex');
%         xlabel('Time $(t^*)$','Interpreter','latex');
%         set(hFig,'Units','Centimeters','Position',[0 0 8.6 8.6]);
%         set(findall(hFig,'-property','FontSize'),'FontSize',9);
%         exportgraphics(hFig,strcat('Upper_Left_Compare','_',simString,".png"));
%         if strcmp(figType,'all')
%             exportgraphics(hFig,strcat('Upper_Left_Compare','_',simString,".eps"));
%             savefig(hFig,strcat('Upper_Left_Compare','_',simString,".fig"));
%         end
%         close(hFig);
%         
%         hFig = figure('Visible','off'); %Plot argon outflows vs time from 1 to tCut for 'Below Lower Left' and 'Above Upper Left'
%         hold on
%         plot(t(1:tCut),phiAValues(7,1:tCut),'b');
%         plot(t(1:tCut),phiAValues(8,1:tCut),'r');
%         legend([regionLabels(7),regionLabels(8)]);
%         ylabel('Argon Outflow Angle $\Phi_A~(Deg.)$','Interpreter','latex');
%         xlabel('Time $(t^*)$','Interpreter','latex');
%         set(hFig,'Units','Centimeters','Position',[0 0 8.6 8.6]);
%         set(findall(hFig,'-property','FontSize'),'FontSize',9);
%         exportgraphics(hFig,strcat('Upper_Right_Compare','_',simString,".png"));
%         if strcmp(figType,'all')
%             exportgraphics(hFig,strcat('Upper_Right_Compare','_',simString,".eps"));
%             savefig(hFig,strcat('Upper_Right_Compare','_',simString,".fig"));
%         end
%         close(hFig);
%         
%         if sumCountI ~= 0 %If impurities exist plot comparisons with argon and impurity
%             hFig = figure('Visible','off'); %Plot argon and impurity outflows vs time from 1 to tCut for 'Below Lower Right'
%             hold on
%             plot(t(1:tCut),phiAValues(7,1:tCut),'b');
%             plot(t(1:tCut),phiIValues(7,1:tCut),'r');
%             legend([{'Argon Above Upper Right'},{'Impurity Above Upper Right'}]);
%             ylabel('Outflow Angle $\Phi~(Deg.)$','Interpreter','latex');
%             xlabel('Time $(t^*)$','Interpreter','latex');
%             set(hFig,'Units','Centimeters','Position',[0 0 8.6 8.6]);
%             set(findall(hFig,'-property','FontSize'),'FontSize',9);
%             exportgraphics(hFig,strcat('Right_Particle_Compare','_',simString,".png"));
%             if strcmp(figType,'all')
%                 exportgraphics(hFig,strcat('Right_Particle_Compare','_',simString,".eps"));
%                 savefig(hFig,strcat('Right_Particle_Compare','_',simString,".fig"));
%             end
%             close(hFig);
%             
%             hFig = figure('Visible','off'); %Plot argon and impurity outflows vs time from 1 to tCut for 'Below Lower Left'
%             hold on
%             plot(t(1:tCut),phiAValues(3,1:tCut),'b');
%             plot(t(1:tCut),phiIValues(3,1:tCut),'r');
%             legend([{'Argon Above Upper Left'},{'Impurity Above Upper Left'}]);
%             ylabel('Outflow Angle $\Phi~(Deg.)$','Interpreter','latex');
%             xlabel('Time $(t^*)$','Interpreter','latex');
%             set(hFig,'Units','Centimeters','Position',[0 0 8.6 8.6]);
%             set(findall(hFig,'-property','FontSize'),'FontSize',9);
%             exportgraphics(hFig,strcat('Left_Particle_Compare','_',simString,".png"));
%             if strcmp(figType,'all')
%                 exportgraphics(hFig,strcat('Left_Particle_Compare','_',simString,".eps"));
%                 savefig(hFig,strcat('Left_Particle_Compare','_',simString,".fig"));
%             end
%             close(hFig);
%         end
%     end

