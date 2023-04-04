function [angV, vortices, maxVortex, maxDur, maxLoc] = measureVectorCurl(t,x,y,uA,vA)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% [x,y] = meshgrid((0:20:2020),(0:20:1980));
leftDual = 1;
zCut = 0;
xMid = 120;
yMid = 280;
% yMid = 460;
width = 120;
depth = 60;
spacing = 120;
separation = 120;
xLeft = xMid;
if leftDual == 1
    yLeft = yMid-spacing-width/2;
else
    yLeft = yMid-width/2;
end
%For dual orifice in left
xRight = xMid+depth+separation;
yRight = yMid-spacing-width/2;

% xLow = 700;
% xUp = 1500;
% yLow = 600;
% yUp = 1400;

uA(isnan(uA)) = 0;
vA(isnan(vA)) = 0;
u = uA;
v = vA;
% u = (uA.*countA+uI.*countI)./(countA+countI);
% v = (vA.*countA+vI.*countI)./(countA+countI);
xTotal = size(x,1);
yTotal = size(y,2);

maxT=size(t,1);
% maxT=200;

curlV = zeros(xTotal,yTotal,maxT);
angV = zeros(xTotal,yTotal,maxT);

for i=1:1:maxT
%     min(u(:,:,i),[],3)
%     max(v(:,:,i),[],3)
     [curlV(:,:,i), angV(:,:,i)] = curl(y,x,v(:,:,i),u(:,:,i));
%      [curlV(:,:,i), angV(:,:,i)] = curl(v(:,:,i),u(:,:,i));
%     min(curlV(:,:,i),[],3)
%     max(curlV(:,:,i),[],3)
end
% sum(isnan(curlV(:)))
% sum(isinf(curlV(:)))
% curlV(isinf(curlV)|isnan(curlV)) = 0;
% sum(isnan(curlV(:)))
% sum(isinf(curlV(:)))


xStart=35;
xEnd=75;
yStart=30;
yEnd=70;

% [minCurls,minInd] = min(curlV(xStart:xEnd,yStart:yEnd,:),[],3);
% [maxCurls,maxInd] = max(curlV(xStart:xEnd,yStart:yEnd,:),[],3);
% minCurl = min(minCurls,[],'all');
% maxCurl = max(maxCurls,[],'all');

minAng = min(angV,[],'all');
maxAng = max(angV,[],'all');

findVort = false;
plotCurl = true;

if findVort == true
    stride=1;
    width=0;
    angThresh=0.5;
    vorTresh=5;
    vortices=zeros(3,2,1);
    nVort=1;
    for xInd=xStart:stride:xEnd
        for yInd=yStart:stride:yEnd
            counter=0;
            maxCounter=0;
            prevSign = sign(mean(angV(xInd-width:xInd+width,yInd-width:yInd+width,1),'all'));
            tStart = 0;
            for tInd=2:1:maxT
                angV=mean(angV(xInd-width:xInd+width,yInd-width:yInd+width,tInd),'all');
                curSign=sign(angV);
                if (abs(angV) >= angThresh) && (curSign==prevSign)
                    counter = counter+1;
                    if counter == 1
                        tStart = tInd;
                    end
                else
                    tEnd = tInd;
                    if (counter >= vorTresh)
                        vortices(:,:,:,nVort) = [xInd-width, xInd+width; yInd-width, yInd+width; tStart, tEnd];
                        if (counter > maxCounter)
                            maxVortex = vortices(:,:,:,nVort);
                            maxDur = maxCounter;
                            maxLoc = maxVortex(:,:,1)*20;
                        end
                        nVort=nVort+1;
                    end
                    counter=0;
                end
                prevSign=curSign; 
            end

        end
    end
end
% save('angularVel.mat', 't', 'x', 'y', 'curlV', 'vortices');
% save('angularVel.mat', 't', 'x', 'y', 'vortices');
if plotCurl == true
    for i = 2:200:size(t,1)
%     for i = 2:1:20+1
%     for i = 2:1000:size(t,1)
%     for i = 2:20:size(t,1)/50+20
%     for i = 2:200:size(t,1)/10+200
        cFig = figure('Visible','off');
        pos = get(cFig,'position');
        set(cFig,'position',[pos(1:2)/4 pos(3:4)*2])
