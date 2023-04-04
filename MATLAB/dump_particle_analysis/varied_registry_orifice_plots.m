function [] = varied_registry_orifice_plots(orifice_registry_data, ptclType, series, saves)
%Plot pressure slices and unknown
S = 100;
l = 5;

if strcmp(ptclType,'Argon') && strcmp(series,'Instantaneous')
    ptclIndx = 4;
elseif strcmp(ptclType,'Argon') && strcmp(series,'Cummulative')
    ptclIndx = 6;
elseif strcmp(ptclType,'Impurity') && strcmp(series,'Instantaneous')
    ptclIndx = 8;
elseif strcmp(ptclType,'Impurity') && strcmp(series,'Cummulative')
    ptclIndx = 10;
end
[parNames, parVars, parVals] = ensemble_parameters(orifice_registry_data{2,1}{1,1});
simList = {strcat(parVars(1,1),num2str(parVals(1,1)),'_',parVars(1,2),num2str(parVals(1,2)))};
for simIndx = 1:1:size(orifice_registry_data{2,1},1)
    addSim = 0;
    for listIndx = 1:1:size(simList,2)
        [parNames, parVars, parVals] = ensemble_parameters(orifice_registry_data{2,1}{simIndx,1});
        if strcmp(simList{1,listIndx},strcat(parVars(1,1),num2str(parVals(1,1)),'_',parVars(1,2),num2str(parVals(1,2))))
             addSim = 0;
        else
            addSim = 1;
        end
    end
    if addSim == 1
        simList{1,size(simList,2)+1} = strcat(parVars(1,1),num2str(parVals(1,1)),'_',parVars(1,2),num2str(parVals(1,2)));
    end
end

for listIndx = 1:1:size(simList,2)
    for orificeIndx = 1:1:size(orifice_registry_data{1,1},1)
        fileName = strcat(orifice_registry_data{1,1}{orificeIndx,1},  '_Orifice_',ptclType,'_',series,'_',simList{1,listIndx});
        oFig = figure();
        hold on
        box on
        lineStyle = {':k';'--b';'-.r';'-m'};
        lineIndx = 1;
        for simIndx = 1:1:size(orifice_registry_data{2,1},1)
            [parNames, parVars, parVals] = ensemble_parameters(orifice_registry_data{2,1}{simIndx,1});
            if strcmp(simList{1,listIndx},strcat(parVars(1,1),num2str(parVals(1,1)),'_',parVars(1,2),num2str(parVals(1,2))))
                if parVals(1,3) == 0 || parVals(1,3) == 20 || parVals(1,3) == 100 || parVals(1,3) == 200
                    ptclData = orifice_registry_data{ptclIndx,1}(orificeIndx,simIndx,:);
                    plot(orifice_registry_data{3,1}/200,ptclData(:),lineStyle{lineIndx,1},'DisplayName',strcat('$',parVars(1,3),'=',num2str(parVals(1,3)),'r^*$'));
                    lineIndx = lineIndx + 1;
                end
            end
        end
        legend('show');
        legend('Interpreter','latex');
        if strcmp(series,'Instantaneous')
            xUpper = 1*10^4;
            xlim([0 xUpper]);
        end
        oAx = gca;
        oAx.XAxis.Exponent = 0;
        xTic = xticks;
        xticklabels(xTic/(10^4));
        xlabel('Time $(10^4~t^*)$','Interpreter','latex');
        ylabel(strcat(series,{' '},ptclType,' Particle Transport, $N$'),'Interpreter','latex');    
        title(strcat(orifice_registry_data{1,1}{orificeIndx,1},'_', simList{1,listIndx}),'Interpreter','none');
        set(oFig,'Units','Centimeters','Position',[0 0 8.6 8.6]);
        set(findall(oFig,'-property','FontSize'),'FontSize',9);
        if strcmp(saves,'png')
            exportgraphics(oAx,strcat(fileName,".png"));
        elseif strcmp(saves,'all')
            exportgraphics(oAx,strcat(fileName,".png"));
            exportgraphics(oAx,strcat(fileName,".eps"));
            savefig(oFig,strcat(fileName,".fig"));
        end
        close(oFig);
    end
end
end



