function [SL1AFitCurve,SL1AFitGoodness,SL1IFitCurve,SL1IFitGoodness] = Phi_vel_SL_mean_trends_plot_FL1(phiStatData,dataLabels,figDir)
%Plots collated outflow angles and internal flow angle calculated from mean
%velocity components.
%   Iterates over simulation folders to calculate the flow angle in various
%   regions

cd(figDir);
debug = 1;
% plotBoth = 1; plotFits = 1;
plotBoth = 0; plotFits = 1;
% plotBoth = 1; plotFits = 0;

parVar = 'Delta';
nameTags = {'SL[1], Ar.','SL[2], Ar.','SL[1], Im.','SL[2], Im.'};

sortedPhiStatData = sortrows(phiStatData, [4 2]); %Sort with 'D' most rapidly varying
parVals = sortedPhiStatData(:,parCols);
meanSL1A = sortedPhiStatData(:,3);
meanSL2A = sortedPhiStatData(:,4);
stdSL1A = sortedPhiStatData(:,5);
stdSL2A = sortedPhiStatData(:,6);
weightSL1A = 1./stdSL1A.^2;
weightSL2A = 1./stdSL2A.^2;

shift = 3;
stride = 3;
if strcmp(parVar,"D")
    meanSL1I = [sortedPhiStatData(1,3); sortedPhiStatData(2:size(parVals),7)];
    meanSL2I = [sortedPhiStatData(1,4); sortedPhiStatData(2:size(parVals),8)];
    stdSL1I = [sortedPhiStatData(1,5); sortedPhiStatData(2:size(parVals),9)];
    stdSL2I = [sortedPhiStatData(1,6); sortedPhiStatData(2:size(parVals),10)];
else
    meanSL1I = sortedPhiStatData(:,7);
    meanSL2I = sortedPhiStatData(:,8);
    stdSL1I = sortedPhiStatData(:,9);
    stdSL2I = sortedPhiStatData(:,10);
end
weightSL1I = 1./stdSL1I.^2;
weightSL2I = 1./stdSL2I.^2;

[linSL1AFitCurve,linSL1AFitGoodness, linSL1AFitOutput] = fit(parVals,meanSL1A,'poly1','Weights',weightSL1A);
[expSL1AFitCurve,expSL1AFitGoodness, expSL1AFitOutput] = fit(parVals,meanSL1A,'exp1','Weights',weightSL1A);
[powSL1AFitCurve,powSL1AFitGoodness, powSL1AFitOutput] = fit(parVals,meanSL1A,'power1','Weights',weightSL1A);

[linSL2AFitCurve,linSL2AFitGoodness, linSL2AFitOutput] = fit(parVals,meanSL2A,'poly1','Weights',weightSL2A);
if ((1-linSL1AFitGoodness.adjrsquare) < 0.05) && ((1-linSL1AFitGoodness.adjrsquare) < (1-powSL1AFitGoodness.adjrsquare)-0.01) && ((1-linSL1AFitGoodness.adjrsquare) < (1-expSL1AFitGoodness.adjrsquare)-0.01)
    SL1AFitCurve = linSL1AFitCurve;
    SL1AFitGoodness = linSL1AFitGoodness;
    SL1AFitLabel = 'Lin. Trend';
elseif ((1-linSL1AFitGoodness.adjrsquare) < 0.05) && ((1-expSL1AFitGoodness.adjrsquare) < (1-powSL1AFitGoodness.adjrsquare)-0.01) && ((1-expSL1AFitGoodness.adjrsquare) < (1-linSL1AFitGoodness.adjrsquare)-0.01)
    SL1AFitCurve = expSL1AFitCurve;
    SL1AFitGoodness = expSL1AFitGoodness;
    SL1AFitLabel = 'Exp. Trend';
elseif ((1-linSL1AFitGoodness.adjrsquare) < 0.05) && ((1-powSL1AFitGoodness.adjrsquare) < (1-expSL1AFitGoodness.adjrsquare)-0.01) && ((1-powSL1AFitGoodness.adjrsquare) < (1-linSL1AFitGoodness.adjrsquare)-0.01)
    SL1AFitCurve = powSL1AFitCurve;
    SL1AFitGoodness = powSL1AFitGoodness;
    SL1AFitLabel = 'Alg. Trend';
else
    SL1AFitCurve = linSL1AFitCurve;
    SL1AFitGoodness = linSL1AFitGoodness;
    SL1AFitLabel = 'Lin. Trend';
