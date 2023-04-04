% function [] = meshCalculationCompareVectorPlot(t,x,y,uA,vA,countA,tempA,internalTempA,internalKEA,uI,vI,countI,tempI,internalTempI,internalKEI,)
function [] = meshCalculationCompareVectorPlot(t,x,y,uA,vA,countA,tempA,internalTempA,uI,vI,countI,tempI,internalTempI)
% function [] = meshCalculationCompareVectorPlot(t,x,y,uA,vA,countA,tempA,internalTempA)
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes here
leftDual = 1;
zCut = 0;
xMid = 120;
yMid = 280;
% yMid = 460;
width = 120;
depth = 60;
spacing = 120;
separation = 120;
xLeft = xMid;
if leftDual == 1
    yLeft = yMid-spacing-width/2;
else
    yLeft = yMid-width/2;
end
%For dual orifice in left
xRight = xMid+depth+separation;
yRight = yMid-spacing-width/2;


xLow = min(x,[],'all');
xUp = max(x,[],'all');
yLow = min(y,[],'all');
yUp = max(y,[],'all');

xAxMax = size(x,1);
yAxMax = size(y,1);

% xLow = 0;
% xUp = 2500;
% yLow = 0;
% yUp = 2000;

countAMax = max(countA,[],'all');
tempAMax = max(tempA,[],'all');
countIMax = max(countI,[],'all');
tempIMax = max(tempI,[],'all');


totalKE = countA.*tempA+countI.*tempI;
calculatedInternalKE = countA.*internalTempA+countI.*internalTempI;
flowKE = 1/2*countA.*uA.^2 + 1/2*25*countI.*uI.^2;
% totalKE = countA.*tempA;
% flowKE = 1/2*countA.*uA.^2;
% calculatedInternalKE = countA.*internalTempA;

diffKE = totalKE-calculatedInternalKE;
calcTotalKE = flowKE + calculatedInternalKE;
diffInternalFlowKE = calculatedInternalKE-flowKE;
diffTotalFlowKE = totalKE-flowKE;
% diffSumFlowKE = totalKE-calcTotalKE;

% lammpsInternalKE = internalKEA+internalKEI;
% diffInternalKE = lammpsInternalKE-calculatedInternalKE;



maxAMag = max((uA.^2+vA.^2).^(1/2),[],'all');
vNet = (vA.*countA+vI.*countI)./(countA+countI);
uNet = (uA.*countA+uI.*countI)./(countA+countI);
% maxVelMag = max((vNet.^2+uNet.^2).^(1/2),[],'all');

maxIMag = max((uI.^2+vI.^2).^(1/2),[],'all');
maxMag = max(maxAMag,maxIMag);
% maxMag = maxAMag;
uANorm = uA./maxMag;
vANorm = vA./maxMag;

% uINorm = uI./maxMag;
% vINorm = vI./maxMag;

