function [] = meshVectorPlotSteps(t,x,y,uA,vA,countA,tempA,uI,vI,countI,tempI,D)
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes here

leftDual = 1;
zCut = 0;
width = 120;
depth = 60;
spacing = 120;
separation = 120;

xLeft = 120;
% yLeft = mid-width/2;
yLeft = 100;

xRight = xLeft+depth+separation;
% yRight = yLeft-spacing-width/2;
yRight = yLeft;

% xLow = min(x,[],'all');
% xUp = max(x,[],'all');
% yLow = min(y,[],'all');
% yUp = max(y,[],'all');

xLow = min(x,[],'all');
xUp = max(x,[],'all')-20;
yLow = min(y,[],'all')+20;
yUp = max(y,[],'all');


xAxMax = size(x,1);
yAxMax = size(y,1);

countAMax = max(countA,[],'all');
tempAMax = max(tempA,[],'all');
countIMax = max(countI,[],'all');
tempIMax = max(tempI,[],'all');

countIMax = round(max(countI,[],'all'));


kinetic = countA.*tempA + countI.*tempI*D^2;
logKinetic = log10(kinetic+1);
logKinetic(isinf(logKinetic)|isnan(logKinetic)) = 0;
logKineticMax = max(logKinetic,[],'all');
logKineticMin = min(logKinetic,[],'all');

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

triFig = figure('Visible','on');
tiledlayout(1,3, 'Padding', 'tight', 'TileSpacing', 'tight');
nexttile
ax1 = gca;
% ax1 = subplot(1,3,1);
% ax1 = axes('Position',pos1,'Units','centimeters');
% subplot(1,3,1);
t1 = 21;
surf(x,y,countI(:,:,t1)-countIMax);
axis([xLow xUp yLow yUp -countIMax 0]);
% surf(x,y,logKinetic(:,:,t1)-logKineticMax);
% axis([xLow xUp yLow yUp -logKineticMax 0]);
title("$t=100$ ~~~~ \qquad (a)",'Interpreter','Latex')
xlabel("$x$",'Interpreter','Latex');
ylabel("$y$",'Interpreter','Latex');
view(0,90);
hold on
quiver(x+10, y+10, uNormCM(:,:,t1)*50, vNormCM(:,:,t1)*50, 'AutoScale', 'off', 'Color' ,'w');%, 'LineWidth',2);%,'MaxHeadSize',5);
colormap(parula(countIMax+1));
% hcolorBar = colorbar('Ticks',(-countIMax:1),'TickLabels',(0:1:countIMax+1));
% ylabel(hcolorBar, "$N_I$", 'Interpreter', 'latex');
% caxis([-countIMax 0]);
patch( [xLeft xLeft xLeft+depth xLeft+depth], [0 yLeft yLeft 0], [zCut zCut zCut zCut], 'w');
patch( [xLeft xLeft xLeft+depth xLeft+depth], [yLeft+width yLeft+2*width yLeft+2*width yLeft+width], [zCut zCut zCut zCut], 'w');
patch( [xLeft xLeft xLeft+depth xLeft+depth], [yLeft+3*width 2000 2000 yLeft+3*width], [zCut zCut zCut zCut], 'w');
patch( [xRight xRight xRight+depth xRight+depth], [0 yRight yRight 0], [zCut zCut zCut zCut], 'w');
patch( [xRight xRight xRight+depth xRight+depth], [yRight+width yRight+2*width yRight+2*width yRight+width], [zCut zCut zCut zCut], 'w');
patch( [xRight xRight xRight+depth xRight+depth], [yRight+3*width 2000 2000 yRight+3*width], [zCut zCut zCut zCut], 'w');
set(ax1,'ytick',[0 100 220 340 460 540]);
set(ax1,'yticklabel',[0 80 200 320 440 520]);
set(ax1,'xtick',[0 120 180 300 360 520]);
set(ax1,'xticklabel',[0 120 180 300 360 520]);
xtickangle(45);
% set(ax1,'xtick',[0 60 120 180 240 300 360 420 480 520]);
% set(ax1,'xticklabel',[0 60 120 180 240 300 360 420 480 520]);
set(ax1,'TickDir','out');
axis(ax1,'square')
% set(ax1,'Units','Centimeters','Position',[1 1 8 8]);
set(findall(ax1,'-property','FontSize'),'FontSize',9);

