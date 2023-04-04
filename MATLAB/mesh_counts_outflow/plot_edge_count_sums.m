function [outFlowAngleLabels,outFlowAngleData] = plot_edge_count_sums(simString,edgeCountA,edgeCountSumI,lowTheta,upTheta,centeredX,centeredY,sliceIndx,figDir,saveplots)
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here

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

edgeSumA = sum(edgeCountA(sliceIndx,:,:),3);
for i = 1 : 1 : size(centeredY,2)
    if centeredY(1,i) > 0
        yCenterIndex = i;
        break;
    end
end

argonPower = ceil(log10(max(edgeSumA)-1))-1;
if size(edgeCountI,1) > 1 
    edgeSumI = sum(edgeCountI(sliceIndx,:,:),3);
    impurityPower = ceil(log10(max(edgeSumI)-1))-1;
    nCol = 2;
    aRow = [1,3,5];
else
    nCol = 1;
    aRow = [1,2,3];
end
titles = ['(a)';'(b)';'(c)';'(d)';'(e)';'(f)'];
fileName = strcat(simString,'_count_slice_',num2str(centeredX(sliceIndx)));
tickSpacing = 120;
yHigh = round(max(centeredY)/tickSpacing);
yLow = -yHigh;
xTic = (yLow:1:yHigh)*tickSpacing;

hFig =figure('Visible','off');
title(fileName);
binsY = centeredY(1,:);
binsLowTheta = lowTheta(sliceIndx,:);
binsUpTheta = upTheta(sliceIndx,:);

subplot(3,nCol,aRow(1));
hold on;
bar(binsY,edgeSumA,'grouped');

[argonLine,argonGood,argonEtc] = fit(binsY',edgeSumA','gauss2','StartPoint',[2*10^4,-120,60,2*10^4,120,60]);

% fitCoef = coeffvalues(argonLine);
% mean1=fitCoef(1,2);
% mean2=fitCoef(1,5);
% argonAngles = [mean1, mean2];
% sigma1=fitCoef(1,3);
% sigma2=fitCoef(1,6);
% argonStddevs = [sigma1, sigma2];
% coefConfInt = confint(argonLine);

plot(argonLine);
legend('off');
ylabel(strcat('$N_A~(10^{',num2str(argonPower),'})$'),'Interpreter','Latex');
hAx = gca;
hAx.YAxis.Exponent = 0;
ylim([0 27500]);
yTic = yticks;
yticklabels(yTic/(10^argonPower));
xlabel("$y'~(r^*)$",'Interpreter','Latex');
xticks(xTic);
xlim([yLow*tickSpacing-40 yHigh*tickSpacing+40]);
title(titles(1,:),'Interpreter','none');

subplot(3,nCol,aRow(2));
hold on;
scatter(binsLowTheta(1:yCenterIndex-1),edgeSumA(1:yCenterIndex-1));
% bar(binsLowTheta,edgeSumA,'grouped');
[lowArgonLine,lowArgonGood,lowArgonEtc] = fit(binsLowTheta(1:yCenterIndex-1)',edgeSumA(1:yCenterIndex-1)','gauss1','StartPoint',[2*10^4,0,45]);
% [lowArgonLine,lowArgonGood,lowArgonEtc] = fit(binsLowTheta',edgeSumA','gauss2','StartPoint',[2*10^4,-75,45,2*10^4,0,5]);

fitCoef = coeffvalues(lowArgonLine);
argonAngleLow=fitCoef(1,2);
argonStddevLow=fitCoef(1,3);
% argonAngleLow=fitCoef(1,5);
% argonStddevLow=fitCoef(1,6);

plot(lowArgonLine);
legend('off');
ylabel(strcat('$N_A~(10^{',num2str(argonPower),'})$'),'Interpreter','Latex');
hAx = gca;
hAx.YAxis.Exponent = 0;
ylim([0 27500]);
yTic = yticks;
% yticklabels(yTic/sum(edgeSumA(1:yCenterIndex-1)));
yticklabels(yTic/(10^argonPower));
xlabel('$\Phi_{Lower}~( deg.)$','Interpreter','Latex');
xlim([-45 45]);
% xlim([-60 60]);
title(titles(2,:),'Interpreter','none');