% for i = 1:1:11
for i = 20:20:size(t,1)/10
%     qFig = figure('Visible','off');
%     pos = get(qFig,'position');
%     set(qFig,'position',[pos(1:2)/4 pos(3:4)*2])    
%     hold on;
%     plotMax = max(calculatedInternalKE,[],'all');
%     surf(x,y,calculatedInternalKE(:,:,i)-plotMax);
%     axis([xLow xUp yLow yUp -plotMax 0]);
%     caxis([-plotMax 0]);
% %     hcolorBar = colorbar('Ticks',linspace(0,max(calculatedInternalKE,[],'all'),8),'TickLabels', num2cell(0:0.5:3.5));
%     hcolorBar = colorbar();
%     ylabel(hcolorBar, '$Calculated Internal KE$', 'Interpreter', 'latex') ;
%     quiver(x+10, y+10, uANorm(:,:,i)*25, vANorm(:,:,i)*25, 'AutoScale', 'off', 'Color' ,'w');%, 'LineWidth',2);%,'MaxHeadSize',5); 
% %     if leftDual == 1
% %         patch( [xLeft xLeft xLeft+depth xLeft+depth], [0 yLeft yLeft 0], [zCut zCut zCut zCut], 'w');
% %         patch( [xLeft xLeft xLeft+depth xLeft+depth], [yLeft+width yLeft+2*width yLeft+2*width yLeft+width], [zCut zCut zCut zCut], 'w');
% %         patch( [xLeft xLeft xLeft+depth xLeft+depth], [yLeft+3*width 2000 2000 yLeft+3*width], [zCut zCut zCut zCut], 'w');
% %     else
% %     patch( [xLeft xLeft xLeft+depth xLeft+depth], [0 yLeft yLeft 0], [zCut zCut zCut zCut], 'w');
% %     patch( [xLeft xLeft xLeft+depth xLeft+depth], [yLeft+width 2000 2000 yLeft+width], [zCut zCut zCut zCut], 'w');
% %     end
% %     patch( [xRight xRight xRight+depth xRight+depth], [0 yRight yRight 0], [zCut zCut zCut zCut], 'w');
% %     patch( [xRight xRight xRight+depth xRight+depth], [yRight+width yRight+2*width yRight+2*width yRight+width], [zCut zCut zCut zCut], 'w');
% %     patch( [xRight xRight xRight+depth xRight+depth], [yRight+3*width 2000 2000 yRight+3*width], [zCut zCut zCut zCut], 'w');
%     title(strcat("Argon Velocity Vector Field, Calculated Internal KE Mesh at $t^*=$ ", num2str(t(i))), 'Interpreter', 'LaTex', 'FontSize', 12 );  
%     xlabel("x $(r*)$",'Interpreter','Latex');
%     ylabel("y $(r*)$",'Interpreter','Latex'); 
% %     xlabel("$x'~(r*)$",'Interpreter','Latex');
% %     ylabel("$y'~(r*)$",'Interpreter','Latex');
%     view(0,90);
%     print(strcat("CalcInternalKE_LJTime_",num2str(t(i))), '-dpng');
%     close(qFig);

    qFig = figure('Visible','off');
    pos = get(qFig,'position');
    set(qFig,'position',[pos(1:2)/4 pos(3:4)*2])    
    hold on;
    plotMax = max(totalKE,[],'all');
    surf(x,y,totalKE(:,:,i)-plotMax);
    axis([xLow xUp yLow yUp -plotMax 0]);
    caxis([-plotMax 0]);
%     hcolorBar = colorbar('Ticks',linspace(0,max(totalKE,[],'all'),8),'TickLabels', num2cell(0:0.5:3.5));
    hcolorBar = colorbar();
    ylabel(hcolorBar, '$Total KE$', 'Interpreter', 'latex') ;
    quiver(x+10, y+10, uANorm(:,:,i)*25, vANorm(:,:,i)*25, 'AutoScale', 'off', 'Color' ,'w');%, 'LineWidth',2);%,'MaxHeadSize',5); 
    if leftDual == 1
        patch( [xLeft xLeft xLeft+depth xLeft+depth], [0 yLeft yLeft 0], [zCut zCut zCut zCut], 'w');
        patch( [xLeft xLeft xLeft+depth xLeft+depth], [yLeft+width yLeft+2*width yLeft+2*width yLeft+width], [zCut zCut zCut zCut], 'w');
        patch( [xLeft xLeft xLeft+depth xLeft+depth], [yLeft+3*width 2000 2000 yLeft+3*width], [zCut zCut zCut zCut], 'w');
    else
    patch( [xLeft xLeft xLeft+depth xLeft+depth], [0 yLeft yLeft 0], [zCut zCut zCut zCut], 'w');
    patch( [xLeft xLeft xLeft+depth xLeft+depth], [yLeft+width 2000 2000 yLeft+width], [zCut zCut zCut zCut], 'w');
    end
    patch( [xRight xRight xRight+depth xRight+depth], [0 yRight yRight 0], [zCut zCut zCut zCut], 'w');
    patch( [xRight xRight xRight+depth xRight+depth], [yRight+width yRight+2*width yRight+2*width yRight+width], [zCut zCut zCut zCut], 'w');
    patch( [xRight xRight xRight+depth xRight+depth], [yRight+3*width 2000 2000 yRight+3*width], [zCut zCut zCut zCut], 'w');
    title(strcat("Argon Velocity Vector Field, Total KE Mesh at $t^*=$ ", num2str(t(i))), 'Interpreter', 'LaTex', 'FontSize', 12 );  
    xlabel("x $(r*)$",'Interpreter','Latex');
    ylabel("y $(r*)$",'Interpreter','Latex');
    view(0,90);
    print(strcat("TotalKE_LJTime_",num2str(t(i))), '-dpng');
    close(qFig);

