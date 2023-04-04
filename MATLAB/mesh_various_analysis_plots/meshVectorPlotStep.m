function [] = meshVectorPlotStep(t,x,y,uA,vA,countA,tempA)%,uI,vI,countI,tempI)
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes here
uI=zeros(size(x,1),size(x,2));
vI=zeros(size(x,1),size(x,2));
countI=zeros(size(x,1),size(x,2));
tempI=zeros(size(x,1),size(x,2));

fullSave = 0;
%Choice of data to be plotted
meshType = 'netP'; %Mesh Types are: netP, intP, flowP, netKE, intKE, flowKE, numA, numI, no
meshScale = 'lin'; %Mesh Scale can be: lin, log
vectorType = 'arg'; %Vector Types are: arg, imp, CoM, no
t0Empty = 0; %Whether or not the first line of printed data is all zeros

%Whether to plot as tiled or not and in what geometry
nTiles = 1;
xTiles = 1;
yTiles = 1;
tileWidth = 1;
tileTitles = {'(a)','(b)','(c)','(d)'};%,'(e)','(f)','(g)','(h)'};
tIndex = [1,101,401,10001];

%Select the method of timesteps to print
if nTiles == 1
    tStart = 1; 
    tStop = 501;
    tInterval = 5;
    tIndex = tStart:tInterval:tStop;
end
%Decides how many cells to plot, set to 0 to plot the full data set
numCells = 10;
numCellsX = 0;
numCellsY = 0;

%Configuration parameters
nameFlag = 'WCA'; %Extra note for file name such as: zoomed, full, 
yBoundary = 'yRef'; %Y-Boundary Conditions can be: yRef, yPer
xBoundary = 'xPer'; %Y-Boundary Conditions can be: xPer, xOpen
D = 1; %Impurity diameter
FLn = 2; %May be 1 or 2 for # orifices in FL
SLn = 0; %May be 0 for no second layer or 2 for SL2
W = 40; %Orifice Width
l = 20; %Filter Depth 
S = 80; %Orifice Spacing
delta = 0; %Filter Separation
H = 0; %Registry Shift
Lx = 2000 + FLn*l + SLn*l; %Length of simulation
Ly = 2000; %Height of simulation
xFL = 1000; %Location of left edge of FL
if FLn == 2
    yFL = Ly/2-S/2-W;
else
    yFL = Ly/2-W/2;
end
%For dual orifice in left
xSL = xFL+l+delta;
ySL = Ly/2-S-W/2;
cellSize = 20;

if numCells == 0
    xAxisUp = max(x,[],'all');
    xAxisLow = min(x,[],'all');
    yAxisUp = max(y,[],'all');
    yAxisLow = min(y,[],'all');
else
    if delta == 0
        xAxisLow = xFL-(numCells/2-(l/20))*cellSize;
    else
        xAxisLow = xFL-(numCells/2-(l*2/20))*cellSize;
    end
    xAxisUp = xSL+numCells/2*cellSize;
    yAxisLow = Ly/2-numCells/2*cellSize;
    yAxisUp = Ly/2+numCells/2*cellSize;
end

if t0Empty == 1
    t=t(2:max(size(t)))-5;
    uA=uA(:,:,2:max(size(t)));
    vA=vA(:,:,2:max(size(t)));
    countA=countA(:,:,2:max(size(t)));
    tempA=tempA(:,:,2:max(size(t)));
    uI=uI(:,:,2:max(size(t)));
    vI=vI(:,:,2:max(size(t)));
    countI=countI(:,:,2:max(size(t)));
    tempI=tempI(:,:,2:max(size(t)));
end
if strcmp(meshType,'no')
    meshVals = zeros(max(size(x)),max(size(y)));
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
else
    velIMag = (uI.^2+vI.^2).^(1/2);
    maxVelI = max(velIMag,[],'all');
    maxVel = max(maxVelA,maxVelI);
    uINorm = uI./maxVel;
    vINorm = vI./maxVel;

    uNet = (countA.*uA + countI.*uI)./(countA+D^2*countI);
    vNet = (countA.*vA + countI.*vI)./(countA+D^2*countI);
    velNetMag = (uNet.^2+vNet.^2).^(1/2);
    maxVelNet = max(velNetMag,[],'all');
    uNormNet = uNet/maxVelNet;
    vNormNet = vNet/maxVelNet;

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
meshValsMin = min(meshVals,[],'all');
meshValsMean = mean(meshVals,'all');

%Decides if a manual limit on color bar should be applied. Set to 0 for automatic
manualColorbarTicks = 1;
manualColorbarMax = 0.08; 
manualColorbarInterval = 0.01;
manualColorbarExponent = -2;

