function [] = scratch_Hist_only()%ensembleDir, figDir, doPlot)
%[outFlowAngleLabels,sortedOutFlowAngleData] = separation_ensemble_outflow_count(ensembleDir, figDir, doPlot)
%Given mesh data, calculate outflow count by distance and angle, optionally plot histograms
%   Inputs are directory of simulation ensemble, directory to save figures,
%   and a boolean flag for if plots should be performed. Output is label of
%   data sets and sorted outflow angles. Looping through ensemble directory
%   we perform analysis counting the number of particles some distance from
%   the far filter edge. Optionally plot histograms and gaussian fit of the
%   aforementioned data.

doTimeAvg = 1;
tStart = 2001;
tStop = 10001;

doQuiver = 1;

% ensembleDir = 'E:\Data\Molecular_Dynamics_Data\FL1SL2O\DualLayer_MonoOrifice_Hopper_07_2020\Assymetric_DualLayer_Hopper_Ensemble';
% figDir = 'E:\Data\Molecular_Dynamics_Data\FL1SL2O\DualLayer_MonoOrifice_Hopper_07_2020\Assymetric_DualLayer_Hopper_Ensemble';
% fileName = strcat('Na_Ni_Vcm_mesh_hist_3multi_H_FL1SL2O_Periodic');

ensembleDir = 'E:\Molecular_Dynamics_Data\FL1SL2O\DualLayer_MonoOrifice_Hopper_07_2020\Reflective_Y_DualLayer_Hopper_Ensemble';
figDir = 'E:\Molecular_Dynamics_Data\FL1SL2O\DualLayer_MonoOrifice_Hopper_07_2020\Reflective_Y_DualLayer_Hopper_Ensemble';
fileName = strcat('outflow_percents_yRef');

% simList = {'120W_5D_60L_120F_120S'; '120W_5D_60L_120F_120S_60H';'120W_5D_60L_120F_120S_120H';'120W_5D_60L_120F_120S_240H';'120W_5D_60L_120F_120S_480H'};
% hStrings = {'$H=0\sigma$~';'$H=60\sigma$~';'$H=120\sigma$~';'$H=240\sigma$~';'$H=480\sigma$~'};
simList = {'120W_5D_60L_120F_120S';'120W_5D_60L_120F_120S_120H';'120W_5D_60L_120F_120S_480H'};
hStrings = {'$H=0\sigma$~';'$H=120\sigma$~';'$H=480\sigma$~'};

% debug = 0;
% if debug == 1
%     % rootDir = 'E:\Data\Molecular_Dynamics_Data\Focused_Mesh_07_2020\Assymetric_Dual_Layer_Periodic_Ensemble';
%     rootDir = pwd;
% end

hFig =figure('Visible','on');
rootDir = ensembleDir;

for i=1:1:size(simList,1) %Loop through folders in root directory
    theFullFile = fullfile(ensembleDir,simList{i,1});
    cd(theFullFile);
    fileList = dir(pwd);
    for j=1:1:size(fileList,1) %Load the collated mesh data .mat file
        if endsWith(fileList(j).name,'.mat') && startsWith(fileList(j).name,'Mesh')
            load(fileList(j).name);
            break;
        end
    end
    if max(countI(:,:,t3),[],'all') > allMaxCountI
        allMaxCountI = max(countI(:,:,t3),[],'all');
    end
end

for i=1:1:size(simList,1) %Loop through folders in root directory
    theFullFile = fullfile(ensembleDir,simList{i,1});
    cd(theFullFile);
    fileList = dir(pwd);
    for j=1:1:size(fileList,1) %Load the collated mesh data .mat file
        if endsWith(fileList(j).name,'.mat') && startsWith(fileList(j).name,'Mesh')
            load(fileList(j).name);
            break;
        end
    end
    [parNames, parVars, parVals] = ensemble_parameters(simList{i,1}); %Get parameter info
    for k=1:1:size(parVars,2)
        if strcmp(parVars(k),'D')
            dVal = parVals(k);
            break;
        end
    end
    if dVal == 1 %Make impurity count 0 if no impurity
        countI = 0;
        uI = 0;
        vI = 0;
    end