%     qFig = figure('Visible','off');
%     pos = get(qFig,'position');
%     set(qFig,'position',[pos(1:2)/4 pos(3:4)*2])    
%     hold on;
%     plotMax = max(flowKE,[],'all');
%     surf(x,y,flowKE(:,:,i)-plotMax);
%     axis([xLow xUp yLow yUp -plotMax 0]);
%     caxis([-plotMax 0]);
% %     hcolorBar = colorbar('Ticks',linspace(0,max(totalKE,[],'all'),8),'TickLabels', num2cell(0:0.5:3.5));
%     hcolorBar = colorbar();
%     ylabel(hcolorBar, '$Flow KE$', 'Interpreter', 'latex') ;
%     quiver(x+10, y+10, uANorm(:,:,i)*25, vANorm(:,:,i)*25, 'AutoScale', 'off', 'Color' ,'w');%, 'LineWidth',2);%,'MaxHeadSize',5); 
%     if leftDual == 1
%         patch( [xLeft xLeft xLeft+depth xLeft+depth], [0 yLeft yLeft 0], [zCut zCut zCut zCut], 'w');
%         patch( [xLeft xLeft xLeft+depth xLeft+depth], [yLeft+width yLeft+2*width yLeft+2*width yLeft+width], [zCut zCut zCut zCut], 'w');
%         patch( [xLeft xLeft xLeft+depth xLeft+depth], [yLeft+3*width 2000 2000 yLeft+3*width], [zCut zCut zCut zCut], 'w');
%     else
%     patch( [xLeft xLeft xLeft+depth xLeft+depth], [0 yLeft yLeft 0], [zCut zCut zCut zCut], 'w');
%     patch( [xLeft xLeft xLeft+depth xLeft+depth], [yLeft+width 2000 2000 yLeft+width], [zCut zCut zCut zCut], 'w');
%     end
%     patch( [xRight xRight xRight+depth xRight+depth], [0 yRight yRight 0], [zCut zCut zCut zCut], 'w');
%     patch( [xRight xRight xRight+depth xRight+depth], [yRight+width yRight+2*width yRight+2*width yRight+width], [zCut zCut zCut zCut], 'w');
%     patch( [xRight xRight xRight+depth xRight+depth], [yRight+3*width 2000 2000 yRight+3*width], [zCut zCut zCut zCut], 'w');
%     title(strcat("Argon Velocity Vector Field, Flow KE Mesh at $t^*=$ ", num2str(t(i))), 'Interpreter', 'LaTex', 'FontSize', 12 );  
%     xlabel("x $(r*)$",'Interpreter','Latex');
%     ylabel("y $(r*)$",'Interpreter','Latex');
%     view(0,90);
%     print(strcat("FlowKE_LJTime_",num2str(t(i))), '-dpng');
%     close(qFig);

    
%     qFig = figure('Visible','off');
%     pos = get(qFig,'position');
%     set(qFig,'position',[pos(1:2)/4 pos(3:4)*2])    
%     hold on;
%     plotMax = max(calcTotalKE,[],'all');
%     surf(x,y,calcTotalKE(:,:,i)-plotMax);
%     axis([xLow xUp yLow yUp -plotMax 0]);
%     caxis([-plotMax 0]);
% %     hcolorBar = colorbar('Ticks',linspace(0,max(calcTotalKE,[],'all'),8),'TickLabels', num2cell(0:0.5:3.5));
%     hcolorBar = colorbar();
%     ylabel(hcolorBar, '$Internal KE + Flow KE$', 'Interpreter', 'latex') ;
%     quiver(x+10, y+10, uANorm(:,:,i)*25, vANorm(:,:,i)*25, 'AutoScale', 'off', 'Color' ,'w');%, 'LineWidth',2);%,'MaxHeadSize',5); 
%     if leftDual == 1
%         patch( [xLeft xLeft xLeft+depth xLeft+depth], [0 yLeft yLeft 0], [zCut zCut zCut zCut], 'w');
%         patch( [xLeft xLeft xLeft+depth xLeft+depth], [yLeft+width yLeft+2*width yLeft+2*width yLeft+width], [zCut zCut zCut zCut], 'w');
%         patch( [xLeft xLeft xLeft+depth xLeft+depth], [yLeft+3*width 2000 2000 yLeft+3*width], [zCut zCut zCut zCut], 'w');
%     else
%     patch( [xLeft xLeft xLeft+depth xLeft+depth], [0 yLeft yLeft 0], [zCut zCut zCut zCut], 'w');
%     patch( [xLeft xLeft xLeft+depth xLeft+depth], [yLeft+width 2000 2000 yLeft+width], [zCut zCut zCut zCut], 'w');
%     end
%     patch( [xRight xRight xRight+depth xRight+depth], [0 yRight yRight 0], [zCut zCut zCut zCut], 'w');
%     patch( [xRight xRight xRight+depth xRight+depth], [yRight+width yRight+2*width yRight+2*width yRight+width], [zCut zCut zCut zCut], 'w');
%     patch( [xRight xRight xRight+depth xRight+depth], [yRight+3*width 2000 2000 yRight+3*width], [zCut zCut zCut zCut], 'w');
%     title(strcat("Argon Velocity Vector Field, Calculated Total KE Mesh at $t^*=$ ", num2str(t(i))), 'Interpreter', 'LaTex', 'FontSize', 12 );  
%     xlabel("x $(r*)$",'Interpreter','Latex');
%     ylabel("y $(r*)$",'Interpreter','Latex');
%     view(0,90);
%     print(strcat("CalcTotalKE_LJTime_",num2str(t(i))), '-dpng');
%     close(qFig);

