%% Names of the figures that have been edited.
fileName = "Front_Rear_P_vs_t_100W_1D";
fileName = "Fit_Statistical_Front Pressure_vs_Time_20W_1D_5L_LJ_3D";
fileName = "100W_compare_D_freq";
fileName = "closed_boundary_diagram_P_v";
fileName = "tau_vs_W_to_1500_1D";
fileName = "tau_vs_D_100W";
fileName = "ratio_tau_dual_mono_2W";
fileName = "P_vs_t_multilayer_20W_200W";
fileName = "Na_SL1_periodic";

%% Various y-axis labels
ylabel("$P$","Interpreter","Latex");
ylabel("$P_0$","Interpreter","Latex");
ylabel("$v_x$","Interpreter","Latex");
ylabel("$\tau$","Interpreter","Latex");
ylabel("$\tau ~(t_{\mathrm{LJ}})$","Interpreter","Latex");
ylabel("$N_A$","Interpreter","Latex");
ylabel("$\Phi_{SL[1]}$ $(deg.)$","Interpreter","Latex");

%% Various x-axis labels
xlabel("$W$","Interpreter","Latex");
xlabel("$D$","Interpreter","Latex");
xlabel("$D ~(\sigma)$","Interpreter","Latex");
xlabel("$f$","Interpreter","Latex");
xlabel("$t$","Interpreter","Latex");
xlabel("Registry Angle, $\theta ~ (deg.)$ ","Interpreter","Latex");
xlabel("$\Delta$","Interpreter","Latex");

%% Various legend entries
legend(["Avg. $P_{\text{I}}$", "Avg. $P_{\text{\Romannum{2}}$", "Exp. Trend"],'Interpreter','Latex');
legend(["Avg. Front", "Avg. Rear", "Exp. Trend"],'Interpreter','Latex');
legend(["Region $I$", "Region $II$", "Exp. Trend"],'Interpreter','Latex');
legend(["$S=50$", "$S=250$", "$S=500$", "$S=1000$", "Average", "Exp. Trend"],'Interpreter','Latex');
legend(["Mean \& Std. Dev.", "Quadratic Trend"],'Interpreter','Latex');
legend(["Region I", "Exp. Trend"],'Interpreter','Latex');
legend(["Pure Argon", "$D=5$", "$D=10$"],'Interpreter','Latex');
legend(["Region I", "Region II", "Region III"],'Interpreter','Latex');
legend(["$H = 0$", "$H = 20$", "$H = 100$", "$H = 200$"],'Interpreter','Latex');
legend(["$W/D = 2$", "$W/D = 10$", "$W/D = 20$", "$W/D = 100$"],'Interpreter','Latex');
legend(["$\Phi_A$, $D = 5$", "$\Phi_I$, $D = 5$", "$\Phi_A$, $D = 2$", "$\Phi_I$, $D = 2$", "$\Phi_A$, $D = 1$"],'Interpreter','Latex');

%% Various titles
title("$W = 20$ ~~ \qquad (a)",'Interpreter','Latex');
title("$W = 200$ ~~ \qquad (b)",'Interpreter','Latex');

%% Further axis formatting
xticks('auto'); %Set ticks to auto to undo manual
xticklabels('auto'); %Set ticks to auto to undo manual
gca.XAxis.Exponent = 4; %Change power notation of x-axis to 10^4
gca.YAxis.Exponent = -2; %Change power notation of y-axis to 10^-2

%% Saving and formating
myAx = gca; %Get current axes
myFig = gcf; %Get current figure
axis square;

set(gcf,'Units','Centimeters','Position',[0 0 8.6 8.6]);
set(findall(gcf,'-property','FontSize'),'FontSize',9);
exportgraphics(gcf,strcat(fileName,".png"));
exportgraphics(gcf,strcat(fileName,".eps"));
savefig(gcf,strcat(fileName,".fig"));

%% Current figure commands
fileName = "P_vs_t_multilayer_20W_200W";
ylabel("$P$","Interpreter","Latex");
xlabel("$t$","Interpreter","Latex");
title("$W = 20$ \quad (a)",'Interpreter','Latex');
title("$W = 200$ \quad (b)",'Interpreter','Latex');
% xticks('auto'); %Set ticks to auto to undo manual
% xticklabels('auto'); %Set ticks to auto to undo manual
legend(["Region I", "Region II", "Region III"],'Interpreter','Latex');

myAx = gca; %Get current axes
myAx.XAxis.Exponent = 4; %Change power notation of x-axis to 10^4
myAx.YAxis.Exponent = -2; %Change power notation of y-axis to 10^-2

