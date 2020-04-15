function [] = plot_variable(t, varAvg, varName, parNames, parVars, parVals, plotFit)
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
plot(t, varAvg, '.');
hold on;
title(titleString, 'Interpreter', 'LaTex', 'FontSize', 8 );
ylabel(strcat('Pressure (', varSym,')'),'Interpreter','Latex');
%legend("Data", "Exp. Decay Fit");
legend("Avg. $P_{front}$",'Interpreter','Latex');
%axis([0 max(t) 0.9*min(P) 1.1*max(P)]);
axis([0 max(t) 0.9*min(varAvg) 1.1*max(varAvg)]);
if strcmp(plotFit, 'LJ') == 1
    xlabel("Time ($t^*$)",'Interpreter','Latex');
elseif strcmp(plotFit, 'real') == 1
    xlabel("$t (ns)$",'Interpreter','Latex');
end 
print(strcat("Statistical_",varTitle,"_vs_Time_",parString,"_",plotFit), '-dpng');
%savefig(fitFig, strcat("Fit_Statistical_",varTitle,"_vs_Time_",parString,"_",plotFit,".fig"));

close(fitFig);

end
