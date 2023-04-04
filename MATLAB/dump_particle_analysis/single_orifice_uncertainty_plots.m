function [] = single_orifice_uncertainty_plots(orifice_registry_data,orificeIndx,series,saves)
%Plot pressure slices and unknown
S = 100;
l = 5;

if strcmp(series,'Instantaneous')
    argonIndx = 4;
    impurityIndx = 8;
elseif strcmp(series,'Cummulative')
    argonIndx = 6;
    impurityIndx = 10;
end

for simIndx = 1:1:size(orifice_registry_data{2,1},1)
    fileName = strcat(orifice_registry_data{1,1}{orificeIndx,1},'_Orifice_Uncertainty_',series,'_',orifice_registry_data{2,1}{simIndx,1});
    oFig = figure();
    hold on
    box on
    
    argonData = orifice_registry_data{argonIndx,1}(orificeIndx,simIndx,:);
    argonStd=orifice_registry_data{argonIndx+1,1}(orificeIndx,simIndx,:);
    impurityData = orifice_registry_data{impurityIndx,1}(orificeIndx,simIndx,:);
    impurityStd=orifice_registry_data{impurityIndx+1,1}(orificeIndx,simIndx,:);
    
    subplot(2,2,1);
    plot(orifice_registry_data{3,1}/200,argonData(:),'-k');
    if strcmp(series,'Instantaneous')
        xUpper = 1*10^4;
        xlim([0 xUpper]);
    end
    oAx = gca;
    oAx.XAxis.Exponent = 0;
    xTic = xticks;
    xticklabels(xTic/(10^4));
    xlabel('Time $(10^4~t^*)$','Interpreter','latex');
    ylabel('$N_A$','Interpreter','latex');    
    title('(a)','Interpreter','none');

    subplot(2,2,3);
    plot(orifice_registry_data{3,1}/200,argonStd(:),'-k');
    if strcmp(series,'Instantaneous')
        xUpper = 1*10^4;
        xlim([0 xUpper]);
    end
    oAx = gca;
    oAx.XAxis.Exponent = 0;
    xTic = xticks;
    xticklabels(xTic/(10^4));
    xlabel('Time $(10^4~t^*)$','Interpreter','latex');
    ylabel('$\sigma_{N_A}$','Interpreter','latex');    
    title('(b)','Interpreter','none');

    subplot(2,2,2);
    plot(orifice_registry_data{3,1}/200,impurityData(:),'-k');
    if strcmp(series,'Instantaneous')
        xUpper = 1*10^4;
        xlim([0 xUpper]);
    end
    oAx = gca;
    oAx.XAxis.Exponent = 0;
    xTic = xticks;
    xticklabels(xTic/(10^4));
    xlabel('Time $(10^4~t^*)$','Interpreter','latex');
    ylabel('$N_I$','Interpreter','latex');    
    title('(c)','Interpreter','none');

    subplot(2,2,4);
    plot(orifice_registry_data{3,1}/200,impurityStd(:),'-k');
    if strcmp(series,'Instantaneous')
        xUpper = 1*10^4;
        xlim([0 xUpper]);
    end
    oAx = gca;
    oAx.XAxis.Exponent = 0;
    xTic = xticks;
    xticklabels(xTic/(10^4));
    xlabel('Time $(10^4~t^*)$','Interpreter','latex');
    ylabel('$\sigma_{N_I}$','Interpreter','latex');   
    title('(d)','Interpreter','none');

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



