function [] = scratch_Na_Ni_hist()%ensembleDir, figDir, doPlot)
%[outFlowAngleLabels,sortedOutFlowAngleData] = separation_ensemble_outflow_count(ensembleDir, figDir, doPlot)
%Given mesh data, calculate outflow count by distance and angle, optionally plot histograms
%   Inputs are directory of simulation ensemble, directory to save figures,
%   and a boolean flag for if plots should be performed. Output is label of
%   data sets and sorted outflow angles. Looping through ensemble directory
%   we perform analysis counting the number of particles some distance from
%   the far filter edge. Optionally plot histograms and gaussian fit of the
%   aforementioned data.

ensembleDir = 'E:\Data\Molecular_Dynamics_Data\FL1SL2O\DualLayer_MonoOrifice_Hopper_07_2020\Assymetric_DualLayer_Hopper_Ensemble';
figDir = 'E:\Data\Molecular_Dynamics_Data\FL1SL2O\DualLayer_MonoOrifice_Hopper_07_2020\Assymetric_DualLayer_Hopper_Ensemble\Figures_FL1SL2O_Na_Ni_Vcm_5D_Varied_H';
% selectedVars = {'v_hopperArgonCount','v_hopperArgonCount'};
    
t1 = 21;
t2 = 201;
t3 = 2001;
% varList = {'Step'; 'TotEng'; 'KinEng'; 'PotEng'; 'c_gasTemp'; 'Press'; 'v_hopperPress'; 'c_hopperVx'; 'v_hopperArgonCount'; 'v_hopperImpurityCount'; 'v_interLayerPress'; 'c_interLayerVx'; 'v_interLayerArgonCount'; 'v_interLayerImpurityCount'};

% debug = 0;
% if debug == 1
%     % rootDir = 'E:\Data\Molecular_Dynamics_Data\Focused_Mesh_07_2020\Assymetric_Dual_Layer_Periodic_Ensemble';
%     rootDir = pwd;
% end
fileName = strcat('Na_Ni_hist_Multi_H');
hFig =figure('Visible','on');
hold on;
tiledlayout(2,1, 'Padding', 'tight', 'TileSpacing', 'tight');
tiledlayout(3,1, 'Padding', 'tight', 'TileSpacing', 'tight');
% titles = {'(a)'; '$H=0\sigma$ (b)'; '$H=0\sigma$ \quad (c)';'(d)'; '\qquad (e)'; '$H=60\sigma$ \quad (f)'; '(g)'; '$H=120\sigma$ (h)'; '\qquad (i)';'(j)'; '$H=480\sigma$ (k)';'\qquad (l)'};
% rootDir = ensembleDir;
% rootList = dir(rootDir);
n=0;
edgeSumsA = zeros(28,5);
edgeSumsI = zeros(28,5);
legendVals = ["$H=0\sigma$"; "$H=120\sigma$"; "$H=480\sigma$" ];
simList = {'120W_5D_60L_120F_120S'; '120W_5D_60L_120F_120S_120H';'120W_5D_60L_120F_120S_480H'};
% legendVals = ["$H=0\sigma$"; "$H=60\sigma$"; "$H=120\sigma$"; "$H=240\sigma$"; "$H=480\sigma$" ];
% simList = {'120W_5D_60L_120F_120S'; '120W_5D_60L_120F_120S_60H';'120W_5D_60L_120F_120S_120H';'120W_5D_60L_120F_120S_240H';'120W_5D_60L_120F_120S_480H'};
% simList = {'120W_2D_60L_120F_120S'; '120W_2D_60L_120F_120S_60H';'120W_2D_60L_120F_120S_120H';'120W_2D_60L_120F_120S_240H';'120W_2D_60L_120F_120S_480H'};
% simList = {'120W_5D_60L_120F_120S_60H';'120W_5D_60L_120F_120S_480H'};
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
     
%     [steps, ~] = select_thermo_var(varNames, ensembleAvgVals, ensembleStdVals, 'Step');
%     time = steps/200;
%     clear steps
%     hopperArgon = select_thermo_var(varNames, ensembleAvgVals, ensembleStdVals, 'v_hopperArgonCount');
%     if impurityDiameter > 1
%         hopperImpurity = select_thermo_var(varNames, ensembleAvgVals, ensembleStdVals, 'v_hopperImpurityCount');
%         [fitLineI, fitGoodnessI] = therm_variable_fit( time, hopperImpurity);
%     else
%         uI = 0;
%         vI = 0;
%         countI = 0;
%         fitLineI = 0;
%         fitGoodnessI = 0;
%     end
%     [fitLineA, fitGoodnessA] = therm_variable_fit( time, hopperArgon);
     
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
    if i == 1 
        binsY = yCentered(1,:);
    end
    % [edgeSumA,edgeSumI] = edgeSumCount(t,countA,countI);
    truncate = 28;
    sliceIndx = size(x,1);% - 5; %How far from edge of filter do we sum particles
    % edgeSumA = sum(countA(sliceIndx,:,:),3)./(hopperArgon(1)-hopperArgon(size(hopperArgon,1)));
    edgeSumA = sum(countA(sliceIndx,:,:),3)./sum(countA(sliceIndx,:,:),'all')*100;%./(hopperArgon(1)-hopperArgon(size(hopperArgon,1)));
    edgeSumsA(:,i) = edgeSumA(sliceIndx-truncate+1:sliceIndx);
    %     edgeSumA = sum(countA(sliceIndx,:,:),3);%./(hopperArgon(1)-hopperArgon(size(hopperArgon,1)));
