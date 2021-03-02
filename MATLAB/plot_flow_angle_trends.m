function [] = plot_flow_angle_trends(meanPhi,dataLabels,figDir)
%Plots collated outflow angles and internal flow angle calculated from mean
%velocity components.
%   Iterates over simulation folders to calculate the flow angle in various
%   regions

cd(figDir);
debug = 1;

regime = 'Early';
% regime = 'Full';
nDVals = 4;
nSVals = 4;

%%TODO: Make variable
nRegions = 10;

for i=1:1:nRegions
    labelWords = strsplit(dataLabels(i+3));
    regionLabels(i) = labelWords(2);
    if size(labelWords,2) > 2
        for j=3:1:size(labelWords,2)
            regionLabels(i) = regionLabels(i)+' '+labelWords(j);
        end
    end
end
sortedMeanPhi = sortrows(meanPhi,[2 1]); %Sort with 'L' most rapidly varying
sVals = sortedMeanPhi(1:4,1);
dVals = sortedMeanPhi(1:4:size(sortedMeanPhi,1),2);

for i=1:1:nDVals
    %Plot Argon Angle as function of L
    if debug == 1
        sFig = figure('Visible','on');
    else
        sFig = figure('Visible','off');
    end
    hold on
    plot(sVals,sortedMeanPhi((1:4)+(i-1)*nSVals,5),'-r');
    plot(sVals,sortedMeanPhi((1:4)+(i-1)*nSVals,6),'--r');
    plot(sVals,sortedMeanPhi((1:4)+(i-1)*nSVals,9),'-k');
    plot(sVals,sortedMeanPhi((1:4)+(i-1)*nSVals,10),'--k');
    legend([regionLabels(5-3),regionLabels(6-3),regionLabels(9-3),regionLabels(10-3)]);
    ylabel('Argon Outflow Angle, $\Phi_A~(Deg.)$','Interpreter','latex');
    xlabel('Filter Layer Separation, $L~(r^*)$','Interpreter','latex');
    nameTag = strcat('Argon_Upper_Separation_Trend_',num2str(dVals(i,1)),'D_',regime);
    exportgraphics(sFig,strcat(nameTag,".png"));
    if debug == 0
        set(sFig,'Units','Centimeters','Position',[0 0 8.6 8.6]); %Format figure for PRL
        set(findall(sFig,'-property','FontSize'),'FontSize',9);
        exportgraphics(sFig,strcat(nameTag,".eps"));
        savefig(sFig,strcat(nameTag,".fig"));
    end
    close(sFig);

    %Plot Impurity Angle as function of L
    if i > 1
        if debug == 1
            sFig = figure('Visible','on');
        else
            sFig = figure('Visible','off');
        end
        hold on
        plot(sVals,sortedMeanPhi((1:4)+(i-1)*nSVals,15),'-r');
        plot(sVals,sortedMeanPhi((1:4)+(i-1)*nSVals,16),'--r');
        plot(sVals,sortedMeanPhi((1:4)+(i-1)*nSVals,19),'-k');
        plot(sVals,sortedMeanPhi((1:4)+(i-1)*nSVals,20),'--k');
        legend([regionLabels(5-3),regionLabels(6-3),regionLabels(9-3),regionLabels(10-3)]);
        ylabel('Impurity Outflow Angle, $\Phi_I~(Deg.)$','Interpreter','latex');
        xlabel('Filter Layer Separation, $L~(r^*)$','Interpreter','latex');
        nameTag = strcat('Impurity_Upper_Separation_Trend_',num2str(dVals(i,1)),'D_',regime);
        exportgraphics(sFig,strcat(nameTag,".png"));
        if debug == 0
            set(sFig,'Units','Centimeters','Position',[0 0 8.6 8.6]); %Format figure for PRL
            set(findall(sFig,'-property','FontSize'),'FontSize',9);
            exportgraphics(sFig,strcat(nameTag,".eps"));
            savefig(sFig,strcat(nameTag,".fig"));
        end
        close(sFig);
    end
end

