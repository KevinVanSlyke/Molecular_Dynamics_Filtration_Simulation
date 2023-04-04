function [] = scratch_Na_Ni_Vcm_mesh_Na_Ni_therm()%ensembleDir, figDir, doPlot)
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

ensembleDir = 'E:\Data\Molecular_Dynamics_Data\FL1SL2O\DualLayer_MonoOrifice_Hopper_07_2020\Assymetric_DualLayer_Hopper_Ensemble';
figDir = 'E:\Data\Molecular_Dynamics_Data\FL1SL2O\DualLayer_MonoOrifice_Hopper_07_2020\Assymetric_DualLayer_Hopper_Ensemble\Figures_FL1SL2O_Na_Ni_Vcm_5D_Varied_H';
% selectedVars = {'v_hopperArgonCount','v_hopperArgonCount'};
    
t1 = 501;
t2 = 5001;
t3 = 10001;
% varList = {'Step'; 'TotEng'; 'KinEng'; 'PotEng'; 'c_gasTemp'; 'Press'; 'v_hopperPress'; 'c_hopperVx'; 'v_hopperArgonCount'; 'v_hopperImpurityCount'; 'v_interLayerPress'; 'c_interLayerVx'; 'v_interLayerArgonCount'; 'v_interLayerImpurityCount'};

% debug = 0;
% if debug == 1
%     % rootDir = 'E:\Data\Molecular_Dynamics_Data\Focused_Mesh_07_2020\Assymetric_Dual_Layer_Periodic_Ensemble';
%     rootDir = pwd;
% end
fileName = strcat('Na_Ni_Vcm_mesh_Na_Ni_therm_Multi_H_Alt');
hFig =figure('Visible','on');
tiledlayout(4,8, 'Padding', 'compact', 'TileSpacing', 'compact');
titles = {'$H=0\sigma$ (a)'; '(b)'; '(c)';'$H=60\sigma$ (d)'; '(e)'; '(f)'; '$H=120\sigma$ (g)'; '(h)'; '(i)';'$H=240\sigma$ (j)'; '(k)';'(l)'; '(m)';'$H=240\sigma$ (j)'; '(n)';'(o)'};
rootDir = ensembleDir;
rootList = dir(rootDir);
n=0;
simList = {'120W_5D_60L_120F_120S'; '120W_5D_60L_120F_120S_60H';'120W_5D_60L_120F_120S_120H';'120W_5D_60L_120F_120S_240H';'120W_5D_60L_120F_120S_480H'};
% simList = {'120W_5D_60L_120F_120S_60H';'120W_5D_60L_120F_120S_480H'};

avgCountI = mean(countI(:,:,tStart:tStop),3);
allMaxAvgCountI = 0;
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
    if max(countI(:,:,t3),[],'all') > allMaxAvgCountI
        allMaxAvgCountI = max(countI(:,:,t3),[],'all');
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
    [varNames, ensembleAvgVals, ensembleStdVals] = therm_variable(theFullFile);
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
    
    [steps, ~] = select_thermo_var(varNames, ensembleAvgVals, ensembleStdVals, 'Step');
    time = steps/200;
    clear steps
    hopperArgon = select_thermo_var(varNames, ensembleAvgVals, ensembleStdVals, 'v_hopperArgonCount');
    if impurityDiameter > 1
        hopperImpurity = select_thermo_var(varNames, ensembleAvgVals, ensembleStdVals, 'v_hopperImpurityCount');
        [fitLineI, fitGoodnessI] = therm_variable_fit( time, hopperImpurity);
    else
        uI = 0;
        vI = 0;
        countI = 0;
        fitLineI = 0;
        fitGoodnessI = 0;
    end
    [fitLineA, fitGoodnessA] = therm_variable_fit( time, hopperArgon);
    
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
    % [x, y] = centerMeshAxes(fileDir,x,y);
    [xActual, yActual] = centerMeshAxes(simString,x,y);
    
    % [edgeSumA,edgeSumI] = edgeSumCount(t,countA,countI);
    
    sliceIndx = size(x,1);% - 5; %How far from edge of filter do we sum particles
    % edgeSumA = sum(countA(sliceIndx,:,:),3)./(hopperArgon(1)-hopperArgon(size(hopperArgon,1)));
    edgeSumA = sum(countA(sliceIndx,:,:),3)/sum(countA(sliceIndx,:,:),'all')*100;%./(hopperArgon(1)-hopperArgon(size(hopperArgon,1)));