%     argonPower = ceil(log10(max(edgeSumA)-1))-1;
    %     edgeSumI = sum(countI(sliceIndx,:,:),3)./(hopperImpurity(1)-hopperImpurity(size(hopperImpurity)));
    edgeSumI = sum(countI(sliceIndx,:,:),3)./sum(countI(sliceIndx,:,:),'all')*100;%./(hopperImpurity(1)-hopperImpurity(size(hopperImpurity)));
    edgeSumsI(:,i) = edgeSumI(sliceIndx-truncate+1:sliceIndx);
%     edgeSumI = sum(countI(sliceIndx,:,:),3);%./(hopperImpurity(1)-hopperImpurity(size(hopperImpurity)));
%     impurityPower = ceil(log10(max(edgeSumI)-1))-1;
%     edgeCounts = [edgeSumA; edgeSumI];
    
    
    % tickSpacing = 120;
    % yHigh = round(max(centeredY)/tickSpacing);
    % yLow = -yHigh;
    % xTic = (yLow:1:yHigh)*tickSpacing;
end
nexttile
% barh(binsY,[edgeSumI; edgeSumA],'grouped');
bar(binsY,edgeSumsA,'grouped');
%     [argonLine,argonGood,argonEtc] = fit(binsY',edgeSumA','gauss2','StartPoint',[2*10^4,-120,60,2*10^4,120,60]);
xlim([0 6]);
ylabel(strcat('$N_A ~(\%)$'),'Interpreter','Latex');
xlabel("$y'~(\sigma)$",'Interpreter','Latex');
title('(a)','Interpreter','Latex');
xlim([binsY(1) binsY(size(binsY,2))]);
xticks(-600:60:600);


    % fitCoef = coeffvalues(argonLine);
    % mean1=fitCoef(1,2);
    % mean2=fitCoef(1,5);
    % argonAngles = [mean1, mean2];
    % sigma1=fitCoef(1,3);
    % sigma2=fitCoef(1,6);
    % argonStddevs = [sigma1, sigma2];
    % coefConfInt = confint(argonLine);
    
    % plot(argonLine);
%     argonCurve = argonLine(binsY);
%     plot(argonCurve,binsY);
%     legend('off');
    % ylabel(strcat('$N_A~(10^{',num2str(argonPower),'})$'),'Interpreter','Latex');
%     hAx = gca;
%     hAx.XAxis.Exponent = argonPower;
    % ylim([0 27500]);
    % yTic = yticks;
    % yticklabels(yTic/(10^argonPower));
    % xticks(xTic);
    % xlim([yLow*tickSpacing-40 yHigh*tickSpacing+40]);

% hold off
    
    nexttile
%     ax2 = gca;
%     hold on
    bar(binsY,edgeSumsI,'grouped');
%     [impurityLine,impurityGood,impurityEtc] = fit(binsY',edgeSumI','gauss2','StartPoint',[5*10^3,-120,60,5*10^4,120,60]);
%     impurityCurve = impurityLine(binsY);
    % plot(impurityLine);
%     plot(impurityCurve,binsY);
%     legend('off');
    ylabel(strcat('$N_I ~(\%)$'),'Interpreter','Latex');
%     ylim([0 10]);
    % ylabel(strcat('$N_I~(10^{',num2str(impurityPower),'})$'),'Interpreter','Latex');
%     hAx = gca;
%     hAx.XAxis.Exponent = impurityPower;
    % ylim([0 2750]);
    % yTic = yticks;
    % yticklabels(yTic/(10^impurityPower));
    xlabel("$y'~(\sigma)$",'Interpreter','Latex');
    % xticks(xTic);
    % xlim([yLow*tickSpacing-40 yHigh*tickSpacing+40]);
    title('(b)','Interpreter','Latex');
    xlim([binsY(1) binsY(size(binsY,2))]);
%     xticks(yCentered(1,1):120:yCentered(1,size(yCentered,2)));
    xticks(-600:60:600);
% hold off
    legend(legendVals,'Location','southoutside','NumColumns',3,'Interpreter','latex');

cd(figDir);
set(hFig,'Units','Centimeter','Position',[0 0 8.6 8.6]);
exportgraphics(hFig,strcat(fileName,".png"));
exportgraphics(hFig,strcat(fileName,".eps"));
savefig(hFig,strcat(fileName,".fig"));
close(hFig);
end