%         cd(figDir);
%     [varNames, ensembleAvgVals, ensembleStdVals] = therm_variable(theFullFile);
%         [nA(i), quiver, therm] = plot_histogram_quiver_therm(simString,t,xActual,yActual,uA,vA,countA,uI,vI,countI,varNames, ensembleAvgVals, ensembleStdVals, figDir);
    orificeWidth = parVals(1);
    impurityDiameter = parVals(2);
    filterDepth = parVals(3);
    filterSeparation = parVals(4);
    orificeSpacing = parVals(5);
    if size(parVars) < 6
        registryShift = 0;
    else
        registryShift = parVals(6);
    end
    
    [orificeIndices] = get_orifice_indices(countA); %Calculate orifice indices
    middleY = orificeIndices(2,2,2)-1+(orificeIndices(1,2,3) - orificeIndices(2,2,2))/2;
    yCentered = y(1,:) - 20*middleY -10;
    for q = 1 : 1 : size(yCentered,2)
        if yCentered(1,q) > 0
            yCenterIndex = q;
            break;
        end
    end
    xCentered = x(1:size(x,1));
%     xCentered = x(orificeIndices(1,1,1)-6:size(x,1));
    binsY = yCentered(1,:);

    sliceIndx = size(x,1);% - 5; %How far from edge of filter do we sum particles
    % edgeSumA = sum(countA(sliceIndx,:,:),3)./(hopperArgon(1)-hopperArgon(size(hopperArgon,1)));
    edgeSumA = sum(countA(sliceIndx,:,:),3)/sum(countA(sliceIndx,:,:),'all')*100;%./(hopperArgon(1)-hopperArgon(size(hopperArgon,1)));
%     edgeSumA = sum(countA(sliceIndx,:,:),3);%./(hopperArgon(1)-hopperArgon(size(hopperArgon,1)));
    argonPower = ceil(log10(max(edgeSumA)-1))-1;
    %     edgeSumI = sum(countI(sliceIndx,:,:),3)./(hopperImpurity(1)-hopperImpurity(size(hopperImpurity)));
    edgeSumI = sum(countI(sliceIndx,:,:),3)/sum(countI(sliceIndx,:,:),'all')*100;%./(hopperImpurity(1)-hopperImpurity(size(hopperImpurity)));
%     edgeSumI = sum(countI(sliceIndx,:,:),3);%./(hopperImpurity(1)-hopperImpurity(size(hopperImpurity)));
    impurityPower = ceil(log10(max(edgeSumI)-1))-1;

% [x, y] = centerMeshAxes(fileDir,x,y);
%     [xActual, yActual] = centerMeshAxes(simString,x,y);

    % [edgeSumA,edgeSumI] = edgeSumCount(t,countA,countI);
    meanA = mean(countA(:,:,tStart:tStop),3);
    countAMinMean =min(meanA,[],'all');
    countAMaxMean =max(meanA,[],'all');
    meanALog = log10(meanA);
    meanALog(isinf(meanALog)|isnan(meanALog)|meanALog<-2) = -1.2;
    countAMinMeanLog =min(meanALog,[],'all');
    countAMaxMeanLog =max(meanALog,[],'all');
    meanI = mean(countI(:,:,tStart:tStop),3);
    countIMinMean = min(meanI,[],'all');
    countIMaxMean = max(meanI,[],'all');
    meanILog = log10(meanI);
    meanILog(isinf(meanILog)|isnan(meanILog)) = -4;
    countIMinMeanLog = min(meanILog,[],'all');
    uAMean = mean(uA(:,:,tStart:tStop),3);
    vAMean = mean(vA(:,:,tStart:tStop),3);
    uIMean = mean(uI(:,:,tStart:tStop),3);
    vIMean = mean(vI(:,:,tStart:tStop),3);    
    uCMmean = (meanA.*uAMean+impurityDiameter^2*meanI.*uIMean)./(meanA+impurityDiameter^2*meanI);
    vCMmean = (meanA.*vAMean+impurityDiameter^2*meanI.*vIMean)./(meanA+impurityDiameter^2*meanI);
    maxMagCMmean = max((uCMmean.^2+vCMmean.^2).^(1/2),[],'all');
%     uNormCMmean = uCMmean./maxMagCMmean;
%     vNormCMmean = vCMmean./maxMagCMmean;  
    
    uCM = (countA.*uA+impurityDiameter^2*countI.*uI)./(countA+impurityDiameter^2*countI);
    vCM = (countA.*vA+impurityDiameter^2*countI.*vI)./(countA+impurityDiameter^2*countI);
    maxMagCM = max((uCM.^2+vCM.^2).^(1/2),[],'all');
    uNormCM = uCM./maxMagCM;
    vNormCM = vCM./maxMagCM;
