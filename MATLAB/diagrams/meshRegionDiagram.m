function [] = meshRegionDiagram(t,x,y,uA,vA,countA,tempA,uI,vI,countI,tempI,D)
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes here

vcm = 1;
bothAI = 0;

FL = 2;
zCut = 0;
width = 120;
depth = 60;
spacing = 120;
separation = 120;
shift = 0;

middleY = 280;
yCentered = y - middleY;

xLeft = 120;
% yLeft = mid-width/2;

xRight = xLeft+depth+separation;
if FL == 1
    yLeft = -width/2-shift;
    yRight = yLeft-spacing/2-width/2+shift;
else
    yLeft = -width-spacing/2-shift;
    yRight = yLeft+shift;
end
% yRight = yLeft+360;

xLow = min(x,[],'all');
xUp = max(x,[],'all')-20;
yLow = min(yCentered,[],'all')+20;
yUp = max(yCentered,[],'all');

t1 = 21;
t2 = 201;
t3 = 2001;

% xAxMax = size(x,1);
% yAxMax = size(y,1);

% countAMax = max(countA,[],'all');
% tempAMax = max(tempA,[],'all');
% countIMax = max(countI,[],'all');
% tempIMax = max(tempI,[],'all');

% countIMax = round(max(countI,[],'all'));
countIMax = max([countI(:,:,t1), countI(:,:,t2), countI(:,:,t3)],[],'all');

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
vNormCMRegions = vNormCM(:,:,t3);
vNormCMRegions(isinf(vNormCMRegions)|isnan(vNormCMRegions)) = 0;
vFL1 = mean(vNormCMRegions(10:15, 1:28),'all');
% vFL1 = mean(vNormCMRegions(10:15, 10:23),'all');
vSL2 = mean(vNormCMRegions(20:28, 1:14),'all');
vSL1 = mean(vNormCMRegions(20:28, 15:28),'all');
uNormCMRegions = uNormCM(:,:,t3);
uNormCMRegions(isinf(uNormCMRegions)|isnan(uNormCMRegions)) = 0;
uFL1 = mean(uNormCMRegions(10:15, 1:28),'all');
% uFL1 = mean(uNormCMRegions(10:15, 10:23),'all');
uSL2 = mean(uNormCMRegions(20:28, 1:14),'all');
uSL1 = mean(uNormCMRegions(20:28, 15:28),'all');
triFig = figure('Visible','on');
if vcm == 1
    ax1 = gca;
    % ax1 = subplot(1,3,1);
    % ax1 = axes('Position',pos1,'Units','centimeters');
    % subplot(1,3,1);
%     mesh(x,y,zeros(28,28),'EdgeColor',[0 0 0]);
    axis([xLow xUp yLow yUp -1 1]);
    % surf(x,y,logKinetic(:,:,t3)-logKineticMax);
    % axis([xLow xUp yLow yUp -logKineticMax 0]);
    title("$t^*=10000$ \qquad ~~~",'Interpreter','Latex')
    xlabel("$x'/\sigma$~(Dimensionless)",'Interpreter','Latex');
    ylabel("$y'/\sigma$~(Dimensionless)",'Interpreter','Latex');
    view(0,90);
    hold on
    quiver(x+10, yCentered+10, uNormCM(:,:,t3)*50, vNormCM(:,:,t3)*50, 'AutoScale', 'off', 'Color' ,'k');%, 'LineWidth',2);%,'MaxHeadSize',5);
%     colormap(parula(countIMax+1));
    % hcolorBar = colorbar('Ticks',(-countIMax:1),'TickLabels',(0:1:countIMax+1));
    % ylabel(hcolorBar, "$N_I$", 'Interpreter', 'latex');
    % caxis([-countIMax 0]);
    phiScale = 1;
    %Patches for the filter walls
    if FL == 1
        patch( [xLeft xLeft xLeft+depth xLeft+depth], [-2000 yLeft yLeft -2000], [zCut zCut zCut zCut], 'FaceColor',[0.94 0.94 0.94]);
        patch( [xLeft xLeft xLeft+depth xLeft+depth], [yLeft+width 2000 2000 yLeft+width], [zCut zCut zCut zCut], 'FaceColor',[0.94 0.94 0.94]);

        patch( [xLeft+depth xLeft+depth xRight-0.2 xRight-0.2], [20 540 540 20], [zCut zCut zCut zCut], 'FaceColor', 'none','EdgeColor',[0 0 0],'LineWidth',2);
%         text(200, 240, '$\Phi_{FL[1]}$','Color',[0.4940 0.1840 0.5560],'Interpreter','latex','FontSize',22,'FontWeight','bold')
        text(180, 210, '$\Phi$','Color',[0 0 0],'Interpreter','latex','FontSize',22,'FontWeight','bold')