if strcmp(vectorType,'arg')
    uNorm = uANorm;
    vNorm = vANorm;
elseif strcmp(vectorType,'imp')
    uNorm = uINorm;
    vNorm = vINorm;
elseif strcmp(vectorType,'com')
    uNorm = uNormNet;
    vNorm = vNormNet;
end
wNorm = zeros(size(x,1),max(size(x,2)));
z = zeros(size(x,1),max(size(x,2)))+meshValsMax;
zCut = meshValsMax;
autoColorbarMax = round(meshValsMax,2,'significant');
autoColorbarExponent = ceil(log10(autoColorbarMax)-1);
if nTiles > 1
    qFig = tiledlayout(yTiles*tileWidth,xTiles*tileWidth,'TileSpacing','tight','Padding','tight','Visible','on');
    tile = 0;
end
for i = tIndex
    if nTiles == 1
        qFig = figure('Visible','on');
    else
        nexttile([tileWidth tileWidth])
        tile = tile + 1;
    end
    hold on;
    axis square;
    if ~strcmp(meshType,'no')
        surf(x,y,meshVals(:,:,i));
        axis([xAxisLow xAxisUp yAxisLow yAxisUp 0 meshValsMax]);
        if manualColorbarTicks == 1
            clim([0 manualColorbarMax]);
            if nTiles == 1 || tile == max(size(tIndex))
                hcolorBar = colorbar('Ticks',0:manualColorbarInterval:manualColorbarMax);
                hcolorBar.Ruler.Exponent = manualColorbarExponent;
            end
        else
            clim([0 meshValsMax]);
            if nTiles == 1 || tile == max(size(tIndex))
                hcolorBar = colorbar('Ticks',linspace(0,autoColorbarMax,10));
                hcolorBar.Ruler.Exponent = autoColorbarExponent;
            end
        end
        if nTiles == 1 || tile == max(size(tIndex))
            ylabel(hcolorBar, cLabel, 'Interpreter', 'latex', 'FontSize',9) ;
        end
    end
    if ~strcmp(vectorType,'no')
        if ~strcmp(meshType,'no')
            quiver3(x+10, y+10, z, uNorm(:,:,i)*50, vNorm(:,:,i)*50, wNorm, 'AutoScale', 'off', 'Color' ,'w', 'LineWidth',1);%,'MaxHeadSize',5);
        else
             quiver3(x+10, y+10, z, uNorm(:,:,i)*50, vNorm(:,:,i)*50, wNorm, 'AutoScale', 'off', 'Color' ,'k', 'LineWidth',1);%,'MaxHeadSize',5);
        end
    end
%     ytickangle(90);
%     yticks([900 1000 1100]);
%     if nTiles == 1 || (nTiles == 3 && tile == 1) || (nTiles == 4 && tile == 3)
        ylabel('$y/\sigma$ (Dimensionless)','Interpreter','Latex', 'FontSize', 9);
%     end
%     xticks([900 1000 1100]);    
%     if nTiles == 1 || (nTiles == 3 && tile == 2) || (nTiles == 4 && tile == 3)
        xlabel('$x/\sigma$ (Dimensionless)','Interpreter','Latex', 'FontSize', 9);
%     end
    if nTiles == 1