%     countIMax = max(countI(:,:,t3),[],'all');
    doPhi = 0;
    if doPhi == 1
        uARegions = mean(vNormCM,3);
        uARegions(isinf(uAMean)|isnan(uAMean)) = 0;
        rFL1 = [orificeIndices(2,1,1)+1 orificeIndices(1,1,2) orificeIndices(1,2,2) orificeIndices(2,2,3)];
        rSL1 = [orificeIndices(2,1,2)+1 orificeIndices(2,1,2)+9 orificeIndices(1,2,3)-3 orificeIndices(2,2,3)+5];
        rSL2 = [orificeIndices(2,1,2)+1 orificeIndices(2,1,2)+9 orificeIndices(1,2,2)-5 orificeIndices(2,2,2)+3];
        uFL1A = mean(uAMean(rFL1(1):rFL1(2), rFL1(3):rFL1(4)),'all');
        uSL1A = mean(uAMean(rSL1(1):rSL1(2), rSL1(3):rSL1(4)),'all');
        uSL2A = mean(uAMean(rSL2(1):rSL2(2), rSL2(3):rSL2(4)),'all');
        uFL1I = mean(uIMean(rFL1(1):rFL1(2), rFL1(3):rFL1(4)),'all');
        uSL1I = mean(uIMean(rSL1(1):rSL1(2), rSL1(3):rSL1(4)),'all');
        uSL2I = mean(uIMean(rSL2(1):rSL2(2), rSL2(3):rSL2(4)),'all');
        vFL1A = mean(vAMean(rFL1(1):rFL1(2), rFL1(3):rFL1(4)),'all');
        vSL1A = mean(vAMean(rSL1(1):rSL1(2), rSL1(3):rSL1(4)),'all');
        vSL2A = mean(vAMean(rSL2(1):rSL2(2), rSL2(3):rSL2(4)),'all');
        vFL1I = mean(vIMean(rFL1(1):rFL1(2), rFL1(3):rFL1(4)),'all');
        vSL1I = mean(vIMean(rSL1(1):rSL1(2), rSL1(3):rSL1(4)),'all');
        vSL2I = mean(vIMean(rSL2(1):rSL2(2), rSL2(3):rSL2(4)),'all');
        uNormCMRegions = uNormCM(:,:,t3);
        uNormCMRegions(isinf(uNormCMRegions)|isnan(uNormCMRegions)) = 0;
        uFL1 = mean(uNormCMRegions(10:15, 1:28),'all');
        % uFL1 = mean(uNormCMRegions(10:15, 10:23),'all');
        uSL2 = mean(uNormCMRegions(20:28, 1:14),'all');
        uSL1 = mean(uNormCMRegions(20:28, 15:28),'all');
    end
    nexttile([2 2])
    nTile = 1;
    axA = gca;
    hold on