%     qFig = figure('Visible','off');
%     pos = get(qFig,'position');
%     set(qFig,'position',[pos(1:2)/4 pos(3:4)*2])    
%     hold on;
%     plotMax = max(diffInternalFlowKE,[],'all');
%     surf(x,y,diffInternalFlowKE(:,:,i)-plotMax);
%     axis([xLow xUp yLow yUp min(diffInternalFlowKE,[],'all')-plotMax 0]);
%     caxis([min(diffInternalFlowKE,[],'all')-plotMax 0]);
% %     hcolorBar = colorbar('Ticks',linspace(0,max(totalKE,[],'all'),8),'TickLabels', num2cell(0:0.5:3.5));
%     hcolorBar = colorbar();
%     ylabel(hcolorBar, '$Internal KE - Flow KE$', 'Interpreter', 'latex') ;
%     quiver(x+10, y+10, uANorm(:,:,i)*25, vANorm(:,:,i)*25, 'AutoScale', 'off', 'Color' ,'w');%, 'LineWidth',2);%,'MaxHeadSize',5); 
%     if leftDual == 1
%         patch( [xLeft xLeft xLeft+depth xLeft+depth], [0 yLeft yLeft 0], [zCut zCut zCut zCut], 'w');
%         patch( [xLeft xLeft xLeft+depth xLeft+depth], [yLeft+width yLeft+2*width yLeft+2*width yLeft+width], [zCut zCut zCut zCut], 'w');
%         patch( [xLeft xLeft xLeft+depth xLeft+depth], [yLeft+3*width 2000 2000 yLeft+3*width], [zCut zCut zCut zCut], 'w');
%     else
%     patch( [xLeft xLeft xLeft+depth xLeft+depth], [0 yLeft yLeft 0], [zCut zCut zCut zCut], 'w');
%     patch( [xLeft xLeft xLeft+depth xLeft+depth], [yLeft+width 2000 2000 yLeft+width], [zCut zCut zCut zCut], 'w');
%     end
%     patch( [xRight xRight xRight+depth xRight+depth], [0 yRight yRight 0], [zCut zCut zCut zCut], 'w');
%     patch( [xRight xRight xRight+depth xRight+depth], [yRight+width yRight+2*width yRight+2*width yRight+width], [zCut zCut zCut zCut], 'w');
%     patch( [xRight xRight xRight+depth xRight+depth], [yRight+3*width 2000 2000 yRight+3*width], [zCut zCut zCut zCut], 'w');
%     title(strcat("Argon Velocity Vector Field, Difference in Internal and Flow KE Mesh at $t^*=$ ", num2str(t(i))), 'Interpreter', 'LaTex', 'FontSize', 12 );  
%     xlabel("x $(r*)$",'Interpreter','Latex');
%     ylabel("y $(r*)$",'Interpreter','Latex');
%     view(0,90);
%     print(strcat("DiffFlowInternalKE_LJTime_",num2str(t(i))), '-dpng');
%     close(qFig);


