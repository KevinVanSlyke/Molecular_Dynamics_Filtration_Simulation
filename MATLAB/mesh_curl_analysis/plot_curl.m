function [] = plot_curl(t,x,y,u,v,curlV)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

minCurl = min(curlV,[],'all');
maxCurl = max(curlV,[],'all');

for i=1:1000:size(curlV,3)
    cFig = figure('Visible','off');
    pos = get(cFig,'position');
    set(cFig,'position',[pos(1:2)/4 pos(3:4)*2])
%     pcolor(x-10,y-10,curlV(:,:,i)); 
    pcolor(x,y,curlV(:,:,i)); 

%     axis([xLow xUp yLow yUp]);

    shading interp
    hold on
    quiver(x+10,y+10,u(:,:,i),v(:,:,i),'k');
%     quiver(x,y,u(:,:,i),v(:,:,i),'k');
% 
%     hold off
%     colormap('copper');
    caxis([minCurl maxCurl]);
    hcolorBar = colorbar();%'Ticks',linspace(minCurl-maxCurl,0,8),'TickLabels', num2cell(minCurl:0.5:maxCurl));
    ylabel(hcolorBar, 'Angular Velocity, $\frac{rad}{t^*}$', 'Interpreter', 'latex') ;

%     zCut = 0;
%     xLeft = 1000;
%     xRight = 1120;
%     depth=20;
%     yLeft=940;
%     height=120;
%     yRight=820;
%     patch( [xLeft xLeft xLeft+depth xLeft+depth], [0 yLeft yLeft 0], [zCut zCut zCut zCut], 'k');
%     patch( [xLeft xLeft xLeft+depth xLeft+depth], [yLeft+height 2000 2000 yLeft+height], [zCut zCut zCut zCut], 'k');
% 
%     patch( [xRight xRight xRight+depth xRight+depth], [0 yRight yRight 0], [zCut zCut zCut zCut], 'k');
%     patch( [xRight xRight xRight+depth xRight+depth], [yRight+height yRight+2*height yRight+2*height yRight+height], [zCut zCut zCut zCut], 'k');
%     patch( [xRight xRight xRight+depth xRight+depth], [yRight+3*height 2000 2000 yRight+3*height], [zCut zCut zCut zCut], 'k');

    title(strcat("Argon Velocity Vector Field with Color Mapped Angular Velocity at $t^*=$ ", num2str(t(i))), 'Interpreter', 'LaTex', 'FontSize', 12 );

    xlabel("x $(r*)$",'Interpreter','Latex');
    ylabel("y $(r*)$",'Interpreter','Latex');
    view(0,90);

%     savefig('Velocity_Curl.fig');
    print(strcat("Angular_ArgonVelocity_Timestep_",num2str(t(i)*200)), '-dpng');
    close(cFig);
end

end