%% Copy figure to subplots, not as good as tiled
subFig = figure();
ax1 = subplot(1,2,1,'parent',subFig);
ax2 = subplot(1,2,2,'parent',subFig);
axCopy1 = copyobj(ax20W,subFig);
set(axCopy1,'Position',get(ax1,'position'));
axCopy2 = copyobj(ax200W,subFig);
set(axCopy2,'Position',get(ax2,'position'));
delete(ax1);
delete(ax2);
axis(axCopy1,'square');
axis(axCopy2,'square');
axCopy1.XAxis.Limits = [0 15000];
axCopy1.YAxis.Limits = [0 0.09];
axCopy2.YAxis.Limits = [0 0.09];

%% Copy figure to tiled plots
tiledFig = figure();
tiledlayout(1,2, 'Padding', 'tight', 'TileSpacing', 'compact'); 
ax1 = nexttile(1);
% axis(ax1,'square');
ax2 = nexttile(2);
% axis(ax2,'square');
axCopy1 = copyobj(axOriginal1,tiledFig);
set(axCopy1,'Position',get(ax1,'position'));
axCopy2 = copyobj(axOriginal2,tiledFig);
set(axCopy2,'Position',get(ax2,'position'));

title("\qquad \qquad \qquad $W = 20$ \qquad \qquad (a)",'Interpreter','Latex');
title("\qquad \qquad \qquad $W = 200$ ~ \qquad \quad (b)",'Interpreter','Latex');
legend(["Region I", "Region II", "Region III"],'Interpreter','Latex');

delete(ax1);
delete(ax2);

% legend(axcp20W,["Region I", "Region II", "Region III"],'Interpreter','Latex');
% set(findall(axcp20W,'-property','FontSize'),'FontSize',9);
% legend(axcp200W,["Region I", "Region II", "Region III"],'Interpreter','Latex');
% set(findall(axcp200W,'-property','FontSize'),'FontSize',9);

%% Export as png, eps and fig
fileName = "P_vs_t_multilayer_20W_200W";
exportgraphics(gcf,strcat(fileName,".png"));
exportgraphics(gcf,strcat(fileName,".eps"));
savefig(gcf,strcat(fileName,".fig"));

exportgraphics(tiledFig,strcat(fileName,".png"));
exportgraphics(tiledFig,strcat(fileName,".eps"));
savefig(tiledFig,strcat(fileName,".fig"));

%% N_A vs t for FL1-SL2-P
fileName = "Na_SL1_periodic";
ylabel("$N_A$","Interpreter","Latex");
xlabel("$t$","Interpreter","Latex");
title('');
legend(["$H = 0$", "$H = 20$", "$H = 100$", "$H = 200$"],'Interpreter','Latex');
gca.XAxis.TickLabelsMode = 'auto'; %Change power notation of x-axis to 10^4
gca.XAxis.TickValuesMode = 'auto'; %Change power notation of x-axis to 10^4
gca.XAxis.ExponentMode = 'manual';
gca.XAxis.Exponent = 4; %Change power notation of x-axis to 10^4

% gca.XAxis.Exponent = 4; %Change power notation of x-axis to 10^4

%% tau vs theta scatter for FL1-SL2-P
fileName = "tau_func_theta_periodic";

[linWD2FitCurve, linWD2FitGoodness, linWD2FitOutput] = fit(xWD2,yWD2,'poly1');
[linWD10FitCurve, linWD10FitGoodness, linWD10FitOutput] = fit(xWD10,yWD10,'poly1');
[linWD20FitCurve, linWD20FitGoodness, linWD20FitOutput] = fit(xWD20,yWD20,'poly1');
[linWD100FitCurve, linWD100FitGoodness, linWD100FitOutput] = fit(xWD100,yWD100,'poly1');

aFig = figure();
hold on
scatter(xWD2, yWD2, '+b');
% plot(linWD2FitCurve,':b');
scatter(xWD10, yWD10, 'or');
% plot(linWD10FitCurve,':r');
scatter(xWD20, yWD20, 'sm');
% plot(linWD20FitCurve,':m');
scatter(xWD100, yWD100, 'xk');
% plot(linWD100FitCurve,':k');

theta = rad2deg(atan((tauAvgVals(:,6)-tauAvgVals(:,1)/2-tauAvgVals(:,5)./tauAvgVals(:,3))));
theta = rad2deg(atan((tauAvgVals(1,6)-tauAvgVals(1,1)/2-tauAvgVals(1,5)./tauAvgVals(1,3))));