%     qFig = figure('Visible','off');
%     pos = get(qFig,'position');
%     set(qFig,'position',[pos(1:2)/4 pos(3:4)*2])    
%     hold on;
%     plotMax = max(diffTotalFlowKE,[],'all');
%     surf(x,y,diffTotalFlowKE(:,:,i)-plotMax);
%     axis([xLow xUp yLow yUp min(diffTotalFlowKE,[],'all')-plotMax 0]);
%     caxis([min(diffTotalFlowKE,[],'all')-plotMax 0]);
% %     hcolorBar = colorbar('Ticks',linspace(0,max(totalKE,[],'all'),8),'TickLabels', num2cell(0:0.5:3.5));
%     hcolorBar = colorbar();
%     ylabel(hcolorBar, '$Total KE - Flow KE$', 'Interpreter', 'latex') ;
%     quiver(x+10, y+10, uANorm(:,:,i)*25, vANorm(:,:,i)*25, 'AutoScale', 'off', 'Color' ,'w');%, 'LineWidth',2);%,'MaxHeadSize',5); 
%     if leftDual == 1
%         patch( [xLeft xLeft xLeft+depth xLeft+depth], [0 yLeft yLeft 0], [zCut zCut zCut zCut], 'w');
%         patch( [xLeft xLeft xLeft+depth xLeft+depth], [yLeft+width yLeft+2*width yLeft+2*width yLeft+width], [zCut zCut zCut zCut], 'w');
%         patch( [xLeft xLeft xLeft+depth xLeft+depth], [yLeft+3*width 2000 2000 yLeft+3*width], [zCut zCut zCut zCut], 'w');
%     else
%     patch( [xLeft xLeft xLeft+depth xLeft+depth], [0 yLeft yLeft 0], [zCut zCut zCut zCut], 'w');
%     patch( [xLeft xLeft xLeft+depth xLeft+depth], [yLeft+width 2000 2000 yLeft+width], [zCut zCut zCut zCut], 'w');
%     end
%     patch( [xRight xRight xRight+depth xRight+depth], [0 yRight yRight 0], [zCut zCut zCut zCut], 'w');
%     patch( [xRight xRight xRight+depth xRight+depth], [yRight+width yRight+2*width yRight+2*width yRight+width], [zCut zCut zCut zCut], 'w');
%     patch( [xRight xRight xRight+depth xRight+depth], [yRight+3*width 2000 2000 yRight+3*width], [zCut zCut zCut zCut], 'w');
%     title(strcat("Argon Velocity Vector Field, Difference in Total and Flow KE Mesh at $t^*=$ ", num2str(t(i))), 'Interpreter', 'LaTex', 'FontSize', 12 );  
%     xlabel("x $(r*)$",'Interpreter','Latex');
%     ylabel("y $(r*)$",'Interpreter','Latex');
%     view(0,90);
%     print(strcat("DiffFlowTotalKE_LJTime_",num2str(t(i))), '-dpng');
%     close(qFig);