%         text(180, 210, '$\Phi$','Color',[0.4940 0.1840 0.5560],'Interpreter','latex','FontSize',22,'FontWeight','bold')
%         text(215, 180, '\textbf{FL[1]}','Color',[0.4940 0.1840 0.5560],'Interpreter','latex','FontSize',12,'FontWeight','bold')
        text(215, 180, '\textbf{FL}','Color',[0 0 0],'Interpreter','latex','FontSize',12,'FontWeight','bold')
%         text(215, 180, '\textbf{FL}','Color',[0.4940 0.1840 0.5560],'Interpreter','latex','FontSize',12,'FontWeight','bold')
        annotation('arrow',[0.41 0.41+uFL1*phiScale],[0.525 0.525+vFL1*phiScale],'Color',[0 0 0],'LineWidth',2);
%         annotation('arrow',[0.41 0.41+uFL1*1.75],[0.525 0.525+vFL1*1.75],'Color',[0.4940 0.1840 0.5560],'LineWidth',2);
        annotation('line',[0.41 0.41+.19],[0.525 0.525],'Color',[0 0 0],'LineWidth',2,'LineStyle','--');
%         annotation('line',[0.41 0.41+.19],[0.525 0.525],'Color',[0.4940 0.1840 0.5560],'LineWidth',2,'LineStyle','--');
%         annotation('textarrow',[]);

        patch( [xRight xRight xRight+depth xRight+depth], [-2000 yRight yRight -2000], [zCut zCut zCut zCut], 'FaceColor',[0.94 0.94 0.94]);
%         patch( [xRight+depth xRight+depth 520 520], [280.5 540 540 280.5], [zCut zCut zCut zCut], 'FaceColor', 'none','EdgeColor',[1 0 0],'LineWidth',2);
%         text(380, 420, '$\Phi_{SL[1]}$','Color',[1 0 0],'Interpreter','latex','FontSize',22,'FontWeight','bold')
        text(380, 350, '$\Phi$','Color',[1 0 0],'Interpreter','latex','FontSize',22,'FontWeight','bold')
        text(415, 320, '\textbf{SL[1]}','Color',[1 0 0],'Interpreter','latex','FontSize',12,'FontWeight','bold')
        annotation('arrow',[0.665 0.665+uSL1*phiScale],[0.705 0.705+vSL1*phiScale],'Color',[1 0 0],'LineWidth',2);
        annotation('line',[0.665 0.665+.225],[0.705 0.705],'Color',[1 0 0],'LineWidth',2,'LineStyle','--');

        patch( [xRight xRight xRight+depth xRight+depth], [yRight+width yRight+2*width yRight+2*width yRight+width], [zCut zCut zCut zCut], 'FaceColor',[0.94 0.94 0.94]);
        patch( [xRight xRight xRight+depth xRight+depth], [yRight+3*width 2000 2000 yRight+3*width], [zCut zCut zCut zCut], 'FaceColor',[0.94 0.94 0.94]);
        patch( [xRight+depth xRight+depth 520 520], [20 279.2 279.2 20], [zCut zCut zCut zCut], 'FaceColor', 'none','EdgeColor',[0 0 1],'LineWidth',2);
%         text(400, 100, '$\Phi_{SL[2]}$','Color',[0 0 1],'Interpreter','latex','FontSize',22,'FontWeight','bold')
        text(380, 100, '$\Phi$','Color',[0 0 1],'Interpreter','latex','FontSize',22,'FontWeight','bold')
        text(415, 70, '\textbf{SL[2]}','Color',[0 0 1],'Interpreter','latex','FontSize',12,'FontWeight','bold')
        annotation('arrow',[0.665 0.665+uSL2*1.75],[0.33 0.33+vSL2*1.75],'Color',[0 0 1],'LineWidth',2);
        annotation('line',[0.665 0.665+.225],[0.33 0.33],'Color',[0 0 1],'LineWidth',2,'LineStyle','--');

    elseif FL == 2
        patch( [xLeft xLeft xLeft+depth xLeft+depth], [-2000 yLeft yLeft -2000], [zCut zCut zCut zCut], 'FaceColor',[0.94 0.94 0.94]);
        patch( [xLeft xLeft xLeft+depth xLeft+depth], [yLeft+width yLeft+2*width yLeft+2*width yLeft+width], [zCut zCut zCut zCut], 'FaceColor',[0.94 0.94 0.94]);
        patch( [xLeft xLeft xLeft+depth xLeft+depth], [yLeft+3*width 2000 2000 yLeft+3*width], [zCut zCut zCut zCut], 'FaceColor',[0.94 0.94 0.94]);
        
        patch( [xRight xRight xRight+depth xRight+depth], [-2000 yRight yRight -2000], [zCut zCut zCut zCut], 'FaceColor',[0.94 0.94 0.94]);
        patch( [xRight+depth xRight+depth 520 520], [280.5 540 540 280.5]-middleY, [zCut zCut zCut zCut], 'FaceColor', 'none','EdgeColor',[1 0 0],'LineWidth',2);
