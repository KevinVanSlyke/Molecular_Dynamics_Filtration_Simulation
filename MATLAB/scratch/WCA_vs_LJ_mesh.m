function [] = WCA_vs_LJ_mesh(t,x,y,uA,vA,countA,tempA,uI,vI,countI,tempI)
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes here

nameFlag = 'WCA_vs_LJ'; %Extra note for file name 
saveFormat = 'full'; %Format can be: png, full (png, eps and fig)

varName = '';
varValues = [NaN, NaN];
varStrings = {'WCA Potential \quad', 'LJ Potential \quad'};
varIndices = 1:size(varValues,2);
equalVariable = 'column';

%%Choice of data to be plotted
vectorType = {'none', 'com'}; %Vector Types are: arg, imp, com, none
vectorLabel = 'hybrid';
meshType = 'netP'; %Mesh Types are: netP, intP, flowP, netKE, intKE, flowKE, numA, numI, none
meshScale = 'lin'; %Mesh Scale can be: lin, log
colorbarLoc = 'east'; %Location of the colorbar tile which can be: north, south, east, west
t0Empty = 1; %Whether or not the first line of printed data is all zeros

%%Whether to plot as tiled or not and in what geometry
xTiles = 2;
yTiles = 2;
tileWidth = 1;
nTiles = xTiles*yTiles/tileWidth^2;
tileLabels = {'(a)','(b)','(c)','(d)','(e)','(f)','(g)','(h)'};

tIndices = [101, 101];
equalTime = 'all'; %Decides how times are placed in the tiles, can be: row, column, all

zoomType = 'hybrid'; %Can be set to: full, zoomed, hybrid
cellBuffer = [0, 5]; %The number of cells plotted along each axis, 0 is for maximum
equalZoom = 'row';

%%Select the method of timesteps to print
if nTiles == 1
    tStart = 1; 
    tStop = 501;
    tInterval = 5;
    tIndices = tStart:tInterval:tStop;
end

%%Configuration parameters
yBoundary = 'yRef'; %Y-Boundary Conditions can be: yRef, yPer
xBoundary = 'xPer'; %Y-Boundary Conditions can be: xPer, xOpen
D = 5; %Impurity diameter
FLn = 1; %May be 1 or 2 for # orifices in FL
SLn = 2; %May be 0 for no second layer or 2 for SL2
W = 120; %Orifice Width
depth = 20; %Filter Depth 
S = 120; %Orifice Spacing
delta = 100; %Filter Separation
H = 0; %Registry Shift
Lx = 2000 + FLn*depth + SLn*depth; %Length of simulation
Ly = 2000; %Height of simulation
xFL = 1000; %Location of left edge of FL
if FLn == 2
    yFL = Ly/2-S-W/2;
else
    yFL = Ly/2-W/2;
end
%For dual orifice in left
xSL = xFL+depth+delta;
ySL = Ly/2-S-W/2;
cellSize = 20;

if strcmp(equalZoom,'row')
    nZooms = yTiles;
else
    nZooms = xTiles;
end
xAxisUp = zeros(nZooms,1);
xAxisLow = zeros(nZooms,1);
yAxisUp = zeros(nZooms,1);
yAxisLow = zeros(nZooms,1);
for i = 1:nZooms
    if cellBuffer(i) == 0
        xAxisUp(i) = max(x,[],'all');
        xAxisLow(i) = min(x,[],'all');
        yAxisUp(i) = max(y,[],'all');
        yAxisLow(i) = min(y,[],'all');
    else
        if delta == 0
            xAxisLow(i) = xFL-(cellBuffer(i)+depth/20)*cellSize;
        else
            xAxisLow(i) = xFL-(cellBuffer(i)+depth*2/20)*cellSize;
        end
        xAxisUp(i) = xSL+cellBuffer(i)*cellSize;
        yAxisLow(i) = Ly/2-cellBuffer(i)*cellSize;
        yAxisUp(i) = Ly/2+cellBuffer(i)*cellSize;
    end
end

