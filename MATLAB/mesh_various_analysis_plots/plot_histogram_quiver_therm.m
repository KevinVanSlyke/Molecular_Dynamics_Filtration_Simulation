function    [] = plot_histogram_quiver_therm(simString,t,x,y,uA,vA,countA,uI,vI,countI,varNames, ensembleAvgVals, ensembleStdVals,figDir)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
doMean = 1;
if doMean == 1
    fileName = strcat('Na_Ni_Vcm_mesh_mean_',simString);
elseif doTherm == 1
    fileName = strcat('Na_Ni_Vcm_mesh_therm',simString);
elseif doPercent == 1
    fileName = strcat('Na_Ni_Vcm_mesh_percent',simString);
end
    
    %% From [outFlowAngleLabels,outFlowAngleData] = edge_particle_sums(simString,edgeCountA,edgeCountI,lowTheta,upTheta,centeredX,centeredY,sliceIndx,figDir,saveplots)
[parNames, parVars, parVals] = ensemble_parameters(simString); %Get parameter info
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
if registryShift == 0
    doPhi = 1;
else
    doPhi = 0;
end
% 
% [steps, ~] = select_thermo_var(varNames, ensembleAvgVals, ensembleStdVals, 'Step');
% time = steps/200;
% clear steps
% hopperArgon = select_thermo_var(varNames, ensembleAvgVals, ensembleStdVals, 'v_hopperArgonCount');
% if impurityDiameter > 1
%     hopperImpurity = select_thermo_var(varNames, ensembleAvgVals, ensembleStdVals, 'v_hopperImpurityCount');
%     [fitLineI, fitGoodnessI] = therm_variable_fit( time, hopperImpurity);
% else
%     uI = 0;
%     vI = 0;
%     countI = 0;
%     fitLineI = 0;
%     fitGoodnessI = 0;
% end
% [fitLineA, fitGoodnessA] = therm_variable_fit( time, hopperArgon);

[orificeIndices] = get_orifice_indices(countA); %Calculate orifice indices
middleY = orificeIndices(2,2,2)-1+(orificeIndices(1,2,3) - orificeIndices(2,2,2))/2;
yCentered = y(1,:) - 20*middleY -10;
for i = 1 : 1 : size(yCentered,2)
    if yCentered(1,i) > 0
        yCenterIndex = i;
        break;
    end
end
xCentered = x(1:size(x,1));
% [x, y] = centerMeshAxes(fileDir,x,y);
[xActual, yActual] = centerMeshAxes(simString,x,y);
binsY = yCentered(1,:);

% [edgeSumA,edgeSumI] = edgeSumCount(t,countA,countI);

 edgeMeanI = mean(countI(:,:,:),3);%./(hopperImpurity(1)-hopperImpurity(size(hopperImpurity)));
 edgeMeanA = mean(countA(:,:,:),3);%./(hopperArgon(1)-hopperArgon(size(hopperArgon,1)));
 sliceIndx = size(x,1);% - 5; %How far from edge of filter do we sum particles
    edgeSumA = sum(countA(sliceIndx,:,:),3)/sum(countA(sliceIndx,:,:),'all')*100;%./(hopperArgon(1)-hopperArgon(size(hopperArgon,1)));
    edgeSumI = sum(countI(sliceIndx,:,:),3)/sum(countI(sliceIndx,:,:),'all')*100;%./(hopperImpurity(1)-hopperImpurity(size(hopperImpurity)));
    argonPower = ceil(log10(max(edgeSumA)-1))-1;
%     edgeSumA = sum(countA(sliceIndx,:,:),3)./(hopperArgon(1)-hopperArgon(size(hopperArgon,1)));
%     edgeSumI = sum(countI(sliceIndx,:,:),3)./(hopperImpurity(1)-hopperImpurity(size(hopperImpurity)));
%     edgeSumA = sum(countA(sliceIndx,:,:),3);
%     edgeSumI = sum(countI(sliceIndx,:,:),3)
    impurityPower = ceil(log10(max(edgeSumI)-1))-1;
%     edgeCounts = [edgeSumA; edgeSumI];
    

titles = ['(a)';'(b)';'(c)'];
% tickSpacing = 120;
% yHigh = round(max(centeredY)/tickSpacing);
% yLow = -yHigh;
% xTic = (yLow:1:yHigh)*tickSpacing;

hFig =figure('Visible','on');
% title(fileName);
tiledlayout(2,4, 'Padding', 'tight', 'TileSpacing', 'compact');