end
[linSL1IFitCurve,linSL1IFitGoodness, linSL1IFitOutput] = fit(parVals,meanSL1I,'poly1','Weights',weightSL1I);
[expSL1IFitCurve,expSL1IFitGoodness, expSL1IFitOutput] = fit(parVals,meanSL1I,'exp1','Weights',weightSL1I);
[powSL1IFitCurve,powSL1IFitGoodness, powSL1IFitOutput] = fit(parVals,meanSL1I,'power1','Weights',weightSL1I);

[linSL2IFitCurve,linSL2IFitGoodness, linSL2IFitOutput] = fit(parVals,meanSL2I,'poly1','Weights',weightSL2I);

if ((1-linSL1IFitGoodness.adjrsquare) < 0.05) && ((1-linSL1IFitGoodness.adjrsquare) < (1-powSL1IFitGoodness.adjrsquare)-0.01) && ((1-linSL1IFitGoodness.adjrsquare) < (1-expSL1IFitGoodness.adjrsquare)-0.01)
    SL1IFitCurve = linSL1IFitCurve;
    SL1IFitGoodness = linSL1IFitGoodness;
    SL1IFitLabel = 'Lin. Trend';
elseif ((1-expSL1IFitGoodness.adjrsquare) < 0.05) && ((1-expSL1IFitGoodness.adjrsquare) < (1-powSL1IFitGoodness.adjrsquare)-0.01) && ((1-expSL1IFitGoodness.adjrsquare) < (1-linSL1IFitGoodness.adjrsquare)-0.01)
    SL1IFitCurve = expSL1IFitCurve;
    SL1IFitGoodness = expSL1IFitGoodness;
    SL1IFitLabel = 'Exp. Trend';
elseif ((1-powSL1IFitGoodness.adjrsquare) < 0.05) && ((1-powSL1IFitGoodness.adjrsquare) < (1-expSL1IFitGoodness.adjrsquare)-0.01) && ((1-powSL1IFitGoodness.adjrsquare) < (1-linSL1IFitGoodness.adjrsquare)-0.01)
    SL1IFitCurve = powSL1IFitCurve;
    SL1IFitGoodness = powSL1IFitGoodness;
    SL1IFitLabel = 'Alg. Trend';
else
    SL1IFitCurve = linSL1IFitCurve;
    SL1IFitGoodness = linSL1IFitGoodness;
    SL1IFitLabel = 'Lin. Trend';
end

%Plot Argon Angle as function of L
if debug == 1
    aFig = figure('Visible','on');
else
    aFig = figure('Visible','off');
end
hold on
errorbar(parVals,meanSL1A,stdSL1A,'rs','MarkerSize',4);
errorbar(parVals,meanSL1I,stdSL1I,'k.','MarkerSize',4);
if plotBoth == 1
    errorbar(parVals,meanSL2A,stdSL2A,'rd','MarkerSize',4);
    errorbar(parVals,meanSL2I,stdSL2I,'k*','MarkerSize',4);
end
if plotFits == 1
    plot(SL1AFitCurve,'-r');
    plot(SL1IFitCurve,':k');
end
if plotBoth ~= 1 && plotFits == 1
    legend([nameTags(1),nameTags(3),SL1AFitLabel,SL1IFitLabel],'NumColumns',2,'Interpreter','latex','Location','northwest');
    nameTag = strcat('Phi_vel_vs_',parVar,'_fit');
elseif plotBoth == 1 && plotFits == 1
    legend([nameTags(1),nameTags(3),nameTags(2),nameTags(4),SL1AFitLabel,SL1IFitLabel],'NumColumns',3,'Interpreter','latex','Location','northoutside');
    nameTag = strcat('Phi_vel_vs_',parVar,'_multi_fit');
elseif plotBoth == 1 && plotFits ~= 1
    legend([nameTags(1),nameTags(3),nameTags(2),nameTags(4)],'NumColumns',2,'Interpreter','latex','Location','northoutside');
    nameTag = strcat('Phi_vel_vs_',parVar,'_multi');
end
% xlim([0.5 10.5]);
xlim([20 420]);
ylabel('$\Phi~(deg.)$','Interpreter','latex');
% xlabel('$S$','Interpreter','latex');
% xlabel('$\Delta$','Interpreter','latex');
% xlabel('$H$','Interpreter','latex');
if strcmp(parVar,"F") || strcmp(parVar,"Delta") 
    xlabel(strcat('$\Delta$'),'Interpreter','latex');