[linWD2FitCurve, linWD2FitGoodness, linWD2FitOutput] = fit(tauAvgValsSpaced(8:14,9), tauAvgValsSpaced(8:14,7), 'poly1', 'Weights', tauAvgValsSpaced(8:14,8));
[linWD10FitCurve, linWD10FitGoodness, linWD10FitOutput] = fit(tauAvgValsSpaced(1:7,9), tauAvgValsSpaced(1:7,7), 'poly1', 'Weights', tauAvgValsSpaced(1:7,8));
[linWD20FitCurve, linWD20FitGoodness, linWD20FitOutput] = fit(tauAvgValsSpaced(19:22,9), tauAvgValsSpaced(19:22,7), 'poly1', 'Weights', tauAvgValsSpaced(19:22,8));
[linWD100FitCurve, linWD100FitGoodness, linWD100FitOutput] = fit(tauAvgValsSpaced(15:18,9), tauAvgValsSpaced(15:18,7), 'poly1', 'Weights', tauAvgValsSpaced(15:18,8));

%% tau vs theta error bar for FL1-SL2-P
fileName = "tau_vs_theta_periodic";
fig = figure();
hold on
errorbar(tauAvgValsSpaced(8:14,9), tauAvgValsSpaced(8:14,7), tauAvgValsSpaced(8:14,8),'ob');
errorbar(tauAvgValsSpaced(1:7,9), tauAvgValsSpaced(1:7,7), tauAvgValsSpaced(1:7,8),'sr');
errorbar(tauAvgValsSpaced(19:22,9), tauAvgValsSpaced(19:22,7), tauAvgValsSpaced(19:22,8),'*k');
errorbar(tauAvgValsSpaced(15:18,9), tauAvgValsSpaced(15:18,7), tauAvgValsSpaced(15:18,8),'.m');
axis([-90 90 2000 12000]);
ylabel("$\tau$","Interpreter","Latex");
xlabel("Registry Angle, $\theta$","Interpreter","Latex");
xlabel("$H$","Interpreter","Latex");
legend(["$W/D = 2$", "$W/D = 10$", "$W/D = 20$", "$W/D = 100$"],'Interpreter','Latex','NumColumns',2);
gca.YAxis.Exponent = 3; %Change power notation of x-axis to 10^4

%% tau vs H error bar for FL1-SL2-P
fileName = "tau_vs_H_periodic";
fig = figure();
hold on
errorbar(tauAvgValsSpacedCopy(5:8,6), tauAvgValsSpacedCopy(5:8,7), tauAvgValsSpacedCopy(5:8,8),'ob','MarkerSize',4);
errorbar(tauAvgValsSpacedCopy(1:4,6), tauAvgValsSpacedCopy(1:4,7), tauAvgValsSpacedCopy(1:4,8),'sr','MarkerSize',4);
errorbar(tauAvgValsSpacedCopy(13:16,6), tauAvgValsSpacedCopy(13:16,7), tauAvgValsSpacedCopy(13:16,8),'*k','MarkerSize',4);
errorbar(tauAvgValsSpacedCopy(9:12,6), tauAvgValsSpacedCopy(9:12,7), tauAvgValsSpacedCopy(9:12,8),'.m','MarkerSize',4);
axis([-5 205 2000 12000]);
ylabel("$\tau$","Interpreter","Latex");
xlabel("$H$","Interpreter","Latex");
legend(["$W/D = 2$", "$W/D = 10$", "$W/D = 20$", "$W/D = 100$"],'Interpreter','Latex','NumColumns',2, 'Location','North');
legend(["$D/W = 0.5$", "$D/W = 0.1$", "$D/W = 0.05$", "$D/W = 0.01$"],'Interpreter','Latex','NumColumns',2, 'Location','North');
gca.YAxis.Exponent = 3; %Change power notation of x-axis to 10^4

set(gcf,'Units','Centimeters','Position',[0 0 8.6 8.6]);
set(findall(gcf,'-property','FontSize'),'FontSize',9);

exportgraphics(gcf,strcat(fileName,".png"));
exportgraphics(gcf,strcat(fileName,".eps"));
savefig(gcf,strcat(fileName,".fig"));

%% Define variables from phiData
deltaVals = phiData(1:4,4);
deltaStride=size(deltaVals);
hVals = phiData(13:17,6);
hStride=size(hVals);
sVals = phiData(28:31,5);
sStride=size(sVals);
dVals = phiData(40:42,2);
dStride=size(dVals);

stride = hStride; %pick stride depending on what were plotting against
s1=13;
e1=17;
s2=s1+stride;
e2=e1+stride;
s3=s2+stride;
e3=e2+stride;
s4=s3+stride;
e4=e3+stride;

parVals = deltaVals;
meanData = phiData(s2:e2,11);
stdData = phiData(s2:e2,13);

%% Basic fits
weightData = 1./stdData.^2;
[linFitCurve,linFitGoodness, linFitOutput] = fit(parVals,meanData,'poly1','Weights',weightData);
linRsq = linFitGoodness.adjrsquare
[expFitCurve,expFitGoodness, expFitOutput] = fit(parVals,meanData,'exp1','Weights',weightData);
expRsq = expFitGoodness.adjrsquare
[powFitCurve,powFitGoodness, powFitOutput] = fit(parVals,meanData,'power1','Weights',weightData);
powRsq = powFitGoodness.adjrsquare