if t0Empty == 1
    t=t(2:max(size(t)))-5;
    uA=uA(:,:,2:max(size(t)),:);
    vA=vA(:,:,2:max(size(t)),:);
    countA=countA(:,:,2:max(size(t)),:);
    tempA=tempA(:,:,2:max(size(t)),:);
    uI=uI(:,:,2:max(size(t)),:);
    vI=vI(:,:,2:max(size(t)),:);
    countI=countI(:,:,2:max(size(t)),:);
    tempI=tempI(:,:,2:max(size(t)),:);
end
uA(isinf(uA)|isnan(uA)) = 0;
vA(isinf(vA)|isnan(vA)) = 0;
countA(isinf(countA)|isnan(countA)) = 0;
tempA(isinf(tempA)|isnan(tempA)) = 0;
uI(isinf(uI)|isnan(uI)) = 0;
vI(isinf(vI)|isnan(vI)) = 0;
countI(isinf(countI)|isnan(countI)) = 0;
tempI(isinf(tempI)|isnan(tempI)) = 0;

if strcmp(meshType,'none')
    meshVals = zeros(size(x,1),size(y,2),size(tIndices,2),size(varValues,2));
end

velAMag = (uA.^2+vA.^2).^(1/2);
maxVelA = max(velAMag,[],'all');
keAcm = 1/2*countA.*velAMag.^2;
keAcm(isinf(keAcm)|isnan(keAcm)) = 0;

if D == 1
    keInt = tempA;
    keFlow = keAcm;
    uANorm = uA./maxVelA;
    vANorm = vA./maxVelA;
    uNet = uANorm;
else
    velIMag = (uI.^2+vI.^2).^(1/2);
    maxVelI = max(velIMag,[],'all');
    maxVel = max(maxVelA,maxVelI);
    uANorm = uA./maxVel;
    vANorm = vA./maxVel;
    uINorm = uI./maxVel;
    vINorm = vI./maxVel;
    uNet = (countA.*uA + countI.*uI)./(countA+D^2*countI);
    vNet = (countA.*vA + countI.*vI)./(countA+D^2*countI);
    velNetMag = (uNet.^2+vNet.^2).^(1/2);
    maxVelNet = max(velNetMag,[],'all');
    uNetNorm = uNet/maxVelNet;
    vNetNorm = vNet/maxVelNet;

    keIcm = 1/2*D^2*velIMag.^2;
    keIcm(isinf(keIcm)|isnan(keIcm)) = 0;
    keInt = tempA + tempI;
    keFlow = keAcm + keIcm;
end

keNet = keInt + keFlow;
pressInt = keInt/400;
pressFlow = keFlow/400;
pressNet = keNet/400;
if strcmp(meshType,'netP')
    meshVals = pressNet;
    cLabel = 'P^*';
elseif strcmp(meshType,'intP')
    meshVals = pressInt;
    cLabel = 'P_{\mathrm{Int.}}^*';
elseif strcmp(meshType,'flowP')
    meshVals = pressFlow;
    cLabel = 'P_{\mathrm{Flow}}^*';
elseif strcmp(meshType,'netKE')
    meshVals = keNet;
    cLabel = '\mathrm{KE}^*';
elseif strcmp(meshType,'intKE')
    meshVals = keInt;
    cLabel = '\mathrm{KE}_{\mathrm{Int.}}^*';
elseif strcmp(meshType,'flowKE')
    meshVals = keFlow;
    cLabel = '\mathrm{KE}_{\mathrm{Flow}}^*';
elseif strcmp(meshType,'numA')
    meshVals = countA;
    cLabel = 'N_{\mathrm{Ar.}}';
elseif strcmp(meshType,'numI')
    meshVals = countI;    
    cLabel = 'N_{\mathrm{Imp.}}';
end
if strcmp(meshScale,'log')
    cLabel = strcat('$\log(',cLabel);
    if ~strcmp(meshType,'countA') && ~strcmp(meshType,'countI')
        cLabel = strcat(cLabel,'+1)$');
    else
        cLabel = strcat(cLabel,')$');
    end
    cLabel = strcat(cLabel,' (Dimensionless)');
    logMeshVals = log10(meshVals+1);
    logMeshVals(isinf(logMeshVals)|isnan(logMeshVals)) = 0;
    meshVals = logMeshVals;    
