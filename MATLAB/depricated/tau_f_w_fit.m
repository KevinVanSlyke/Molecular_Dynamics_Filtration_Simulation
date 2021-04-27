function [ varargout ] = tau_f_w_fit( constList, varList, tau_est_matrix, tau_std_matrix )
%UNTITLED3 Summary of this function goes here
%   Need to swap comments and input order depending on if you want tau as a
%   function of F or W
for n = 1 : 1 : size(varList,2)
    W = constList(n);
    tau_est = tau_est_matrix(n,:);
    tau_std = tau_std_matrix(n,:);
    
%     F = constList(n);
%     tau_est = tau_est_matrix(:,n);
%     tau_std = tau_std_matrix(:,n);

    tau_weights = tau_std.^(-2);
     
    [lin_fit_curve, lin_fit_goodness, lin_fit_output] = fit(varList',tau_est','poly1', 'Weights', tau_weights');
    [exp_fit_curve, exp_fit_goodness, exp_fit_output] = fit(varList',tau_est','exp1', 'Weights', tau_weights');
    
%     [lin_fit_curve, lin_fit_goodness, lin_fit_output] = fit(varList',tau_est,'poly1', 'Weights', tau_weights);
%     [exp_fit_curve, exp_fit_goodness, exp_fit_output] = fit(varList',tau_est,'exp1', 'Weights', tau_weights);
    
    doTauPlot = 1;
    if doTauPlot == 1
        cd('/home/Kevin/Documents/Simulation_Data/Molecular_Dynamics/September_2018_3D_MultiOrifice/MultiSlit_Data');

        fig = figure('Visible','off');
        ax1 = axes('Position',[0 0 1 1],'Visible','off');
        ax2 = axes('Position',[.1 .1 .6 .8],'Visible','off');
        axes(ax2);
        plot(lin_fit_curve,varList,tau_est);
        hold on;
        errorbar(varList, tau_est, tau_std, 'o');
        
        title(strcat('$\tau(F) = a \cdot F + b$, Constant Width W =~', num2str(W), '$r^*$'),'Interpreter','latex');
        xlabel('Orifice Spacing, $F ~ (r^*)$','Interpreter','latex');
        
%         title(strcat('$\tau(w) = a \cdot W + b$, Constant Spacing F =~', num2str(F), '$r^*$'),'Interpreter','latex');
%         xlabel('Orifice Width, $W ~ (r^*)$','Interpreter','latex');

        ylabel('$\tau, (t^*)$','Interpreter','latex');
        legend('off');
        adjrsquare = lin_fit_goodness.adjrsquare;
        rmse = lin_fit_goodness.rmse;
        c = coeffvalues(lin_fit_curve);
        axes(ax1);
        text(0.725,0.85, ['$a =$ ' num2str(c(1)) '$\frac{r^*}{t^*}$'], 'Interpreter', 'latex', 'units', 'normalized')
        text(0.725,0.8, ['$b =$ ' num2str(c(2)) '$t^*$'], 'Interpreter', 'latex', 'units', 'normalized')
        text(0.725,0.75, ['Adj. $R^2$ Err. = ' num2str(adjrsquare)], 'Interpreter', 'latex', 'units', 'normalized')
        text(0.725,0.7, ['RMS Err. = ' num2str(rmse)], 'Interpreter', 'latex', 'units', 'normalized')
        print(strcat('tau_lin_func_F_const_W_',num2str(W)), '-dpng');
%         print(strcat('tau_lin_func_W_const_F_',num2str(F)), '-dpng');
        close(fig);

        fig = figure('Visible','off');
        ax1 = axes('Position',[0 0 1 1],'Visible','off');
        ax2 = axes('Position',[.1 .1 .6 .8],'Visible','off');
        axes(ax2);
        plot(exp_fit_curve,varList,tau_est);
        hold on;
        errorbar(varList, tau_est, tau_std, 'o');
        
        title(strcat('$\tau(F) = a \cdot e^{b \cdot F}$, Constant Width W =~', num2str(W), '$r^*$'),'Interpreter','latex');
        xlabel('Orifice Spacing, $F ~ (r^*)$','Interpreter','latex');
        
%         title(strcat('$\tau(w) = a \cdot e^{b \cdot W}$, Constant Spacing F =~', num2str(F), '$r^*$'),'Interpreter','latex');
%         xlabel('Orifice Width, $W ~ (r^*)$','Interpreter','latex');

        ylabel('$\tau, (t^*)$','Interpreter','latex');
        legend('off');
        adjrsquare = exp_fit_goodness.adjrsquare;
        rmse = exp_fit_goodness.rmse;
        c = coeffvalues(exp_fit_curve);
        axes(ax1);
        text(0.725,0.85, ['$a =$ ' num2str(c(1))], 'Interpreter', 'latex', 'units', 'normalized')
        text(0.725,0.8, ['$b =$ ' num2str(c(2))], 'Interpreter', 'latex', 'units', 'normalized')
        text(0.725,0.75, ['Adj. $R^2$ Err. = ' num2str(adjrsquare)], 'Interpreter', 'latex', 'units', 'normalized')
        text(0.725,0.7, ['RMS Err. = ' num2str(rmse)], 'Interpreter', 'latex', 'units', 'normalized')
        print(strcat('tau_exp_func_F_const_W_',num2str(W)), '-dpng');
%         print(strcat('tau_exp_func_W_const_F_',num2str(F)), '-dpng');
        close(fig);
    end
end
varargout{1}.lin = {lin_fit_curve, lin_fit_goodness, lin_fit_output};
varargout{1}.exp = {exp_fit_curve, exp_fit_goodness, exp_fit_output};

end

