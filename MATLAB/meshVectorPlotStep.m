function [] = meshVectorPlotStep(t,x,y,uA,vA,countA,tempA,uI,vI,countI,tempI)
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes here

xLow = 700;
xUp = 1500;
yLow = 600;
yUp = 1400;

% xLow = 0;
% xUp = 2500;
% yLow = 0;
% yUp = 2000;

countAMax = max(countA,[],'all');
tempAMax = max(tempA,[],'all');
countIMax = max(countI,[],'all');
tempIMax = max(tempI,[],'all');
kinetic = countA.*tempA+countI.*tempI;
% logKinetic = log((countA.*tempA+countI.*tempI)+1);
logKinetic = log10((countA.*tempA+countI.*tempI)+1);
% logKinetic = log((countA.*tempA)+1);
logKinetic(isinf(logKinetic)|isnan(logKinetic)) = 0;
logKineticMax = max(logKinetic,[],'all');
logKineticMin = min(logKinetic,[],'all');
% kinLogMax = max(logKinetic,[],'all');
% kinTickSpace = round((kineticMax-kineticMin)/10,1);
maxAMag = max((uA.^2+vA.^2).^(1/2),[],'all');
maxIMag = max((uI.^2+vI.^2).^(1/2),[],'all');
maxMag = max(maxAMag,maxIMag);
uANorm = uA./maxMag;
vANorm = vA./maxMag;
uINorm = uI./maxMag;
vINorm = vI./maxMag;


% for i = 1:1:301
for i = 1:1:size(t,1)
    qFig = figure('Visible','off');
    pos = get(qFig,'position');
    set(qFig,'position',[pos(1:2)/4 pos(3:4)*2])    
    hold on;
    
%     flowEng = 1/2.*uA.^2;
%     logFlowEng = log10(flowEng+1);
%     logFlowEng(isinf(logFlowEng)|isnan(logFlowEng)) = 0;

%     flowEngMax = max(logFlowEng,[],'all');
%     logKin = kinetic-1/2*(uA.^2+vA.^2).^(1/2);
%     logKin = kinetic-flowEng;
%     logKin(logKin<=1)=1;
%     logKin = log(logKin);
%     surf(x,y,logKin(:,:,i));
%     axis([xLow xUp yLow yUp 0 max(logKin,[],'all')]);
%     caxis([0 log(kineticMax-flowEngMax)]);

%     surf(x,y,kinetic(:,:,i)-kineticMax);
%     axis([xLow xUp yLow yUp kineticMin kineticMax]);
%     caxis([kineticMin kineticMax]);
%     colorbar;

%     axis([xLow xUp yLow yUp -8 0]);
%     caxis([-8 0]);
%     colorbar;

%     colormap(parula(7));
%     colorbar('TickLabels', num2cell(0:1:8));
%     colorbar('TickLabels', num2cell(0:1:kinTickSpace+1));

     surf(x,y,logKinetic(:,:,i)-logKineticMax);
     axis([xLow xUp yLow yUp -logKineticMax 0]);
     caxis([-logKineticMax 0]);
     hcolorBar = colorbar('Ticks',linspace(-logKineticMax,0,8),'TickLabels', num2cell(0:0.5:3.5));
     ylabel(hcolorBar, '$log(KE+1)$', 'Interpreter', 'latex') ;
     
%     colorbar('Ticks', (0:1:4));
%     colorbar('TickLabels', num2cell(0:1:4));



%     surf(x,y,countI(:,:,i)-countIMax);
%     axis([xLow xUp yLow yUp -countIMax 0]);
%     colormap(parula(countIMax));
%     colorbar('TickLabels', num2cell(0:countIMax));
%     caxis([-countIMax 0]);

    quiver(x+10, y+10, uANorm(:,:,i)*50, vANorm(:,:,i)*50, 'AutoScale', 'off', 'Color' ,'r');%, 'LineWidth',2);%,'MaxHeadSize',5);
%     quiver(x+10, y+10, uINorm(:,:,i)*50, vINorm(:,:,i)*50, 'AutoScale', 'off', 'Color' ,'w');%, 'LineWidth',2,'MaxHeadSize',5);
%     axis([xLow xUp yLow yUp 0 0]);

    zCut = 0;
    patch( [1000 1000 1500 1500], [0 940 940 0], [zCut zCut zCut zCut], 'k');
    patch( [1000 1000 1500 1500], [1060 2000 2000 1060], [zCut zCut zCut zCut], 'k');

%     patch( [1220 1220 1240 1240], [0 820 820 0], [zCut zCut zCut zCut], 'w');
%     patch( [1220 1220 1240 1240], [940 1060 1060 940], [zCut zCut zCut zCut], 'w');
%     patch( [1220 1220 1240 1240], [1180 2000 2000 1180], [zCut zCut zCut zCut], 'w');
    
%     zCut = 0;
%     patch( [10000 10000 10020 10020], [0 940 940 0], [zCut zCut zCut zCut], 'k');
%     patch( [10000 10000 10020 10020], [1060 2000 2000 1060], [zCut zCut zCut zCut], 'k');
% 
%     patch( [10120 10120 10140 10140], [0 820 820 0], [zCut zCut zCut zCut], 'k');
%     patch( [10120 10120 10140 10140], [940 1060 1060 940], [zCut zCut zCut zCut], 'k');
%     patch( [10120 10120 10140 10140], [1180 2000 2000 1180], [zCut zCut zCut zCut], 'k');
    
    title(strcat("Argon Velocity Vector Field, Log KE Mesh at $t^*=$ ", num2str(t(i))), 'Interpreter', 'LaTex', 'FontSize', 12 );
%     title(strcat("Impurity Velocity Vector Field, Impurity Count Mesh at $t^*=$ ", num2str(t(i))), 'Interpreter', 'LaTex', 'FontSize', 12 );
%     title(strcat("Impurity Velocity Vector Field at $t^*=$ ", num2str(t(i))), 'Interpreter', 'LaTex', 'FontSize', 12 );
%     title(strcat("Pressure at $t^*=$ ", num2str(t(i))), 'Interpreter', 'LaTex', 'FontSize', 12 );
    
    xlabel("x $(r*)$",'Interpreter','Latex');
    ylabel("y $(r*)$",'Interpreter','Latex');
    view(0,90);

%     print(strcat("ImpurityVelocityCount_Timestep_",num2str(t(i)*200)), '-dpng');
   print(strcat("Zoom_ArgonVelocity_LogKE_Timestep_",num2str(t(i)*200)), '-dpng');

%     print(strcat("Bernoulli_Timestep_",num2str(t(i)*200)), '-dpng');
    close(qFig);
    
end

end

