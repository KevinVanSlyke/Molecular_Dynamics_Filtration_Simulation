function [] = quiverSubplot(x,y,u,v,t1,t2,t3)
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

qFig=figure('Visible','on','Position',[0 0 1200 400]);
% qFig=figure('Visible','on');

% pos1=[0.2 0.2 0.5 0.5];
% ax1=subplot('Position',pos1);
ax1=subplot(1,3,1);

q1=quiver(x,y,u1,v1,0.5);

if orifices == 1
    rectangle('Position',[1000 0 20 980],'LineWidth',1)
    rectangle('Position',[1000 1020 20 980],'LineWidth',1)
elseif orifices == 2
    rectangle('Position',[1000 0 20 920],'LineWidth',1)
    rectangle('Position',[1000 960 20 80],'LineWidth',1)
    rectangle('Position',[1000 1080 20 920],'LineWidth',1)
end
axis([xLow xUp yLow yUp]);
axis square;
%xticklabels([]);
yticks(yTicks);
ylabel("Vertical Displacement, $r^*$ ", 'Interpreter', 'LaTex', 'FontSize', 12 );
title(strcat("$t^*=$ ", num2str((t1-1)*5)), 'Interpreter', 'LaTex', 'FontSize', 12 );

% pos2=[0.8 0.2 0.5 0.5];
% ax2=subplot('Position',pos2);
ax1=subplot(1,3,2);
q2=quiver(x,y,u2,v2,0.5);
if orifices == 1
    rectangle('Position',[1000 0 20 980],'LineWidth',1)
    rectangle('Position',[1000 1020 20 980],'LineWidth',1)
elseif orifices == 2
    rectangle('Position',[1000 0 20 920],'LineWidth',1)
    rectangle('Position',[1000 960 20 80],'LineWidth',1)
    rectangle('Position',[1000 1080 20 920],'LineWidth',1)
end
axis([xLow xUp yLow yUp]);
axis square;
xlabel("Horizontal Displacement, $r^*$ ", 'Interpreter', 'LaTex', 'FontSize', 12 );
yticklabels([]);
title(strcat("$t^*=$ ", num2str((t2-1)*5)), 'Interpreter', 'LaTex', 'FontSize', 12 );

% pos3=[1.4 0.2 0.5 0.5];
% ax3=subplot('Position',pos3);
ax3=subplot(1,3,3);
q3=quiver(x,y,u3,v3,0.5);
if orifices == 1
    rectangle('Position',[1000 0 20 980],'LineWidth',1)
    rectangle('Position',[1000 1020 20 980],'LineWidth',1)
elseif orifices == 2
    rectangle('Position',[1000 0 20 920],'LineWidth',1)
    rectangle('Position',[1000 960 20 80],'LineWidth',1)
    rectangle('Position',[1000 1080 20 920],'LineWidth',1)
end
axis([xLow xUp yLow yUp]);
axis square;
%xticklabels([]);
yticklabels([]);
title(strcat("$t^*=$ ", num2str((t3-1)*5)), 'Interpreter', 'LaTex', 'FontSize', 12 );

%q=quiver(x,y,u,v,0.5,'Color','k');

%set(q,'LineWidth',.5,'MaxHeadSize',10,'Color','black');
% q.LineWidth = 1;
% q.MaxHeadSize = 10;

sgtitle("Center of Mass Velocity Vector Fields", 'Interpreter', 'LaTex', 'FontSize', 12 );

if orifices == 1
    sgtitle("Mono-Orifice Center of Mass Velocity Vector Fields", 'Interpreter', 'LaTex', 'FontSize', 12 );
    print(strcat("Zoom_Mono_Quiver_Timesteps_",num2str((t1-1)*1000),'_',num2str((t2-1)*1000),'_',num2str((t3-1)*1000)), '-dpng');
else
    sgtitle("Dual-Orifice Center of Mass Velocity Vector Fields", 'Interpreter', 'LaTex', 'FontSize', 12 );
    print(strcat("Zoom_Dual_Quiver_Timesteps_",num2str((t1-1)*1000),'_',num2str((t2-1)*1000),'_',num2str((t3-1)*1000)), '-dpng');
end
close(qFig);
end

