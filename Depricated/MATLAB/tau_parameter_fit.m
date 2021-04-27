function [tauFitLine, expRSquare, expAdjRSquare, expRMSE] = tau_parameter_fit(tauAvgs, tauStds, parNames, parVars, parValsList)
%Takes the exponential decay constant data of pressure envelope as a
%function of parameter and plots a functional fit
%   Current Input data format:
%   fit_data{trial,:} = {simString, tau_fit, tau_stddev, exp_rsquare, exp_adjrsquare, exp_rmse, beta_fit, beta_stddev, pow_rsquare, pow_adjrsquare, pow_rmse, fundFreq};

sigma = 3.4*10^(-10); %Nm

startDir = pwd;

%%Old Input format
% data_labels = varargin{1}.data_labels;
% decay_fit_data = varargin{1}.decay_fit_data;
% baseDir = varargin{2};
% cd(baseDir);
% dList = decay_fit_data(:,1);
% tau_est = decay_fit_data(:,2);
% tau_stddev = decay_fit_data(:,3);
% beta = decay_fit_data(:,7);
% beta_stddev = decay_fit_data(:,8);
% primary_freq = decay_fit_data(:,12);

fit_data = varargin{1,1}.fit_data;
nTrials = max(size(fit_data));

for i = 1 : 1 : nTrials
    simString = fit_data{i,1}{1,1};
    parStrings = strsplit(simString,{'_'});

    wString = strsplit(parStrings{1,1},{'W'});
    wList(i) = str2double(wString{1,1}); %Argon Diameters

    dString = strsplit(parStrings{1,2},{'D'});
    dList(i) = str2double(dString{1,1})*sigma*(1/(10^(-9))); %nanometers
    
    tau_est(i) = fit_data{i,1}{1,2};
    tau_stddev(i) = fit_data{i,1}{1,3};
    beta(i) = fit_data{i,1}{1,7};
    beta_stddev(i) = fit_data{i,1}{1,8};
    primary_freq(i) = fit_data{i,1}{1,12};
end


data = [dList; tau_est; tau_stddev; beta; beta_stddev; primary_freq];

