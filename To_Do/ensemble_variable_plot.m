function [ tauAvg, tauStd, fitData, fitFigure ] = ensemble_variable_plot( steps, varName, varAvg, varStd, parNames, parVars, parVals )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%LJ dimensionless unit conversion for Argon gas
% sigma = 3.4*10^(-10); %meters
% mass = 6.69*10^(-26); %kilograms
% epsilon = 1.65*10^(-21); %joules
% tau = 2.17*10^(-12); %seconds
% timestep = tau/200; %seconds
% kb = 1.38*10^(-23); %Joules/Kelvin

if varName == 'v_P'
    varName = 'Pressure';
    yTitle = 'P*';
    xTitle = 't*';
end

t = steps/200; %LJ dimensionless time
%    P(:,1) = P_avg(:,j,i); %LJ Dimensionless
%    P_plot = P*epsilon/sigma^(3)*10^(-6); %kJoules/meter^3
%    P_plot_dev(:,1) = P_std(:,j,i)*epsilon/sigma^(3)*10^(-6); %kJoules/meter^3
%    P_dev(:,1) = P_std(:,j,i); %LJ Dimensionless

fig = figure('Position',[100,100,1280,720],'Visible','off');
ax0 = axes('Position',[0 0 1 1],'Visible','off');
text(0.75,0.9, 'Assumed Pressure Function', 'Interpreter', 'Latex', 'units', 'normalized', 'FontSize', 9);
text(0.75,0.85, '$P(t)=P_{\alpha,b}(t) \cdot cos(2 \pi f_0 t) + P_{eq}$', 'Interpreter', 'Latex', 'units', 'normalized');
text(0.75,0.8, ['$f_0 =$ ' num2str(fundFreq,5) ' GHz'], 'Interpreter', 'Latex', 'units', 'normalized');
text(0.75,0.75, ['$P_{eq} =$ ' num2str(thermalVal,5) ' $\frac{kJ}{m^{3}}$'], 'Interpreter', 'Latex', 'units', 'normalized');
text(0.75,0.7, ['$\sigma_{eq} =$ ' num2str(thermalValStd,5) ' $\frac{kJ}{m^{3}}$'], 'Interpreter', 'Latex', 'units', 'normalized');

text(0.625,0.6, 'Exponential Amplitude Decay', 'Interpreter', 'Latex', 'units', 'normalized', 'FontSize', 9);
text(0.625,0.55, '$P_{\alpha}(t) = P_{0} \cdot exp(-t/\tau)$', 'Interpreter', 'Latex', 'units', 'normalized');
text(0.625,0.5, ['$P_{0} =$ ' num2str(P_0_fit,5) ' $\frac{kJ}{m^{3}}$'], 'Interpreter', 'Latex', 'units', 'normalized');
text(0.625,0.45, ['$\sigma_{0} =$ ' num2str(amplitudeStd,5) ' $\frac{kJ}{m^{3}}$'], 'Interpreter', 'Latex', 'units', 'normalized');
text(0.625,0.4, ['$\tau =$ ' num2str(tauFit,5) ' $ns$'], 'Interpreter', 'Latex', 'units', 'normalized');
text(0.625,0.35, ['$\sigma_{\tau} =$ ' num2str(tau_stddev,5) ' $ns$'], 'Interpreter', 'Latex', 'units', 'normalized');

text(0.625,0.25, 'Goodness of Fit for $P_{\alpha}(t)$', 'Interpreter', 'Latex', 'units', 'normalized');
text(0.625,0.2, ['$R^2$ Value = ' num2str(exp_rsquare,5)], 'Interpreter', 'Latex', 'units', 'normalized');
text(0.625,0.15, ['Adj. $R^2$ Value = ' num2str(exp_adjrsquare,5)], 'Interpreter', 'Latex', 'units', 'normalized');
text(0.625,0.1, ['RMS Error = ' num2str(exp_rmse,5)], 'Interpreter', 'Latex', 'units', 'normalized');