t1 = 21;
t2 = 201;
t3 = 2001;
t4 = 10001;
D = impurityDiameter;
% density = (countA + countI.*D^2)./400;

% kinetic = countA.*tempA + countI.*tempI*D^2;
% logKinetic = log10(kinetic+1);
% logKinetic(isinf(logKinetic)|isnan(logKinetic)) = 0;
% logKineticMax = max(logKinetic,[],'all');
% logKineticMin = min(logKinetic,[],'all');

maxAMag = max((uA.^2+vA.^2).^(1/2),[],'all');
maxIMag = max((uI.^2+vI.^2).^(1/2),[],'all');
maxMag = max(maxAMag,maxIMag);
uANorm = uA./maxMag;
vANorm = vA./maxMag;
uINorm = uI./maxMag;
vINorm = vI./maxMag;

% meanA = mean(countA(:,:,t3:t4),3);
% meanI = mean(countI(:,:,t3:t4),3);
% uAMean = mean(uA(:,:,t3:t4),3);
% uIMean = mean(uI(:,:,t3:t4),3);
% vAMean = mean(vA(:,:,t3:t4),3);
% vIMean = mean(vI(:,:,t3:t4),3);
meanA = mean(countA,3);
meanALog = log10(meanA);
meanALog(isinf(meanALog)|isnan(meanALog)|meanALog<-2) = -1.2;
countAMinMeanLog =min(meanALog,[],'all');
countAMaxMeanLog =max(meanALog,[],'all');
meanI = mean(countI,3);
meanILog = log10(meanI);
meanILog(isinf(meanILog)|isnan(meanILog)) = -4;
countIMinMeanLog =min(meanILog,[],'all');
uAMean = mean(uA,3);
vAMean = mean(vA,3);
uIMean = mean(uI,3);
vIMean = mean(vI,3);    
uCMmean = (meanA.*uAMean+D^2*meanI.*uIMean)./(meanA+D^2*meanI);
vCMmean = (meanA.*vAMean+D^2*meanI.*vIMean)./(meanA+D^2*meanI);
maxMagCMmean = max((uCMmean.^2+vCMmean.^2).^(1/2),[],'all');
uNormCMmean = uCMmean./maxMagCMmean;
vNormCMmean = vCMmean./maxMagCMmean;  

uCM = (countA.*uA+D^2*countI.*uI)./(countA+D^2*countI);
vCM = (countA.*vA+D^2*countI.*vI)./(countA+D^2*countI);
maxMagCM = max((uCM.^2+vCM.^2).^(1/2),[],'all');
uNormCM = uCM./maxMagCM;
vNormCM = vCM./maxMagCM;
countIMax = max(countI(:,:,t3),[],'all');

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
% triFig = figure('Visible','on','Position',[0 0 18 6],'Units','centimeters');
% pos1 = [1 1 6 6];
% pos2 = [7 1 6 6];
% pos3 = [13 1 6 6];
%% From [] = meshVectorPlotSteps(t,x,y,uA,vA,countA,tempA,uI,vI,countI,tempI,D)
nexttile([2 2])
ax3 = gca;
hold on
if doMean == 1
    surf(xCentered,yCentered,meanILog');

    % hcolorBar = colorbar('Ticks',(-countIMax+0.25:1:0.25),'TickLabels',(0:1:countIMax));
    % hcolorBar = colorbar('Ticks',(-countIMaxMean:1),'TickLabels',(0:1:countIMaxMean+1));
    % hcolorBar = colorbar('Ticks',(-countIMax:1),'TickLabels',(0:1:countIMax+1),'Position',[1.1 0 0.1 0.9]);
%     hcolorBar = colorbar('Ticks',(countIMinMeanLog:-countIMinMeanLog/12:0),'TickLabels',(0:-countIMinMeanLog/12:-countIMinMeanLog));
    
    quiver3(xCentered'+10, yCentered'+10, zeros(size(xCentered,2),size(xCentered,2)), uIMean'*50, vIMean'*50, zeros(size(xCentered,2),size(xCentered,2)), 'AutoScale', 'off', 'Color' ,'k');%, 'LineWidth',2);%,'MaxHeadSize',5);
    colormap(parula(10));
    caxis([countIMinMeanLog+1 0]);
    hcolorBar = colorbar(ax3);
    ylabel(hcolorBar, "$\log(\langle N_I \rangle)$", 'Interpreter', 'latex','FontSize',9);
