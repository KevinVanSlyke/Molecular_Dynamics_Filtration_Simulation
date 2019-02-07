function [] = plot_variable(steps, varAvg, selectedVar, parNames, parVars, parVals)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
t = steps/200;
[varTitle, varSym] = format_variable_name(selectedVar);

[parString] = catenate_parameters(parVars,parVals);

titleString = strcat(varTitle, " adjoining Filter with ");
for i = 1 : 1 : size(parVars,2)
    
    titleString = strcat(titleString, parNames(1,i), " ", parVars(1,i), "=", num2str(parVals(1,i)), "r*");
    if i < size(parNames,2)
        titleString = strcat(titleString, ", ");
    end
end

fig = figure('Visible','off');
ax = axes('Visible','off');
%errorbar(t,P_plot, P_plot_dev, '.');
plot(t, varAvg, '.');
title(titleString, 'Interpreter', 'LaTex', 'FontSize', 8 );
xlabel("$t*$",'Interpreter','Latex');
ylabel(varSym,'Interpreter','Latex');
legend("Raw Data");
%axis([0 t_cutoff 0.9*min(P) 1.1*max(P)]);
axis([0 max(t) 0.9*min(varAvg) 1.1*max(varAvg)]);
print(strcat("Statistical_",varTitle,"_vs_Time_",parString), '-dpng');
close(fig);

end