else
    xlabel(strcat('$',parVar,'$'),'Interpreter','latex');
end

% if debug == 0
    set(aFig,'Units','Centimeters','Position',[0 0 8.6 8.6]); %Format figure for PRL
    set(findall(aFig,'-property','FontSize'),'FontSize',9);
    exportgraphics(aFig,strcat(nameTag,".png"));
    exportgraphics(aFig,strcat(nameTag,".eps"));
    savefig(aFig,strcat(nameTag,".fig"));
% else
%     exportgraphics(aFig,strcat(nameTag,".png"));
% end

close(aFig);
end
 
% %Plot Impurity Angle as function of L
% if debug == 1
%     sFig = figure('Visible','on');
% else
%     sFig = figure('Visible','off');
% end
% hold on
% plot(sVals,sortedPhiStatData((1:nSVals)+(i-1)*nSVals,15),'-r');
% plot(sVals,sortedPhiStatData((1:nSVals)+(i-1)*nSVals,16),'--r');
% plot(sVals,sortedPhiStatData((1:nSVals)+(i-1)*nSVals,19),'-k');
% plot(sVals,sortedPhiStatData((1:nSVals)+(i-1)*nSVals,20),'--k');
% legend([nameTags(5-3),nameTags(6-3),nameTags(9-3),nameTags(10-3)]);
% ylabel('Impurity Outflow Angle, $\Phi_I~(Deg.)$','Interpreter','latex');
% %             xlabel('Filter Layer Separation, $L~(r^*)$','Interpreter','latex');
% xlabel('Orifice Offset, $H~(r^*)$','Interpreter','latex');
% nameTag = strcat('Impurity_Upper_Separation_Trend_',num2str(dVals(i,1)),'D_',regime);
% exportgraphics(sFig,strcat(nameTag,".png"));
% if debug == 0
%     set(sFig,'Units','Centimeters','Position',[0 0 8.6 8.6]); %Format figure for PRL
%     set(findall(sFig,'-property','FontSize'),'FontSize',9);
%     exportgraphics(sFig,strcat(nameTag,".eps"));
%     savefig(sFig,strcat(nameTag,".fig"));
% end
% close(aFig);
% end
% end
% end
% if nDVals > 1
% sortedPhiStatData = sortrows(phiStatData,[1 2]);
% for i=1:1:nSVals
% %Plot Argon Angle as function of D
% if debug == 1
%     dFig = figure('Visible','on');
% else
%     dFig = figure('Visible','off');
% end
% hold on
% plot(dVals,sortedPhiStatData((1:nDVals)+(i-1)*nDVals,5),'-r');
% plot(dVals,sortedPhiStatData((1:nDVals)+(i-1)*nDVals,6),'--r');
% plot(dVals,sortedPhiStatData((1:nDVals)+(i-1)*nDVals,9),'-k');
% plot(dVals,sortedPhiStatData((1:nDVals)+(i-1)*nDVals,10),'--k');
% legend([nameTags(5-3),nameTags(6-3),nameTags(9-3),nameTags(10-3)]);
% ylabel('Argon Outflow Angle, $\Phi_A~(Deg.)$','Interpreter','latex');
% xlabel('Impurity Diameter, $D~(r^*)$','Interpreter','latex');
% %             nameTag = strcat('Argon_Upper_Diameter_Trend_',num2str(sVals(i,1)),'L_',regime);
% nameTag = strcat('Argon_Upper_Diameter_Trend_',num2str(sVals(i,1)),'H_',regime);
% exportgraphics(dFig,strcat(nameTag,".png"));
% if debug == 0
%     set(dFig,'Units','Centimeters','Position',[0 0 8.6 8.6]); %Format figure for PRL
%     set(findall(dFig,'-property','FontSize'),'FontSize',9);
%     exportgraphics(dFig,strcat(nameTag,".eps"));
%     savefig(dFig,strcat(nameTag,".fig"));
% end
% close(dFig);
% 
% %Plot Impurity Angle as function of D
% if debug == 1
%     dFig = figure('Visible','on');
% else
%     dFig = figure('Visible','off');
% end
% hold on
% plot(dVals,sortedPhiStatData((1:nDVals)+(i-1)*nDVals,15),'-r');
% plot(dVals,sortedPhiStatData((1:nDVals)+(i-1)*nDVals,16),'--r');
% plot(dVals,sortedPhiStatData((1:nDVals)+(i-1)*nDVals,19),'-k');
% plot(dVals,sortedPhiStatData((1:nDVals)+(i-1)*nDVals,20),'--k');
% legend([nameTags(5-3),nameTags(6-3),nameTags(9-3),nameTags(10-3)]);
% ylabel('Impurity Outflow Angle, $\Phi_I~(Deg.)$','Interpreter','latex');
% xlabel('Impurity Diameter, $D~(r^*)$','Interpreter','latex');
% %             nameTag = strcat('Argon_Upper_Diameter_Trend_',num2str(sVals(i,1)),'L_',regime);
% nameTag = strcat('Impurity_Upper_Diameter_Trend_',num2str(sVals(i,1)),'H_',regime);
% exportgraphics(dFig,strcat(nameTag,".png"));
% if debug == 0
%     set(dFig,'Units','Centimeters','Position',[0 0 8.6 8.6]); %Format figure for PRL
%     set(findall(dFig,'-property','FontSize'),'FontSize',9);
%     exportgraphics(dFig,strcat(nameTag,".eps"));
%     savefig(dFig,strcat(nameTag,".fig"));
% end
% close(dFig);
% for depricated = 1 %Place holder for code folding of depricated method.
    %for i=1:1:nDVals
    %     %Plot Argon Angle as function of D
    %     if debug == 1
    %         dFig = figure('Visible','on');
    %     else
    %         dFig = figure('Visible','off');
    %     end
    %     hold on
    %     plot(dVals,sortedMeanPhi(i:nSVals:nSVals*nDVals,5),'-r');
    %     plot(dVals,sortedMeanPhi(i:nSVals:nSVals*nDVals,6),'--r');
    %     plot(dVals,sortedMeanPhi(i:nSVals:nSVals*nDVals,9),'-k');
    %     plot(dVals,sortedMeanPhi(i:nSVals:nSVals*nDVals,10),'--k');
    %
    %     legend([nameTags(5-3),nameTags(6-3),nameTags(9-3),nameTags(10-3)]);
    %     ylabel('Argon Outflow Angle, $\Phi_A~(Deg.)$','Interpreter','latex');
    %     xlabel('Impurity Diameter, $D~(r^*)$','Interpreter','latex');
    %     nameTag = strcat('Argon_Upper_Diameter_Trend_',num2str(sVals(i,1)),'L_',regime);
    %     exportgraphics(dFig,strcat(nameTag,".png"));
    %     if debug == 0
    %         set(dFig,'Units','Centimeters','Position',[0 0 8.6 8.6]); %Format figure for PRL
    %         set(findall(dFig,'-property','FontSize'),'FontSize',9);
    %         exportgraphics(dFig,strcat(nameTag,".eps"));
    %         savefig(dFig,strcat(nameTag,".fig"));
    %     end
    %     close(dFig);
    %
    %     %Plot Impurity Angle as function of D
    %     if debug == 1
    %         dFig = figure('Visible','on');
    %     else
    %         dFig = figure('Visible','off');
    %     end
    %     hold on
    %     plot(dVals(2:nDVals),sortedMeanPhi(i+nDVals:nSVals:nSVals*nDVals,15),'-r');
    %     plot(dVals(2:nDVals),sortedMeanPhi(i+nDVals:nSVals:nSVals*nDVals,16),'--r');
    %     plot(dVals(2:nDVals),sortedMeanPhi(i+nDVals:nSVals:nSVals*nDVals,19),'-k');
    %     plot(dVals(2:nDVals),sortedMeanPhi(i+nDVals:nSVals:nSVals*nDVals,20),'--k');
    %
    %     legend([nameTags(5-3),nameTags(6-3),nameTags(9-3),nameTags(10-3)]);
    %     ylabel('Impurity Outflow Angle, $\Phi_I~(Deg.)$','Interpreter','latex');
    %     xlabel('Impurity Diameter, $D~(r^*)$','Interpreter','latex');
    %     nameTag = strcat('Impurity_Upper_Diameter_Trend_',num2str(sVals(i,1)),'L_',regime);
    %     exportgraphics(dFig,strcat(nameTag,".png"));
    %     if debug == 0
    %         set(dFig,'Units','Centimeters','Position',[0 0 8.6 8.6]); %Format figure for PRL
    %         set(findall(dFig,'-property','FontSize'),'FontSize',9);
    %         exportgraphics(dFig,strcat(nameTag,".eps"));
    %         savefig(dFig,strcat(nameTag,".fig"));
    %     end
    %     close(dFig);
% end