%         title(strcat('$t^*=', num2str(t(i)),'$'), 'Interpreter', 'LaTex', 'FontSize', 9,'FontWeight','bold');
        title(strcat('$t^*=', num2str(t(i)),'$ (Dimensionless)'), 'Interpreter', 'LaTex', 'FontSize', 9,'FontWeight','bold');
    else
        title(strcat('~\qquad~$t^*=', num2str(t(i)),'$ (Dimensionless) ~\qquad~',tileTitles(tile)), 'Interpreter', 'LaTex', 'FontSize', 9);%,'FontWeight','bold');
    end
    view(0,90);
    if FLn == 2
        patch( [xFL xFL xFL+l xFL+l], [0 yFL yFL 0], [zCut zCut zCut zCut], 'w');
        patch( [xFL xFL xFL+l xFL+l], [yFL+W yFL+W+S yFL+W+S yFL+W], [zCut zCut zCut zCut], 'w');
        patch( [xFL xFL xFL+l xFL+l], [yFL+2*W+S Ly Ly yFL+2*W+S], [zCut zCut zCut zCut], 'w');
    else
        patch( [xFL xFL xFL+l xFL+l], [0 yFL yFL 0], [zCut zCut zCut zCut], 'w');
        patch( [xFL xFL xFL+l xFL+l], [yFL+W Ly Ly yFL+W], [zCut zCut zCut zCut], 'w');
    end
    if SLn == 2
        patch( [xSL xSL xSL+l xSL+l], [0 ySL ySL 0], [zCut zCut zCut zCut], 'w');
        patch( [xSL xSL xSL+l xSL+l], [ySL+W ySL+2*W ySL+2*W ySL+W], [zCut zCut zCut zCut], 'w');
        patch( [xSL xSL xSL+l xSL+l], [ySL+3*W Ly Ly ySL+3*W], [zCut zCut zCut zCut], 'w');
    end

    if nTiles == 1
        fileName = strcat(meshType,'_',meshScale,'_mesh_',vectorType,'_vec_',num2str(W),'W_',num2str(D),'D_',num2str(l),'L_');
        if S > 0
            fileName = strcat(fileName,num2str(S),'S_');
        end
        if delta > 0 
            fileName = strcat(fileName,num2str(delta),'delta_',num2str(H),'H_');
        end
        fileName = strcat(fileName,yBoundary,'_',xBoundary,'_');
        if ~strcmp(nameFlag,'')
          fileName = strcat(fileName,nameFlag,'_');
        end
        if numCells == 0
            fileName = strcat(fileName,'fullCells_');
        else
            fileName = strcat(fileName,num2str(numCells),'cells_');
        end
        fileName = strcat(fileName,num2str(t(i)),'t');
        exportgraphics(qFig,strcat(fileName,'.png'));
        set(findall(gcf,'-property','FontSize'),'FontSize',9);
        set(qFig,'Units','Centimeters','Position',[0 0 8.6 7]); %Format figure for PRL
        if fullSave == 1
            exportgraphics(qFig,strcat(fileName,'.eps'));
            savefig(qFig,strcat(fileName,'.fig'));
        end
        close(qFig);
    end
end
if nTiles > 1
    hcolorBar.Layout.Tile = 'east';
    fileName = strcat(meshType,'_',meshScale,'_mesh_',vectorType,'_vec_',num2str(W),'W_',num2str(D),'D_',num2str(l),'L_');
    if S > 0
        fileName = strcat(fileName,num2str(S),'S_');
    end
    if delta > 0 
        fileName = strcat(fileName,num2str(delta),'delta_',num2str(H),'H_');
    end
    fileName = strcat(fileName,yBoundary,'_',xBoundary,'_');
    if ~strcmp(nameFlag,'')
      fileName = strcat(fileName,nameFlag,'_');
    end
    if numCells == 0
        fileName = strcat(fileName,'fullCells');
    else
        fileName = strcat(fileName,num2str(numCells),'cells');
    end
    for i = tIndex
        fileName = strcat(fileName,'_',num2str(t(i)));
    end
    fileName = strcat(fileName,'t');
    set(findall(gcf,'-property','FontSize'),'FontSize',9);
    set(gcf,'Units','Centimeters','Position',[0 0 17 17]); %Format figure for PRL
    exportgraphics(gcf,strcat(fileName,'.png'));
    if fullSave == 1
        exportgraphics(gcf,strcat(fileName,'.eps'));
        savefig(gcf,strcat(fileName,'.fig'));
    end
    close(gcf);
end
end