%% (1.) Plot of two vertical tiles of mean and std dev \Phi(\Delta), each with two data series (D=2 and D=5)
aFig = figure();
aFileName = "Phi_vs_Delta_MultiD_Std";
tiledlayout(2,1,'TileSpacing','none','Padding','compact');

nexttile
hold on
scatter(deltaVals,phiData(s2:e2,7),'.r'); %Argon, D = 5, S=120, Delta = [60,120,240,480] 
scatter(deltaVals,phiData(s2:e2,11),'ok'); %Impurity, D = 5, S=120, Delta = [60,120,240,480] 
scatter(deltaVals,phiData(s3:e3,7),'xr'); %Argon, D = 5, S=120, Delta = [60,120,240,480] 
scatter(deltaVals,phiData(s3:e3,11),'+k'); %Impurity, D = 5, S=120, Delta = [60,120,240,480] 
xticklabels('');
ylabel("$\Phi_{SL[1]}~(deg.)$","Interpreter","Latex");
title("\qquad \qquad \qquad \qquad \qquad \qquad \qquad \qquad \qquad (a)",'Interpreter','Latex');
ylim([0 20]);

nexttile
hold on
scatter(deltaVals,phiData(s2:e2,9),'.r'); %Argon, D = 5, S=120, Delta = [60,120,240,480] 
scatter(deltaVals,phiData(s2:e2,13),'ok'); %Impurity, D = 5, S=120, Delta = [60,120,240,480] 
scatter(deltaVals,phiData(s3:e3,9),'xr'); %Argon, D = 5, S=120, Delta = [60,120,240,480] 
scatter(deltaVals,phiData(s3:e3,13),'+k'); %Impurity, D = 5, S=120, Delta = [60,120,240,480] 
xlabel("$\Delta$","Interpreter","Latex");
ylabel("$\sigma_{\Phi}~(deg.)$","Interpreter","Latex");
title("\qquad \qquad \qquad \qquad \qquad \qquad \qquad \qquad \qquad (b)",'Interpreter','Latex');
ylim([0 20]);
yticklabels({'0','5','10','15',''});
legend(["D=2, Ar.", "D=2, Im.","D=5, Ar.", "D=5, Im."],'Interpreter','latex','Location','northwest','NumColumns',2);
set(aFig,'Units','Centimeters','Position',[0 0 8.6 8.6]);
set(findall(aFig,'-property','FontSize'),'FontSize',9);
exportgraphics(aFig,strcat(aFileName,".png"));
exportgraphics(aFig,strcat(aFileName,".eps"));
savefig(aFig,strcat(aFileName,".fig"));

%% (2.) Plot of three columns with two rows of mean and std dev for \Phi(\Delta), \Phi(D) and \Phi(S) for D=5 only
aFig = figure();
aFileName = "Phi_vs_Delta_S_D_Std";
tiledlayout(2,3,'TileSpacing','compact','Padding','compact');

nexttile(1)
hold on
scatter(deltaVals,phiData(s3:e3,7),'xr'); %Argon, D = 5, S=120, Delta = [60,120,240,480] 
scatter(deltaVals,phiData(s3:e3,11),'.k'); %Impurity, D = 5, S=120, Delta = [60,120,240,480] 
xlabel("$\Delta$","Interpreter","Latex");
ylim([0 20]);
xlim([0 500]);
title("(a)",'Interpreter','Latex');
% title("\qquad \qquad \qquad \qquad (a)",'Interpreter','Latex');
ylabel("$\Phi_{SL[1]}~(deg.)$","Interpreter","Latex");

nexttile(4)
hold on
scatter(deltaVals,phiData(s3:e3,9),'xr'); %Argon, D = 5, S=120, Delta = [60,120,240,480] 
scatter(deltaVals,phiData(s3:e3,13),'.k'); %Impurity, D = 5, S=120, Delta = [60,120,240,480] 
xlabel("$\Delta$","Interpreter","Latex");
ylabel("$\sigma_{\Phi}~(deg.)$","Interpreter","Latex");
ylim([0 10]);
xlim([0 500]);
% title("\qquad \qquad \qquad \qquad (b)",'Interpreter','Latex');
title("(b)",'Interpreter','Latex');

nexttile(2)
hold on
scatter(dVals,phiData(55:57,7),'xr'); %Argon, D = 5, S=120, Delta = [60,120,240,480] 
scatter(dVals,[phiData(55,7); phiData(56:57,11)],'.k'); %Impurity, D = 5, S=120, Delta = [60,120,240,480] 
xlabel("$D$","Interpreter","Latex");
ylim([0 20]);
xlim([0 6]);
% title("\qquad \qquad \qquad \qquad (c)",'Interpreter','Latex');
title("(c)",'Interpreter','Latex');
ylabel("$\Phi_{SL[1]}~(deg.)$","Interpreter","Latex");

