function [] = quiverStep(t,x,y,u,v,xLow,xUp,yLow,yUp,orifices)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% headWidth = 5;
% headLength = 5;
% lineLength = 5;
% figure('Show','off');
% for i = 1:1:101
%     for j = 1:1:100
%         if u(i,j) == 0
%             continue
%         else
%             ah = annotation('arrow',...
%                 'headStyle','cback1','HeadLength',headLength,'HeadWidth',headWidth);
%             set(ah,'parent',gca);
%             set(ah,'position',[x(i,j) y(i,j) lineLength*u(i,j) lineLength*v(i,j)]);
%         end
%     end
% end
qFig = figure('Visible','off');
quiver(x,y,u,v,0.5);

%q=quiver(x,y,u,v,0.5,'Color','k');

%set(q,'LineWidth',.5,'MaxHeadSize',10,'Color','black');
% q.LineWidth = 1;
% q.MaxHeadSize = 10;

if orifices == 1
    rectangle('Position',[1000 0 20 980])
    rectangle('Position',[1000 1020 20 980])
elseif orifices == 2
    rectangle('Position',[1000 0 20 800])
    rectangle('Position',[1000 900 20 200])
    rectangle('Position',[1000 1200 20 800])
end
axis([xLow xUp yLow yUp]);
title(strcat("Center of Mass Velocity Field at $t^*=$ ", num2str(t-1)), 'Interpreter', 'LaTex', 'FontSize', 12 );
xlabel("x, $r*$",'Interpreter','Latex');
ylabel("y, $r*$",'Interpreter','Latex');
print(strcat("Quiver_Timestep_",num2str((t-1)*200)), '-dpng');
close(qFig);
end