text(0.825,0.6, 'Algebraic Amplitude Decay', 'Interpreter', 'Latex', 'units', 'normalized', 'FontSize', 9);
text(0.825,0.55, '$P_{b}(t) = A \cdot t^{~\beta}$', 'Interpreter', 'Latex', 'units', 'normalized');
text(0.825,0.5, ['$A =$ ' num2str(A_fit,5) ' $\frac{mJ}{m^{2}}$'], 'Interpreter', 'Latex', 'units', 'normalized');
text(0.825,0.45, ['$\sigma_{A} =$ ' num2str(A_stddev,5) ' $\frac{kJ}{m^{3}}$'], 'Interpreter', 'Latex', 'units', 'normalized');
text(0.825,0.4, ['$\beta =$ ' num2str(beta_fit,5)], 'Interpreter', 'Latex', 'units', 'normalized');
text(0.825,0.35, ['$\sigma_{\beta} =$ ' num2str(beta_stddev,5)], 'Interpreter', 'Latex', 'units', 'normalized');

text(0.825,0.25, 'Goodness of Fit for $P_{b}(t)$', 'Interpreter', 'Latex', 'units', 'normalized');
text(0.825,0.2, ['$R^2$ Value = ' num2str(pow_rsquare,5)], 'Interpreter', 'Latex', 'units', 'normalized');
text(0.825,0.15, ['Adj. $R^2$ Value = ' num2str(pow_adjrsquare,5)], 'Interpreter', 'Latex', 'units', 'normalized');
text(0.825,0.1, ['RMS Error = ' num2str(pow_rmse,5)], 'Interpreter', 'Latex', 'units', 'normalized');

ax1 = axes('Position',[.1 .1 .5 .8],'Visible','off');
%errorbar(t,P_plot, P_plot_dev, '.');
plot(t, P_plot, '.');
hold on;
errorbar(tPeaks, (varPeakDiff+thermalVal), P_plot_peaks_dev, 'o');
hold on;
plot(t, (exp_fit_line+thermalVal), t(2:size(t,1)), (pow_fit_line+thermalVal));    %plot(t, P, '.', t_peaks, (P_diff_peaks+P_thermal), 'ro', t, (exp_fit_line+P_thermal), t(2:size(t,1)), (pow_fit_line+P_thermal));
%       title(strcat('Statistical Pressure at~', region, ' of Filter with Pore Width W=', num2str(W), 'd, Impurity Diameter D=', num2str(D), 'd and Registry Shift H=', num2str(H),'d'), 'Interpreter', 'LaTex', 'FontSize', 8 );
title(strcat('Statistical Pressure at~', region, ' of Filter with Pore Width W=', num2str(W), 'd, Impurity Diameter D=', num2str(D), 'd'), 'Interpreter', 'LaTex', 'FontSize', 8 );
xlabel('Time, $t ~ (ns)$','Interpreter','Latex');
ylabel('Pressure, $P ~ (\frac{kJ}{m^{3}})$','Interpreter','Latex');
legend('Raw Data', 'Peak (Fit) Values', 'Exponential Fit', 'Algebraic Fit');
%axis([0 t_cutoff 0.9*min(P) 1.1*max(P)]);
axis([0 max(t) 0.9*min(P_plot) 1.1*max(P_plot)]);
print(strcat(region,'_Statistical_Pressure_vs_Time_',simString), '-dpng');
close(fig);

%%%%%%%%%%%%%%%%%%%%%%%%

fig1 = figure('Position',[100,100,1280,720],'Visible','off');
ax0 = axes('Position',[0 0 1 1],'Visible','off');

