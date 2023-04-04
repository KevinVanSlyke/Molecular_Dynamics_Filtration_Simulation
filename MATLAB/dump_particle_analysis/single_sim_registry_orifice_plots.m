function [] = single_sim_registry_orifice_plots(orifice_registry_data, ptclType,series,saves)
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

for simIndx = 1:1:size(orifice_registry_data{2,1},1)
    fileName = strcat('All_Orifice_',ptclType,'_',series,'_',orifice_registry_data{2,1}{simIndx,1});
    oFig = figure();
    hold on
    box on
    lineStyle = {':k';'-.b';'-r'};
    for orificeIndx = 1:1:size(orifice_registry_data{1,1},1)
        ptclData = orifice_registry_data{ptclIndx,1}(orificeIndx,simIndx,:);
        plot(orifice_registry_data{3,1}/200,ptclData(:),lineStyle{orificeIndx,1},'DisplayName',orifice_registry_data{1,1}{orificeIndx,1});
    end
    legend('show');
    legend('Interpreter','latex');
    [parNames, parVars, parVals] = ensemble_parameters(orifice_registry_data{2,1}{simIndx,1});
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
    title(orifice_registry_data{2,1}{simIndx,1},'Interpreter','none');
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



