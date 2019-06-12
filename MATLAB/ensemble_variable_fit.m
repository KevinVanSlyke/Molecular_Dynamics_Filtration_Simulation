function [ tauAvg, tauStd, expFitLine, tPeaks, varPeaks, varPeakStds, expRSquare, expAdjRSquare, expRMSE ] = ensemble_variable_fit( time, varAvg, varStd, fundSampleFreq )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%LJ dimensionless unit conversion for Argon gas
% sigma = 3.4*10^(-10); %meters
% mass = 6.69*10^(-26); %kilograms
% epsilon = 1.65*10^(-21); %joules
% tau = 2.17*10^(-12); %seconds
% timestep = tau/200; %seconds
% kb = 1.38*10^(-23); %Joules/Kelvin

%    P(:,1) = P_avg(:,j,i); %LJ Dimensionless
%    P_plot = P*epsilon/sigma^(3)*10^(-6); %kJoules/meter^3
%    P_plot_dev(:,1) = P_std(:,j,i)*epsilon/sigma^(3)*10^(-6); %kJoules/meter^3
%    P_dev(:,1) = P_std(:,j,i); %LJ Dimensionless

%varWeights = varStd.^(-2); %LJ Dimensionless

[equibVal, varAvgDiff, thermalValStd] = equilibrium_difference(time, varAvg);

minPeakDistance = round(1/8*(1/fundSampleFreq),0);

tPeaks = [];
varPeakStds = [];
varPeakWeights = [];
%[varPeakDiff, peakInd] = findpeaks(varAvgDiff);
[varPeakDiff, peakInd] = findpeaks(varAvgDiff,'MinPeakDistance',minPeakDistance);
nPeaks = max(size(varPeakDiff));
for k = 1 : 1 : nPeaks
    tPeaks(k,1) = time(peakInd(k)); 
    varPeaks(k,1) = varAvg(peakInd(k));
    varPeakStds(k,1) = varStd(peakInd(k));
    varPeakWeights(k,1) = varStd(peakInd(k))^(-2);
end

%[expFitCurve, expFitGoodness, expFitOutput] = fit(tPeaks,varPeakDiff,'exp1','Weights',varPeakWeights);
[expFitCurve, expFitGoodness, ~] = fit(tPeaks,varPeakDiff,'exp1');

expFitCoef = coeffvalues(expFitCurve);
expCoefConfInt = confint(expFitCurve);

%Upper and lower confidence are 95% bounds
ampAvg = expFitCoef(1);
ampUpConf = expCoefConfInt(1,1);
ampLowConf = expCoefConfInt(2,1);
ampStd = (abs(ampAvg-ampUpConf)/1.96 + abs(ampAvg-ampLowConf)/1.96)/2;

tauAvg = -1/expFitCoef(2); 
tauUpConf = -1/expCoefConfInt(1,2); 
tauLowConf = -1/expCoefConfInt(2,2); 
tauStd = (abs(tauAvg-tauUpConf)/1.96 + abs(tauAvg-tauLowConf)/1.96)/2; 

expRSquare = expFitGoodness.rsquare;
expAdjRSquare = expFitGoodness.adjrsquare;
expRMSE = expFitGoodness.rmse;

expFitLine = feval(expFitCurve, time) + equibVal; %LJ Dimensionless

