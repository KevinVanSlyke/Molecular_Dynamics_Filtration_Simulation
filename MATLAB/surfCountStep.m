function [] = surfCountStep(t,x,y,count)
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes here
xLow = 920;
xUp = 1240;
yLow = 700;
yUp = 1300;
nMax = max(count,[],'all');


for i = 1:1:size(t,1)
    qFig = figure('Visible','off');
    surf(x,y,count(:,:,i));
    axis([xLow xUp yLow yUp 0 nMax]);
    hold on;
    colorbar('Ticks', [0:1:nMax]);
    %colorbar('Ticks', []);
    view(0,90);
    %quiver(x,y,u(:,:,i),v(:,:,i),0.5);

    
    %q=quiver(x,y,u,v,0.5,'Color','w');

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
    patch( [1000 1000 1020 1020], [0 940 940 0], [nMax nMax nMax nMax], 'k');
    patch( [1000 1000 1020 1020], [1060 2000 2000 1060], [nMax nMax nMax nMax ], 'k');
    %rectangle('Position',[1000 0 20 950], 'FaceColor', 'k');
    %rectangle('Position',[1000 1051 20 949], 'FaceColor', 'k');
    %elseif orifices == 2
    patch( [1120 1120 1140 1140], [0 820 820 0], [nMax nMax nMax nMax], 'k');
    patch( [1120 1120 1140 1140], [940 1060 1060 940], [nMax nMax nMax nMax], 'k');
    patch( [1120 1120 1140 1140], [1180 2000 2000 1180], [nMax nMax nMax nMax], 'k');
    %rectangle('Position',[1220 0 20 850], 'FaceColor', 'k');
    %rectangle('Position',[1220 951 20 99], 'FaceColor', 'k');
    %rectangle('Position',[1220 1151 20 849], 'FaceColor', 'k');
    %end
    title(strcat("Count Grid at $t^*=$ ", num2str(t(i))), 'Interpreter', 'LaTex', 'FontSize', 12 );
    xlabel("x, $r*$",'Interpreter','Latex');
    ylabel("y, $r*$",'Interpreter','Latex');
    print(strcat("Impurity_Count_Timestep_",num2str(t(i)*200)), '-dpng');
    close(qFig);
end
end

