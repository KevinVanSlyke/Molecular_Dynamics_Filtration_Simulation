function [] = plot_variable_fit(time, varAvg, tPeaks, varPeaks, varPeakStds, expFitLine, varName, parNames, parVars, parVals, plotFit)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

%LJ dimensionless unit conversion for Argon gas
% sigma = 3.4*10^(-10); %meters
% mass = 6.69*10^(-26); %kilograms
% epsilon = 1.65*10^(-21); %joules
% tau = 2.17*10^(-12); %seconds
% timestep = 0.005*tau; %seconds
% t* = timestep
% kb = 1.38*10^(-23); %Joules/Kelvin

if strcmp(plotFit, 'real') == 1
    time = time*2.17*10^(-12)*10^9; %convert to ns
    tPeaks = tPeaks*2.17*10^(-12)*10^9; %convert to ns
end

[varTitle, varSym] = format_variable_name(varName);
[parString] = catenate_parameters(parVars,parVals);
titleString = strcat(varTitle, " adjoining Filter with ");
for i = 1 : 1 : size(parVars,2)
    titleString = strcat(titleString, parNames(1,i), " ", parVars(1,i), "=", num2str(parVals(1,i)), "r*");
    if i < size(parNames,2)
        titleString = strcat(titleString, ", ");
    end
end

fitFig = figure('Visible','off');
ax = axes('Visible','off');
plot(time, varAvg, '.');
hold on;
errorbar(tPeaks, varPeaks, varPeakStds, 'o');
hold on;
plot(time, expFitLine);
title(titleString, 'Interpreter', 'LaTex', 'FontSize', 8 );
ylabel(strcat('Pressure (', varSym,')'),'Interpreter','Latex');
legend("Raw Data", "Peak Values", "Exponential Fit");
%axis([0 t_cutoff 0.9*min(P) 1.1*max(P)]);
axis([0 max(time)/3 0.9*min(varAvg) 1.1*max(varAvg)]);
if strcmp(plotFit, 'LJ') == 1
    xlabel("Time ($t^*$)",'Interpreter','Latex');
elseif strcmp(plotFit, 'real') == 1
    xlabel("$t (ns)$",'Interpreter','Latex');
end 
print(strcat("Statistical_",varTitle,"_vs_Time_Fit_",parString,"_",plotFit), '-dpng');
close(fitFig);

end
