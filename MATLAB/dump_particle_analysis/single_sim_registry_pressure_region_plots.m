function [] = single_sim_registry_pressure_region_plots(pressure_registry_data, error)
%Plot pressure slices and unknown
S = 100;
l = 5;
for simIndx = 1:1:size(pressure_registry_data{2,1},1)
    pFig = figure();
    hold on
    box on
    lineStyle = {':b';'-k';'-.r'};
    if error == 0
        fileName = strcat('Pressure_',pressure_registry_data{2,1}{simIndx,1});
        for pRegionInd = 1:1:size(pressure_registry_data{1,1},1)
            plot(pressure_registry_data{3,1}/200,pressure_registry_data{4,1}(:,simIndx,pRegionInd),lineStyle{pRegionInd,1},'DisplayName',pressure_registry_data{1,1}{pRegionInd,1});
        end
        legend('show');
        legend('Interpreter','latex');
        [parNames, parVars, parVals] = ensemble_parameters(pressure_registry_data{2,1}{simIndx,1});
        if parVals(1,1) == 20 && parVals(1,2) == 10
            xUpper = 5*10^4;
        elseif parVals(1,1) == 20 && parVals(1,2) == 2
            xUpper = 4*10^4;
        elseif parVals(1,1) == 200 && parVals(1,2) == 10
            xUpper = 2.5*10^4;
        elseif parVals(1,1) == 200 && parVals(1,2) == 2
            xUpper = 1.5*10^4;
        end
        pAx = gca;
        pAx.XAxis.Exponent = 0;
        xlim([0 xUpper]);
        xTic = xticks;
        xticklabels(xTic/(10^4));
        xlabel('Time $(10^4~t^*)$','Interpreter','latex');
        ylabel('Pressure $(P^*)$','Interpreter','latex');
        title(pressure_registry_data{2,1}{simIndx,1},'Interpreter','none');
        
    elseif error == 1
        fileName = strcat('Uncertainty_Pressure_',pressure_registry_data{2,1}{simIndx,1});
        subplot(2,1,1);
        hold on
        for pRegionInd = 1:1:size(pressure_registry_data{1,1},1)
            plot(pressure_registry_data{3,1}/200,pressure_registry_data{4,1}(:,simIndx,pRegionInd),lineStyle{pRegionInd,1},'DisplayName',pressure_registry_data{1,1}{pRegionInd,1});
        end
        legend('show');
        legend('Interpreter','latex');
        [parNames, parVars, parVals] = ensemble_parameters(pressure_registry_data{2,1}{simIndx,1});
        if parVals(1,1) == 20 && parVals(1,2) == 10
            xUpper = 5*10^4;
        elseif parVals(1,1) == 20 && parVals(1,2) == 2
            xUpper = 4*10^4;
        elseif parVals(1,1) == 200 && parVals(1,2) == 10
            xUpper = 2.5*10^4;
        elseif parVals(1,1) == 200 && parVals(1,2) == 2
            xUpper = 1.5*10^4;
        end
        pAx = gca;
        pAx.XAxis.Exponent = 0;
        xlim([0 xUpper]);
        xTic = xticks;
        xticklabels(xTic/(10^4));
        xlabel('Time $(10^4~t^*)$','Interpreter','latex');
        ylabel('Pressure $(P^*)$','Interpreter','latex');
        title(pressure_registry_data{2,1}{simIndx,1},'Interpreter','none');
        
        subplot(2,1,2);
        hold on
        for pRegionInd = 1:1:size(pressure_registry_data{1,1},1)
            plot(pressure_registry_data{3,1}/200,pressure_registry_data{5,1}(:,simIndx,pRegionInd),lineStyle{pRegionInd,1},'DisplayName',pressure_registry_data{1,1}{pRegionInd,1});
        end
        legend('show');
        legend('Interpreter','latex');
        [parNames, parVars, parVals] = ensemble_parameters(pressure_registry_data{2,1}{simIndx,1});
        if parVals(1,1) == 20 && parVals(1,2) == 10
            xUpper = 5*10^4;
        elseif parVals(1,1) == 20 && parVals(1,2) == 2
            xUpper = 4*10^4;
        elseif parVals(1,1) == 200 && parVals(1,2) == 10
            xUpper = 2.5*10^4;
        elseif parVals(1,1) == 200 && parVals(1,2) == 2
            xUpper = 1.5*10^4;
        end
        pAx = gca;
        pAx.XAxis.Exponent = 0;
        xlim([0 xUpper]);
        xTic = xticks;
        xticklabels(xTic/(10^4));
        xlabel('Time $(10^4~t^*)$','Interpreter','latex');
        ylabel('Std. Dev. $(P^*)$','Interpreter','latex');
        title(pressure_registry_data{2,1}{simIndx,1},'Interpreter','none');
    end
   
    set(pFig,'Units','Centimeters','Position',[0 0 8.6 8.6]);
    set(findall(pFig,'-property','FontSize'),'FontSize',9);
    exportgraphics(pAx,strcat(fileName,".png"));
    exportgraphics(pAx,strcat(fileName,".eps"));
    savefig(pFig,strcat(fileName,".fig"));
    close(pFig);
end

end

