function [] = plot_single_sim_therm()
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


for i = 1 : 1 : size(simStrings,1)
simString = simStrings(i,1);
[parName, parVar, parVal] = ensemble_parameters(simString);

tFig = figure('Visible','off');
tAx = axes('Visible','off');
plot(t, varAvg, '.');
hold on;
title(titleString, 'Interpreter', 'LaTex', 'FontSize', 8 );
ylabel(strcat('Pressure (', varSym,')'),'Interpreter','Latex');
legend("Avg. $P_{front}$",'Interpreter','Latex');
axis([0 max(t) 0.9*min(varAvg) 1.1*max(varAvg)]);
xlabel("Time ($t^*$)",'Interpreter','Latex');

%%Normalize figure size for article requirements.
set(tFig,'Units','Centimeters','Position',[0 0 8.6 8.6]);
set(findall(tFig,'-property','FontSize'),'FontSize',9);

%%Save functions for various file types.
varTitle = strcat(parVar,"_vs_Time_",parString);
% print(strcat(varTitle,"_vs_Time_",parString,"_",plotFit), '-dpng');
% savefig(fitFig, strcat("Fit_Statistical_",varTitle,"_vs_Time_",parString,"_",plotFit,".fig"));
exportgraphics(tAx,strcat(fileName,".png"));
% exportgraphics(tAx,strcat(fileName,".eps"));
% savefig(pFig,strcat(fileName,".fig"));
close(tFig);
end

end