for compare = 1
sortedMeanPhi = sortrows(meanPhi,[1 2]);
for i=1:1:nDVals
    %Plot Argon Angle as function of D
    if debug == 1
        dFig = figure('Visible','on');
    else
        dFig = figure('Visible','off');
    end
    hold on
    plot(dVals,sortedMeanPhi((1:4)+(i-1)*nDVals,5),'-r');
    plot(dVals,sortedMeanPhi((1:4)+(i-1)*nDVals,6),'--r');
    plot(dVals,sortedMeanPhi((1:4)+(i-1)*nDVals,9),'-k');
    plot(dVals,sortedMeanPhi((1:4)+(i-1)*nDVals,10),'--k');
    legend([regionLabels(5-3),regionLabels(6-3),regionLabels(9-3),regionLabels(10-3)]);
    ylabel('Argon Outflow Angle, $\Phi_A~(Deg.)$','Interpreter','latex');
    xlabel('Impurity Diameter, $D~(r^*)$','Interpreter','latex');
    nameTag = strcat('Argon_Upper_Diameter_Trend_',num2str(sVals(i,1)),'L_',regime);
    exportgraphics(dFig,strcat(nameTag,".png"));
    if debug == 0
        set(dFig,'Units','Centimeters','Position',[0 0 8.6 8.6]); %Format figure for PRL
        set(findall(dFig,'-property','FontSize'),'FontSize',9);
        exportgraphics(dFig,strcat(nameTag,".eps"));
        savefig(dFig,strcat(nameTag,".fig"));
    end
    close(dFig);
    
    %Plot Impurity Angle as function of D
    if debug == 1
        dFig = figure('Visible','on');
    else
        dFig = figure('Visible','off');
    end
    hold on
    plot(dVals,sortedMeanPhi((1:4)+(i-1)*nDVals,15),'-r');
    plot(dVals,sortedMeanPhi((1:4)+(i-1)*nDVals,16),'--r');
    plot(dVals,sortedMeanPhi((1:4)+(i-1)*nDVals,19),'-k');
    plot(dVals,sortedMeanPhi((1:4)+(i-1)*nDVals,20),'--k');
    legend([regionLabels(5-3),regionLabels(6-3),regionLabels(9-3),regionLabels(10-3)]);
    ylabel('Impurity Outflow Angle, $\Phi_I~(Deg.)$','Interpreter','latex');
    xlabel('Impurity Diameter, $D~(r^*)$','Interpreter','latex');
    nameTag = strcat('Impurity_Upper_Diameter_Trend_',num2str(sVals(i,1)),'L_',regime);
    exportgraphics(dFig,strcat(nameTag,".png"));
    if debug == 0
        set(dFig,'Units','Centimeters','Position',[0 0 8.6 8.6]); %Format figure for PRL
        set(findall(dFig,'-property','FontSize'),'FontSize',9);
        exportgraphics(dFig,strcat(nameTag,".eps"));
        savefig(dFig,strcat(nameTag,".fig"));
    end
    close(dFig);
end
end
sortedMeanPhi = sortrows(meanPhi,[1 2]); %Sort with D most rapidly varying
for i=1:1:nDVals
    %Plot Argon Angle as function of D
    if debug == 1
        dFig = figure('Visible','on');
    else
        dFig = figure('Visible','off');
    end
    hold on
    plot(dVals,sortedMeanPhi((1:4)+(i-1)*nDVals,5),'-r');
    plot(dVals,sortedMeanPhi((1:4)+(i-1)*nDVals,6),'--r');
    plot(dVals,sortedMeanPhi((1:4)+(i-1)*nDVals,9),'-k');
    plot(dVals,sortedMeanPhi((1:4)+(i-1)*nDVals,10),'--k');
    legend([regionLabels(5-3),regionLabels(6-3),regionLabels(9-3),regionLabels(10-3)]);
    ylabel('Argon Outflow Angle, $\Phi_A~(Deg.)$','Interpreter','latex');
    xlabel('Impurity Diameter, $D~(r^*)$','Interpreter','latex');
    nameTag = strcat('Argon_Upper_Diameter_Trend_',num2str(sVals(i,1)),'L_',regime);
    exportgraphics(dFig,strcat(nameTag,".png"));
    if debug == 0
        set(dFig,'Units','Centimeters','Position',[0 0 8.6 8.6]); %Format figure for PRL
        set(findall(dFig,'-property','FontSize'),'FontSize',9);
        exportgraphics(dFig,strcat(nameTag,".eps"));
        savefig(dFig,strcat(nameTag,".fig"));
    end
    close(dFig);
    
    %Plot Impurity Angle as function of D
    if debug == 1
        dFig = figure('Visible','on');
    else
        dFig = figure('Visible','off');
    end
    hold on
    plot(dVals,sortedMeanPhi((1:4)+(i-1)*nDVals,15),'-r');
    plot(dVals,sortedMeanPhi((1:4)+(i-1)*nDVals,16),'--r');
    plot(dVals,sortedMeanPhi((1:4)+(i-1)*nDVals,19),'-k');
    plot(dVals,sortedMeanPhi((1:4)+(i-1)*nDVals,20),'--k');
    legend([regionLabels(5-3),regionLabels(6-3),regionLabels(9-3),regionLabels(10-3)]);
    ylabel('Impurity Outflow Angle, $\Phi_I~(Deg.)$','Interpreter','latex');
    xlabel('Impurity Diameter, $D~(r^*)$','Interpreter','latex');
    nameTag = strcat('Impurity_Upper_Diameter_Trend_',num2str(sVals(i,1)),'L_',regime);
    exportgraphics(dFig,strcat(nameTag,".png"));
    if debug == 0
        set(dFig,'Units','Centimeters','Position',[0 0 8.6 8.6]); %Format figure for PRL
        set(findall(dFig,'-property','FontSize'),'FontSize',9);
        exportgraphics(dFig,strcat(nameTag,".eps"));
        savefig(dFig,strcat(nameTag,".fig"));
    end
    close(dFig);