subplot(3,nCol,aRow(3));
hold on;
% bar(binsUpTheta,edgeSumA,'grouped');
scatter(binsUpTheta(yCenterIndex:size(centeredY,2)),edgeSumA(yCenterIndex:size(centeredY,2)));
[upArgonLine,upArgonGood,upArgonEtc] = fit(binsUpTheta(yCenterIndex:size(centeredY,2))',edgeSumA(yCenterIndex:size(centeredY,2))','gauss1','StartPoint',[2*10^4,0,45]);
% [upArgonLine,upArgonGood,upArgonEtc] = fit(binsUpTheta',edgeSumA','gauss2','StartPoint',[2*10^4,0,45,2*10^4,75,45]);

fitCoef = coeffvalues(upArgonLine);
argonAngleUp=fitCoef(1,2);
argonStddevUp=fitCoef(1,3);
% coefConfInt = confint(argonLine);

plot(upArgonLine);
legend('off');
ylabel(strcat('$N_A~(10^{',num2str(argonPower),'})$'),'Interpreter','Latex');
hAx = gca;
hAx.YAxis.Exponent = 0;
ylim([0 27500]);
yTic = yticks;
% yticklabels(yTic/sum(edgeSumA(yCenterIndex:size(centeredY,2))));
yticklabels(yTic/(10^argonPower));
xlabel('$\Phi_{Upper}~( deg.)$','Interpreter','Latex');
% xlim([-60 60]);
xlim([-45 45]);
title(titles(3,:),'Interpreter','none');

% argonAngles = [argonAngleUp,argonAngleLow];
% argonStddevs = [argonStddevLow,argonStddevUp];

if nCol == 2
    subplot(3,nCol,aRow(1)+1);
    hold on;
    title(titles(4),'Interpreter','none');
    bar(binsY,edgeSumI,'grouped');
    [impurityLine,impurityGood,impurityEtc] = fit(binsY',edgeSumI','gauss2','StartPoint',[2*10^4,-120,60,2*10^4,120,60]);

%     fitCoef = coeffvalues(impurityLine);
%     mean1=fitCoef(1,2);
%     mean2=fitCoef(1,5);
%     impurityAngles = [mean1, mean2];
%     sigma1=fitCoef(1,3);
%     sigma2=fitCoef(1,6);
%     impurityStddevs = [sigma1, sigma2];
%     coefConfInt = confint(argonLine);

    plot(impurityLine);
    legend('off');
    ylabel(strcat('$N_I~(10^{',num2str(impurityPower),'})$'),'Interpreter','Latex');
    hAx = gca;
    hAx.YAxis.Exponent = 0;
    ylim([0 2750]);
    yTic = yticks;
    yticklabels(yTic/(10^impurityPower));
    xlabel("$y'~(r^*)$",'Interpreter','Latex');
    xticks(xTic);
    xlim([yLow*tickSpacing-40 yHigh*tickSpacing+40]);
    title(titles(4,:),'Interpreter','none');

    subplot(3,nCol,aRow(2)+1);
    title(titles(5),'Interpreter','none');
    hold on;
%     bar(binsLowTheta,edgeSumI,'grouped');
    scatter(binsLowTheta(1:yCenterIndex-1),edgeSumI(1:yCenterIndex-1));
    [lowImpurityLine,lowImpurityGood,lowImpurityEtc] = fit(binsLowTheta(1:yCenterIndex-1)',edgeSumI(1:yCenterIndex-1)','gauss1','StartPoint',[2*10^4,0,45]);
%     [lowImpurityLine,lowImpurityGood,lowImpurityEtc] = fit(binsLowTheta',edgeSumI','gauss2','StartPoint',[2*10^4,-75,45,2*10^4,0,5]);
    
    fitCoef = coeffvalues(lowImpurityLine);
    impurityAngleLow=fitCoef(1,2);
    impurityStddevLow=fitCoef(1,3);    
%     impurityAngleLow=fitCoef(1,5);
%     impurityStddevLow=fitCoef(1,6);
    coefConfInt = confint(argonLine);
    
    plot(lowImpurityLine);
    legend('off');
    ylabel(strcat('$N_I~(10^{',num2str(impurityPower),'})$'),'Interpreter','Latex');
    hAx = gca;
    hAx.YAxis.Exponent = 0;
    ylim([0 2750]);
    yTic = yticks;