nexttile(5)
hold on
scatter(dVals,phiData(55:57,9),'xr'); %Argon, D = 5, S=120, Delta = [60,120,240,480] 
scatter(dVals,[phiData(55,9); phiData(56:57,13)],'.k'); %Impurity, D = 5, S=120, Delta = [60,120,240,480] 
xlabel("$D$","Interpreter","Latex");
ylabel("$\sigma_{\Phi}~(deg.)$","Interpreter","Latex");
ylim([0 20]);
xlim([0 6]);
% title("\qquad \qquad \qquad \qquad (d)",'Interpreter','Latex');
title("(d)",'Interpreter','Latex');

nexttile(3)
hold on
scatter(sVals,phiData(36:39,7),'xr'); %Argon, D = 5, S=120, Delta = [60,120,240,480] 
scatter(sVals,phiData(36:39,11),'.k'); %Impurity, D = 5, S=120, Delta = [60,120,240,480] 
xlabel("$S$","Interpreter","Latex");
ylim([-5 25]);
xlim([0 500]);
legend(["Argon", "Impurity"],'Interpreter','latex','Location','northeast');
% title("\qquad \qquad \qquad \qquad (e)",'Interpreter','Latex');
title("(e)",'Interpreter','Latex');
ylabel("$\Phi_{SL[1]}~(deg.)$","Interpreter","Latex");

nexttile(6)
hold on
scatter(sVals,phiData(36:39,9),'xr'); %Argon, D = 5, S=120, Delta = [60,120,240,480] 
scatter(sVals,phiData(36:39,13),'.k'); %Impurity, D = 5, S=120, Delta = [60,120,240,480] 
xlabel("$S$","Interpreter","Latex");
ylabel("$\sigma_{\Phi}~(deg.)$","Interpreter","Latex");
ylim([0 10]);
xlim([0 500]);
title("(f)",'Interpreter','Latex');
% title("\qquad \qquad \qquad \qquad (f)",'Interpreter','Latex');

% lg = legend(["SL[1], Ar.", "SL[1], Im."],'Interpreter','latex','Location','best');
% lg.Layout.Tile = 'east';

set(aFig,'Units','Centimeters','Position',[0 0 17.2 8.6]);
set(findall(aFig,'-property','FontSize'),'FontSize',9);
exportgraphics(aFig,strcat(aFileName,".png"));
exportgraphics(aFig,strcat(aFileName,".eps"));
savefig(aFig,strcat(aFileName,".fig"));

%% (3.) Plot of two vertical tiles of mean and std dev \Phi(H), each with three data series (D=1, D=2 and D=5)
aFig = figure();
aFileName = "Phi_vs_H_MultiD_Std_Adj";
tiledlayout(2,1,'TileSpacing','compact','Padding','compact');

nexttile
hold on
scatter(hVals,phiData(s3:e3,7),'xk'); %Argon, D = 5, S=120, Delta = [60,120,240,480] 
scatter(hVals,phiData(s2:e2,7),'ok'); %Argon, D = 2, S=120, Delta = [60,120,240,480] 
scatter(hVals,phiData(s1:e1,7),'.k'); %Argon, D = 1, S=120, Delta = [60,120,240,480] 
scatter(hVals,phiData(s3:e3,11),'+r'); %Impurity, D = 5, S=120, Delta = [60,120,240,480] 
scatter(hVals,phiData(s2:e2,11),'sr'); %Impurity, D = 2, S=120, Delta = [60,120,240,480] 
xlabel("$H$","Interpreter","Latex");
ylabel("$\Phi_{SL[1]}~(deg.)$","Interpreter","Latex");
title("\qquad \qquad \qquad \qquad \qquad \qquad \qquad \qquad \qquad (a)",'Interpreter','Latex');
ylim([0 20]);
xlim([-10 500]);

nexttile
hold on
scatter(hVals,phiData(s3:e3,9),'xk'); %Argon, D = 5, S=120, Delta = [60,120,240,480] 
scatter(hVals,phiData(s2:e2,9),'ok'); %Argon, D = 2, S=120, Delta = [60,120,240,480] 
scatter(hVals,phiData(s1:e1,9),'.k'); %Argon, D = 1, S=120, Delta = [60,120,240,480] 
scatter(hVals,phiData(s3:e3,13),'+r'); %Impurity, D = 5, S=120, Delta = [60,120,240,480] 
scatter(hVals,phiData(s2:e2,13),'sr'); %Impurity, D = 2, S=120, Delta = [60,120,240,480] 
xlabel("$H$","Interpreter","Latex");
ylabel("$\sigma_{\Phi}~(deg.)$","Interpreter","Latex");
title("\qquad \qquad \qquad \qquad \qquad \qquad \qquad \qquad \qquad (b)",'Interpreter','Latex');
ylim([0 20]);
xlim([-10 500]);
% yticklabels({'0','5','10','15',''});
legend(["D=5, Ar.","D=2, Ar.","D=1, Ar.", "D=5, Im.","D=2, Im."],'Interpreter','latex','Location','northoutside','NumColumns',2);