%     edgeSumA = sum(countA(sliceIndx,:,:),3);%./(hopperArgon(1)-hopperArgon(size(hopperArgon,1)));
    argonPower = ceil(log10(max(edgeSumA)-1))-1;
    %     edgeSumI = sum(countI(sliceIndx,:,:),3)./(hopperImpurity(1)-hopperImpurity(size(hopperImpurity)));
    edgeSumI = sum(countI(sliceIndx,:,:),3)/sum(countI(sliceIndx,:,:),'all')*100;%./(hopperImpurity(1)-hopperImpurity(size(hopperImpurity)));
%     edgeSumI = sum(countI(sliceIndx,:,:),3);%./(hopperImpurity(1)-hopperImpurity(size(hopperImpurity)));
    impurityPower = ceil(log10(max(edgeSumI)-1))-1;
%     edgeCounts = [edgeSumA; edgeSumI];
    binsY = yCentered(1,:);
    %% From [] = meshVectorPlotSteps(t,x,y,uA,vA,countA,tempA,uI,vI,countI,tempI,D)
    nexttile([2 2])
%     ax3 = gca;
    hold on
    vcm = 1;
    bothAI = 0;
    
    % xLow = min(x,[],'all');
    % xUp = max(x,[],'all');
    % yLow = min(y,[],'all');
    % yUp = max(y,[],'all');
    
    xLow = min(x,[],'all');
    xUp = max(x,[],'all')-20;
    yLow = min(y,[],'all')+20;
    yUp = max(y,[],'all');

    
    % xAxMax = size(x,1);
    % yAxMax = size(y,1);
    
    % countAMax = max(countA,[],'all');
    % tempAMax = max(tempA,[],'all');
    % countIMax = max(countI,[],'all');
    % tempIMax = max(tempI,[],'all');
    countI = 
    % countIMax = round(max(countI,[],'all'));
%     countIMax = max([countI(:,:,t1), countI(:,:,t2), countI(:,:,t3)],[],'all');
    countIMax = max([countI(:,:,t1), countI(:,:,t2), countI(:,:,t3)],[],'all');
    D = impurityDiameter;
    density = (countA + countI.*D^2)./400;
    
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
    
    uCM = (countA.*uA+D^2*countI.*uI)./(countA+D^2*countI);
    vCM = (countA.*vA+D^2*countI.*vI)./(countA+D^2*countI);
    maxMagCM = max((uCM.^2+vCM.^2).^(1/2),[],'all');
    uNormCM = uCM./maxMagCM;
    vNormCM = vCM./maxMagCM;
    
    % triFig = figure('Visible','on','Position',[0 0 18 6],'Units','centimeters');
    % pos1 = [1 1 6 6];
    % pos2 = [7 1 6 6];
    % pos3 = [13 1 6 6];
    
    %     ax3 = gca;
    % ax3 = subplot(1,3,3);
    % ax3 = axes('Position',pos3,'Units','centimeters');
    % subplot(1,3,3);
    % quiver(xCentered+10, yCentered+10, uNormCM(:,:,t3)*50, vNormCM(:,:,t3)*50, 'AutoScale', 'off', 'Color' ,'w');%, 'LineWidth',2);%,'MaxHeadSize',5);
    surf(xCentered,yCentered,countI(:,:,t3)'-allMaxAvgCountI);
    quiver3(xCentered'+10, yCentered'+10, zeros(size(xCentered,2),size(xCentered,2)), uNormCM(:,:,t3)'*50, vNormCM(:,:,t3)'*50, zeros(size(xCentered,2),size(xCentered,2)), 'AutoScale', 'off', 'Color' ,'w');%, 'LineWidth',2);%,'MaxHeadSize',5);
    % axis([xLow xUp yLow yUp -countIMax 0]);
    % surf(x,y,logKinetic(:,:,t3)-logKineticMax);
    % axis([20 xCentered(1,size(xCentered,2)-1) yLow yUp -logKineticMax 0]);
    title(titles((i-1)*3+1),'Interpreter','Latex')
    xlabel("$x'~(\sigma)$",'Interpreter','Latex');
    ylabel("$y'~(\sigma)$",'Interpreter','Latex');
    yticks(-600:120:600);
    xticks(-600:120:6000);

    % ylabel("$y$",'Interpreter','Latex');
    view(0,90);
    ylim([binsY(1) binsY(size(binsY,2))]);
    xlim([20 xCentered(1,size(xCentered,2))]);
    colormap(parula(allMaxAvgCountI+1));
    caxis([-allMaxAvgCountI 0]);