elseif strcmp(meshType,'countA') && strcmpr(meshType,'countI')
    cLabel = strcat('$',cLabel,'$');
else
    cLabel = strcat('$',cLabel,'$ (Dimensionless)');
end
meshValsMax = max(meshVals,[],'all');
% meshValsMin = min(meshVals,[],'all');
% meshValsMean = mean(meshVals,'all');

%%Decides if a manual limit on color bar should be applied. Set to 0 for automatic
manualColorbarTicks = 1;
manualColorbarMax = 0.08; 
manualColorbarInterval = 0.01;
manualColorbarExponent = -2;

wNorm = zeros(size(x,1),max(size(x,2)));
z = zeros(size(x,1),max(size(x,2)))+meshValsMax;
zCut = meshValsMax;
autoColorbarMax = round(meshValsMax,2,'significant');
autoColorbarExponent = ceil(log10(autoColorbarMax)-1);

tileFig = tiledlayout(yTiles*tileWidth,xTiles*tileWidth,'TileSpacing','tight','Padding','tight','Visible','on');
for tile = 1:nTiles
    nexttile([tileWidth tileWidth])
    column = mod(tile,xTiles);
    if column == 0
        column = xTiles;
    end
    row = floor((tile-.1)/xTiles)+1;

    if strcmp(equalTime,'all')
        tIndex = tIndices(1);
    elseif strcmp(equalTime,'row')
        tIndex = tIndices(row);
    else
        tIndex = tIndices(column);
    end

    if strcmp(equalVariable,'all')
        varIndex = varIndices(1);
    elseif strcmp(equalVariable,'row')
        varIndex = varIndices(row);
    else
        varIndex = varIndices(column);
    end

    hold on;
    axis square;
    if ~strcmp(meshType,'none')
        surf(x,y,meshVals(:,:,tIndex,varIndex));
        axis([xAxisLow(row) xAxisUp(row) yAxisLow(row) yAxisUp(row) 0 meshValsMax]);
        if manualColorbarTicks == 1
            clim([0 manualColorbarMax]);
            if tile == nTiles
                hcolorBar = colorbar('Ticks',0:manualColorbarInterval:manualColorbarMax);
                hcolorBar.Ruler.Exponent = manualColorbarExponent;
            end
        else
            clim([0 meshValsMax]);
            if tile == nTiles
                hcolorBar = colorbar('Ticks',linspace(0,autoColorbarMax,10));
                hcolorBar.Ruler.Exponent = autoColorbarExponent;
            end
        end
        if tile == nTiles
            hcolorBar.Layout.Tile = colorbarLoc;
            ylabel(hcolorBar, cLabel, 'Interpreter', 'latex', 'FontSize',9) ;
        end
    end
    if ~strcmp(vectorType{row},'none')
        if strcmp(vectorType{row},'arg')
            uNorm = uANorm;
            vNorm = vANorm;
        elseif strcmp(vectorType{row},'imp')
            uNorm = uINorm;
            vNorm = vINorm;
        elseif strcmp(vectorType{row},'com')
            uNorm = uNetNorm;
            vNorm = vNetNorm;
        end
        if ~strcmp(meshType,'none')
            quiver3(x+10, y+10, z, uNorm(:,:,tIndex,varIndex)*50, vNorm(:,:,tIndex,varIndex)*50, wNorm, 'AutoScale', 'off', 'Color' ,'w', 'LineWidth',1);%,'MaxHeadSize',5);
        else
            quiver3(x+10, y+10, z, uNorm(:,:,tIndex,varIndex)*50, vNorm(:,:,tIndex,varIndex)*50, wNorm, 'AutoScale', 'off', 'Color' ,'k', 'LineWidth',1);%,'MaxHeadSize',5);
        end
    end
