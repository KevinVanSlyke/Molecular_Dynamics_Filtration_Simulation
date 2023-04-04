function [] = plot_outflow_perc()

tStart = 2001;
tStop = 10001;

ensembleDir = 'E:\Molecular_Dynamics_Data\FL1SL2O\DualLayer_MonoOrifice_Hopper_07_2020\Reflective_Y_DualLayer_Hopper_Ensemble';
fileName = strcat('nA_nI_percents_3multi_H_FL1SL2O_yRef');
simList = {'120W_5D_60L_120F_120S';'120W_5D_60L_120F_120S_120H';'120W_5D_60L_120F_120S_480H'};
hStrings = {'$H=0\sigma$';'$H=120\sigma$';'$H=480\sigma$'};
% legendString = {'$H=0\sigma$, Avg. Data','$H=0\sigma$, Trend Line','$H=120\sigma$, Avg. Data','$H=120\sigma$, Trend Line','$H=480\sigma$, Avg. Data','$H=480\sigma$, Trend Line'};
legendString = {'$H=0\sigma$','Trend','$H=120\sigma$','Trend','$H=480\sigma$','Trend'};

percFig =figure('Visible','on');
tiledlayout(1,2, 'Padding', 'compact', 'TileSpacing', 'compact');
axAperc = nexttile();
hold on
box on
title('~\qquad~\qquad~Argon~\quad~\qquad~\qquad~(a)','Interpreter','latex');
xlim([-260 260]);
ylabel(strcat('$n_A ~(\%)$'),'Interpreter','Latex');
ylim([0 6]);
xlabel("$y'/\sigma$ (Dimensionless)",'Interpreter','Latex');
xticks(-240:120:240);
axIperc = nexttile();
hold on
box on
title('~\qquad~\qquad~Impurity~\quad~\qquad~\qquad~(b)','Interpreter','latex');
xlim([-260 260]);
ylabel(strcat('$n_I ~(\%)$'),'Interpreter','Latex');
ylim([0 12]);
xlabel("$y'/\sigma$ (Dimensionless)",'Interpreter','Latex');
xticks(-240:120:240);

for i=1:1:size(simList,1) %Loop through folders in root directory
    theFullFile = fullfile(ensembleDir,simList{i,1});
    cd(theFullFile);
    fileList = dir(pwd);
    for j=1:1:size(fileList,1) %Load the collated mesh data .mat file
        if endsWith(fileList(j).name,'.mat') && startsWith(fileList(j).name,'Mesh')
            load(fileList(j).name);
            break;
        end
    end
    [parNames, parVars, parVals] = ensemble_parameters(simList{i,1}); %Get parameter info
    for k=1:1:size(parVars,2)
        if strcmp(parVars(k),'D')
            dVal = parVals(k);
            break;
        end
    end
    if dVal == 1 %Make impurity count 0 if no impurity
        countI = 0;
        uI = 0;
        vI = 0;
    end
    orificeWidth = parVals(1);
    impurityDiameter = parVals(2);
    filterDepth = parVals(3);
    filterSeparation = parVals(4);
    orificeSpacing = parVals(5);
    if size(parVars) < 6
        registryShift = 0;
    else
        registryShift = parVals(6);
    end
    
    [orificeIndices] = get_orifice_indices(countA); %Calculate orifice indices
    middleY = orificeIndices(2,2,2)-1+(orificeIndices(1,2,3) - orificeIndices(2,2,2))/2;
    yCentered = y(1,:) - 20*middleY -10;
    for q = 1 : 1 : size(yCentered,2)
        if yCentered(1,q) > 0
            yCenterIndex = q;
            break;
        end
    end
    xCentered = x(1:size(x,1));
    binsY = yCentered(1,:);

    sliceIndx = size(x,1);% - 5; %How far from edge of filter do we sum particles
    edgeSumA = sum(countA(sliceIndx,:,:),3)/sum(countA(sliceIndx,:,:),'all')*100;%./(hopperArgon(1)-hopperArgon(size(hopperArgon,1)));
    edgeSumI = sum(countI(sliceIndx,:,:),3)/sum(countI(sliceIndx,:,:),'all')*100;%./(hopperImpurity(1)-hopperImpurity(size(hopperImpurity)));

    [argonLine,argonGood,argonEtc] = fit(binsY'+10,edgeSumA','gauss2','StartPoint',[2*10^4,-120,60,2*10^4,120,60]);
    argonCurve = argonLine(binsY);
       
    [impurityLine,impurityGood,impurityEtc] = fit(binsY'+10,edgeSumI','gauss2','StartPoint',[5*10^3,-120,60,5*10^4,120,60]);
    impurityCurve = impurityLine(binsY);   
    if i == 1
        plot(axAperc,binsY+10,edgeSumA,'.k');
        plot(axAperc,binsY+10,argonCurve,'--k');

        plot(axIperc,binsY+10,edgeSumI,'.k');
        plot(axIperc,binsY+10,impurityCurve,'--k');
    elseif i == 2
        plot(axAperc,binsY+10,edgeSumA,'xb');
        plot(axAperc,binsY+10,argonCurve,'-.b');

        plot(axIperc,binsY+10,edgeSumI,'xb');
        plot(axIperc,binsY+10,impurityCurve,'-.b');
    else
        plot(axAperc,binsY+10,edgeSumA,'+r');
        plot(axAperc,binsY+10,argonCurve,'-r');
%         legend(legendString,'Interpreter','Latex');

        plot(axIperc,binsY+10,edgeSumI,'+r');
        plot(axIperc,binsY+10,impurityCurve,'-r');
%         legend(legendString,'Interpreter','Latex');
    end
end
legend(legendString,'Interpreter','Latex');
set(percFig,'Units','Centimeter','Position',[0 0 16 8]);
exportgraphics(percFig,strcat(fileName,".png"));
exportgraphics(percFig,strcat(fileName,".eps"));
savefig(percFig,strcat(fileName,".fig"));
end