else
    surf(xCentered,yCentered,countI(:,:,t3)'-countIMax);
       
    quiver3(xCentered'+10, yCentered'+10, zeros(size(xCentered,2),size(xCentered,2)), uNormCM(:,:,t3)'*50, vNormCM(:,:,t3)'*50, zeros(size(xCentered,2),size(xCentered,2)), 'AutoScale', 'off', 'Color' ,'w');%, 'LineWidth',2);%,'MaxHeadSize',5);
    colormap(parula(countIMax+1));
    caxis([-countIMax 0]);
    hcolorBar = colorbar('Ticks',(-countIMax:1),'TickLabels',(0:1:countIMax+1));
    ylabel(hcolorBar, "\log( \langle N_I \rangle )", 'Interpreter', 'latex','FontSize',9);
end
% axis([20 xCentered(1,size(xCentered,2)-1) yLow yUp -logKineticMax 0]);
title("\qquad \qquad \qquad \qquad \qquad (a)",'Interpreter','Latex')
ylabel("$y'/\sigma$",'Interpreter','Latex');
xlabel("$x'/\sigma$",'Interpreter','Latex');    
% hcolorBar.Layout.Tile = 'west';
% ylabel("$y$",'Interpreter','Latex');
view(0,90);
ylim([binsY(2) binsY(size(binsY,2))]);
xlim([20 xCentered(1,size(xCentered,2)-1)]);
yticks(-600:120:600);
xticks(-600:120:6000);
% xticks(xCentered(1,1):60:xCentered(1,size(xCentered,2)));
% yticks(yCentered(1,1):60:yCentered(1,size(yCentered,2)));
zCut = 0.1;
% orificeWidth = 120;
% filterDepth = 60;
% orificeSpacing = 120;
% filterSeparation = 120;
% registryShift = 60;

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

%     set(ax3,'ytick',[0 100 220 340 460 540]);
% set(ax3,'yticklabel',[]);
%     set(ax3,'xtick',[0 120 180 300 360 520]);
%     set(ax3,'xticklabel',[0 120 180 300 360 520]);
%     xtickangle(45);
% set(ax3,'xtick',[0 60 120 180 240 300 360 420 480 520]);
% set(ax3,'xticklabel',[0 60 120 180 240 300 360 420 480 520]);
set(ax3,'TickDir','out');
% set(ax3,'Units','Centimeters','Position',[20 1 8 8]);
% set(findall(ax3,'-property','FontSize'),'FontSize',9);
axis(ax3,'square')

hold off

if doMean == 1
    nexttile([2 2])
    ax4 = gca;
    hold on
    surf(xCentered,yCentered,meanALog');
    colormap(parula(10));
%     colormap(parula);
    caxis([countAMinMeanLog-0.2 countAMaxMeanLog]);
    hcolorBar = colorbar(ax4);
    % hcolorBar = colorbar('Ticks',(-countIMax+0.25:1:0.25),'TickLabels',(0:1:countIMax));
    % hcolorBar = colorbar('Ticks',(-countIMaxMean:1),'TickLabels',(0:1:countIMaxMean+1));
    % hcolorBar = colorbar('Ticks',(-countIMax:1),'TickLabels',(0:1:countIMax+1),'Position',[1.1 0 0.1 0.9]);
%     hcolorBar = colorbar('Ticks',(countIMinMeanLog:-countIMinMeanLog/12:0),'TickLabels',(0:-countIMinMeanLog/12:-countIMinMeanLog));
    ylabel(hcolorBar, "$\log(\langle N_A \rangle)$", 'Interpreter', 'latex','FontSize',9);
    % axis([20 xCentered(1,size(xCentered,2)-1) yLow yUp -logKineticMax 0]);
    ylabel("$y'/\sigma$",'Interpreter','Latex');
    xlabel("$x'/\sigma$",'Interpreter','Latex');    
%     hcolorBar.Layout.Tile = 'east';
    % ylabel("$y$",'Interpreter','Latex');
    view(0,90);
    ylim([binsY(2) binsY(size(binsY,2))]);
    xlim([20 xCentered(1,size(xCentered,2)-1)]);
    yticks(-600:120:600);
    xticks(-600:120:6000);
    % xticks(xCentered(1,1):60:xCentered(1,size(xCentered,2)));
    % yticks(yCentered(1,1):60:yCentered(1,size(yCentered,2)));
    zCut = 1.2;
    % orificeWidth = 120;
    % filterDepth = 60;
    % orificeSpacing = 120;
    % filterSeparation = 120;
    % registryShift = 60;
    quiver3(xCentered'+10, yCentered'+10, zeros(size(xCentered,2),size(xCentered,2))+zCut, uAMean'*50, vAMean'*50, zeros(size(xCentered,2),size(xCentered,2)), 'AutoScale', 'off', 'Color' ,'k');%, 'LineWidth',2);%,'MaxHeadSize',5);

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
    
    %     set(ax3,'ytick',[0 100 220 340 460 540]);
    % set(ax3,'yticklabel',[]);
    %     set(ax3,'xtick',[0 120 180 300 360 520]);
    %     set(ax3,'xticklabel',[0 120 180 300 360 520]);
    %     xtickangle(45);
    % set(ax3,'xtick',[0 60 120 180 240 300 360 420 480 520]);
    % set(ax3,'xticklabel',[0 60 120 180 240 300 360 420 480 520]);
    set(ax4,'TickDir','out');
    % set(ax3,'Units','Centimeters','Position',[20 1 8 8]);
