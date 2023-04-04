function [] = Na_Ni_Vcm_mesh_multi_H()%ensembleDir, figDir, doPlot)
%[outFlowAngleLabels,sortedOutFlowAngleData] = separation_ensemble_outflow_count(ensembleDir, figDir, doPlot)
%Given mesh data, calculate outflow count by distance and angle, optionally plot histograms
%   Inputs are directory of simulation ensemble, directory to save figures,
%   and a boolean flag for if plots should be performed. Output is label of
%   data sets and sorted outflow angles. Looping through ensemble directory
%   we perform analysis counting the number of particles some distance from
%   the far filter edge. Optionally plot histograms and gaussian fit of the
%   aforementioned data.

tStart = 2001;
tStop = 10001;
ensembleDir = 'E:\Molecular_Dynamics_Data\FL1SL2O\DualLayer_MonoOrifice_Hopper_07_2020\Assymetric_DualLayer_Hopper_Ensemble';
% fileName = strcat('Na_Ni_mesh_3multi_H_FL1SL2O_yPer');
fileName = strcat('Na_Ni_mesh_480H_FL1SL2O_yPer');
simList = {'120W_5D_60L_120F_120S_480H'};
% ensembleDir = 'E:\Molecular_Dynamics_Data\FL1SL2O\DualLayer_MonoOrifice_Hopper_07_2020\Reflective_Y_DualLayer_Hopper_Ensemble';
% fileName = strcat('Na_Ni_mesh_3multi_H_FL1SL2O_yRef');
% simList = {'120W_5D_60L_120F_120S';'120W_5D_60L_120F_120S_120H';'120W_5D_60L_120F_120S_480H'};

allMaxCountA = 0;
allMaxCountI = 0;
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
    meanA = mean(countA(:,:,tStart:tStop),3);
    countAMaxMean =max(meanA,[],'all');
    if max(countAMaxMean,[],'all') > allMaxCountA
        allMaxCountA = max(countAMaxMean,[],'all');
    end
    meanI = mean(countI(:,:,tStart:tStop),3);
    countIMaxMean = max(meanI,[],'all');
    if max(countIMaxMean,[],'all') > allMaxCountI
        allMaxCountI = max(countIMaxMean,[],'all');
    end
end

