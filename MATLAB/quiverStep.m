function [] = quiverStep(t,x,y,u,v)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
xLow = 920;
xUp = 1240;
yLow = 700;
yUp = 1300;

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
for i = 1:1:size(t,1)
%for i = 1:10:size(t,1)
    qFig = figure('Visible','off');
    quiver(x,y,u(:,:,i),v(:,:,i),0.5);

    %q=quiver(x,y,u,v,0.5,'Color','k');

    %set(q,'LineWidth',.5,'MaxHeadSize',10,'Color','black');
    % q.LineWidth = 1;
    % q.MaxHeadSize = 10;

    %if orifices == 1
    rectangle('Position',[1000 0 20 940], 'FaceColor', 'k');
    rectangle('Position',[1000 1060 20 940], 'FaceColor', 'k');
    %elseif orifices == 2
    rectangle('Position',[1120 0 20 820], 'FaceColor', 'k');
    rectangle('Position',[1120 940 20 120], 'FaceColor', 'k');
    rectangle('Position',[1120 1180 20 820], 'FaceColor', 'k');
    %end
    axis([xLow xUp yLow yUp]);
    title(strcat("Center of Mass Velocity Field at $t^*=$ ", num2str(t(i))), 'Interpreter', 'LaTex', 'FontSize', 12 );
    xlabel("x, $r*$",'Interpreter','Latex');
    ylabel("y, $r*$",'Interpreter','Latex');
    print(strcat("Impurity_Quiver_Timestep_",num2str(t(i)*200)), '-dpng');
    close(qFig);
    
end

end