%     flowEng = 1/2.*uA.^2;
%     logFlowEng = log10(flowEng+1);
%     logFlowEng(isinf(logFlowEng)|isnan(logFlowEng)) = 0;
%     flowEngMax = max(logFlowEng,[],'all');
%     logKin = kinetic-1/2*(uA.^2+vA.^2).^(1/2);
%     logKin = kinetic-flowEng;
%     logKin(logKin<=1)=1;
%     logKin = log(logKin);
%     surf(x,y,logKin(:,:,i));
%     axis([xLow xUp yLow yUp 0 max(logKin,[],'all')]);
%     caxis([0 log(kineticMax-flowEngMax)]);
%     surf(x,y,kinetic(:,:,i)-kineticMax);
%     axis([xLow xUp yLow yUp kineticMin kineticMax]);
%     caxis([kineticMin kineticMax]);
%     colorbar;
%     axis([xLow xUp yLow yUp -8 0]);
%     caxis([-8 0]);
%     colorbar;
%     colormap(parula(7));
%     colorbar('TickLabels', num2cell(0:1:8));
%     colorbar('TickLabels', num2cell(0:1:kinTickSpace+1));
%
%     title(strcat('Argon Velocity Vector Field, Log Internal KE Mesh at $t^*=$ ', num2str(t(i))), 'Interpreter', 'LaTex', 'FontSize', 12 );
%     title(strcat('Argon Velocity Vector Field, Log Calculated Internal KE Mesh at $t^*=$ ', num2str(t(i))), 'Interpreter', 'LaTex', 'FontSize', 12 );
%     title(strcat('Argon Velocity Vector Field, Log TempCom Mesh at $t^*=$ ', num2str(t(i))), 'Interpreter', 'LaTex', 'FontSize', 12 );
%     title(strcat('Argon Velocity Vector Field, Log Temp Mesh at $t^*=$ ', num2str(t(i))), 'Interpreter', 'LaTex', 'FontSize', 12 );
%     title(strcat('Argon Velocity Vector Field, Uncertainty in Argon X-Vel at $t^*=$ ', num2str(t(i)-5)), 'Interpreter', 'LaTex', 'FontSize', 12 );
%     title(strcat('$t^*=$ ', num2str(t(i)-5)), 'Interpreter', 'LaTex', 'FontSize', 12);
%     title(strcat('Mean Argon Velocity Vector Field, Uncertainty in Argon X-Vel at $t^*=$ ', num2str(t(i)-5)), 'Interpreter', 'LaTex', 'FontSize', 12 );
%     title(strcat('Mean Argon Velocity Vector Field, Impurity Count Mesh at $t^*=$ ', num2str(t(i)-5)), 'Interpreter', 'LaTex', 'FontSize', 12 );
%     title(strcat('Mean Argon Velocity Vector Field, Mean Impurity Count Mesh at $t^*=$ ', num2str(t(i)-5)), 'Interpreter', 'LaTex', 'FontSize', 12 );
%     title(strcat('Argon Velocity Vector Field, Impurity Count Mesh at $t^*=$ ', num2str(t(i))), 'Interpreter', 'LaTex', 'FontSize', 12 );
%     title(strcat('Impurity Velocity Vector Field, Impurity Count Mesh at $t^*=$ ', num2str(t(i))), 'Interpreter', 'LaTex', 'FontSize', 12 );
%     title(strcat('Impurity Velocity Vector Field at $t^*=$ ', num2str(t(i))), 'Interpreter', 'LaTex', 'FontSize', 12 );
%     title(strcat('Pressure at $t^*=$ ', num2str(t(i))), 'Interpreter', 'LaTex', 'FontSize', 12 );
%     
%     print(strcat('480F_ImpurityVelocityCount_LJTime_',num2str(t(i))), '-dpng');
%     print(strcat('MeanArgonVelocity_VxUncertainty_LJTime_',num2str(t(i)-5)), '-dpng');
%     print(strcat('ArgonVelocity_VxUncertainty_LJTime_',num2str(t(i)-5)), '-dpng');
%     print(strcat('MeanArgonVelocity_ImpurityCount_LJTime_',num2str(t(i)-5)), '-dpng');
%     print(strcat('MeanArgonVelocity_MeanImpurityCount_LJTime_',num2str(t(i)-5)), '-dpng');
%     print(strcat('ShiftedArgonVelocity_LogCalcKE_Timestep_',num2str(t(i))), '-dpng');
%     print(strcat('Bernoulli_Timestep_',num2str(t(i)*200)), '-dpng'); 
%     title(strcat('Soft Sphere WCA Potential at $t^*=$ ', num2str(t(i)-5)), 'Interpreter', 'LaTex', 'FontSize', 12 );
%     title(strcat('Soft Sphere WCA Potential at $t^*=$ ', num2str(t(i)-5)), 'Interpreter', 'LaTex', 'FontSize', 12 );
%     
%     fileName = strcat('KE_mesh_Va_',num2str(width),'W_',num2str(D),'D_',num2str(depth),'L_',num2str(separation),'F_',num2str(spacing),'S_',num2str(shift),'H','_yReflective_LJ_',num2str(t(i)-5),'t');
%     fileName = strcat('KE_mesh_Va_',num2str(width),'W_',num2str(D),'D_',num2str(depth),'L_',num2str(t(i)-5),'t');
%     fileName = strcat('logKE_mesh_Va_',num2str(width),'W_',num2str(D),'D_',num2str(depth),'L_',num2str(t(i)),'t');
%     fileName = strcat('KE_mesh_Va_',num2str(width),'W_',num2str(D),'D_',num2str(depth),'L_',num2str(t(i)),'t');
%     fileName = strcat('logP_mesh_Va_',num2str(width),'W_',num2str(D),'D_',num2str(depth),'L_',num2str(t(i)),'t');
%     fileName = strcat('Vcm_Ni_LJTime_Triple_',num2str(width),'W_',num2str(D),'D_',num2str(depth),'L_',num2str(separation),'F_',num2str(spacing),'S_',num2str(shift),'H','_Periodic');