%         pcolor(x-20,y-20,curlV(:,:,i)-maxCurl); 
        pcolor(x,y,angV(:,:,i)); 

        axis([min(x,[],'all') max(x,[],'all') min(y,[],'all') max(y,[],'all')]);

        shading interp
        hold on
        quiver(x+10,y+10,u(:,:,i),v(:,:,i),'k');
%         quiver(x,y,u(:,:,i),v(:,:,i),'k');

    %     hold off
    %      colormap('copper');
        caxis([minAng maxAng]);
%         caxis([minCurl-maxCurl 0]);
        hcolorBar = colorbar();%'Ticks',linspace(minCurl-maxCurl,0,8),'TickLabels', num2cell(minCurl:0.5:maxCurl));
%         hcolorBar = colorbar('Ticks',[-2,-1,0],'TickLabels',[0,1,2]);
        ylabel(hcolorBar, 'Angular Velocity, $\frac{rad}{t^*}$', 'Interpreter', 'latex') ;

%         zCut = 0;
%         xLeft = 1000;
%         xRight = 1120;
%         depth=20;
%         yLeft=940;
%         height=120;
%         yRight=820;

    if leftDual == 1
        patch( [xLeft xLeft xLeft+depth xLeft+depth], [0 yLeft yLeft 0], [zCut zCut zCut zCut], 'w');
        patch( [xLeft xLeft xLeft+depth xLeft+depth], [yLeft+width yLeft+2*width yLeft+2*width yLeft+width], [zCut zCut zCut zCut], 'w');
        patch( [xLeft xLeft xLeft+depth xLeft+depth], [yLeft+3*width 2000 2000 yLeft+3*width], [zCut zCut zCut zCut], 'w');
    else
        patch( [xLeft xLeft xLeft+depth xLeft+depth], [0 yLeft yLeft 0], [zCut zCut zCut zCut], 'w');
        patch( [xLeft xLeft xLeft+depth xLeft+depth], [yLeft+width 2000 2000 yLeft+width], [zCut zCut zCut zCut], 'w');
    end
    patch( [xRight xRight xRight+depth xRight+depth], [0 yRight yRight 0], [zCut zCut zCut zCut], 'w');
    patch( [xRight xRight xRight+depth xRight+depth], [yRight+width yRight+2*width yRight+2*width yRight+width], [zCut zCut zCut zCut], 'w');
    patch( [xRight xRight xRight+depth xRight+depth], [yRight+3*width 2000 2000 yRight+3*width], [zCut zCut zCut zCut], 'w');

%         patch( [xLeft xLeft xLeft+depth xLeft+depth], [0 yLeft yLeft 0], [zCut zCut zCut zCut], 'k');
%         patch( [xLeft xLeft xLeft+depth xLeft+depth], [yLeft+height 2000 2000 yLeft+height], [zCut zCut zCut zCut], 'k');
% 
%         patch( [xRight xRight xRight+depth xRight+depth], [0 yRight yRight 0], [zCut zCut zCut zCut], 'k');
%         patch( [xRight xRight xRight+depth xRight+depth], [yRight+height yRight+2*height yRight+2*height yRight+height], [zCut zCut zCut zCut], 'k');
%         patch( [xRight xRight xRight+depth xRight+depth], [yRight+3*height 2000 2000 yRight+3*height], [zCut zCut zCut zCut], 'k');

        title(strcat("Mean Argon Velocity Vector Field with Color Mapped Angular Velocity at $t^*=$ ", num2str(t(i)-5)), 'Interpreter', 'LaTex', 'FontSize', 12 );

        xlabel("x $(r*)$",'Interpreter','Latex');
        ylabel("y $(r*)$",'Interpreter','Latex');
        view(0,90);

    %     savefig('Velocity_Curl.fig');
        print(strcat("Test_Mean_Angular_ArgonVelocity_Timestep_",num2str(t(i)-5)), '-dpng');
        close(cFig);
    end
end

end