%         text(380, 420, '$\Phi_{SL[1]}$','Color',[1 0 0],'Interpreter','latex','FontSize',22,'FontWeight','bold')
        text(380, 350-middleY, '$\Phi$','Color',[1 0 0],'Interpreter','latex','FontSize',22,'FontWeight','bold')
        text(415, 320-middleY, '\textbf{SL[1]}','Color',[1 0 0],'Interpreter','latex','FontSize',12,'FontWeight','bold')
        annotation('arrow',[0.665 0.665+uSL1*phiScale],[0.705 0.705+vSL1*phiScale],'Color',[1 0 0],'LineWidth',2);
        annotation('line',[0.665 0.665+.225],[0.705 0.705],'Color',[1 0 0],'LineWidth',2,'LineStyle','--');

        
        patch( [xRight xRight xRight+depth xRight+depth], [yRight+width yRight+2*width yRight+2*width yRight+width], [zCut zCut zCut zCut], 'FaceColor',[0.94 0.94 0.94]);
        patch( [xRight xRight xRight+depth xRight+depth], [yRight+3*width 2000 2000 yRight+3*width], [zCut zCut zCut zCut], 'FaceColor',[0.94 0.94 0.94]);
        patch( [xRight+depth xRight+depth 520 520], [20 279.2 279.2 20]-middleY, [zCut zCut zCut zCut], 'FaceColor', 'none','EdgeColor',[0 0 1],'LineWidth',2);
%         text(400, 100, '$\Phi_{SL[2]}$','Color',[0 0 1],'Interpreter','latex','FontSize',22,'FontWeight','bold')
        text(380, 100-middleY, '$\Phi$','Color',[0 0 1],'Interpreter','latex','FontSize',22,'FontWeight','bold')
        text(415, 70-middleY, '\textbf{SL[2]}','Color',[0 0 1],'Interpreter','latex','FontSize',12,'FontWeight','bold')
        annotation('arrow',[0.665 0.665+uSL2*phiScale],[0.33 0.33+vSL2*phiScale],'Color',[0 0 1],'LineWidth',2);
        annotation('line',[0.665 0.665+.225],[0.33 0.33],'Color',[0 0 1],'LineWidth',2,'LineStyle','--');    
    
    end
    yticks(-600:120:600);
    xticks(-600:120:600);

%     set(ax1,'ytick',[0 100 160 280 340 460 540]);
%     set(ax1,'yticklabel',[0 80 140 260 320 440 520]);
%     set(ax1,'xtick',[0 120 180 300 360 520]);
%     set(ax1,'xticklabel',[0 120 180 300 360 520]);
%     xtickangle(45);
    % set(ax1,'xtick',[0 60 120 180 240 300 360 420 480 520]);
    % set(ax1,'xticklabel',[0 60 120 180 240 300 360 420 480 520]);
    set(ax1,'TickDir','out');
%     axis(ax1,'square')
    % set(ax1,'Units','Centimeters','Position',[1 1 8 8]);
%     set(findall(ax1,'-property','FontSize'),'FontSize',9);
    
    % axesHandles = findobj(get(triFig,'Children'), 'flat','Type','axes');
    % axis(axesHandles,'square')
    
    % hcolorBar = colorbar(ax3);
    % hcolorBar = colorbar('Ticks',(-countIMax+0.25:1:0.25),'TickLabels',(0:1:countIMax));
%     hcolorBar = colorbar('Ticks',(-countIMax:1),'TickLabels',(0:1:countIMax+1));
    % hcolorBar = colorbar('Ticks',(-countIMax:1),'TickLabels',(0:1:countIMax+1),'Position',[1.1 0 0.1 0.9]);
    % hcolorBar = colorbar('Ticks',[-1.75 -1.25 -0.75],'TickLabels',{'0' '1' '2'});
%     ylabel(hcolorBar, "$N_I$", 'Interpreter', 'latex','FontSize',9);
    % caxis([-countIMax 0]);
%     hcolorBar.Layout.Tile = 'east';
end

set(triFig,'Units','Centimeter','Position',[0 0 8.6 8.6]);
fileName = strcat('Phi_Region_Diagram_Vcm_Clean_',num2str(width),'W_',num2str(D),'D_',num2str(depth),'L_',num2str(separation),'F_',num2str(spacing),'S_',num2str(shift),'H');
exportgraphics(triFig,strcat(fileName,".png"));
exportgraphics(triFig,strcat(fileName,".eps"));
savefig(triFig,strcat(fileName,".fig"));
close(triFig);
end
