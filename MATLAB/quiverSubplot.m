function [] = quiverSubplot(x,y,u,v,t1,t2,t3,simString)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
orifices = 1;

xLow = 900;
xUp = 1100;
yLow = 900;
yUp = 1100;

yTicks = [800 900 1000 1100 1200];

u1=u(:,:,t1);
v1=v(:,:,t1);
u2=u(:,:,t2);
v2=v(:,:,t2);
u3=u(:,:,t3);
v3=v(:,:,t3);

% qFig=figure('Visible','on','Position',[0 0 1200 420]);
% qFig=figure('Visible','on');
qFig=figure('Visible','on','Units','Centimeters','Position',[0 0 8.6*2 7]);
tileFig = tiledlayout(1,3);
tileFig.TileSpacing = 'Compact';
tileFig.Padding = 'Compact';
% pos1=[0.2 0.2 0.5 0.5];
% ax1=subplot('Position',pos1);
nexttile
% ax1=subplot(1,3,1);
% q1=quiver(x+10,y+10,u1,v1,0.5);
quiver(x+10,y+10,u1,v1,0.5);

if orifices == 1
    rectangle('Position',[1000 0 20 980],'LineWidth',1)
    rectangle('Position',[1000 1020 20 980],'LineWidth',1)
elseif orifices == 2
    rectangle('Position',[1000 0 20 920],'LineWidth',1)
    rectangle('Position',[1000 960 20 80],'LineWidth',1)
    rectangle('Position',[1000 1080 20 920],'LineWidth',1)
end
axis([xLow xUp yLow yUp]);
ax1 = gca;
ax1.FontSize = 12;
axis square;
%xticklabels([]);
xtickangle(45);
yticks(yTicks);
ylabel("Vertical Displacement, $y~(r^*)$ ", 'Interpreter', 'LaTex', 'FontSize', 12 );

title(strcat("$t=", num2str((t1-1)*5),"t^*$"), 'Interpreter', 'LaTex', 'FontSize', 12 );
% aTitle = title(strcat("$t=", num2str((t1-1)*5),"t^*$ (a) "), 'Interpreter', 'LaTex', 'FontSize', 12 );
text(xUp-30,yUp+20,'(a)','FontSize',12);
% pos2=[0.8 0.2 0.5 0.5];
% ax2=subplot('Position',pos2);
nexttile
% ax1=subplot(1,3,2);
% q2=quiver(x+10,y+10,u2,v2,0.5);
quiver(x+10,y+10,u2,v2,0.5);
if orifices == 1
    rectangle('Position',[1000 0 20 980],'LineWidth',1)
    rectangle('Position',[1000 1020 20 980],'LineWidth',1)
elseif orifices == 2
    rectangle('Position',[1000 0 20 920],'LineWidth',1)
    rectangle('Position',[1000 960 20 80],'LineWidth',1)
    rectangle('Position',[1000 1080 20 920],'LineWidth',1)
end
axis([xLow xUp yLow yUp]);
ax2 = gca;
ax2.FontSize = 12;
axis square;
xlabel("Horizontal Displacement, $x~(r^*)$ ", 'Interpreter', 'LaTex', 'FontSize', 12 );
xtickangle(45);
yticks(yTicks);
yticklabels([]);

title(strcat("$t=", num2str((t2-1)*5),"t^*$"), 'Interpreter', 'LaTex', 'FontSize', 12 );
text(xUp-30,yUp+20,'(b)','FontSize',12);
% pos3=[1.4 0.2 0.5 0.5];
% ax3=subplot('Position',pos3);
nexttile
% ax3=subplot(1,3,3);
% q3=quiver(x+10,y+10,u3,v3,0.5);
quiver(x+10,y+10,u3,v3,0.5);
if orifices == 1
    rectangle('Position',[1000 0 20 980],'LineWidth',1)
    rectangle('Position',[1000 1020 20 980],'LineWidth',1)
elseif orifices == 2
    rectangle('Position',[1000 0 20 920],'LineWidth',1)
    rectangle('Position',[1000 960 20 80],'LineWidth',1)
    rectangle('Position',[1000 1080 20 920],'LineWidth',1)
end
axis([xLow xUp yLow yUp]);
ax3 = gca;
ax3.FontSize = 12;
axis square;
%xticklabels([]);
xtickangle(45);
yticks(yTicks);
yticklabels([]);
title(strcat("$t=", num2str((t3-1)*5),"t^*$"), 'Interpreter', 'LaTex', 'FontSize', 12 );
text(xUp-30,yUp+20,'(c)','FontSize',12);
%q=quiver(x,y,u,v,0.5,'Color','k');

%set(q,'LineWidth',.5,'MaxHeadSize',10,'Color','black');
% q.LineWidth = 1;
% q.MaxHeadSize = 10;

% sgtitle("Center of Mass Velocity Vector Fields", 'Interpreter', 'LaTex', 'FontSize', 12 );

%     sgtitle("Mono-Orifice Center of Mass Velocity Vector Fields", 'Interpreter', 'LaTex', 'FontSize', 12 );
%     print(strcat("Zoom_Mono_Quiver_Timesteps_",num2str((t1-1)*1000),'_',num2str((t2-1)*1000),'_',num2str((t3-1)*1000)), '-dpng');
fileName = strcat("Quiver_Compare_",simString,"_t",num2str((t1-1)*5),'_',num2str((t2-1)*5),'_',num2str((t3-1)*5));
exportgraphics(tileFig,strcat(fileName,".png"));
exportgraphics(tileFig,strcat(fileName,".eps"));
savefig(qFig,strcat(fileName,".fig"));

close(qFig);
end