set(aFig,'Units','Centimeters','Position',[0 0 8.6 8.6]);
set(findall(aFig,'-property','FontSize'),'FontSize',9);
exportgraphics(aFig,strcat(aFileName,".png"));
exportgraphics(aFig,strcat(aFileName,".eps"));
savefig(aFig,strcat(aFileName,".fig"));

%% (4.) Plot of two vertical tiles of mean and std dev \Phi(H), each with three two series SL[1] and SL[2] for fixed D=5
aFig = figure();
aFileName = "Phi_vs_H_MultiSL_Std_Adj";
tiledlayout(2,1,'TileSpacing','compact','Padding','compact');

nexttile
hold on
scatter(hVals,phiData(s3:e3,7),'xk'); %Argon, D = 5, S=120, Delta = 120, SL[1]
scatter(hVals,phiData(s3:e3,8),'ok'); %Argon, D = 5, S=120, Delta = 120, SL[2]
scatter(hVals,phiData(s3:e3,11),'+r'); %Impurity, D = 5, S=120, Delta = 120, SL[1]
scatter(hVals,phiData(s3:e3,12),'sr'); %Impurity, D = 5, S=120, Delta = 120, SL[2]
xlabel("$H$","Interpreter","Latex");
ylabel("$\Phi~(deg.)$","Interpreter","Latex");
title("\qquad \qquad \qquad \qquad \qquad \qquad \qquad \qquad \qquad (a)",'Interpreter','Latex');
ylim([-30 30]);
yticks([-30 -15 0 15 30]);
xlim([-10 500]);

nexttile
hold on
scatter(hVals,phiData(s3:e3,9),'xk'); %Argon, D = 5, S=120, Delta = 120, SL[1]
scatter(hVals,phiData(s3:e3,10),'ok'); %Argon, D = 5, S=120, Delta = 120, SL[2]
scatter(hVals,phiData(s3:e3,13),'+r'); %Impurity, D = 5, S=120, Delta = 120, SL[1]
scatter(hVals,phiData(s3:e3,14),'sr'); %Impurity, D = 5, S=120, Delta = 120, SL[2]
xlabel("$H$","Interpreter","Latex");
ylabel("$\sigma_{\Phi}~(deg.)$","Interpreter","Latex");
title("\qquad \qquad \qquad \qquad \qquad \qquad \qquad \qquad \qquad (b)",'Interpreter','Latex');
ylim([0 15]);
xlim([-10 500]);
% yticklabels({'0','5','10','15',''});
legend(["SL[1], Ar.","SL[2], Ar.", "SL[1], Im.","SL[2], Im."],'Interpreter','latex','Location','northoutside','NumColumns',2);

set(aFig,'Units','Centimeters','Position',[0 0 8.6 8.6]);
set(findall(aFig,'-property','FontSize'),'FontSize',9);
exportgraphics(aFig,strcat(aFileName,".png"));
exportgraphics(aFig,strcat(aFileName,".eps"));
savefig(aFig,strcat(aFileName,".fig"));

%% (5.) Plot of three columns for D=1, D=2 and D=5 with two rows of mean and std dev for \Phi(H)
%Not edited, just a copy of 2.
aFig = figure();
aFileName = "Phi_vs_Delta_S_D_Std";
tiledlayout(2,3,'TileSpacing','compact','Padding','compact');

nexttile(1)
hold on
scatter(deltaVals,phiData(s3:e3,7),'xr'); %Argon, D = 5, S=120, Delta = [60,120,240,480] 
scatter(deltaVals,phiData(s3:e3,11),'.k'); %Impurity, D = 5, S=120, Delta = [60,120,240,480] 
xlabel("$\Delta$","Interpreter","Latex");
ylim([0 20]);
xlim([0 500]);
title("(a)",'Interpreter','Latex');
% title("\qquad \qquad \qquad \qquad (a)",'Interpreter','Latex');
ylabel("$\Phi_{SL[1]}~(deg.)$","Interpreter","Latex");

nexttile(4)
hold on
scatter(deltaVals,phiData(s3:e3,9),'xr'); %Argon, D = 5, S=120, Delta = [60,120,240,480] 
scatter(deltaVals,phiData(s3:e3,13),'.k'); %Impurity, D = 5, S=120, Delta = [60,120,240,480] 
xlabel("$\Delta$","Interpreter","Latex");
ylabel("$\sigma_{\Phi}~(deg.)$","Interpreter","Latex");
ylim([0 10]);
xlim([0 500]);
% title("\qquad \qquad \qquad \qquad (b)",'Interpreter','Latex');
title("(b)",'Interpreter','Latex');