% [pow_fit_curve, pow_fit_goodness, pow_fit_output] = amplitudeAvg(tPeaks,varPeakDiff,'power1','Weights', varPeakWeights);
% 
% pow_fit_coef = coeffvalues(pow_fit_curve);
% pow_coef_conf_int = confint(pow_fit_curve);
% 
% A_fit = pow_fit_coef(1); % \frac{kJ}{m^{3}}
% A_up_95_conf = pow_coef_conf_int(1,1); % \frac{kJ}{m^{3}}
% A_low_95_conf = pow_coef_conf_int(2,1); % \frac{kJ}{m^{3}}
% A_stddev = (abs(A_fit-A_up_95_conf)/1.96 + abs(A_fit-A_low_95_conf)/1.96)/2; % \frac{kJ}{m^{3}}
% 
% beta_fit = pow_fit_coef(2);
% beta_up_95_conf = pow_coef_conf_int(1,2);
% beta_low_95_conf = pow_coef_conf_int(2,2);
% beta_stddev = (abs(beta_fit-beta_up_95_conf)/1.96 + abs(beta_fit-beta_low_95_conf)/1.96)/2;
% 
% pow_rsquare = pow_fit_goodness.rsquare;
% pow_adjrsquare = pow_fit_goodness.adjrsquare;
% pow_rmse = pow_fit_goodness.rmse;
% 
% pow_fit_line = feval(pow_fit_curve, t(2:size(t,1))); %kJoules/meter^3
%t_cutoff = 10*tau_fit;

%cd('/home/Kevin/Documents/Dust_Data/Molecular/.../Figures');

%P_plot_peaks_dev = varPeakStds*epsilon/sigma^(3)*10^(-6); %kJoules/meter^3
%equibVal = equibVal*epsilon/sigma^(3)*10^(-6); %kJoules/meter^3