%     yticklabels(yTic/sum(edgeSumI(1:yCenterIndex-1)));    
    yticklabels(yTic/(10^impurityPower));    
    xlabel('$\Phi_{Lower}~( deg.)$','Interpreter','Latex');
%     xlim([-60 60]);
    xlim([-45 45]);
    title(titles(5,:),'Interpreter','none');
    
    subplot(3,nCol,aRow(3)+1);
    title(titles(6),'Interpreter','none');
    hold on;
    scatter(binsUpTheta(yCenterIndex:size(centeredY,2)),edgeSumI(yCenterIndex:size(centeredY,2)));
    [upImpurityLine,upImpurityGood,upImpurityEtc] = fit(binsUpTheta(yCenterIndex:size(centeredY,2))',edgeSumI(yCenterIndex:size(centeredY,2))','gauss1','StartPoint',[2*10^4,0,45]);
%     scatter(binsUpTheta(yCenterIndex:size(centeredY,2)),edgeSumI(yCenterIndex:size(centeredY,2))/sum(edgeSumI(yCenterIndex:size(centeredY,2))));
%     [upImpurityLine,upImpurityGood,upImpurityEtc] = fit(binsUpTheta(yCenterIndex:size(centeredY,2))',edgeSumI(yCenterIndex:size(centeredY,2))'/sum(edgeSumI(yCenterIndex:size(centeredY,2))),'gauss1','StartPoint',[2*10^4,0,45]);
%     bar(binsUpTheta,edgeSumI,'grouped');
%     [upImpurityLine,upImpurityGood,upImpurityEtc] = fit(binsUpTheta',edgeSumI','gauss2','StartPoint',[2*10^4,0,45,2*10^4,75,45]);
        
    fitCoef = coeffvalues(upImpurityLine);
    impurityAngleUp=fitCoef(1,2);
    impurityStddevUp=fitCoef(1,3);
    coefConfInt = confint(argonLine);
    
    plot(upImpurityLine);
    legend('off');    
%     ylabel(strcat('$N_I~($\%$)$'),'Interpreter','Latex');
    ylabel(strcat('$N_I~(10^{',num2str(impurityPower),'})$'),'Interpreter','Latex');
    hAx = gca;
    hAx.YAxis.Exponent = 0;
    ylim([0 2750]);
    yTic = yticks;
%     yticklabels(yTic/sum(edgeSumI(yCenterIndex:size(centeredY,2))));
    yticklabels(yTic/(10^impurityPower));
    xlabel('$\Phi_{Upper}~( deg.)$','Interpreter','Latex');
%     xlim([-60 60]);
    xlim([-45 45]);
    title(titles(6,:),'Interpreter','none');
    
else
    impurityAngleUp = 0;
    impurityAngleLow = 0;
    impurityStddevUp = 0;
    impurityStddevLow = 0;
end

if saveplots ~= 0
    set(hFig,'Units','Centimeters','Position',[0 0 8.6 8.6]);
    set(findall(hFig,'-property','FontSize'),'FontSize',9);
    cd(figDir);
    exportgraphics(hFig,strcat(fileName,".png"));
    exportgraphics(hFig,strcat(fileName,".eps"));
    savefig(hFig,strcat(fileName,".fig"));
end
close(hFig);

offsetAngle = rad2deg(atan((registryShift-orificeWidth/2-orificeSpacing/2)/filterSeparation));
outFlowAngleLabels = ["orificeWidth", "impurityDiameter", "filterDepth", "filterSeparation", "orificeSpacing", "registryShift", "offsetAngle", "argonAngleLow", "argonStddevLow","argonAngleUp", "argonStddevUp","impurityAngleLow", "impurityStddevLow","impurityAngleUp", "impurityStddevUp"];
outFlowAngleData = [orificeWidth, impurityDiameter, filterDepth, filterSeparation, orificeSpacing, registryShift, argonAngleLow, offsetAngle, argonStddevLow,argonAngleUp, argonStddevUp,impurityAngleLow, impurityStddevLow,impurityAngleUp, impurityStddevUp];

end