nexttile(2)
hold on
scatter(dVals,phiData(55:57,7),'xr'); %Argon, D = 5, S=120, Delta = [60,120,240,480] 
scatter(dVals,[phiData(55,7); phiData(56:57,11)],'.k'); %Impurity, D = 5, S=120, Delta = [60,120,240,480] 
xlabel("$D$","Interpreter","Latex");
ylim([0 20]);
xlim([0 6]);
% title("\qquad \qquad \qquad \qquad (c)",'Interpreter','Latex');
title("(c)",'Interpreter','Latex');
ylabel("$\Phi_{SL[1]}~(deg.)$","Interpreter","Latex");

nexttile(5)
hold on
scatter(dVals,phiData(55:57,9),'xr'); %Argon, D = 5, S=120, Delta = [60,120,240,480] 
scatter(dVals,[phiData(55,9); phiData(56:57,13)],'.k'); %Impurity, D = 5, S=120, Delta = [60,120,240,480] 
xlabel("$D$","Interpreter","Latex");
ylabel("$\sigma_{\Phi}~(deg.)$","Interpreter","Latex");
ylim([0 20]);
xlim([0 6]);
% title("\qquad \qquad \qquad \qquad (d)",'Interpreter','Latex');
title("(d)",'Interpreter','Latex');

nexttile(3)
hold on
scatter(sVals,phiData(36:39,7),'xr'); %Argon, D = 5, S=120, Delta = [60,120,240,480] 
scatter(sVals,phiData(36:39,11),'.k'); %Impurity, D = 5, S=120, Delta = [60,120,240,480] 
xlabel("$S$","Interpreter","Latex");
ylim([-5 25]);
xlim([0 500]);
legend(["Argon", "Impurity"],'Interpreter','latex','Location','northeast');
% title("\qquad \qquad \qquad \qquad (e)",'Interpreter','Latex');
title("(e)",'Interpreter','Latex');
ylabel("$\Phi_{SL[1]}~(deg.)$","Interpreter","Latex");

nexttile(6)
hold on
scatter(sVals,phiData(36:39,9),'xr'); %Argon, D = 5, S=120, Delta = [60,120,240,480] 
scatter(sVals,phiData(36:39,13),'.k'); %Impurity, D = 5, S=120, Delta = [60,120,240,480] 
xlabel("$S$","Interpreter","Latex");
ylabel("$\sigma_{\Phi}~(deg.)$","Interpreter","Latex");
ylim([0 10]);
xlim([0 500]);
title("(f)",'Interpreter','Latex');
% title("\qquad \qquad \qquad \qquad (f)",'Interpreter','Latex');

% lg = legend(["SL[1], Ar.", "SL[1], Im."],'Interpreter','latex','Location','best');
% lg.Layout.Tile = 'east';

set(aFig,'Units','Centimeters','Position',[0 0 17.2 8.6]);
set(findall(aFig,'-property','FontSize'),'FontSize',9);
exportgraphics(aFig,strcat(aFileName,".png"));
exportgraphics(aFig,strcat(aFileName,".eps"));
savefig(aFig,strcat(aFileName,".fig"));

%% (X.) Copy figure to tile
dAx = gca;
deltaAx = gca;
diffAx = gca;

tiledFig = figure();
set(tiledFig,'Units','Centimeter','Position',[0 0 17 8.6]);

tiledlayout(1,3, 'Padding', 'compact', 'TileSpacing', 'tight'); 
ax1 = nexttile(1);
axis(ax1,'square');
ax2 = nexttile(2);
axis(ax2,'square');
ax3 = nexttile(3);
axis(ax3,'square');

axcp1 = copyobj(dAx,tiledFig);
set(axcp1,'Position',get(ax1,'position'));

axcp2 = copyobj(deltaAx,tiledFig);
set(axcp2,'Position',get(ax2,'position'));

axcp3 = copyobj(diffAx,tiledFig);
set(axcp3,'Position',get(ax3,'position'));

delete(ax1);
delete(ax2);
delete(ax3);

fileName = 'P_Vx_vs_t_FL1O';
set(tiledFig,'Units','Centimeter','Position',[0 0 17.2 8.6]);
set(findall(tiledFig,'-property','FontSize'),'FontSize',9);
exportgraphics(tiledFig,strcat(fileName,".png"));
exportgraphics(tiledFig,strcat(fileName,".eps"));
savefig(tiledFig,strcat(fileName,".fig"));