%     surf(xCentered,yCentered,meanALog');
    surf(xCentered,yCentered,meanA');
%     colormap(parula(10));
    colormap(parula);
%     clim([countAMinMeanLog-0.2 countAMaxMeanLog]);
    clim([0 countAMaxMean]);
    ylim([binsY(2) binsY(size(binsY,2))]);
    xlim([0 xCentered(1,size(xCentered,2)-1)]);
    yticks(-600:120:600);
%     yticklabels('');
    xticks(0:120:1000);
    % hcolorBar = colorbar('Ticks',(-countIMax+0.25:1:0.25),'TickLabels',(0:1:countIMax));
    % hcolorBar = colorbar('Ticks',(-countIMaxMean:1),'TickLabels',(0:1:countIMaxMean+1));
    % hcolorBar = colorbar('Ticks',(-countIMax:1),'TickLabels',(0:1:countIMax+1),'Position',[1.1 0 0.1 0.9]);
%     hcolorBar = colorbar('Ticks',(countIMinMeanLog:-countIMinMeanLog/12:0),'TickLabels',(0:-countIMinMeanLog/12:-countIMinMeanLog));
    if i == size(hStrings,1)
        hcolorBarA = colorbar(axA,'location','southoutside');
%         hcolorBarA = colorbar(axA);
%         ylabel(hcolorBarA, "$\log(\langle N_A \rangle_t)$", 'Interpreter', 'latex','FontSize',9);
        ylabel(hcolorBarA, "$\langle N_A \rangle_t$", 'Interpreter', 'latex','FontSize',9);
%         hcolorBarA.Layout.Tile = 25;
%         hcolorBarA.Layout.TileSpan = [1 2];
        xlim([360 xCentered(1,size(xCentered,2)-1)]);
        xticklabels(string(xticks-360));
    end
    % axis([20 xCentered(1,size(xCentered,2)-1) yLow yUp -logKineticMax 0]);
    title(strcat(hStrings(i), titles((i-1)*4+1)),'Interpreter','Latex')
    
%     yyaxis left
%     ylabel(hStrings(i),'Interpreter','Latex');
    %     yticklabels('');

%     yyaxis right
%     ylabel(strcat(hStrings(i),"\qquad","$y'/\sigma$"),'Interpreter','Latex');
    ylabel("$y'/\sigma$ (Dimensionless)",'Interpreter','Latex');
    
    xlabel("$x'/\sigma$ (Dimensionless)",'Interpreter','Latex');
%     hcolorBar.Layout.Tile = 'east';
    % ylabel("$y$",'Interpreter','Latex');
    view(0,90);
%     yyaxis right

    % xticks(xCentered(1,1):60:xCentered(1,size(xCentered,2)));
    % yticks(yCentered(1,1):60:yCentered(1,size(yCentered,2)));
%     zCut = 1.2;
    % orificeWidth = 120;
    % filterDepth = 60;
    % orificeSpacing = 120;
    % filterSeparation = 120;
    % registryShift = 60;
    if doQuiver == 1
%         quiver3(xCentered'+10, yCentered'+10, zeros(size(xCentered,2),size(xCentered,2))+countAMaxMean, uAMean'*50, vAMean'*50, zeros(size(xCentered,2),size(xCentered,2)), 'AutoScale', 'off', 'Color' ,'k','MaxHeadSize',5);
%         quiver3(xCentered'+10, yCentered'+10, zeros(size(xCentered,2),size(xCentered,2))+countAMaxMean, uAMean'*25, vAMean'*25, zeros(size(xCentered,2),size(xCentered,2)), 'AutoScale', 'off', 'Color' ,'w','MaxHeadSize',5);
        quiver3(xCentered'+10, yCentered'+10, zeros(size(xCentered,2),size(xCentered,2))+countAMaxMean, uAMean'*25, vAMean'*25, zeros(size(xCentered,2),size(xCentered,2)), 'AutoScale', 'off', 'Color' ,'k','MaxHeadSize',5);
    end
    % xLeft = 140;
    xLeft = xCentered(orificeIndices(1,1,1));%*20-20;
    % yLeft = mid-width/2;
    if registryShift == 0
        yLeft = yCentered(orificeIndices(2,1,1))+60;
    elseif registryShift == 60
        yLeft = yCentered(orificeIndices(2,1,1));
    elseif registryShift == 120
        yLeft = yCentered(orificeIndices(2,1,1))-60;
    elseif registryShift == 240
        yLeft = yCentered(orificeIndices(2,1,1))-180;
    elseif registryShift == 480
        yLeft = yCentered(orificeIndices(2,1,1))-420;
    end
    xRight = xCentered(orificeIndices(1,1,3));
    % yRight = yLeft-spacing-width/2;
    % yRight = yCentered(orificeIndices(2,1,2));
    yRight = yCentered(orificeIndices(1,2,2));
    zCut = countAMaxMean;
    patch( [xLeft xLeft xLeft+filterDepth xLeft+filterDepth], [-2000 yLeft yLeft -2000], [zCut zCut zCut zCut], 'w');
    patch( [xLeft xLeft xLeft+filterDepth xLeft+filterDepth], [yLeft+orificeWidth 2000 2000 yLeft+orificeWidth], [zCut zCut zCut zCut], 'w');

    patch( [xRight xRight xRight+filterDepth xRight+filterDepth], [-2000 yRight yRight -2000], [zCut zCut zCut zCut], 'w');
    patch( [xRight xRight xRight+filterDepth xRight+filterDepth], [yRight+orificeWidth yRight+2*orificeWidth yRight+2*orificeWidth yRight+orificeWidth], [zCut zCut zCut zCut], 'w');
    patch( [xRight xRight xRight+filterDepth xRight+filterDepth], [yRight+3*orificeWidth 2000 2000 yRight+3*orificeWidth], [zCut zCut zCut zCut], 'w');
if doPhi == 1
    phiAScale = 0.2;
    xOriginFL = xOriginFL+shiftSL;
    xOriginSL = xOriginSL+shiftSL;
    axLen = 0.1;
    yRight = yCentered(orificeIndices(1,2,2));
    %     text(phiOriginFLx, phiOriginFLy, zCut,'$\Phi_{\mathrm{\textbf{FL, Ar.}}}$','Color',[1 1 1],'Interpreter','latex','FontSize',18,'FontWeight','bold')
    text(phiOriginFLx, phiOriginFLy, zCut,'$\Phi$','Color',[1 1 1],'Interpreter','latex','FontSize',18,'FontWeight','bold')
    text(phiOriginFLx+subShiftX, phiOriginFLy+subShiftY, zCut,'\textbf{FL},Ar.','Color',[ 1 1 1],'Interpreter','latex','FontSize',10,'FontWeight','bold')
    annotation('arrow',[xOriginFL xOriginFL+uFL1A*phiAScale],[yOriginFL1 yOriginFL1+vFL1A*phiAScale],'Color',[1 1 1],'LineWidth',2);
    annotation('line',[xOriginFL xOriginFL+axLen],[yOriginFL1 yOriginFL1],'Color',[1 1 1],'LineWidth',2,'LineStyle','--');
%     text(phiOriginSLx, phiOriginSL1y, zCut, '$\Phi_{\mathrm{\textbf{SL[1], Ar.}}}$','Color',[1 1 1],'Interpreter','latex','FontSize',18,'FontWeight','bold');
    text(phiOriginSLx, phiOriginSL1y, zCut, '$\Phi$','Color',[1 1 1],'Interpreter','latex','FontSize',18,'FontWeight','bold');
    text(phiOriginSLx+subShiftX, phiOriginSL1y+subShiftY, zCut,'\textbf{SL[1]},Ar.','Color',[1 1 1],'Interpreter','latex','FontSize',10,'FontWeight','bold');
    annotation('arrow',[xOriginSL xOriginSL+uSL1A*phiAScale],[yOriginSL1 yOriginSL1+vSL1A*phiAScale],'Color',[1 1 1],'LineWidth',2);
    annotation('line',[xOriginSL xOriginSL+axLen],[yOriginSL1 yOriginSL1],'Color',[1 1 1],'LineWidth',2,'LineStyle','--');
%     text(phiOriginSLx, phiOriginSL2y, zCut,'$\Phi_{\mathrm{\textbf{SL[2], Ar.}}}$','Color',[1 1 1],'Interpreter','latex','FontSize',18,'FontWeight','bold');
    text(phiOriginSLx, phiOriginSL2y, zCut,'$\Phi$','Color',[1 1 1],'Interpreter','latex','FontSize',18,'FontWeight','bold');
    text(phiOriginSLx+subShiftX, phiOriginSL2y-20, zCut,'\textbf{SL[2]},Ar.','Color',[1 1 1],'Interpreter','latex','FontSize',10,'FontWeight','bold');
    annotation('arrow',[xOriginSL xOriginSL+uSL2A*phiAScale],[yOriginSL2 yOriginSL2+vSL2A*phiAScale],'Color',[1 1 1],'LineWidth',2);
    annotation('line',[xOriginSL xOriginSL+axLen],[yOriginSL2 yOriginSL2],'Color',[1 1 1],'LineWidth',2,'LineStyle','--');
end
    
    %     set(axA,'ytick',[0 100 220 340 460 540]);
    % set(axA,'yticklabel',[]);
    %     set(axA,'xtick',[0 120 180 300 360 520]);
    %     set(axA,'xticklabel',[0 120 180 300 360 520]);
    %     xtickangle(45);
    % set(axA,'xtick',[0 60 120 180 240 300 360 420 480 520]);
    % set(axA,'xticklabel',[0 60 120 180 240 300 360 420 480 520]);
    set(axA,'TickDir','out');
    % set(axA,'Units','Centimeters','Position',[20 1 8 8]);
%     set(findall(axA,'-property','FontSize'),'FontSize',9);
%     axis(axA,'square');
    hold off

    nexttile([2 1])
    nTile = nTile + 1;
%     ax1 = gca;
    hold on;
    % barh(binsY,[edgeSumI; edgeSumA],'grouped');
    indx = 1;
    for j = 1:1:size(binsY,2)
        if binsY(j) ~= 0
            binsYHist(indx) = binsY(j);
            indx = indx + 1;
        end
    end
%     barh(binsY,edgeSumA,'grouped','BarWidth',1);
%     [argonLine,argonGood,argonEtc] = fit(binsY',edgeSumA','gauss2','StartPoint',[2*10^4,-120,60,2*10^4,120,60]);    
    barh(binsY+10,edgeSumA,'grouped','BarWidth',1);
    [argonLine,argonGood,argonEtc] = fit(binsY'+10,edgeSumA','gauss2','StartPoint',[2*10^4,-120,60,2*10^4,120,60]);
    xlim([0 6]);

    % fitCoef = coeffvalues(argonLine);
    % mean1=fitCoef(1,2);
    % mean2=fitCoef(1,5);
    % argonAngles = [mean1, mean2];
    % sigma1=fitCoef(1,3);
    % sigma2=fitCoef(1,6);
    % argonStddevs = [sigma1, sigma2];
    % coefConfInt = confint(argonLine);
    
    % plot(argonLine);
    argonCurve = argonLine(binsY);
    plot(argonCurve,binsY,'LineStyle','--','LineWidth',2);
    legend('off');
    xlabel(strcat('$n_A ~(\%)$'),'Interpreter','Latex');
    % ylabel(strcat('$N_A~(10^{',num2str(argonPower),'})$'),'Interpreter','Latex');
    hAx = gca;
%     hAx.XAxis.Exponent = argonPower;
    % ylim([0 27500]);
    % yTic = yticks;
    % yticklabels(yTic/(10^argonPower));
% %     ylabel("$y'/\sigma$ (Dimensionless)",'Interpreter','Latex');
    % xticks(xTic);
    % xlim([yLow*tickSpacing-40 yHigh*tickSpacing+40]);
    title(strcat(hStrings(i), titles((i-1)*4+2)),'Interpreter','Latex')
%     hAx.TitleHorizontalAlignment = 'right';
    ylim([binsY(2) binsY(size(binsY,2))]);
%     ylim([binsY(1) binsY(size(binsY,2))]);
%     yticks(yCentered(1,1):120:yCentered(1,size(yCentered,2)));
    yticks(-600:120:600);
    hold off
   
    
    nexttile([2 2])
    nTile = nTile + 1;
    axI = gca;
    hold on

%     surf(xCentered,yCentered,meanILog');
    surf(xCentered,yCentered,meanI');

    % hcolorBar = colorbar('Ticks',(-countIMax+0.25:1:0.25),'TickLabels',(0:1:countIMax));
    % hcolorBar = colorbar('Ticks',(-countIMaxMean:1),'TickLabels',(0:1:countIMaxMean+1));
    % hcolorBar = colorbar('Ticks',(-countIMax:1),'TickLabels',(0:1:countIMax+1),'Position',[1.1 0 0.1 0.9]);
%     hcolorBar = colorbar('Ticks',(countIMinMeanLog:-countIMinMeanLog/12:0),'TickLabels',(0:-countIMinMeanLog/12:-countIMinMeanLog));
    if doQuiver == 1
%         quiver3(xCentered'+10, yCentered'+10, zeros(size(xCentered,2),size(xCentered,2))+countIMaxMean, uIMean'*50, vIMean'*50, zeros(size(xCentered,2),size(xCentered,2)), 'AutoScale', 'off', 'Color' ,'k');%, 'LineWidth',2);%,'MaxHeadSize',5);
%         quiver3(xCentered'+10, yCentered'+10, zeros(size(xCentered,2),size(xCentered,2))+countIMaxMean, uIMean'*50, vIMean'*50, zeros(size(xCentered,2),size(xCentered,2)), 'AutoScale', 'off', 'Color' ,'w');%, 'LineWidth',2);%,'MaxHeadSize',5);
%         quiver3(xCentered'+10, yCentered'+10, zeros(size(xCentered,2),size(xCentered,2))+countIMaxMean, uIMean'*100, vIMean'*100, zeros(size(xCentered,2),size(xCentered,2)), 'AutoScale', 'off', 'Color' ,'w');%, 'LineWidth',2);%,'MaxHeadSize',5);
        quiver3(xCentered'+10, yCentered'+10, zeros(size(xCentered,2),size(xCentered,2))+countIMaxMean, uIMean'*100, vIMean'*100, zeros(size(xCentered,2),size(xCentered,2)), 'AutoScale', 'off', 'Color' ,'k');%, 'LineWidth',2);%,'MaxHeadSize',5);
    end
    colormap(parula);
