function [] = annotationQuiverStep(t,x,y,u,v,xLow,xUp,yLow,yUp,orifices)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
headWidth = 5;
headLength = 5;
lineLength = 5;

%right version (with annotation)
%hax_2 = subplot(1,2,2);
%hold on;
aqFig=figure('Visible','off');
for i = 1:1:101
    for j = 1:1:100
        %Need to add an if statement to not draw a head for a zero vector
        if u(i,j) == 0
            continue
        else
            aq = annotation('arrow',...
                'headStyle','cback1','HeadLength',headLength*(u(i,j)^2+v(i,j)^2)^(1/2),'HeadWidth',headWidth);
%             ah = annotation('arrow',...
%                 'headStyle','cback1','HeadLength',headLength*(u(i,j)^2+v(i,j)^2)^(1/2),'HeadWidth',headWidth*(u(i,j)^2+v(i,j)^2)^(1/2));
            set(aq,'parent',gca);
            set(aq,'position',[x(i,j) y(i,j) lineLength*u(i,j) lineLength*v(i,j)]);
        end
    end
end
axis([xLow xUp yLow yUp]);
%title('Quiver - annotations ','FontSize',16);

%q=quiver(x,y,u,v);
%set(q,'LineWidth',1,'MaxHeadSize',10,'AutoScaleFactor',.5,'Color','black');
%q.LineWidth = 1;
%q.MaxHeadSize = 10;

if orifices == 1
    rectangle('Position',[1000 0 20 980])
    rectangle('Position',[1000 1020 20 980])
elseif orifices == 2
    rectangle('Position',[1000 0 20 800])
    rectangle('Position',[1000 900 20 200])
    rectangle('Position',[1000 1200 20 800])
end

% axis([xLow xUp yLow yUp]);

% title(strcat("Center of Mass Velocity Field at $t^*=$ ", num2str(t-1)), 'Interpreter', 'LaTex', 'FontSize', 12 );
% xlabel("x, $r*$",'Interpreter','Latex');
% ylabel("y, $r*$",'Interpreter','Latex');
print(strcat("Annotation_Quiver_Timestep_",num2str((t-1)*200)), '-dpng');
close(aqFig);
end