%% (A.) Getting data values from existing figure
fig = gcf;
axObjs = fig.Children;
dataObjs = axObjs.Children;
x = dataObjs(1).XData;
y = dataObjs(1).YData;
z = dataObjs(1).ZData;


%% (A.) Snippets of useful stuffs

% Now, link the first axis to the second and make the second invisible
linkaxes([ax1 ax2],'xy');
set(ax2,'Color','none','XTick',[],'YTick',[],'Box','off');

%% A basic diagram plot
FL = 1;
zCut = 0;
width = 120;
depth = 60;
spacing = 120;
separation = 120;
shift = 480;

xLeft = 480;
% yLeft = mid-width/2;
yLeft = 100;

xRight = xLeft+depth+separation;
% yRight = yLeft-spacing-width/2;
yRight = yLeft+360;

xLow = min(x,[],'all');
xUp = max(x,[],'all')-20;
yLow = min(y,[],'all')+20;
yUp = max(y,[],'all');

phiFig = figure('Visible','on');
% nexttile
% ax1 = subplot(1,3,1);
% ax1 = axes('Position',pos1,'Units','centimeters');
% subplot(1,3,1);
% surf(x,y,countI(:,:,t1)-countIMax);
axis([xLow xUp yLow yUp 0 0]);
% surf(x,y,logKinetic(:,:,t1)-logKineticMax);
% axis([xLow xUp yLow yUp -logKineticMax 0]);
xlabel("$x$",'Interpreter','Latex');
ylabel("$y$",'Interpreter','Latex');
% view(0,90);
% hold on
% quiver(x+10, y+10, uNormCM(:,:,t1)*50, vNormCM(:,:,t1)*50, 'AutoScale', 'off', 'Color' ,'w');%, 'LineWidth',2);%,'MaxHeadSize',5);
% colormap(parula(countIMax+1));
% hcolorBar = colorbar('Ticks',(-countIMax:1),'TickLabels',(0:1:countIMax+1));
% ylabel(hcolorBar, "$N_I$", 'Interpreter', 'latex');
% caxis([-countIMax 0]);
if FL == 1
    patch( [xLeft xLeft xLeft+depth xLeft+depth], [0 yLeft yLeft 0], [zCut zCut zCut zCut], [17/255 17/255 17/255]);
    patch( [xLeft xLeft xLeft+depth xLeft+depth], [yLeft+width 2000 2000 yLeft+width], 'FaceColor', [17/255 17/255 17/255]);
    patch( [xRight xRight xRight+depth xRight+depth], [0 yRight yRight 0], [zCut zCut zCut zCut], 'FaceColor', [17/255 17/255 17/255]);
    patch( [xRight xRight xRight+depth xRight+depth], [yRight+width yRight+2*width yRight+2*width yRight+width], [zCut zCut zCut zCut], 'FaceColor', [17/255 17/255 17/255]);
    patch( [xRight xRight xRight+depth xRight+depth], [yRight+3*width 2000 2000 yRight+3*width], [zCut zCut zCut zCut], 'FaceColor', [17/255 17/255 17/255]);
elseif FL == 2
    patch( [xLeft xLeft xLeft+depth xLeft+depth], [0 yLeft yLeft 0], [zCut zCut zCut zCut], 'w');
    patch( [xLeft xLeft xLeft+depth xLeft+depth], [yLeft+width yLeft+2*width yLeft+2*width yLeft+width], [zCut zCut zCut zCut], 'w');
    patch( [xLeft xLeft xLeft+depth xLeft+depth], [yLeft+3*width 2000 2000 yLeft+3*width], [zCut zCut zCut zCut], 'w');
    patch( [xRight xRight xRight+depth xRight+depth], [0 yRight yRight 0], [zCut zCut zCut zCut], 'w');
    patch( [xRight xRight xRight+depth xRight+depth], [yRight+width yRight+2*width yRight+2*width yRight+width], [zCut zCut zCut zCut], 'w');
    patch( [xRight xRight xRight+depth xRight+depth], [yRight+3*width 2000 2000 yRight+3*width], [zCut zCut zCut zCut], 'w');
end
%     set(ax1,'ytick',[0 100 220 340 460 540]);
%     set(ax1,'yticklabel',[0 80 200 320 440 520]);
%     set(ax1,'xtick',[0 120 180 300 360 520]);
%     set(ax1,'xticklabel',[0 120 180 300 360 520]);
%     xtickangle(45);
% set(ax1,'xtick',[0 60 120 180 240 300 360 420 480 520]);
% set(ax1,'xticklabel',[0 60 120 180 240 300 360 420 480 520]);
set(ax1,'TickDir','out');
axis(ax1,'square')
% set(ax1,'Units','Centimeters','Position',[1 1 8 8]);
set(findall(ax1,'-property','FontSize'),'FontSize',9);
    