%     ytickangle(90);
%     yticks([900 1000 1100]);
%     if nTiles == 1 || (nTiles == 3 && tile == 1) || (nTiles == 4 && tile == 3)
%         ylabel('$y/\sigma$ (Dimensionless)','Interpreter','Latex', 'FontSize', 9);
%     end
%     xticks([900 1000 1100]);    
%     if nTiles == 1 || (nTiles == 3 && tile == 2) || (nTiles == 4 && tile == 3)
%         xlabel('$x/\sigma$ (Dimensionless)','Interpreter','Latex', 'FontSize', 9);
%     end
%     ylabel('$y/\sigma$ (Dimensionless)','Interpreter','Latex', 'FontSize', 9);
%     xlabel('$x/\sigma$ (Dimensionless)','Interpreter','Latex', 'FontSize', 9);
%     tileFig.XLabel.String = '';
%     tileFig.YLabel.String = '';

    titleString = '';
    if ~isnan(varValues(1))
        titleString = strcat(titleString, varName, ' $=$ ', num2str(varValues(varIndex)));
    else
        titleString = strcat(titleString, varStrings{column});
    end
    if ~strcmp(equalTime,'all')
        titleString = strcat(titleString, '$t^*=', num2str(t(tIndex)), '$ (Dimensionless)');
    end
    titleString = strcat(titleString, ' \qquad', tileLabels(tile));
    title(titleString, 'Interpreter', 'LaTex', 'FontSize', 9);%,'FontWeight','bold');
    view(0,90);
    if FLn == 2
        patch( [xFL xFL xFL+depth xFL+depth], [0 yFL yFL 0], [zCut zCut zCut zCut], 'w');
        patch( [xFL xFL xFL+depth xFL+depth], [yFL+W yFL+W+S yFL+W+S yFL+W], [zCut zCut zCut zCut], 'w');
        patch( [xFL xFL xFL+depth xFL+depth], [yFL+2*W+S Ly Ly yFL+2*W+S], [zCut zCut zCut zCut], 'w');
    else
        patch( [xFL xFL xFL+depth xFL+depth], [0 yFL yFL 0], [zCut zCut zCut zCut], 'w');
        patch( [xFL xFL xFL+depth xFL+depth], [yFL+W Ly Ly yFL+W], [zCut zCut zCut zCut], 'w');
    end
    if SLn == 2
        patch( [xSL xSL xSL+depth xSL+depth], [0 ySL ySL 0], [zCut zCut zCut zCut], 'w');
        patch( [xSL xSL xSL+depth xSL+depth], [ySL+W ySL+2*W ySL+2*W ySL+W], [zCut zCut zCut zCut], 'w');
        patch( [xSL xSL xSL+depth xSL+depth], [ySL+3*W Ly Ly ySL+3*W], [zCut zCut zCut zCut], 'w');
    end
end
xlabel(tileFig,'$x/\sigma$ (Dimensionless)','Interpreter','LaTeX','FontSize',9);
ylabel(tileFig,'$y/\sigma$ (Dimensionless)','Interpreter','LaTeX','FontSize',9);
fileName = strcat(meshType,meshScale,'_',vectorLabel,'Vec_',num2str(W),'W_',num2str(D),'D_',num2str(depth),'L_');
if S > 0
    fileName = strcat(fileName,num2str(S),'S_');
end
if delta > 0 
    fileName = strcat(fileName,num2str(delta),'d_',num2str(H),'H_');
end
fileName = strcat(fileName,yBoundary,'_',xBoundary,'_');
if ~strcmp(nameFlag,'')
  fileName = strcat(fileName,nameFlag,'_');
end
fileName = strcat(fileName,zoomType);
for tIndex = tIndices
    fileName = strcat(fileName,'_',num2str(t(tIndex)));
    if strcmp(equalTime,'all')
        break;
    end
end

fileName = strcat(fileName,'t');

set(findall(gcf,'-property','FontSize'),'FontSize',9);
set(gcf,'Units','Centimeters','Position',[0 0 8.2*xTiles 8.6*yTiles]); %Format figure for PRL
exportgraphics(gcf,strcat(fileName,'.png'));
if strcmp(saveFormat,'all')
    exportgraphics(gcf,strcat(fileName,'.eps'));
    savefig(gcf,strcat(fileName,'.fig'));
end
close(gcf);
end