titles = {'~\qquad~\qquad~Argon,~$H=0\sigma$~\qquad~\qquad~(a)'; '~\qquad~\qquad~Impurity,~$H=0\sigma$~\qquad~\qquad~(b)'; '~\qquad~\qquad~Argon,~$H=120\sigma$~\qquad~\qquad~(c)'; '~\qquad~\qquad~Impurity,~$H=120\sigma$~\qquad~\qquad~(d)';'~\qquad~\qquad~Argon,~$H=480\sigma$~\qquad~\qquad~(e)'; '~\qquad~\qquad~Impurity,~$H=480\sigma$~\qquad~\qquad~(f)'};
meshFig =figure('Visible','on');
tiledlayout(size(simList,1),2, 'Padding', 'tight', 'TileSpacing', 'tight');

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
    binsY = yCentered(1,:);

    sliceIndx = size(x,1);% - 5; %How far from edge of filter do we sum particles
    edgeSumA = sum(countA(sliceIndx,:,:),3)/sum(countA(sliceIndx,:,:),'all')*100;%./(hopperArgon(1)-hopperArgon(size(hopperArgon,1)));
    edgeSumI = sum(countI(sliceIndx,:,:),3)/sum(countI(sliceIndx,:,:),'all')*100;%./(hopperImpurity(1)-hopperImpurity(size(hopperImpurity)));

    meanA = mean(countA(:,:,tStart:tStop),3);
    countAMaxMean =max(meanA,[],'all');
    meanI = mean(countI(:,:,tStart:tStop),3);
    countIMaxMean = max(meanI,[],'all');
    uAMean = mean(uA(:,:,tStart:tStop),3);
    vAMean = mean(vA(:,:,tStart:tStop),3);
    uIMean = mean(uI(:,:,tStart:tStop),3);
    vIMean = mean(vI(:,:,tStart:tStop),3);    

    nexttile()

    axA = gca;
    hold on
    surf(xCentered,yCentered,meanA');
    colormap(parula);
    clim([0 countAMaxMean]);
    ylim([binsY(2) binsY(size(binsY,2))]);
    xlim([0 xCentered(1,size(xCentered,2)-1)]);
    yticks(-600:120:600);
    xticks(0:120:1000);
    xticklabels('');
    title(titles(i*2-1),'Interpreter','Latex');
    if i == size(simList,1)
        hcolorBarA = colorbar(axA,'location','southoutside');
        ylabel(hcolorBarA, "$\langle N_A \rangle_t$", 'Interpreter', 'latex','FontSize',9);
        xlim([360 xCentered(1,size(xCentered,2)-1)]);
        xticklabels(string(xticks-360));
        xlabel("$x'/\sigma$ (Dimensionless)",'Interpreter','Latex');
    end
    ylabel("$y'/\sigma$ (Dimensionless)",'Interpreter','Latex');
    view(0,90);

    quiver3(xCentered'+10, yCentered'+10, zeros(size(xCentered,2),size(xCentered,2))+countAMaxMean, uAMean'*25, vAMean'*25, zeros(size(xCentered,2),size(xCentered,2)), 'AutoScale', 'off', 'Color' ,'w','MaxHeadSize',5);
    xLeft = xCentered(orificeIndices(1,1,1));%*20-20;
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
    yRight = yCentered(orificeIndices(1,2,2));
    zCut = countAMaxMean;
    patch( [xLeft xLeft xLeft+filterDepth xLeft+filterDepth], [-2000 yLeft yLeft -2000], [zCut zCut zCut zCut], 'w');
    patch( [xLeft xLeft xLeft+filterDepth xLeft+filterDepth], [yLeft+orificeWidth 2000 2000 yLeft+orificeWidth], [zCut zCut zCut zCut], 'w');
    patch( [xRight xRight xRight+filterDepth xRight+filterDepth], [-2000 yRight yRight -2000], [zCut zCut zCut zCut], 'w');
    patch( [xRight xRight xRight+filterDepth xRight+filterDepth], [yRight+orificeWidth yRight+2*orificeWidth yRight+2*orificeWidth yRight+orificeWidth], [zCut zCut zCut zCut], 'w');
    patch( [xRight xRight xRight+filterDepth xRight+filterDepth], [yRight+3*orificeWidth 2000 2000 yRight+3*orificeWidth], [zCut zCut zCut zCut], 'w');
    set(axA,'TickDir','out');
    hold off

    nexttile()
    axI = gca;
    hold on
    surf(xCentered,yCentered,meanI');
    quiver3(xCentered'+10, yCentered'+10, zeros(size(xCentered,2),size(xCentered,2))+countIMaxMean, uIMean'*100, vIMean'*100, zeros(size(xCentered,2),size(xCentered,2)), 'AutoScale', 'off', 'Color' ,'w');%, 'LineWidth',2);%,'MaxHeadSize',5);
    colormap(parula);
    clim([0 countIMaxMean]);
    ylim([binsY(2) binsY(size(binsY,2))]);
    xlim([0 xCentered(1,size(xCentered,2)-1)]);
    yticks(-600:120:600);
    xticks(-600:120:6000);
    xticklabels('');
    yticklabels('');
    if i == size(simList,1)
        hcolorBar = colorbar(axI,'location','southoutside');
        ylabel(hcolorBar, "$\langle N_I \rangle_t$", 'Interpreter', 'latex','FontSize',9); 
        xlim([360 xCentered(1,size(xCentered,2)-1)]);
        xticklabels(string(xticks-360));    
        xlabel("$x'/\sigma$ (Dimensionless)",'Interpreter','Latex');
    end
    title(titles(i*2),'Interpreter','Latex');
%     ylabel("$y'/\sigma$ (Dimensionless)",'Interpreter','Latex');
    view(0,90);
    zCut = countIMaxMean;  
    patch( [xLeft xLeft xLeft+filterDepth xLeft+filterDepth], [-2000 yLeft yLeft -2000], [zCut zCut zCut zCut], 'w');
    patch( [xLeft xLeft xLeft+filterDepth xLeft+filterDepth], [yLeft+orificeWidth 2000 2000 yLeft+orificeWidth], [zCut zCut zCut zCut], 'w');
    patch( [xRight xRight xRight+filterDepth xRight+filterDepth], [-2000 yRight yRight -2000], [zCut zCut zCut zCut], 'w');
    patch( [xRight xRight xRight+filterDepth xRight+filterDepth], [yRight+orificeWidth yRight+2*orificeWidth yRight+2*orificeWidth yRight+orificeWidth], [zCut zCut zCut zCut], 'w');
    patch( [xRight xRight xRight+filterDepth xRight+filterDepth], [yRight+3*orificeWidth 2000 2000 yRight+3*orificeWidth], [zCut zCut zCut zCut], 'w');
    set(axI,'TickDir','out');
end
exportgraphics(meshFig,strcat(fileName,".png"));
exportgraphics(meshFig,strcat(fileName,".eps"));
savefig(meshFig,strcat(fileName,".fig"));
end