%     set(findall(ax4,'-property','FontSize'),'FontSize',9);
    axis(ax4,'square')
    title('\qquad \qquad \qquad \qquad \qquad (b)','Interpreter','latex');
    hold off
end
% nexttile([2 2])
% ax3 = gca;
% hold on
% 
% 
% 
% D = impurityDiameter;
% density = (countA + countI.*D^2)./400;
% %%     vcm = 1;
% %     bothAI = 0;
% 
% % xLow = min(x,[],'all');
% % xUp = max(x,[],'all');
% % yLow = min(y,[],'all');
% % yUp = max(y,[],'all');
% 
% %     xLow = min(x,[],'all');
% %     xUp = max(x,[],'all')-20;
% %     yLow = min(y,[],'all')+20;
% %     yUp = max(y,[],'all');
% 
% t1 = 21;
% t2 = 201;
% t3 = 2001;
% 
% % xAxMax = size(x,1);
% % yAxMax = size(y,1);
% 
% % countAMax = max(countA,[],'all');
% % tempAMax = max(tempA,[],'all');
% % countIMax = max(countI,[],'all');
% % tempIMax = max(tempI,[],'all');
% 
% % countIMax = round(max(countI,[],'all'));
% % countIMax = max([countI(:,:,t1), countI(:,:,t2), countI(:,:,t3)],[],'all');
% %     maxAMag = max((uA.^2+vA.^2).^(1/2),[],'all');
% %     maxIMag = max((uI.^2+vI.^2).^(1/2),[],'all');
% %     maxMag = max(maxAMag,maxIMag);
% %     uANorm = uA./maxMag;
% %     vANorm = vA./maxMag;
% %     uINorm = uI./maxMag;
% %     vINorm = vI./maxMag;
% 
% 
% % kinetic = countA.*tempA + countI.*tempI*D^2;
% % logKinetic = log10(kinetic+1);
% % logKinetic(isinf(logKinetic)|isnan(logKinetic)) = 0;
% % logKineticMax = max(logKinetic,[],'all');
% % logKineticMin = min(logKinetic,[],'all');
% 
% 
% 
% % triFig = figure('Visible','on','Position',[0 0 18 6],'Units','centimeters');
% % pos1 = [1 1 6 6];
% % pos2 = [7 1 6 6];
% % pos3 = [13 1 6 6];
% %%
% %     ax3 = gca;
% % ax3 = subplot(1,3,3);
% % ax3 = axes('Position',pos3,'Units','centimeters');
% % subplot(1,3,3);
% % quiver(xCentered+10, yCentered+10, uNormCM(:,:,t3)*50, vNormCM(:,:,t3)*50, 'AutoScale', 'off', 'Color' ,'k');%, 'LineWidth',2);%,'MaxHeadSize',5);
% surf(xCentered,yCentered,countI(:,:,t3)'-countIMax);
% quiver3(xCentered'+10, yCentered'+10, zeros(size(xCentered,2),size(xCentered,2)), uNormCM(:,:,t3)'*50, vNormCM(:,:,t3)'*50, zeros(size(xCentered,2),size(xCentered,2)), 'AutoScale', 'off', 'Color' ,'w');%, 'LineWidth',2);%,'MaxHeadSize',5);
% % axis([xLow xUp yLow yUp -countIMax 0]);
% % surf(x,y,logKinetic(:,:,t3)-logKineticMax);
% % axis([20 xCentered(1,size(xCentered,2)-1) yLow yUp -logKineticMax 0]);
% title("(a)",'Interpreter','Latex')
% xlabel("$y'/\sigma$",'Interpreter','Latex');
% xlabel("$x'/\sigma$",'Interpreter','Latex');
% 
% % ylabel("$y$",'Interpreter','Latex');
% view(0,90);
% ylim([binsY(1) binsY(size(binsY,2))]);
% xlim([20 xCentered(1,size(xCentered,2))]);
% colormap(parula(countIMax+1));
% caxis([-countIMax 0]);
% yticks(-600:120:600);
% xticks(-600:120:6000);
% % xticks(xCentered(1,1):60:xCentered(1,size(xCentered,2)));
% % yticks(yCentered(1,1):60:yCentered(1,size(yCentered,2)));
% zCut = 0;
% % orificeWidth = 120;
% % filterDepth = 60;
% % orificeSpacing = 120;
% % filterSeparation = 120;
% % registryShift = 60;
% 
% % xLeft = 140;
% xLeft = xCentered(orificeIndices(1,1,1));%*20-20;
% % yLeft = mid-width/2;
% if registryShift == 0
%     yLeft = yCentered(orificeIndices(2,1,1))+60;
% elseif registryShift == 60
%     yLeft = yCentered(orificeIndices(2,1,1));
% elseif registryShift == 120
%     yLeft = yCentered(orificeIndices(2,1,1))-60;
% elseif registryShift == 240
%     yLeft = yCentered(orificeIndices(2,1,1))-180;
% elseif registryShift == 480
%     yLeft = yCentered(orificeIndices(2,1,1))-420;
% end
% xRight = xCentered(orificeIndices(1,1,3));
% % yRight = yLeft-spacing-width/2;
% % yRight = yCentered(orificeIndices(2,1,2));
% 
% FL = 1;
% 
% if FL == 1
%     yRight = yCentered(orificeIndices(1,2,2));
%     patch( [xLeft xLeft xLeft+filterDepth xLeft+filterDepth], [-2000 yLeft yLeft -2000], [zCut zCut zCut zCut], 'w');
%     patch( [xLeft xLeft xLeft+filterDepth xLeft+filterDepth], [yLeft+orificeWidth 2000 2000 yLeft+orificeWidth], [zCut zCut zCut zCut], 'w');
%     patch( [xRight xRight xRight+filterDepth xRight+filterDepth], [-2000 yRight yRight -2000], [zCut zCut zCut zCut], 'w');
%     patch( [xRight xRight xRight+filterDepth xRight+filterDepth], [yRight+orificeWidth yRight+2*orificeWidth yRight+2*orificeWidth yRight+orificeWidth], [zCut zCut zCut zCut], 'w');
%     patch( [xRight xRight xRight+filterDepth xRight+filterDepth], [yRight+3*orificeWidth 2000 2000 yRight+3*orificeWidth], [zCut zCut zCut zCut], 'w');
% elseif FL == 2
%     patch( [xLeft xLeft xLeft+filterDepth xLeft+filterDepth], [-2000 yLeft yLeft -2000], [zCut zCut zCut zCut], 'w');
%     patch( [xLeft xLeft xLeft+filterDepth xLeft+filterDepth], [yLeft+orificeWidth yLeft+2*orificeWidth yLeft+2*orificeWidth yLeft+orificeWidth], [zCut zCut zCut zCut], 'w');
%     patch( [xLeft xLeft xLeft+filterDepth xLeft+filterDepth], [yLeft+3*orificeWidth 2000 2000 yLeft+3*orificeWidth], [zCut zCut zCut zCut], 'w');
%     patch( [xRight xRight xRight+filterDepth xRight+filterDepth], [0 yRight yRight 0], [zCut zCut zCut zCut], 'w');
%     patch( [xRight xRight xRight+filterDepth xRight+filterDepth], [yRight+orificeWidth yRight+2*orificeWidth yRight+2*orificeWidth yRight+orificeWidth], [zCut zCut zCut zCut], 'w');
%     patch( [xRight xRight xRight+filterDepth xRight+filterDepth], [yRight+3*orificeWidth 2000 2000 yRight+3*orificeWidth], [zCut zCut zCut zCut], 'w');
% end
% %     set(ax3,'ytick',[0 100 220 340 460 540]);
% % set(ax3,'yticklabel',[]);
% %     set(ax3,'xtick',[0 120 180 300 360 520]);
% %     set(ax3,'xticklabel',[0 120 180 300 360 520]);
% %     xtickangle(45);
% % set(ax3,'xtick',[0 60 120 180 240 300 360 420 480 520]);
% % set(ax3,'xticklabel',[0 60 120 180 240 300 360 420 480 520]);
% set(ax3,'TickDir','out');
% % set(ax3,'Units','Centimeters','Position',[20 1 8 8]);
% set(findall(ax3,'-property','FontSize'),'FontSize',9);
% axis(ax3,'square')
% 
% 
% % axesHandles = findobj(get(triFig,'Children'), 'flat','Type','axes');
% % axis(axesHandles,'square')
% 
% % hcolorBar = colorbar(ax3);
% % hcolorBar = colorbar('Ticks',(-countIMax+0.25:1:0.25),'TickLabels',(0:1:countIMax));
% hcolorBar = colorbar('Ticks',(-countIMax:1),'TickLabels',(0:1:countIMax+1));
% % hcolorBar = colorbar('Ticks',(-countIMax:1),'TickLabels',(0:1:countIMax+1),'Position',[1.1 0 0.1 0.9]);
% % hcolorBar = colorbar('Ticks',[-1.75 -1.25 -0.75],'TickLabels',{'0' '1' '2'});
% ylabel(hcolorBar, "$N_I$", 'Interpreter', 'latex','FontSize',9);
% % caxis([-countIMax 0]);
% hcolorBar.Layout.Tile = 'west';
% hold off
% 
% end
if doMean ~= 1
    nexttile([2 1])
    ax1 = gca;
    hold on;
    % barh(binsY,[edgeSumI; edgeSumA],'grouped');
    barh(binsY,edgeSumA,'grouped');
    [argonLine,argonGood,argonEtc] = fit(binsY',edgeSumA','gauss2','StartPoint',[2*10^4,-120,60,2*10^4,120,60]);
    
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
    plot(argonCurve,binsY,'LineWidth',2);
    legend('off');
    xlabel(strcat('$n_A ~(\%)$'),'Interpreter','Latex');
    % ylabel(strcat('$N_A~(10^{',num2str(argonPower),'})$'),'Interpreter','Latex');
    hAx = gca;
    % hAx.XAxis.Exponent = argonPower;
    % xlim([2*10^3 2*10^4]);
    % ylim([0 27500]);
    % yTic = yticks;
    % yticklabels(yTic/(10^argonPower));
    ylabel("$y'/\sigma$",'Interpreter','Latex');
    % xticks(xTic);
    % xlim([yLow*tickSpacing-40 yHigh*tickSpacing+40]);
    title("(b)",'Interpreter','Latex');
    ylim([binsY(1) binsY(size(binsY,2))]);
    % yticks(yCentered(1,1):60:yCentered(1,size(yCentered,2)));
    yticks(-600:120:600);
    hold off
    
    nexttile([2 1])
    ax2 = gca;
    hold on
    barh(binsY,edgeSumI,'grouped');
    [impurityLine,impurityGood,impurityEtc] = fit(binsY',edgeSumI','gauss2','StartPoint',[5*10^3,-120,60,5*10^4,120,60]);
    impurityCurve = impurityLine(binsY);
    % plot(impurityLine);
    plot(impurityCurve,binsY,'LineWidth',2);
    legend('off');
    xlabel(strcat('$n_I ~(\%)$'),'Interpreter','Latex');
    % ylabel(strcat('$N_I~(10^{',num2str(impurityPower),'})$'),'Interpreter','Latex');
    hAx = gca;
    % hAx.XAxis.Exponent = impurityPower;
    % ylim([0 2750]);
    % yTic = yticks;
    % yticklabels(yTic/(10^impurityPower));
    ylabel("$y'/\sigma$",'Interpreter','Latex');
    % xticks(xTic);
    % xlim([yLow*tickSpacing-40 yHigh*tickSpacing+40]);
    title("(c)",'Interpreter','Latex');
    ylim([binsY(1) binsY(size(binsY,2))]);
    % yticks(yCentered(1,1):60:yCentered(1,size(yCentered,2)));
    yticks(-600:120:600);
    hold off
end
cd(figDir);
set(hFig,'Units','Centimeter','Position',[0 0 17.2 8.6]);
exportgraphics(hFig,strcat(fileName,".png"));
exportgraphics(hFig,strcat(fileName,".eps"));
savefig(hFig,strcat(fileName,".fig"));
close(hFig);
end