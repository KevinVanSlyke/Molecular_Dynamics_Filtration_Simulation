function [] = surfTempStep(t,x,y,temp)
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes here
xLow = 800;
xUp = 1300;
yLow = 800;
yUp = 1200;

for i = 1:1:size(t,1)
    qFig = figure('Visible','off');
    surf(x,y,temp(:,:,i));

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
    
    %if orifices == 1
    rectangle('Position',[1000 0 20 950], 'FaceColor', 'k');
    rectangle('Position',[1000 1051 20 949], 'FaceColor', 'k');
    %elseif orifices == 2
    rectangle('Position',[1120 0 20 850], 'FaceColor', 'k');
    rectangle('Position',[1120 951 20 99], 'FaceColor', 'k');
    rectangle('Position',[1120 1151 20 849], 'FaceColor', 'k');
    %end
    
    axis([xLow xUp yLow yUp]);
    title(strcat("Temperature Grid at $t^*=$ ", num2str(t(i))), 'Interpreter', 'LaTex', 'FontSize', 12 );
    xlabel("x, $r*$",'Interpreter','Latex');
    ylabel("y, $r*$",'Interpreter','Latex');
    print(strcat("Temperature_Timestep_",num2str(t(i)*200)), '-dpng');
    close(qFig);
end
end

