function [] = surfCountStep(t,x,y,count,xLow,xUp,yLow,yUp)
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes here
qFig = figure('Visible','off');
surf(x,y,count);

%q=quiver(x,y,u,v,0.5,'Color','k');

%set(q,'LineWidth',.5,'MaxHeadSize',10,'Color','black');
% q.LineWidth = 1;
% q.MaxHeadSize = 10;

% if orifices == 1
%     rectangle('Position',[1000 0 20 980],'FaceColor','white')
%     rectangle('Position',[1000 1020 20 980],'FaceColor','white')
% elseif orifices == 2
%     rectangle('Position',[1000 0 20 800],'FaceColor','white')
%     rectangle('Position',[1000 900 20 200],'FaceColor','white')
%     rectangle('Position',[1000 1200 20 800],'FaceColor','white')
% end
axis([xLow xUp yLow yUp]);
title(strcat("Temperature Grid at $t^*=$ ", num2str(t-1)), 'Interpreter', 'LaTex', 'FontSize', 12 );
xlabel("x, $r*$",'Interpreter','Latex');
ylabel("y, $r*$",'Interpreter','Latex');
print(strcat("Count_Timestep_",num2str((t-1)*200)), '-dpng');
close(qFig);
end