%     qFig = figure('Visible','off');
%     pos = get(qFig,'position');
%     set(qFig,'position',[pos(1:2)/4 pos(3:4)*2])    
%     hold on;
%     plotMax = max(diffKE,[],'all');
%     surf(x,y,diffKE(:,:,i)-plotMax);
%     axis([xLow xUp yLow yUp min(diffKE,[],'all')-plotMax 0]);
%     caxis([min(diffKE,[],'all')-plotMax 0]);
% %     hcolorBar = colorbar('Ticks',linspace(0,max(totalKE,[],'all'),8),'TickLabels', num2cell(0:0.5:3.5));
%     hcolorBar = colorbar();
%     ylabel(hcolorBar, '$Total KE - Internal KE$', 'Interpreter', 'latex') ;
%     quiver(x+10, y+10, uANorm(:,:,i)*25, vANorm(:,:,i)*25, 'AutoScale', 'off', 'Color' ,'w');%, 'LineWidth',2);%,'MaxHeadSize',5); 
%     if leftDual == 1
%         patch( [xLeft xLeft xLeft+depth xLeft+depth], [0 yLeft yLeft 0], [zCut zCut zCut zCut], 'w');
%         patch( [xLeft xLeft xLeft+depth xLeft+depth], [yLeft+width yLeft+2*width yLeft+2*width yLeft+width], [zCut zCut zCut zCut], 'w');
%         patch( [xLeft xLeft xLeft+depth xLeft+depth], [yLeft+3*width 2000 2000 yLeft+3*width], [zCut zCut zCut zCut], 'w');
%     else
%     patch( [xLeft xLeft xLeft+depth xLeft+depth], [0 yLeft yLeft 0], [zCut zCut zCut zCut], 'w');
%     patch( [xLeft xLeft xLeft+depth xLeft+depth], [yLeft+width 2000 2000 yLeft+width], [zCut zCut zCut zCut], 'w');
%     end
%     patch( [xRight xRight xRight+depth xRight+depth], [0 yRight yRight 0], [zCut zCut zCut zCut], 'w');
%     patch( [xRight xRight xRight+depth xRight+depth], [yRight+width yRight+2*width yRight+2*width yRight+width], [zCut zCut zCut zCut], 'w');
%     patch( [xRight xRight xRight+depth xRight+depth], [yRight+3*width 2000 2000 yRight+3*width], [zCut zCut zCut zCut], 'w');
%     title(strcat("Argon Velocity Vector Field, Difference in Total and Internal KE Mesh at $t^*=$ ", num2str(t(i))), 'Interpreter', 'LaTex', 'FontSize', 12 );  
%     xlabel("x $(r*)$",'Interpreter','Latex');
%     ylabel("y $(r*)$",'Interpreter','Latex');
%     view(0,90);
%     print(strcat("DiffTotalInternalKE_LJTime_",num2str(t(i))), '-dpng');
%     close(qFig);
   
    
% %     qFig = figure('Visible','off');
% %     pos = get(qFig,'position');
% %     set(qFig,'position',[pos(1:2)/4 pos(3:4)*2])    
% %     hold on;
% %     plotMax = max(diffSumFlowKE,[],'all');
% %     surf(x,y,diffSumFlowKE(:,:,i)-plotMax);
% %     axis([xLow xUp yLow yUp min(diffSumFlowKE,[],'all')-plotMax 0]);
% %     caxis([min(diffSumFlowKE,[],'all')-plotMax 0]);
% % %     hcolorBar = colorbar('Ticks',linspace(0,max(totalKE,[],'all'),8),'TickLabels', num2cell(0:0.5:3.5));
% %     hcolorBar = colorbar();
% %     ylabel(hcolorBar, '$Total KE - (Flow KE + Internal KE)$', 'Interpreter', 'latex') ;
% %     quiver(x+10, y+10, uANorm(:,:,i)*25, vANorm(:,:,i)*25, 'AutoScale', 'off', 'Color' ,'w');%, 'LineWidth',2);%,'MaxHeadSize',5); 
% % %     patch( [xLeft xLeft xLeft+depth xLeft+depth], [0 yLeft yLeft 0], [zCut zCut zCut zCut], 'w');
% % %     patch( [xLeft xLeft xLeft+depth xLeft+depth], [yLeft+width 2000 2000 yLeft+width], [zCut zCut zCut zCut], 'w');
% % %     patch( [xRight xRight xRight+depth xRight+depth], [0 yRight yRight 0], [zCut zCut zCut zCut], 'w');
% % %     patch( [xRight xRight xRight+depth xRight+depth], [yRight+width yRight+2*width yRight+2*width yRight+width], [zCut zCut zCut zCut], 'w');
% % %     patch( [xRight xRight xRight+depth xRight+depth], [yRight+3*width 2000 2000 yRight+3*width], [zCut zCut zCut zCut], 'w');
% %     title(strcat("Argon Velocity Vector Field, Difference in LAMMPS and Calculated Total KE Mesh at $t^*=$ ", num2str(t(i))), 'Interpreter', 'LaTex', 'FontSize', 12 );  
% %     xlabel("x $(r*)$",'Interpreter','Latex');
% %     ylabel("y $(r*)$",'Interpreter','Latex');
% %     view(0,90);
% %     print(strcat("DiffCalcTotalKE_LJTime_",num2str(t(i))), '-dpng');
% %     close(qFig);
% 
% %     qFig = figure('Visible','off');
% %     pos = get(qFig,'position');
% %     set(qFig,'position',[pos(1:2)/4 pos(3:4)*2])    
% %     hold on;
% %     plotMax = max(diffInternalKE,[],'all');
% %     surf(x,y,diffInternalKE(:,:,i)-plotMax);
% %     axis([xLow xUp yLow yUp min(diffInternalKE,[],'all')-plotMax 0]);
% %     caxis([min(diffInternalKE,[],'all')-plotMax 0]);
% % %     hcolorBar =
% % %     colorbar('Ticks',linspace(min(diffInternalKE,[],'all'),max(diffInternalKE,[],'all'),8),'TickLabels',
% % %     num2cell(0:0.5:3.5));
% %     hcolorBar = colorbar();
% %     ylabel(hcolorBar, '$LAMMPS Internal KE - Calculated Internal KE$', 'Interpreter', 'latex') ;
% %     quiver(x+10, y+10, uANorm(:,:,i)*25, vANorm(:,:,i)*25, 'AutoScale', 'off', 'Color' ,'w');%, 'LineWidth',2);%,'MaxHeadSize',5); 
% % %     patch( [xLeft xLeft xLeft+depth xLeft+depth], [0 yLeft yLeft 0], [zCut zCut zCut zCut], 'w'); 
% % %     patch( [xLeft xLeft xLeft+depth xLeft+depth], [yLeft+width 2000 2000 yLeft+width], [zCut zCut zCut zCut], 'w'); 
% % %     patch( [xRight xRight xRight+depth xRight+depth], [0 yRight yRight 0], [zCut zCut zCut zCut], 'w'); 
% % %     patch( [xRight xRight xRight+depth xRight+depth], [yRight+width yRight+2*width yRight+2*width yRight+width], [zCut zCut zCut zCut], 'w');
% % %     patch( [xRight xRight xRight+depth xRight+depth], [yRight+3*width 2000 2000 yRight+3*width], [zCut zCut zCut zCut], 'w');
% %     title(strcat("Argon Velocity Vector Field, Difference in LAMMPS and Calculated Internal KE Mesh at $t^*=$ ", num2str(t(i))), 'Interpreter', 'LaTex', 'FontSize', 12 );  
% %     xlabel("x $(r*)$",'Interpreter','Latex');
% %     ylabel("y $(r*)$",'Interpreter','Latex');
% %     view(0,90);
% %     print(strcat("DiffInternalKE_LJTime_",num2str(t(i))), '-dpng');
% %     close(qFig);
%     
% %     qFig = figure('Visible','off');
% %     pos = get(qFig,'position');
% %     set(qFig,'position',[pos(1:2)/4 pos(3:4)*2])    
% %     hold on;
% %     plotMax = max(lammpsInternalKE,[],'all');
% %     surf(x,y,lammpsInternalKE(:,:,i)-plotMax);
% %     axis([xLow xUp yLow yUp -plotMax 0]);
% %     caxis([-plotMax 0]);
% % %     hcolorBar = colorbar('Ticks',linspace(0,max(internalKE,[],'all'),8),'TickLabels', num2cell(0:0.5:3.5));
% %     hcolorBar = colorbar();
% %     ylabel(hcolorBar, '$LAMMPS Internal KE$', 'Interpreter', 'latex') ;
% %     quiver(x+10, y+10, uANorm(:,:,i)*25, vANorm(:,:,i)*25, 'AutoScale', 'off', 'Color' ,'w');%, 'LineWidth',2);%,'MaxHeadSize',5); 
% % %     patch( [xLeft xLeft xLeft+depth xLeft+depth], [0 yLeft yLeft 0], [zCut zCut zCut zCut], 'w');
% % %     patch( [xLeft xLeft xLeft+depth xLeft+depth], [yLeft+width 2000 2000 yLeft+width], [zCut zCut zCut zCut], 'w');
% % %     patch( [xRight xRight xRight+depth xRight+depth], [0 yRight yRight 0], [zCut zCut zCut zCut], 'w');
% % %     patch( [xRight xRight xRight+depth xRight+depth], [yRight+width yRight+2*width yRight+2*width yRight+width], [zCut zCut zCut zCut], 'w');
% % %     patch( [xRight xRight xRight+depth xRight+depth], [yRight+3*width 2000 2000 yRight+3*width], [zCut zCut zCut zCut], 'w');
% %     title(strcat("Argon Velocity Vector Field, LAMMPS Internal KE Mesh at $t^*=$ ", num2str(t(i))), 'Interpreter', 'LaTex', 'FontSize', 12 );  
% %     xlabel("x $(r*)$",'Interpreter','Latex');
% %     ylabel("y $(r*)$",'Interpreter','Latex');
% %     view(0,90);
% %     print(strcat("LAMMPSInternalKE_LJTime_",num2str(t(i))), '-dpng');
% %     close(qFig);
end