%     colormap(parula(20));
    clim([0 countIMaxMean]);
    ylim([binsY(2) binsY(size(binsY,2))]);
    xlim([0 xCentered(1,size(xCentered,2)-1)]);
    yticks(-600:120:600);
    xticks(-600:120:6000);
%     clim([countIMinMeanLog+1 0]);
    if i == size(hStrings,1)
        hcolorBar = colorbar(axI,'location','southoutside');
%         ylabel(hcolorBar, "$\log(\langle N_I \rangle_t)$", 'Interpreter', 'latex','FontSize',9);
        ylabel(hcolorBar, "$\langle N_I \rangle_t$", 'Interpreter', 'latex','FontSize',9);
%         hcolorBar.Layout.Tile = 27;
%         hcolorBar.Layout.TileSpan = [1 2]; 
        xlim([360 xCentered(1,size(xCentered,2)-1)]);
        xticklabels(string(xticks-360));    
    end
    % axis([20 xCentered(1,size(xCentered,2)-1) yLow yUp -logKineticMax 0]);
    title(strcat(hStrings(i), titles((i-1)*4+3)),'Interpreter','Latex')
%     hAx.TitleHorizontalAlignment = 'right';
%     yyaxis left
%     yticklabels('');

%     yyaxis right
    xlabel("$x'/\sigma$ (Dimensionless)",'Interpreter','Latex');
    % hcolorBar.Layout.Tile = 'west';
    ylabel("$y'/\sigma$ (Dimensionless)",'Interpreter','Latex');
    view(0,90);

    % xticks(xCentered(1,1):60:xCentered(1,size(xCentered,2)));
    % yticks(yCentered(1,1):60:yCentered(1,size(yCentered,2)));
    zCut = countIMaxMean;  
    patch( [xLeft xLeft xLeft+filterDepth xLeft+filterDepth], [-2000 yLeft yLeft -2000], [zCut zCut zCut zCut], 'w');
    patch( [xLeft xLeft xLeft+filterDepth xLeft+filterDepth], [yLeft+orificeWidth 2000 2000 yLeft+orificeWidth], [zCut zCut zCut zCut], 'w');
    patch( [xRight xRight xRight+filterDepth xRight+filterDepth], [-2000 yRight yRight -2000], [zCut zCut zCut zCut], 'w');
    patch( [xRight xRight xRight+filterDepth xRight+filterDepth], [yRight+orificeWidth yRight+2*orificeWidth yRight+2*orificeWidth yRight+orificeWidth], [zCut zCut zCut zCut], 'w');
    patch( [xRight xRight xRight+filterDepth xRight+filterDepth], [yRight+3*orificeWidth 2000 2000 yRight+3*orificeWidth], [zCut zCut zCut zCut], 'w');
    if doPhi == 1
        shiftSL = 0.5;
        subShiftX = 35;
        subShiftY = -25;
        phiIScale = 1;
        xOriginFL = 0.1712;
        yOriginFL1 = 0.5;
        xOriginSL = 0.27505;
        yOriginSL1 = 0.6525;    
        yOriginSL2 = 0.35;
        phiOriginFLx = 150;
        phiOriginFLy = -45;
        phiOriginSLx = 330;
        phiOriginSL1y = 75;
        phiOriginSL2y = -165;
        axLen = 0.1;
        % text(phiOriginFLx, phiOriginFLy, zCut,'$\Phi_{\mathrm{\textbf{Fl, Imp.}}}$','Color',[1 1 1],'Interpreter','latex','FontSize',18,'FontWeight','bold')
        text(phiOriginFLx, phiOriginFLy, zCut,'$\Phi$','Color',[1 1 1],'Interpreter','latex','FontSize',18,'FontWeight','bold')
        text(phiOriginFLx+subShiftX, phiOriginFLy+subShiftY, zCut,'\textbf{FL},Imp.','Color',[ 1 1 1],'Interpreter','latex','FontSize',10,'FontWeight','bold')
        annotation('arrow',[xOriginFL xOriginFL+uFL1I*phiIScale],[yOriginFL1 yOriginFL1+vFL1I*phiIScale],'Color',[1 1 1],'LineWidth',2);
        annotation('line',[xOriginFL xOriginFL+axLen],[yOriginFL1 yOriginFL1],'Color',[1 1 1],'LineWidth',2,'LineStyle','--');
        % text(phiOriginSLx, phiOriginSL1y, zCut, '$\Phi_{\mathrm{\textbf{SL[1], Imp.}}}$','Color',[1 1 1],'Interpreter','latex','FontSize',18,'FontWeight','bold')
        text(phiOriginSLx, phiOriginSL1y, zCut, '$\Phi$','Color',[1 1 1],'Interpreter','latex','FontSize',18,'FontWeight','bold');
        text(phiOriginSLx+subShiftX, phiOriginSL1y+subShiftY, zCut,'\textbf{SL[1]},Imp.','Color',[1 1 1],'Interpreter','latex','FontSize',10,'FontWeight','bold');
        annotation('arrow',[xOriginSL xOriginSL+uSL1I*phiIScale],[yOriginSL1 yOriginSL1+vSL1I*phiIScale],'Color',[1 1 1],'LineWidth',2);
        annotation('line',[xOriginSL xOriginSL+axLen],[yOriginSL1 yOriginSL1],'Color',[1 1 1],'LineWidth',2,'LineStyle','--');
        % text(phiOriginSLx, phiOriginSL2y, zCut,'$\Phi_{\mathrm{\textbf{SL[2], Imp.}}}$','Color',[1 1 1],'Interpreter','latex','FontSize',18,'FontWeight','bold');
        text(phiOriginSLx, phiOriginSL2y, zCut,'$\Phi$','Color',[1 1 1],'Interpreter','latex','FontSize',18,'FontWeight','bold');
        text(phiOriginSLx+subShiftX, phiOriginSL2y+subShiftY, zCut,'\textbf{SL[2]},Imp.','Color',[1 1 1],'Interpreter','latex','FontSize',10,'FontWeight','bold');
        annotation('arrow',[xOriginSL xOriginSL+uSL2I*phiIScale],[yOriginSL2 yOriginSL2+vSL2I*phiIScale],'Color',[1 1 1],'LineWidth',2);
        annotation('line',[xOriginSL xOriginSL+axLen],[yOriginSL2 yOriginSL2],'Color',[1 1 1],'LineWidth',2,'LineStyle','--');
    end
    %     set(axI,'ytick',[0 100 220 340 460 540]);
    % set(axI,'yticklabel',[]);
    %     set(axI,'xtick',[0 120 180 300 360 520]);
    %     set(axI,'xticklabel',[0 120 180 300 360 520]);
    %     xtickangle(45);
    % set(axI,'xtick',[0 60 120 180 240 300 360 420 480 520]);
    % set(axI,'xticklabel',[0 60 120 180 240 300 360 420 480 520]);
    set(axI,'TickDir','out');
    % set(axI,'Units','Centimeters','Position',[20 1 8 8]);
    % set(findall(axI,'-property','FontSize'),'FontSize',9);