sorted_data = sortrows(data');
dList = sorted_data(:,1);
tau_est = sorted_data(:,2);
tau_stddev = sorted_data(:,3);
beta_est = sorted_data(:,4);
beta_stddev = sorted_data(:,5);
tau_95_conf = tau_stddev*1.96;
beta_95_conf = beta_stddev*1.96;

primary_freq = sorted_data(:,6);

[lin_tau_fit_curve, lin_tau_fit_goodness, lin_tau_fit_output] = fit(dList,tau_est,'poly1','Weights',tau_stddev.^(-2));
lin_tau_rsquare = lin_tau_fit_goodness.rsquare;
lin_tau_adjrsquare = lin_tau_fit_goodness.adjrsquare;
lin_tau_rmse = lin_tau_fit_goodness.rmse;
lin_tau_c = coeffvalues(lin_tau_fit_curve);
lin_tau_c_conf = confint(lin_tau_fit_curve);
lin_tau_line = feval(lin_tau_fit_curve, dList);

[exp_tau_fit_curve, exp_tau_fit_goodness, exp_tau_fit_output] = fit(dList,tau_est,'exp1','Weights',tau_stddev.^(-2));
exp_tau_rsquare = exp_tau_fit_goodness.rsquare;
exp_tau_adjrsquare = exp_tau_fit_goodness.adjrsquare;
exp_tau_rmse = exp_tau_fit_goodness.rmse;
exp_tau_c = coeffvalues(exp_tau_fit_curve);
exp_tau_c_conf = confint(exp_tau_fit_curve);
exp_tau_line = feval(exp_tau_fit_curve, dList);

[lin_beta_fit_curve, lin_beta_fit_goodness, lin_beta_fit_output] = fit(dList,beta_est,'poly1','Weights',beta_stddev.^(-2));
lin_beta_rsquare = lin_beta_fit_goodness.rsquare;
lin_beta_adjrsquare = lin_beta_fit_goodness.adjrsquare;
lin_beta_rmse = lin_beta_fit_goodness.rmse;
lin_beta_c = coeffvalues(lin_beta_fit_curve);
lin_beta_c_conf = confint(lin_beta_fit_curve);
lin_beta_line = feval(lin_beta_fit_curve, dList);

[exp_beta_fit_curve, exp_beta_fit_goodness, exp_beta_fit_output] = fit(dList,beta_est,'exp1','Weights',beta_stddev.^(-2));
exp_beta_rsquare = exp_beta_fit_goodness.rsquare;
exp_beta_adjrsquare = exp_beta_fit_goodness.adjrsquare;
exp_beta_rmse = exp_beta_fit_goodness.rmse;
exp_beta_c = coeffvalues(exp_beta_fit_curve);
exp_beta_c_conf = confint(exp_beta_fit_curve);
exp_beta_line = feval(exp_beta_fit_curve, dList);

for i = 1 : 1 : 2
    lin_tau_c_stddev(i) = (abs(lin_tau_c(i)-lin_tau_c_conf(1,i))/1.96 + abs(lin_tau_c(i)-lin_tau_c_conf(2,i))/1.96)/2;
    exp_tau_c_stddev(i) = (abs(exp_tau_c(i)-exp_tau_c_conf(1,i))/1.96 + abs(exp_tau_c(i)-exp_tau_c_conf(2,i))/1.96)/2;
    lin_beta_c_stddev(i) = (abs(lin_beta_c(i)-lin_beta_c_conf(1,i))/1.96 + abs(lin_beta_c(i)-lin_beta_c_conf(2,i))/1.96)/2;
    exp_beta_c_stddev(i) = (abs(exp_beta_c(i)-exp_beta_c_conf(1,i))/1.96 + abs(exp_beta_c(i)-exp_beta_c_conf(2,i))/1.96)/2;

end
shift = -0.25;

fig = figure('Visible','off');
ax0 = axes('Position',[0 0 1 1],'Visible','off');
% text(0.725,0.95+shift, 'Linear Fit:','Interpreter','latex', 'FontSize', 9);
% text(0.725,0.9+shift, '$\tau(D) = a \cdot D + b$','Interpreter','latex');
% text(0.725,0.85+shift, ['$a =$ ' num2str(lin_tau_c(1),5) '$\frac{ns}{nm}$'], 'Interpreter', 'latex', 'units', 'normalized');
% text(0.725,0.8+shift, ['$\sigma_a =$ ' num2str(lin_tau_c_stddev(1),5) '$\frac{ns}{nm}$'], 'Interpreter', 'latex', 'units', 'normalized');
% text(0.725,0.75+shift, ['$b =$ ' num2str(lin_tau_c(2),5) '$ns$'], 'Interpreter', 'latex', 'units', 'normalized');
% text(0.725,0.7+shift, ['$\sigma_b =$ ' num2str(lin_tau_c_stddev(2),5) '$ns$'], 'Interpreter', 'latex', 'units', 'normalized');
% text(0.725,0.65+shift, ['$R^2$ Value = ' num2str(lin_tau_rsquare,5)], 'Interpreter', 'latex', 'units', 'normalized');
% text(0.725,0.6+shift, ['Adj. $R^2$ Value = ' num2str(lin_tau_adjrsquare,5)], 'Interpreter', 'latex', 'units', 'normalized');
% text(0.725,0.55+shift, ['RMS Error = ' num2str(lin_tau_rmse)], 'Interpreter', 'latex', 'units', 'normalized');

text(0.725,0.95+shift, 'Linear Fit:','Interpreter','latex', 'FontSize', 9);
text(0.725,0.9+shift, '$\tau(D) = a \cdot D + b$','Interpreter','latex');
text(0.725,0.85+shift, ['$a =$ ' num2str(lin_tau_c(1),5) '$\frac{s}{m}$'], 'Interpreter', 'latex', 'units', 'normalized');
text(0.725,0.8+shift, ['$\sigma_a =$ ' num2str(lin_tau_c_stddev(1),5) '$\frac{ns}{nm}$'], 'Interpreter', 'latex', 'units', 'normalized');
text(0.725,0.75+shift, ['$b =$ ' num2str(lin_tau_c(2),5) '$ns$'], 'Interpreter', 'latex', 'units', 'normalized');
text(0.725,0.7+shift, ['$\sigma_b =$ ' num2str(lin_tau_c_stddev(2),5) '$ns$'], 'Interpreter', 'latex', 'units', 'normalized');
text(0.725,0.65+shift, ['$R^2$ Value = ' num2str(lin_tau_rsquare,5)], 'Interpreter', 'latex', 'units', 'normalized');
text(0.725,0.6+shift, ['Adj. $R^2$ Value = ' num2str(lin_tau_adjrsquare,5)], 'Interpreter', 'latex', 'units', 'normalized');
text(0.725,0.55+shift, ['RMS Error = ' num2str(lin_tau_rmse)], 'Interpreter', 'latex', 'units', 'normalized');

% text(0.725,0.45, 'Exponential Fit:','Interpreter','latex', 'FontSize', 9);
% text(0.725,0.4, '$\tau(D) = \alpha \cdot exp(\zeta \cdot D)$','Interpreter','latex');
% text(0.725,0.35, ['$\alpha =$ ' num2str(exp_tau_c(1),5) '$ns$'], 'Interpreter', 'latex', 'units', 'normalized');
% text(0.725,0.3, ['$\sigma_{\alpha} =$ ' num2str(exp_tau_c_stddev(1),5) '$ns$'], 'Interpreter', 'latex', 'units', 'normalized');
% text(0.725,0.25, ['$\zeta =$ ' num2str(exp_tau_c(2),5) '$\frac{1}{nm}$'], 'Interpreter', 'latex', 'units', 'normalized');
% text(0.725,0.2, ['$\sigma_{\zeta} =$ ' num2str(exp_tau_c_stddev(2),5) '$\frac{1}{nm}$'], 'Interpreter', 'latex', 'units', 'normalized');
% text(0.725,0.15, ['$R^2$ Value = ' num2str(exp_tau_rsquare,5)], 'Interpreter', 'latex', 'units', 'normalized');
% text(0.725,0.1, ['Adj. $R^2$ Value = ' num2str(exp_tau_adjrsquare,5)], 'Interpreter', 'latex', 'units', 'normalized');
% text(0.725,0.05, ['RMS Error = ' num2str(exp_tau_rmse)], 'Interpreter', 'latex', 'units', 'normalized');

ax1 = axes('Position',[.1 .1 .6 .8],'Visible','off');
pRaw = errorbar(dList, tau_est, tau_95_conf, 'square');
hold on;
pLin = plot(dList, lin_tau_line);
hold on;
%pExp = plot(dList, exp_tau_line);
%hold on;

title('Experimental Data and Linear Fit of $\tau(D)$','Interpreter','latex');
xlabel('Impurity Diameter, $D ~ (nm)$','Interpreter','latex');
ylabel('Exponential Decay Constant, $\tau (ns)$','Interpreter','latex');
legend('95% Confidence Interval', 'Linear Fit', 'Location', 'NorthWest');
%legend('95% Confidence Interval', 'Linear Fit', 'Exponential Fit', 'Location', 'northwest');
xlim([0 7]);
print('tau_func_D', '-dpng');
close(fig);

fig = figure('Visible','off');
ax0 = axes('Position',[0 0 1 1],'Visible','off');
text(0.725,0.95+shift, 'Linear Fit:','Interpreter','latex', 'FontSize', 9);
text(0.725,0.9+shift, '$\beta(D) = c \cdot D + l$','Interpreter','latex');
text(0.725,0.85+shift, ['$c =$ ' num2str(lin_beta_c(1),5) '$\frac{1}{nm}$'], 'Interpreter', 'latex', 'units', 'normalized');
text(0.725,0.8+shift, ['$\sigma_c =$ ' num2str(lin_beta_c_stddev(1),5) '$\frac{1}{nm}$'], 'Interpreter', 'latex', 'units', 'normalized');
text(0.725,0.75+shift, ['$l =$ ' num2str(lin_beta_c(2),5)], 'Interpreter', 'latex', 'units', 'normalized');
text(0.725,0.7+shift, ['$\sigma_l =$ ' num2str(lin_beta_c_stddev(2),5)], 'Interpreter', 'latex', 'units', 'normalized');
text(0.725,0.65+shift, ['$R^2$ Value = ' num2str(lin_beta_rsquare,5)], 'Interpreter', 'latex', 'units', 'normalized');
text(0.725,0.6+shift, ['Adj. $R^2$ Value = ' num2str(lin_beta_adjrsquare,5)], 'Interpreter', 'latex', 'units', 'normalized');
text(0.725,0.55+shift, ['RMS Error = ' num2str(lin_beta_rmse)], 'Interpreter', 'latex', 'units', 'normalized');

% text(0.725,0.95, 'Linear Fit:','Interpreter','latex', 'FontSize', 9);
% text(0.725,0.9, '$\beta(D) = c \cdot D + l$','Interpreter','latex');
% text(0.725,0.85, ['$c =$ ' num2str(lin_beta_c(1),5) '$\frac{1}{nm}$'], 'Interpreter', 'latex', 'units', 'normalized');
% text(0.725,0.8, ['$\sigma_c =$ ' num2str(lin_beta_c_stddev(1),5) '$\frac{1}{nm}$'], 'Interpreter', 'latex', 'units', 'normalized');
% text(0.725,0.75, ['$l =$ ' num2str(lin_beta_c(2),5)], 'Interpreter', 'latex', 'units', 'normalized');
% text(0.725,0.7, ['$\sigma_l =$ ' num2str(lin_beta_c_stddev(2),5)], 'Interpreter', 'latex', 'units', 'normalized');
% text(0.725,0.65, ['$R^2$ Value = ' num2str(lin_beta_rsquare,5)], 'Interpreter', 'latex', 'units', 'normalized');
% text(0.725,0.6, ['Adj. $R^2$ Value = ' num2str(lin_beta_adjrsquare,5)], 'Interpreter', 'latex', 'units', 'normalized');
% text(0.725,0.55, ['RMS Error = ' num2str(lin_beta_rmse)], 'Interpreter', 'latex', 'units', 'normalized');

% text(0.725,0.45, 'Exponential Fit:','Interpreter','latex', 'FontSize', 9);
% text(0.725,0.4, '$\beta(D) = \kappa \cdot exp(\gamma \cdot D)$','Interpreter','latex');
% text(0.725,0.35, ['$\kappa =$ ' num2str(exp_beta_c(1),5)], 'Interpreter', 'latex', 'units', 'normalized');
% text(0.725,0.3, ['$\sigma_{\kappa} =$ ' num2str(exp_beta_c_stddev(1),5)], 'Interpreter', 'latex', 'units', 'normalized');
% text(0.725,0.25, ['$\gamma =$ ' num2str(exp_beta_c(2),5) '$\frac{1}{nm}$'], 'Interpreter', 'latex', 'units', 'normalized');
% text(0.725,0.2, ['$\sigma_{\gamma} =$ ' num2str(exp_beta_c_stddev(2),5) '$\frac{1}{nm}$'], 'Interpreter', 'latex', 'units', 'normalized');
% text(0.725,0.15, ['$R^2$ Value = ' num2str(exp_beta_rsquare,5)], 'Interpreter', 'latex', 'units', 'normalized');
% text(0.725,0.1, ['Adj. $R^2$ Value = ' num2str(exp_beta_adjrsquare,5)], 'Interpreter', 'latex', 'units', 'normalized');
% text(0.725,0.05, ['RMS Error = ' num2str(exp_beta_rmse)], 'Interpreter', 'latex', 'units', 'normalized');
ax1 = axes('Position',[.1 .1 .6 .8],'Visible','off');
pRaw = errorbar(dList, beta_est, beta_95_conf, 'o');
hold on;
pLin = plot(dList, lin_beta_line);
hold on;
% pExp = plot(dList, exp_beta_line);
% hold on;

title('Experimental Data and Fitted Functions for $\beta(D)$','Interpreter','latex');
xlabel('Impurity Diameter, $D ~ (nm)$','Interpreter','latex');
ylabel('$\beta$','Interpreter','latex');
legend('95% Confidence Interval', 'Linear Fit', 'Location', 'northwest');
%legend('95% Confidence Interval', 'Linear Fit', 'Exponential Fit', 'Location', 'northwest');
print('beta_func_D', '-dpng');
close(fig);

%[gauss_fit_curve, gauss_fit_goodness, gauss_fit_output] = fit(dList,tau_est,'gauss1','Weights',tau_stddev.^(-2));
% gauss_rsquare = gauss_fit_goodness.rsquare;
% gauss_adjrsquare = gauss_fit_goodness.adjrsquare;
% gauss_rmse = gauss_fit_goodness.rmse;
% gauss_c = coeffvalues(gauss_fit_curve);
% gauss_c_conf = confint(gauss_fit_curve);
% for i = 1 : 1 : 3
%     gauss_c_stddev(i) = (abs(gauss_c(i)-gauss_c_conf(1,i))/1.96 + abs(gauss_c(i)-gauss_c_conf(2,i))/1.96)/2;
% end
% gauss_line = feval(gauss_fit_curve, dList);
% fig = figure('Visible','off');
% ax0 = axes('Position',[0 0 1 1],'Visible','off');
% text(0.725,0.8, 'Gaussian Function:','Interpreter','latex');
% text(0.725,0.75, '$\tau(D) = a \cdot exp(-[\frac{D-b}{c}]^2)$','Interpreter','latex');
% text(0.725,0.7, ['$a =$ ' num2str(gauss_c(1),5)], 'Interpreter', 'latex', 'units', 'normalized');
% text(0.725,0.65, ['$\sigma_a =$ ' num2str(gauss_c_stddev(1),5)], 'Interpreter', 'latex', 'units', 'normalized');
% text(0.725,0.6, ['$b =$ ' num2str(gauss_c(2),5)], 'Interpreter', 'latex', 'units', 'normalized');
% text(0.725,0.55, ['$\sigma_b =$ ' num2str(gauss_c_stddev(1),5)], 'Interpreter', 'latex', 'units', 'normalized');
% text(0.725,0.5, ['$c =$ ' num2str(gauss_c(3),5)], 'Interpreter', 'latex', 'units', 'normalized');
% text(0.725,0.45, ['$\sigma_c =$ ' num2str(gauss_c_stddev(1),5)], 'Interpreter', 'latex', 'units', 'normalized');
% text(0.725,0.4, ['$R^2$ Value = ' num2str(gauss_rsquare,5)], 'Interpreter', 'latex', 'units', 'normalized');
% text(0.725,0.35, ['Adj. $R^2$ Value = ' num2str(gauss_adjrsquare,5)], 'Interpreter', 'latex', 'units', 'normalized');
% text(0.725,0.3, ['RMS Error = ' num2str(gauss_rmse,5)], 'Interpreter', 'latex', 'units', 'normalized');
% ax1 = axes('Position',[.1 .1 .6 .8],'Visible','off');
% pRaw = errorbar(dList, tau_est, tau_95_conf, 'square');
% hold on;
% pGauss = plot(dList, gauss_line);
% hold on;
% title('Gaussian Fit of Decay Constant Vs Impurity Diameter','Interpreter','latex');
% xlabel('Impurity Diameter, $D ~ (nm)$','Interpreter','latex');
% ylabel('$\tau, (\frac{1}{ns})$','Interpreter','latex');
% legend('95% Confidence Interval', 'Gaussian Fit');
% print('tau_gauss_func_D', '-dpng');
% close(fig);

fig = figure('Visible','off');
plot(dList, primary_freq, '.');
title('Primary Oscillation Frequency vs Impurity Diameter', 'Interpreter', 'LaTex');
xlabel('Impurity Diameter, $D ~ (nm)$','Interpreter','latex');
ylabel('Primary Frequency, $f_0 ~ (GHz)$','Interpreter','latex');
%axis([0 5*fundFreq 0 1]);
print('Frequency_vs_D', '-dpng');
close(fig);

cd(startDir);

varargout{1}.lin = {lin_tau_fit_curve, lin_tau_fit_goodness, lin_tau_fit_output};
varargout{1}.exp = {exp_tau_fit_curve, exp_tau_fit_goodness, exp_tau_fit_output};
%varargout{1}.gauss = {gauss_fit_curve, gauss_fit_goodness, gauss_fit_output};

end
end