text(0.825,0.9, 'General Pressure Function', 'Interpreter', 'Latex', 'units', 'normalized', 'FontSize', 9);
text(0.825,0.85, '$P(t)=P_{A}(t) \cdot cos(2 \pi f_0 t) + P_{eq}$', 'Interpreter', 'Latex', 'units', 'normalized');
text(0.825,0.8, ['$f_0 =$ ' num2str(fundFreq,5) ' GHz'], 'Interpreter', 'Latex', 'units', 'normalized');
text(0.825,0.75, ['$P_{eq} =$ ' num2str(thermalVal,5) ' $\frac{kJ}{m^{3}}$'], 'Interpreter', 'Latex', 'units', 'normalized');
text(0.825,0.7, ['$\sigma_{eq} =$ ' num2str(thermalValStd,5) ' $\frac{kJ}{m^{3}}$'], 'Interpreter', 'Latex', 'units', 'normalized');

text(0.825,0.6, 'Exponential Amplitude Decay', 'Interpreter', 'Latex', 'units', 'normalized', 'FontSize', 9);
text(0.825,0.55, '$P_{A}(t) = P_{0} \cdot exp(-t/\tau)$', 'Interpreter', 'Latex', 'units', 'normalized');
text(0.825,0.5, ['$P_{0} =$ ' num2str(P_0_fit,5) ' $\frac{kJ}{m^{3}}$'], 'Interpreter', 'Latex', 'units', 'normalized');
text(0.825,0.45, ['$\sigma_{0} =$ ' num2str(amplitudeStd,5) ' $\frac{kJ}{m^{3}}$'], 'Interpreter', 'Latex', 'units', 'normalized');
text(0.825,0.4, ['$\tau =$ ' num2str(tauFit,5) ' $ns$'], 'Interpreter', 'Latex', 'units', 'normalized');
text(0.825,0.35, ['$\sigma_{\tau} =$ ' num2str(tau_stddev,5) ' $ns$'], 'Interpreter', 'Latex', 'units', 'normalized');

text(0.825,0.25, 'Goodness of Fit for $P_{A}(t)$', 'Interpreter', 'Latex', 'units', 'normalized');
text(0.825,0.2, ['$R^2$ Value = ' num2str(exp_rsquare,5)], 'Interpreter', 'Latex', 'units', 'normalized');
text(0.825,0.15, ['Adj. $R^2$ Value = ' num2str(exp_adjrsquare,5)], 'Interpreter', 'Latex', 'units', 'normalized');
text(0.825,0.1, ['RMS Error = ' num2str(exp_rmse,5)], 'Interpreter', 'Latex', 'units', 'normalized');


ax1 = axes('Position',[.1 .1 .7 .8],'Visible','off');
%errorbar(t,P_plot, P_plot_dev, '.');
plot(t, P_plot, '.');
hold on;
errorbar(tPeaks, (varPeakDiff+thermalVal), P_plot_peaks_dev, 'o');
hold on;
plot(t, (exp_fit_line+thermalVal));    %plot(t, P, '.', t_peaks, (P_diff_peaks+P_thermal), 'ro', t, (exp_fit_line+P_thermal), t(2:size(t,1)), (pow_fit_line+P_thermal));
%       title(strcat('Statistical Pressure at~', region, ' of Filter with Pore Width W=', num2str(W), 'd, Impurity Diameter D=', num2str(D), 'd and Registry Shift H=', num2str(H),'d'), 'Interpreter', 'LaTex', 'FontSize', 8 );
title(strcat('Statistical Pressure at~', region, ' of Filter with Pore Width W=', num2str(W), 'd, Impurity Diameter D=', num2str(D), 'd'), 'Interpreter', 'LaTex', 'FontSize', 8 );
xlabel('Time, $t ~ (ns)$','Interpreter','Latex');
ylabel('Pressure, $P ~ (\frac{kJ}{m^{3}})$','Interpreter','Latex');
legend('Raw Data', 'Peak (Fit) Values', 'Exponential Fit');
%axis([0 t_cutoff 0.9*min(P) 1.1*max(P)]);
axis([0 max(t) 0.9*min(P_plot) 1.1*max(P_plot)]);
print(strcat(region,'_Clean_Statistical_Pressure_vs_Time_',simString), '-dpng');
close(fig1);




%----------Outputs-------------
%OUTPUTS IN SAME VARIABLE STRUCTURE

varargout{1}.fit_data = fit_data;

%------------------------------end


end