%     axis(axI,'square');


    nexttile([2 1])
    nTile = nTile + 1;
%     ax2 = gca;
    hold on
%     barh(binsY,edgeSumI,'grouped','BarWidth',1);
%     [impurityLine,impurityGood,impurityEtc] = fit(binsY',edgeSumI','gauss2','StartPoint',[5*10^3,-120,60,5*10^4,120,60]);
    barh(binsY+10,edgeSumI,'grouped','BarWidth',1);
    [impurityLine,impurityGood,impurityEtc] = fit(binsY'+10,edgeSumI','gauss2','StartPoint',[5*10^3,-120,60,5*10^4,120,60]);
    impurityCurve = impurityLine(binsY);
    % plot(impurityLine);
    plot(impurityCurve,binsY,'LineStyle','--','LineWidth',2);
    legend('off');
    xlabel(strcat('$n_I ~(\%)$'),'Interpreter','Latex');
    xlim([0 10]);
    % ylabel(strcat('$N_I~(10^{',num2str(impurityPower),'})$'),'Interpreter','Latex');
    hAx = gca;
%     hAx.XAxis.Exponent = impurityPower;
    % ylim([0 2750]);
    % yTic = yticks;
    % yticklabels(yTic/(10^impurityPower));
%     if nTile == 1 || nTile == 3
%         ylabel("$y'/\sigma$ (Dimensionless)",'Interpreter','Latex');
%     end
    % xticks(xTic);
    % xlim([yLow*tickSpacing-40 yHigh*tickSpacing+40]);
    title(strcat(hStrings(i), titles((i-1)*4+4)),'Interpreter','Latex')
    ylim([binsY(2) binsY(size(binsY,2))]);
%     ylim([binsY(1) binsY(size(binsY,2))]);
%     yticks(yCentered(1,1):120:yCentered(1,size(yCentered,2)));
    yticks(-600:120:600);

    hold off
end

cd(figDir);
if size(hStrings,1) == 5
    set(hFig,'Units','Centimeter','Position',[0 0 17.2 25.2]);
else
    set(hFig,'Units','Centimeter','Position',[0 0 17.2 17.2]);
end

exportgraphics(hFig,strcat(fileName,".png"));
exportgraphics(hFig,strcat(fileName,".eps"));
savefig(hFig,strcat(fileName,".fig"));
close(hFig);
end