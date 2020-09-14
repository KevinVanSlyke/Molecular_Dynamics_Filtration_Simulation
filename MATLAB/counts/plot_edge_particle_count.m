function [] = plot_edge_particle_count(countA)
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here
figure();
hold on
n=0;
for i=0:1:10
    edgeCount = countA(size(countA,1)-i,:,:);
    n = n+1;
    combinedBarValues(n,:) = sum(edgeCount(1,:,:),3);
%     combinedBarValues(n,:) = sum(countA(size(countA,1),:,1:i),[1 2]);
    legendStrings{n} = ['$L=' num2str(180-i*20) 'r^*$'];
end
bins = (1:1:size(countA,2))*20;
% for i=1:1000:size(countA,3)
%     plot(y(1,:),countA(size(countA,1),:,i),'DisplayName',strcat('$t=',num2str(t(i)/200),'r^*$'));
barGraph = bar(bins,combinedBarValues,'grouped');
% end

% set(barGraph,{'DisplayName'},legendStrings);
% histLegend = legend('show');
% set(histLegend, 'Interpreter','latex');
legend(legendStrings,'Interpreter','latex');
title('Particle Count at Exit', 'Interpreter', 'LaTex', 'FontSize', 8 );
ylabel('Particle Count','Interpreter','Latex');
xlabel('Height','Interpreter','Latex');
%axis([0 max(t) 0.9*min(P) 1.1*max(P)]);
%axis([0 max(t) 0.9*min(varAvg) 1.1*max(varAvg)]);
set(pFig,'Units','Centimeters','Position',[0 0 8.6 8.6]);
set(findall(pFig,'-property','FontSize'),'FontSize',9);
exportgraphics(pAx,strcat(fileName,".png"));
exportgraphics(pAx,strcat(fileName,".eps"));
savefig(pFig,strcat(fileName,".fig"));
close(pFig);
end