%     xticks(xCentered(1,1):120:xCentered(1,size(xCentered,2)));
%     yticks(yCentered(1,1):120:yCentered(1,size(yCentered,2)));
    zCut = 0;
%     orificeWidth = 120;
%     filterDepth = 60;
%     orificeSpacing = 120;
    % filterSeparation = 120;
%     registryShift = 60;

    xLeft = xCentered(orificeIndices(1,1,1));%*20-20;

    % xLeft = 140;
    if i == 1
        yLeft = yCentered(orificeIndices(2,1,1))+60;
    elseif i == 2
        yLeft = yCentered(orificeIndices(2,1,1));
%     elseif i == 3
%         yLeft = yCentered(orificeIndices(2,1,1))-60;    
    elseif i == 3
        yLeft = yCentered(orificeIndices(2,1,1))-180;
    elseif i == 4
        yLeft = yCentered(orificeIndices(2,1,1))-420;
    end
    % yLeft = mid-width/2;
    
    xRight = xCentered(orificeIndices(1,1,3));
    % yRight = yLeft-spacing-width/2;
    % yRight = yCentered(orificeIndices(2,1,2));
    
    FL = 1;
    
    if FL == 1
        yRight = yCentered(orificeIndices(1,2,2));
        patch( [xLeft xLeft xLeft+filterDepth xLeft+filterDepth], [-2000 yLeft yLeft -2000], [zCut zCut zCut zCut], 'w');
        patch( [xLeft xLeft xLeft+filterDepth xLeft+filterDepth], [yLeft+orificeWidth 2000 2000 yLeft+orificeWidth], [zCut zCut zCut zCut], 'w');
        patch( [xRight xRight xRight+filterDepth xRight+filterDepth], [-2000 yRight yRight -2000], [zCut zCut zCut zCut], 'w');
        patch( [xRight xRight xRight+filterDepth xRight+filterDepth], [yRight+orificeWidth yRight+2*orificeWidth yRight+2*orificeWidth yRight+orificeWidth], [zCut zCut zCut zCut], 'w');
        patch( [xRight xRight xRight+filterDepth xRight+filterDepth], [yRight+3*orificeWidth 2000 2000 yRight+3*orificeWidth], [zCut zCut zCut zCut], 'w');
    elseif FL == 2
        patch( [xLeft xLeft xLeft+filterDepth xLeft+filterDepth], [-2000 yLeft yLeft -2000], [zCut zCut zCut zCut], 'w');
        patch( [xLeft xLeft xLeft+filterDepth xLeft+filterDepth], [yLeft+orificeWidth yLeft+2*orificeWidth yLeft+2*orificeWidth yLeft+orificeWidth], [zCut zCut zCut zCut], 'w');
        patch( [xLeft xLeft xLeft+filterDepth xLeft+filterDepth], [yLeft+3*orificeWidth 2000 2000 yLeft+3*orificeWidth], [zCut zCut zCut zCut], 'w');
        patch( [xRight xRight xRight+filterDepth xRight+filterDepth], [0 yRight yRight 0], [zCut zCut zCut zCut], 'w');
        patch( [xRight xRight xRight+filterDepth xRight+filterDepth], [yRight+orificeWidth yRight+2*orificeWidth yRight+2*orificeWidth yRight+orificeWidth], [zCut zCut zCut zCut], 'w');
        patch( [xRight xRight xRight+filterDepth xRight+filterDepth], [yRight+3*orificeWidth 2000 2000 yRight+3*orificeWidth], [zCut zCut zCut zCut], 'w');
    end
    %     set(ax3,'ytick',[0 100 220 340 460 540]);
    % set(ax3,'yticklabel',[]);
    %     set(ax3,'xtick',[0 120 180 300 360 520]);
    %     set(ax3,'xticklabel',[0 120 180 300 360 520]);
    %     xtickangle(45);
    % set(ax3,'xtick',[0 60 120 180 240 300 360 420 480 520]);
    % set(ax3,'xticklabel',[0 60 120 180 240 300 360 420 480 520]);
    set(gca,'TickDir','out');
    % set(ax3,'Units','Centimeters','Position',[20 1 8 8]);
    set(findall(gca,'-property','FontSize'),'FontSize',9);