% fig = figure('Position',[100,100,1280,720],'Visible','off');
% ax0 = axes('Position',[0 0 1 1],'Visible','off');
% text(0.75,0.9, 'Assumed Pressure Function', 'Interpreter', 'Latex', 'units', 'normalized', 'FontSize', 9);
% text(0.75,0.85, '$P(t)=P_{\alpha,b}(t) \cdot cos(2 \pi f_0 t) + P_{eq}$', 'Interpreter', 'Latex', 'units', 'normalized');
% text(0.75,0.8, ['$f_0 =$ ' num2str(fundFreq,5) ' GHz'], 'Interpreter', 'Latex', 'units', 'normalized');
% text(0.75,0.75, ['$P_{eq} =$ ' num2str(equibVal,5) ' $\frac{kJ}{m^{3}}$'], 'Interpreter', 'Latex', 'units', 'normalized');
% text(0.75,0.7, ['$\sigma_{eq} =$ ' num2str(thermalValStd,5) ' $\frac{kJ}{m^{3}}$'], 'Interpreter', 'Latex', 'units', 'normalized');
% 
% text(0.625,0.6, 'Exponential Amplitude Decay', 'Interpreter', 'Latex', 'units', 'normalized', 'FontSize', 9);
% text(0.625,0.55, '$P_{\alpha}(t) = P_{0} \cdot exp(-t/\tau)$', 'Interpreter', 'Latex', 'units', 'normalized');
% text(0.625,0.5, ['$P_{0} =$ ' num2str(ampFit,5) ' $\frac{kJ}{m^{3}}$'], 'Interpreter', 'Latex', 'units', 'normalized');
% text(0.625,0.45, ['$\sigma_{0} =$ ' num2str(ampStd,5) ' $\frac{kJ}{m^{3}}$'], 'Interpreter', 'Latex', 'units', 'normalized');
% text(0.625,0.4, ['$\tau =$ ' num2str(tauAvg,5) ' $ns$'], 'Interpreter', 'Latex', 'units', 'normalized');
% text(0.625,0.35, ['$\sigma_{\tau} =$ ' num2str(tauStd,5) ' $ns$'], 'Interpreter', 'Latex', 'units', 'normalized');
% 
% text(0.625,0.25, 'Goodness of Fit for $P_{\alpha}(t)$', 'Interpreter', 'Latex', 'units', 'normalized');
% text(0.625,0.2, ['$R^2$ Value = ' num2str(expRSquare,5)], 'Interpreter', 'Latex', 'units', 'normalized');
% text(0.625,0.15, ['Adj. $R^2$ Value = ' num2str(expAdjRSquare,5)], 'Interpreter', 'Latex', 'units', 'normalized');
% text(0.625,0.1, ['RMS Error = ' num2str(expRMSE,5)], 'Interpreter', 'Latex', 'units', 'normalized');
% 
% text(0.825,0.6, 'Algebraic Amplitude Decay', 'Interpreter', 'Latex', 'units', 'normalized', 'FontSize', 9);
% text(0.825,0.55, '$P_{b}(t) = A \cdot t^{~\beta}$', 'Interpreter', 'Latex', 'units', 'normalized');
% text(0.825,0.5, ['$A =$ ' num2str(A_fit,5) ' $\frac{mJ}{m^{2}}$'], 'Interpreter', 'Latex', 'units', 'normalized');
% text(0.825,0.45, ['$\sigma_{A} =$ ' num2str(A_stddev,5) ' $\frac{kJ}{m^{3}}$'], 'Interpreter', 'Latex', 'units', 'normalized');
% text(0.825,0.4, ['$\beta =$ ' num2str(beta_fit,5)], 'Interpreter', 'Latex', 'units', 'normalized');
% text(0.825,0.35, ['$\sigma_{\beta} =$ ' num2str(beta_stddev,5)], 'Interpreter', 'Latex', 'units', 'normalized');
% 
% text(0.825,0.25, 'Goodness of Fit for $P_{b}(t)$', 'Interpreter', 'Latex', 'units', 'normalized');
% text(0.825,0.2, ['$R^2$ Value = ' num2str(pow_rsquare,5)], 'Interpreter', 'Latex', 'units', 'normalized');
% text(0.825,0.15, ['Adj. $R^2$ Value = ' num2str(pow_adjrsquare,5)], 'Interpreter', 'Latex', 'units', 'normalized');
% text(0.825,0.1, ['RMS Error = ' num2str(pow_rmse,5)], 'Interpreter', 'Latex', 'units', 'normalized');
% 
% ax1 = axes('Position',[.1 .1 .5 .8],'Visible','off');
% %errorbar(t,P_plot, P_plot_dev, '.');
% plot(t, P_plot, '.');
% hold on;
% errorbar(tPeaks, (varPeakDiff+equibVal), P_plot_peaks_dev, 'o');
% hold on;
% plot(t, (expFitLine+equibVal), t(2:size(t,1)), (pow_fit_line+equibVal));    %plot(t, P, '.', t_peaks, (P_diff_peaks+P_thermal), 'ro', t, (exp_fit_line+P_thermal), t(2:size(t,1)), (pow_fit_line+P_thermal));
% %       title(strcat('Statistical Pressure at~', region, ' of Filter with Pore Width W=', num2str(W), 'd, Impurity Diameter D=', num2str(D), 'd and Registry Shift H=', num2str(H),'d'), 'Interpreter', 'LaTex', 'FontSize', 8 );
% title(strcat('Statistical Pressure at~', region, ' of Filter with Pore Width W=', num2str(W), 'd, Impurity Diameter D=', num2str(D), 'd'), 'Interpreter', 'LaTex', 'FontSize', 8 );
% xlabel('Time, $t ~ (ns)$','Interpreter','Latex');
% ylabel('Pressure, $P ~ (\frac{kJ}{m^{3}})$','Interpreter','Latex');
% legend('Raw Data', 'Peak (Fit) Values', 'Exponential Fit', 'Algebraic Fit');
% %axis([0 t_cutoff 0.9*min(P) 1.1*max(P)]);
% axis([0 max(t) 0.9*min(P_plot) 1.1*max(P_plot)]);
% print(strcat(region,'_Statistical_Pressure_vs_Time_',simString), '-dpng');
% close(fig);
% 
% %%%%%%%%%%%%%%%%%%%%%%%%
% 
% fig1 = figure('Position',[100,100,1280,720],'Visible','off');
% ax0 = axes('Position',[0 0 1 1],'Visible','off');
% 
% text(0.825,0.9, 'General Pressure Function', 'Interpreter', 'Latex', 'units', 'normalized', 'FontSize', 9);
% text(0.825,0.85, '$P(t)=P_{A}(t) \cdot cos(2 \pi f_0 t) + P_{eq}$', 'Interpreter', 'Latex', 'units', 'normalized');
% text(0.825,0.8, ['$f_0 =$ ' num2str(fundFreq,5) ' GHz'], 'Interpreter', 'Latex', 'units', 'normalized');
% text(0.825,0.75, ['$P_{eq} =$ ' num2str(equibVal,5) ' $\frac{kJ}{m^{3}}$'], 'Interpreter', 'Latex', 'units', 'normalized');
% text(0.825,0.7, ['$\sigma_{eq} =$ ' num2str(thermalValStd,5) ' $\frac{kJ}{m^{3}}$'], 'Interpreter', 'Latex', 'units', 'normalized');
% 
% text(0.825,0.6, 'Exponential Amplitude Decay', 'Interpreter', 'Latex', 'units', 'normalized', 'FontSize', 9);
% text(0.825,0.55, '$P_{A}(t) = P_{0} \cdot exp(-t/\tau)$', 'Interpreter', 'Latex', 'units', 'normalized');
% text(0.825,0.5, ['$P_{0} =$ ' num2str(P_0_fit,5) ' $\frac{kJ}{m^{3}}$'], 'Interpreter', 'Latex', 'units', 'normalized');
% text(0.825,0.45, ['$\sigma_{0} =$ ' num2str(ampStd,5) ' $\frac{kJ}{m^{3}}$'], 'Interpreter', 'Latex', 'units', 'normalized');
% text(0.825,0.4, ['$\tau =$ ' num2str(tauAvg,5) ' $ns$'], 'Interpreter', 'Latex', 'units', 'normalized');
% text(0.825,0.35, ['$\sigma_{\tau} =$ ' num2str(tauStd,5) ' $ns$'], 'Interpreter', 'Latex', 'units', 'normalized');
% 
% text(0.825,0.25, 'Goodness of Fit for $P_{A}(t)$', 'Interpreter', 'Latex', 'units', 'normalized');
% text(0.825,0.2, ['$R^2$ Value = ' num2str(expRSquare,5)], 'Interpreter', 'Latex', 'units', 'normalized');
% text(0.825,0.15, ['Adj. $R^2$ Value = ' num2str(expAdjRSquare,5)], 'Interpreter', 'Latex', 'units', 'normalized');
% text(0.825,0.1, ['RMS Error = ' num2str(expRMSE,5)], 'Interpreter', 'Latex', 'units', 'normalized');
% 
% 
% ax1 = axes('Position',[.1 .1 .7 .8],'Visible','off');
% %errorbar(t,P_plot, P_plot_dev, '.');
% plot(t, P_plot, '.');
% hold on;
% errorbar(tPeaks, (varPeakDiff+equibVal), P_plot_peaks_dev, 'o');
% hold on;
% plot(t, (expFitLine+equibVal));    %plot(t, P, '.', t_peaks, (P_diff_peaks+P_thermal), 'ro', t, (exp_fit_line+P_thermal), t(2:size(t,1)), (pow_fit_line+P_thermal));
% %       title(strcat('Statistical Pressure at~', region, ' of Filter with Pore Width W=', num2str(W), 'd, Impurity Diameter D=', num2str(D), 'd and Registry Shift H=', num2str(H),'d'), 'Interpreter', 'LaTex', 'FontSize', 8 );
% title(strcat('Statistical Pressure at~', region, ' of Filter with Pore Width W=', num2str(W), 'd, Impurity Diameter D=', num2str(D), 'd'), 'Interpreter', 'LaTex', 'FontSize', 8 );
% xlabel('Time, $t ~ (ns)$','Interpreter','Latex');
% ylabel('Pressure, $P ~ (\frac{kJ}{m^{3}})$','Interpreter','Latex');
% legend('Raw Data', 'Peak (Fit) Values', 'Exponential Fit');
% %axis([0 t_cutoff 0.9*min(P) 1.1*max(P)]);
% axis([0 max(t) 0.9*min(P_plot) 1.1*max(P_plot)]);
% print(strcat(region,'_Clean_Statistical_Pressure_vs_Time_',simString), '-dpng');
% close(fig1);




%----------Outputs-------------
%OUTPUTS IN SAME VARIABLE STRUCTURE


%------------------------------end


end