end

for test = 1 %Place holder for code folding of depricated method.
%for i=1:1:nDVals
%     %Plot Argon Angle as function of D
%     if debug == 1
%         dFig = figure('Visible','on');
%     else
%         dFig = figure('Visible','off');
%     end
%     hold on
%     plot(dVals,sortedMeanPhi(i:nSVals:nSVals*nDVals,5),'-r');
%     plot(dVals,sortedMeanPhi(i:nSVals:nSVals*nDVals,6),'--r');
%     plot(dVals,sortedMeanPhi(i:nSVals:nSVals*nDVals,9),'-k');
%     plot(dVals,sortedMeanPhi(i:nSVals:nSVals*nDVals,10),'--k');
%     
%     legend([regionLabels(5-3),regionLabels(6-3),regionLabels(9-3),regionLabels(10-3)]);
%     ylabel('Argon Outflow Angle, $\Phi_A~(Deg.)$','Interpreter','latex');
%     xlabel('Impurity Diameter, $D~(r^*)$','Interpreter','latex');
%     nameTag = strcat('Argon_Upper_Diameter_Trend_',num2str(sVals(i,1)),'L_',regime);
%     exportgraphics(dFig,strcat(nameTag,".png"));
%     if debug == 0
%         set(dFig,'Units','Centimeters','Position',[0 0 8.6 8.6]); %Format figure for PRL
%         set(findall(dFig,'-property','FontSize'),'FontSize',9);
%         exportgraphics(dFig,strcat(nameTag,".eps"));
%         savefig(dFig,strcat(nameTag,".fig"));
%     end
%     close(dFig);
%     
%     %Plot Impurity Angle as function of D
%     if debug == 1
%         dFig = figure('Visible','on');
%     else
%         dFig = figure('Visible','off');
%     end
%     hold on
%     plot(dVals(2:nDVals),sortedMeanPhi(i+nDVals:nSVals:nSVals*nDVals,15),'-r');
%     plot(dVals(2:nDVals),sortedMeanPhi(i+nDVals:nSVals:nSVals*nDVals,16),'--r');
%     plot(dVals(2:nDVals),sortedMeanPhi(i+nDVals:nSVals:nSVals*nDVals,19),'-k');
%     plot(dVals(2:nDVals),sortedMeanPhi(i+nDVals:nSVals:nSVals*nDVals,20),'--k');
%     
%     legend([regionLabels(5-3),regionLabels(6-3),regionLabels(9-3),regionLabels(10-3)]);
%     ylabel('Impurity Outflow Angle, $\Phi_I~(Deg.)$','Interpreter','latex');
%     xlabel('Impurity Diameter, $D~(r^*)$','Interpreter','latex');
%     nameTag = strcat('Impurity_Upper_Diameter_Trend_',num2str(sVals(i,1)),'L_',regime);
%     exportgraphics(dFig,strcat(nameTag,".png"));
%     if debug == 0
%         set(dFig,'Units','Centimeters','Position',[0 0 8.6 8.6]); %Format figure for PRL
%         set(findall(dFig,'-property','FontSize'),'FontSize',9);
%         exportgraphics(dFig,strcat(nameTag,".eps"));
%         savefig(dFig,strcat(nameTag,".fig"));
%     end
%     close(dFig);
end

end