%     axis(gca,'square')
    
    
    % axesHandles = findobj(get(triFig,'Children'), 'flat','Type','axes');
    % axis(axesHandles,'square')
    
    % hcolorBar = colorbar(ax3);
    if i == 3
        % hcolorBar = colorbar('Ticks',(-countIMax+0.25:1:0.25),'TickLabels',(0:1:countIMax));
        hcolorBar = colorbar('Ticks',(-allMaxAvgCountI:1),'TickLabels',(0:1:allMaxAvgCountI+1));
        % hcolorBar = colorbar('Ticks',(-countIMax:1),'TickLabels',(0:1:countIMax+1),'Position',[1.1 0 0.1 0.9]);
        % hcolorBar = colorbar('Ticks',[-1.75 -1.25 -0.75],'TickLabels',{'0' '1' '2'});
        ylabel(hcolorBar, "$N_I$", 'Interpreter', 'latex','FontSize',9);
        % caxis([-countIMax 0]);
        hcolorBar.Layout.Tile = 'west';
    end
    hold off


   
    % tickSpacing = 120;
    % yHigh = round(max(centeredY)/tickSpacing);
    % yLow = -yHigh;
    % xTic = (yLow:1:yHigh)*tickSpacing;
    
    nexttile([2 1])
%     ax1 = gca;
    hold on;
    % barh(binsY,[edgeSumI; edgeSumA],'grouped');
    barh(binsY,edgeSumA,'grouped');
    [argonLine,argonGood,argonEtc] = fit(binsY',edgeSumA','gauss2','StartPoint',[2*10^4,-120,60,2*10^4,120,60]);
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
    plot(argonCurve,binsY);
    legend('off');
    xlabel(strcat('$n_A ~(\%)$'),'Interpreter','Latex');
    % ylabel(strcat('$N_A~(10^{',num2str(argonPower),'})$'),'Interpreter','Latex');
    hAx = gca;
%     hAx.XAxis.Exponent = argonPower;
    % ylim([0 27500]);
    % yTic = yticks;
    % yticklabels(yTic/(10^argonPower));
    ylabel("$y'~(\sigma)$",'Interpreter','Latex');
    % xticks(xTic);
    % xlim([yLow*tickSpacing-40 yHigh*tickSpacing+40]);
    title(titles((i-1)*3+2),'Interpreter','Latex');
    ylim([binsY(1) binsY(size(binsY,2))]);
%     yticks(yCentered(1,1):120:yCentered(1,size(yCentered,2)));
    yticks(-600:120:600);
    hold off
    
    nexttile([2 1])
%     ax2 = gca;
    hold on
    barh(binsY,edgeSumI,'grouped');
    [impurityLine,impurityGood,impurityEtc] = fit(binsY',edgeSumI','gauss2','StartPoint',[5*10^3,-120,60,5*10^4,120,60]);
    impurityCurve = impurityLine(binsY);
    % plot(impurityLine);
    plot(impurityCurve,binsY);
    legend('off');
    xlabel(strcat('$n_I ~(\%)$'),'Interpreter','Latex');
    xlim([0 10]);
    % ylabel(strcat('$N_I~(10^{',num2str(impurityPower),'})$'),'Interpreter','Latex');
    hAx = gca;
%     hAx.XAxis.Exponent = impurityPower;
    % ylim([0 2750]);
    % yTic = yticks;
    % yticklabels(yTic/(10^impurityPower));
    ylabel("$y'~(\sigma)$",'Interpreter','Latex');
    % xticks(xTic);
    % xlim([yLow*tickSpacing-40 yHigh*tickSpacing+40]);
    title(titles((i-1)*3+3),'Interpreter','Latex');
    ylim([binsY(1) binsY(size(binsY,2))]);
%     yticks(yCentered(1,1):120:yCentered(1,size(yCentered,2)));
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