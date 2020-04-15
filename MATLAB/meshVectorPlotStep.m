function [] = meshVectorPlotStep(t,x,y,uA,vA,countA,tempA,uI,vI,countI,tempI)
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes here

% xLow = 800;
% xUp = 1400;
% yLow = 700;
% yUp = 1300;

xLow = 0;
xUp = 2020;
yLow = 0;
yUp = 1990;

countAMax = max(countA,[],'all');
tempAMax = max(tempA,[],'all');
countIMax = max(countI,[],'all');
tempIMax = max(tempI,[],'all');
kinetic = countA.*tempA+countI.*tempI;
kineticMax = max(kinetic,[],'all');
kineticMin = min(kinetic,[],'all');
kinTickSpace = round(kineticMax/10,2,'significant');
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
    logKin = kinetic;
    logKin(logKin<=1)=1;
    logKin = log(logKin);
    surf(x,y,logKin(:,:,i));
    axis([xLow xUp yLow yUp 0 log(kineticMax)+1]);
    caxis([0 log(kineticMax)]);
    %     surf(x,y,kinetic(:,:,i));
%     axis([xLow xUp yLow yUp kineticMin kineticMax]);
%     caxis([kineticMin kineticMax]);
    colorbar;

%     surf(x,y,kinetic(:,:,i)-kineticMax);
%     axis([xLow xUp yLow yUp -kineticMax 0]);
%     colormap(parula(10));
%     colorbar;
% %     colorbar('TickLabels', num2cell(0:kinTickSpace:round(kineticMax,2,'significant')+100));
%     caxis([-kineticMax 0]);


%     surf(x,y,countI(:,:,i)-countIMax);
%     axis([xLow xUp yLow yUp -countIMax 0]);
%     colormap(parula(countIMax));
%     colorbar('TickLabels', num2cell(0:countIMax));
%     caxis([-countIMax 0]);

%     quiver(x+10, y+10, uANorm(:,:,i)*50, vANorm(:,:,i)*50, 'AutoScale', 'off', 'Color' ,'w');%, 'LineWidth',2);%,'MaxHeadSize',5);
%     quiver(x+10, y+10, uINorm(:,:,i)*50, vINorm(:,:,i)*50, 'AutoScale', 'off', 'Color' ,'w');%, 'LineWidth',2,'MaxHeadSize',5);
%     axis([xLow xUp yLow yUp 0 0]);

    zCut = log(kineticMax)+1;
    patch( [1000 1000 1020 1020], [0 940 940 0], [zCut zCut zCut zCut], 'k');
    patch( [1000 1000 1020 1020], [1060 2000 2000 1060], [zCut zCut zCut zCut], 'k');

    patch( [1120 1120 1140 1140], [0 820 820 0], [zCut zCut zCut zCut], 'k');
    patch( [1120 1120 1140 1140], [940 1060 1060 940], [zCut zCut zCut zCut], 'k');
    patch( [1120 1120 1140 1140], [1180 2000 2000 1180], [zCut zCut zCut zCut], 'k');
    
%     zCut = 0;
%     patch( [10000 10000 10020 10020], [0 940 940 0], [zCut zCut zCut zCut], 'k');
%     patch( [10000 10000 10020 10020], [1060 2000 2000 1060], [zCut zCut zCut zCut], 'k');
% 
%     patch( [10120 10120 10140 10140], [0 820 820 0], [zCut zCut zCut zCut], 'k');
%     patch( [10120 10120 10140 10140], [940 1060 1060 940], [zCut zCut zCut zCut], 'k');
%     patch( [10120 10120 10140 10140], [1180 2000 2000 1180], [zCut zCut zCut zCut], 'k');
    
%     title(strcat("Impurity Velocity Vector Field, Impurity Count Mesh at $t^*=$ ", num2str(t(i))), 'Interpreter', 'LaTex', 'FontSize', 12 );
%     title(strcat("Impurity Velocity Vector Field at $t^*=$ ", num2str(t(i))), 'Interpreter', 'LaTex', 'FontSize', 12 );
    title(strcat("Kinetic Energy Mesh at $t^*=$ ", num2str(t(i))), 'Interpreter', 'LaTex', 'FontSize', 12 );
    
    xlabel("x, $r*$",'Interpreter','Latex');
    ylabel("y, $r*$",'Interpreter','Latex');
    view(0,90);

    print(strcat("GasKE_Timestep_",num2str(t(i)*200)), '-dpng');
    close(qFig);
    
end

end