nexttile
ax2 = gca;
% ax2 = subplot(1,3,2);
% ax2 = axes('Position',pos2,'Units','centimeters');
% subplot(1,3,2);
t2 = 201;
surf(x,y,countI(:,:,t2)-countIMax);
axis([xLow xUp yLow yUp -countIMax 0]);
% surf(x,y,logKinetic(:,:,t2)-logKineticMax);
% axis([xLow xUp yLow yUp -logKineticMax 0]);
title("$t=1000$ ~~ \qquad (b)",'Interpreter','Latex')
xlabel("$x$",'Interpreter','Latex');
% ylabel("$y$",'Interpreter','Latex');
view(0,90);
hold on
quiver(x+10, y+10, uNormCM(:,:,t2)*50, vNormCM(:,:,t2)*50, 'AutoScale', 'off', 'Color' ,'w');%, 'LineWidth',2);%,'MaxHeadSize',5);
colormap(parula(countIMax+1));
% hcolorBar = colorbar('Ticks',(-countIMax:1),'TickLabels',(0:1:countIMax+1));
% ylabel(hcolorBar, "$N_I$", 'Interpreter', 'latex');
% caxis([-countIMax 0]);
patch( [xLeft xLeft xLeft+depth xLeft+depth], [0 yLeft yLeft 0], [zCut zCut zCut zCut], 'w');
patch( [xLeft xLeft xLeft+depth xLeft+depth], [yLeft+width yLeft+2*width yLeft+2*width yLeft+width], [zCut zCut zCut zCut], 'w');
patch( [xLeft xLeft xLeft+depth xLeft+depth], [yLeft+3*width 2000 2000 yLeft+3*width], [zCut zCut zCut zCut], 'w');
patch( [xRight xRight xRight+depth xRight+depth], [0 yRight yRight 0], [zCut zCut zCut zCut], 'w');
patch( [xRight xRight xRight+depth xRight+depth], [yRight+width yRight+2*width yRight+2*width yRight+width], [zCut zCut zCut zCut], 'w');
patch( [xRight xRight xRight+depth xRight+depth], [yRight+3*width 2000 2000 yRight+3*width], [zCut zCut zCut zCut], 'w');
set(ax2,'ytick',[0 100 220 340 460 540]);
set(ax2,'yticklabel',[]);
set(ax2,'xtick',[0 120 180 300 360 520]);
set(ax2,'xticklabel',[0 120 180 300 360 520]);
xtickangle(45);
% set(ax2,'xtick',[0 60 120 180 240 300 360 420 480 520]);
% set(ax2,'xticklabel',[0 60 120 180 240 300 360 420 480 520]);
set(ax2,'TickDir','out');
axis(ax2,'square')
% set(ax2,'Units','Centimeters','Position',[10 1 8 8]);
set(findall(ax2,'-property','FontSize'),'FontSize',9);

nexttile
ax3 = gca;
% ax3 = subplot(1,3,3);
% ax3 = axes('Position',pos3,'Units','centimeters');
% subplot(1,3,3);
t3 = 2001;
surf(x,y,countI(:,:,t3)-countIMax);
axis([xLow xUp yLow yUp -countIMax 0]);
% surf(x,y,logKinetic(:,:,t3)-logKineticMax);
% axis([xLow xUp yLow yUp -logKineticMax 0]);
title("$t=10000$ \qquad (c)",'Interpreter','Latex')
xlabel("$x$",'Interpreter','Latex');
% ylabel("$y$",'Interpreter','Latex');
view(0,90);
hold on
quiver(x+10, y+10, uNormCM(:,:,t3)*50, vNormCM(:,:,t3)*50, 'AutoScale', 'off', 'Color' ,'w');%, 'LineWidth',2);%,'MaxHeadSize',5);
colormap(parula(countIMax+1));
patch( [xLeft xLeft xLeft+depth xLeft+depth], [0 yLeft yLeft 0], [zCut zCut zCut zCut], 'w');
patch( [xLeft xLeft xLeft+depth xLeft+depth], [yLeft+width yLeft+2*width yLeft+2*width yLeft+width], [zCut zCut zCut zCut], 'w');
patch( [xLeft xLeft xLeft+depth xLeft+depth], [yLeft+3*width 2000 2000 yLeft+3*width], [zCut zCut zCut zCut], 'w');
patch( [xRight xRight xRight+depth xRight+depth], [0 yRight yRight 0], [zCut zCut zCut zCut], 'w');
patch( [xRight xRight xRight+depth xRight+depth], [yRight+width yRight+2*width yRight+2*width yRight+width], [zCut zCut zCut zCut], 'w');
patch( [xRight xRight xRight+depth xRight+depth], [yRight+3*width 2000 2000 yRight+3*width], [zCut zCut zCut zCut], 'w');
set(ax3,'ytick',[0 100 220 340 460 540]);
set(ax3,'yticklabel',[]);
set(ax3,'xtick',[0 120 180 300 360 520]);
set(ax3,'xticklabel',[0 120 180 300 360 520]);
xtickangle(45);
% set(ax3,'xtick',[0 60 120 180 240 300 360 420 480 520]);
% set(ax3,'xticklabel',[0 60 120 180 240 300 360 420 480 520]);
set(ax3,'TickDir','out');
% set(ax3,'Units','Centimeters','Position',[20 1 8 8]);
set(findall(ax3,'-property','FontSize'),'FontSize',9);
axis(ax3,'square')


% axesHandles = findobj(get(triFig,'Children'), 'flat','Type','axes');
% axis(axesHandles,'square')

% hcolorBar = colorbar(ax3);
% hcolorBar = colorbar('Ticks',(-countIMax:1),'TickLabels',(0:1:countIMax+1));
% hcolorBar = colorbar('Ticks',(-countIMax:1),'TickLabels',(0:1:countIMax+1),'Position',[1.1 0 0.1 0.9]);
hcolorBar = colorbar('Ticks',[-1.75 -1.25 -0.75],'TickLabels',{'0' '1' '2'});
ylabel(hcolorBar, "$N_I$", 'Interpreter', 'latex','FontSize',9);
% caxis([-countIMax 0]);
hcolorBar.Layout.Tile = 'east';

set(triFig,'Units','Centimeter','Position',[0 0 17.2 8.6]);

fileName = "Vcm_Ni_LJTime_Triple";


exportgraphics(triFig,strcat(fileName,".png"));
exportgraphics(triFig,strcat(fileName,".eps"));
savefig(triFig,strcat(fileName,".fig"));
close(triFig);
end
