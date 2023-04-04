function [outFlowAngleLabels,outFlowAngleData] = plot_edge_count_grid(simString,edgeCountA,edgeCountI,lowTheta,upTheta,centeredX,centeredY,sliceIndx,figDir,separation,impurityDiameter,saveplots)
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here

edgeSumA = sum(edgeCountA(sliceIndx,:,:),3);
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
tickSpacing = 240;
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
yTic = yticks;
yticklabels(yTic/(10^argonPower));
xlabel("$y'~(r^*)$",'Interpreter','Latex');
xticks(xTic);
xlim([yLow*tickSpacing-40 yHigh*tickSpacing+40]);
title(titles(1,:),'Interpreter','none');

subplot(3,nCol,aRow(2));
hold on;
bar(binsLowTheta,edgeSumA,'grouped');
[lowArgonLine,lowArgonGood,lowArgonEtc] = fit(binsLowTheta',edgeSumA','gauss2','StartPoint',[2*10^4,-75,45,2*10^4,0,5]);

fitCoef = coeffvalues(lowArgonLine);
argonAngleLow=fitCoef(1,5);
argonStddevLow=fitCoef(1,6);

plot(lowArgonLine);
legend('off');
ylabel(strcat('$N_A~(10^{',num2str(argonPower),'})$'),'Interpreter','Latex');
hAx = gca;
hAx.YAxis.Exponent = 0;
yTic = yticks;
yticklabels(yTic/(10^argonPower));
xlabel('$\theta_{Lower}~( deg.)$','Interpreter','Latex');
xlim([-60 60]);
title(titles(2,:),'Interpreter','none');

subplot(3,nCol,aRow(3));
hold on;
bar(binsUpTheta,edgeSumA,'grouped');
[upArgonLine,upArgonGood,upArgonEtc] = fit(binsUpTheta',edgeSumA','gauss2','StartPoint',[2*10^4,0,45,2*10^4,75,45]);

fitCoef = coeffvalues(upArgonLine);
argonAngleUp=fitCoef(1,2);
argonStddevUp=fitCoef(1,3);
% coefConfInt = confint(argonLine);

plot(upArgonLine);
legend('off');
ylabel(strcat('$N_A~(10^{',num2str(argonPower),'})$'),'Interpreter','Latex');
hAx = gca;
hAx.YAxis.Exponent = 0;
yTic = yticks;
yticklabels(yTic/(10^argonPower));
xlabel('$\theta_{Upper}~( deg.)$','Interpreter','Latex');
xlim([-60 60]);
title(titles(3,:),'Interpreter','none');

argonAngles = [argonAngleUp,argonAngleLow];
argonStddevs = [argonStddevLow,argonStddevUp];

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
    yTic = yticks;
    yticklabels(yTic/(10^impurityPower));
    xlabel("$y'~(r^*)$",'Interpreter','Latex');
    xticks(xTic);
    xlim([yLow*tickSpacing-40 yHigh*tickSpacing+40]);
    title(titles(4,:),'Interpreter','none');

    subplot(3,nCol,aRow(2)+1);
    title(titles(5),'Interpreter','none');
    hold on;
    bar(binsLowTheta,edgeSumI,'grouped');
    [lowImpurityLine,lowImpurityGood,lowImpurityEtc] = fit(binsLowTheta',edgeSumI','gauss2','StartPoint',[2*10^4,-75,45,2*10^4,0,5]);
    
    fitCoef = coeffvalues(lowImpurityLine);
    impurityAngleLow=fitCoef(1,5);
    impurityStddevLow=fitCoef(1,6);
    coefConfInt = confint(argonLine);
    
    plot(lowImpurityLine);
    legend('off');
    ylabel(strcat('$N_I~(10^{',num2str(impurityPower),'})$'),'Interpreter','Latex');
    hAx = gca;
    hAx.YAxis.Exponent = 0;
    yTic = yticks;
    yticklabels(yTic/(10^impurityPower));    
    xlabel('$\theta_{Lower}~( deg.)$','Interpreter','Latex');
    xlim([-60 60]);
    title(titles(5,:),'Interpreter','none');
    
    subplot(3,nCol,aRow(3)+1);
    title(titles(6),'Interpreter','none');
    hold on;
    bar(binsUpTheta,edgeSumI,'grouped');
    [upImpurityLine,upImpurityGood,upImpurityEtc] = fit(binsUpTheta',edgeSumI','gauss2','StartPoint',[2*10^4,0,45,2*10^4,75,45]);
        
    fitCoef = coeffvalues(upImpurityLine);
    impurityAngleUp=fitCoef(1,2);
    impurityStddevUp=fitCoef(1,3);
    coefConfInt = confint(argonLine);
    
    plot(upImpurityLine);
    legend('off');    
    ylabel(strcat('$N_I~(10^{',num2str(impurityPower),'})$'),'Interpreter','Latex');
    hAx = gca;
    hAx.YAxis.Exponent = 0;
    yTic = yticks;
    yticklabels(yTic/(10^impurityPower));
    xlabel('$\theta_{Upper}~( deg.)$','Interpreter','Latex');
    xlim([-60 60]);
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

outFlowAngleLabels = ["separation","impurityDiameter","argonAngleLow", "argonStddevLow","argonAngleUp", "argonStddevUp","impurityAngleLow", "impurityStddevLow","impurityAngleUp", "impurityStddevUp"];
outFlowAngleData = [separation,impurityDiameter,argonAngleLow, argonStddevLow,argonAngleUp, argonStddevUp,impurityAngleLow, impurityStddevLow,impurityAngleUp, impurityStddevUp];

end

