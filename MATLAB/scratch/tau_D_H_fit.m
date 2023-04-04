function [ varargout ] = tau_D_H_fit( parList, tau_est, tau_std, outputDir, fixedVar, fixedVal, variedVar )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

parList = parList';
tau_est = tau_est';
tau_std = tau_std';
tau_weights = tau_std.^(-2);

[lin_fit_curve, lin_fit_goodness, lin_fit_output] = fit(parList,tau_est,'poly1', 'Weights', tau_weights);
% expShiftFit = fittype('expShiftLine(x,a,b,c)');
% [expShift_fit_curve, expShift_fit_goodness, expShift_fit_output] = fit(parList,tau_est,expShiftFit, 'Weights', tau_weights,'StartPoint', [2000, 1000, 0]);
[exp_fit_curve, exp_fit_goodness, exp_fit_output] = fit(parList,tau_est,'exp1', 'Weights', tau_weights);
poly2 = 1;
if poly2 == 1
    [pow_fit_curve, pow_fit_goodness, pow_fit_output] = fit(parList,tau_est,'poly2', 'Weights', tau_weights);
else
    for i = 1:1:size(parList,1)
        if parList(i) == 0 
            powParList = parList;
            powParList(i) = 0.0000001;
            [pow_fit_curve, pow_fit_goodness, pow_fit_output] = fit(powParList,tau_est,'power1', 'Weights', tau_weights);
        elseif parList(i) < 0
            [pow_fit_curve, pow_fit_goodness, pow_fit_output] = fit(parList+45.0000001,tau_est,'power1', 'Weights', tau_weights);
        else
            [pow_fit_curve, pow_fit_goodness, pow_fit_output] = fit(parList,tau_est,'power1', 'Weights', tau_weights);
        end
    end
end

%[gauss_fit_curve, gauss_fit_goodness, gauss_fit_output] = fit(wList,tau_est,'gauss', 'Weights', tau_weights)
doTauPlot = 1;
shift = .3;
if doTauPlot == 1
    cd(outputDir);
    
    fig = figure('Visible','on');
    ax1 = axes('Position',[0 0 1 1],'Visible','off');
    ax2 = axes('Position',[.1 .1 .6 .8],'Visible','off');
    axes(ax2);
    errorbar(parList, tau_est, tau_std, 'o');
    hold on;
    plot(lin_fit_curve,'c');    
    plot(exp_fit_curve,'k');
    plot(pow_fit_curve,'r');    
%     plot(expShift_fit_curve,'b');

    if variedVar == 'D'
        title(strcat('$\tau(D)$ with $W=120r^*$, $',fixedVar,'=',num2str(fixedVal),'r^*$'),'Interpreter','latex');
        xlabel('Impurity Diameter, $D ~ (r^*)$','Interpreter','latex');
        linEq = '$\tau(D) = a \cdot D + b$';
        expEq = '$\tau(D) = a \cdot e^{b \cdot D}$';
        algEq = '$\tau(D) = a \cdot D^{b}$';
        axis([0 max(parList)+1 min(tau_est)-max(tau_std)-100 max(tau_est)+max(tau_std)+100]);
    elseif variedVar == 'W'
        title('$\tau(W)$ with $D=1r^*$','Interpreter','latex');
        xlabel('Pore Width, $W ~ (r^*)$','Interpreter','latex');
        linEq = '$\tau(W) = a \cdot W + b$';
        expEq = '$\tau(W) = a \cdot e^{b \cdot W}$';
        algEq = '$\tau(W) = a \cdot W^{b}$';
    elseif strcmp(variedVar,'abs_theta')
        title(strcat('$\tau(|\theta|)$ with $W=120r^*$, $',fixedVar,'=',num2str(fixedVal),'r^*$'),'Interpreter','latex');
        xlabel('Offset Angle Magnitude, $|\theta| ~ (Deg.)$','Interpreter','latex');
%         xlabel('Offset Angle, $\theta ~ (Deg.)$','Interpreter','latex');
        linEq = '$\tau(|\theta|) = a \cdot \theta + b$';
        expEq = '$\tau(|\theta|) = a \cdot e^{b \cdot \theta}$';
        algEq = '$\tau(|\theta|) = a \cdot \theta^2 + b \cdot \theta + c$';
        axis([-5 90 min(tau_est)-max(tau_std)-100 max(tau_est)+max(tau_std)+100]);
    elseif strcmp(variedVar,'theta')
        title(strcat('$\tau(\theta)$ with $W=120r^*$, $',fixedVar,'=',num2str(fixedVal),'r^*$'),'Interpreter','latex');
        xlabel('Offset Angle, $\theta ~ (Deg.)$','Interpreter','latex');
%         xlabel('Offset Angle, $\theta ~ (Deg.)$','Interpreter','latex');
        linEq = '$\tau(\theta) = a \cdot \theta + b$';
        expEq = '$\tau(\theta) = a \cdot e^{b \cdot \theta}$';
        algEq = '$\tau(\theta) = a \cdot \theta^2 + b \cdot \theta + c$';
        axis([-50 90 min(tau_est)-max(tau_std)-100 max(tau_est)+max(tau_std)+100]);
    elseif variedVar == 'S'
        title(strcat('$\tau(S)$ with $W=100r^*$ and $',fixedVar,'=',num2str(fixedVal),'r^*$'),'Interpreter','latex');
        xlabel('Orifice Separation, $S ~ (r^*)$','Interpreter','latex');
        linEq = '$\tau(S) = a \cdot S + b$';
        expEq = '$\tau(S) = a \cdot e^{b \cdot S}$';
        algEq = '$\tau(S) = a \cdot S^{b}$';
        axis([min(parList)-20 max(parList)+20 min(tau_est)-max(tau_std)-100 max(tau_est)+max(tau_std)+100]);
    elseif variedVar == 'H'
        title(strcat('$\tau(H)$ with $W=200r^*$, $',fixedVar,'=',num2str(fixedVal),'r^*$'),'Interpreter','latex');
        xlabel('Orifice Offset, $H ~ (r^*)$','Interpreter','latex');
        linEq = '$\tau(H) = a \cdot H + b$';
        expEq = '$\tau(H) = a \cdot e^{b \cdot H}$';
        algEq = '$\tau(H) = a \cdot H^{b}$';
        axis([min(parList)-20 max(parList)+20 min(tau_est)-max(tau_std)-100 max(tau_est)+max(tau_std)+100]);
    elseif variedVar == 'F'
        title(strcat('$\tau(H)$ with $W=200r^*$ and $',fixedVar,'=',num2str(fixedVal),'r^*$'),'Interpreter','latex');
        xlabel('Orifice Offset, $H ~ (r^*)$','Interpreter','latex');
        linEq = '$\tau(H) = a \cdot H + b$';
        expEq = '$\tau(H) = a \cdot e^{b \cdot H}$';
        algEq = '$\tau(H) = a \cdot H^{b}$';
        axis([min(parList)-20 max(parList)+20 min(tau_est)-max(tau_std)-100 max(tau_est)+max(tau_std)+100]);
    end
    ylabel('Exp. Decay Time Constant, $\tau~(t^*)$','Interpreter','latex');
    
%     legend("Data", "Linear Fit", "Exponential Fit", "Algebraic Fit", "Location", "SouthEast");
    legend("Data", "Linear Fit", "Exponential Fit", "Quadratic Fit", "Location", "SouthEast");

    adjrsquare = lin_fit_goodness.adjrsquare;
    rmse = lin_fit_goodness.rmse;
    c = coeffvalues(lin_fit_curve);
    axes(ax1);
    text(0.725,0.9,linEq,'Interpreter','latex');
    text(0.725,0.85, ['$a =$ ' num2str(c(1)) '$\frac{r^*}{t^*}$'], 'Interpreter', 'latex', 'units', 'normalized')
    text(0.725,0.8, ['$b =$ ' num2str(c(2)) '$t^*$'], 'Interpreter', 'latex', 'units', 'normalized')
    text(0.725,0.75, ['Adj. $R^2$ Err. = ' num2str(adjrsquare)], 'Interpreter', 'latex', 'units', 'normalized')
    text(0.725,0.7, ['RMS Err. = ' num2str(rmse)], 'Interpreter', 'latex', 'units', 'normalized')
    
    adjrsquare = exp_fit_goodness.adjrsquare;
    rmse = exp_fit_goodness.rmse;
    c = coeffvalues(exp_fit_curve);
    axes(ax1);
    text(0.725,0.9-shift,expEq,'Interpreter','latex');
    text(0.725,0.85-shift, ['$a =$ ' num2str(c(1))], 'Interpreter', 'latex', 'units', 'normalized')
    text(0.725,0.8-shift, ['$b =$ ' num2str(c(2))], 'Interpreter', 'latex', 'units', 'normalized')
    text(0.725,0.75-shift, ['Adj. $R^2$ Err. = ' num2str(adjrsquare)], 'Interpreter', 'latex', 'units', 'normalized')
    text(0.725,0.7-shift, ['RMS Err. = ' num2str(rmse)], 'Interpreter', 'latex', 'units', 'normalized')
    
    adjrsquare = pow_fit_goodness.adjrsquare;
    rmse = pow_fit_goodness.rmse;
    c = coeffvalues(pow_fit_curve);
    axes(ax1);
    text(0.725,0.9-2*shift,algEq,'Interpreter','latex');
    text(0.725,0.85-2*shift, ['$a =$ ' num2str(c(1))], 'Interpreter', 'latex', 'units', 'normalized')
    text(0.725,0.8-2*shift, ['$b =$ ' num2str(c(2))], 'Interpreter', 'latex', 'units', 'normalized')
    if poly2 == 1
        text(0.725,0.75-2*shift, ['$c =$ ' num2str(c(3))], 'Interpreter', 'latex', 'units', 'normalized')
        text(0.725,0.7-2*shift, ['Adj. $R^2$ Err. = ' num2str(adjrsquare)], 'Interpreter', 'latex', 'units', 'normalized')
        text(0.725,0.65-2*shift, ['RMS Err. = ' num2str(rmse)], 'Interpreter', 'latex', 'units', 'normalized')
    else
        text(0.725,0.75-2*shift, ['Adj. $R^2$ Err. = ' num2str(adjrsquare)], 'Interpreter', 'latex', 'units', 'normalized')
        text(0.725,0.7-2*shift, ['RMS Err. = ' num2str(rmse)], 'Interpreter', 'latex', 'units', 'normalized')
    end
    
    %     fileName = strcat('tau_func_',variedVar,'_mean_',fixedVar,num2str(fixedVal),'_fits');
%     fileName = strcat('tau_2W_ratio_func_',variedVar,'_fixed_',fixedVar,num2str(fixedVal),'_fits');
%     fileName = strcat('tau_func_abs_',variedVar,'_fixed_',fixedVar,num2str(fixedVal),'_120W_120F_60L_fits');
    fileName = strcat('tau_func_',variedVar,'_fixed_',fixedVar,num2str(fixedVal),'_120W_120F_60L_fits');
    print(fileName, '-dpng');
    savefig(fig, fileName);


    close(fig);
    
    
    
    
    
    
    
    
%     fig = figure('Visible','on');
%     ax1 = axes('Position',[0 0 1 1],'Visible','off');
%     ax2 = axes('Position',[.1 .1 .6 .8],'Visible','off');
%     axes(ax2);
%     plot(lin_fit_curve,parList,tau_est);
%     hold on;
%     errorbar(parList, tau_est, tau_std, 'o');
%     title('$\tau(W) = a \cdot W + b$','Interpreter','latex');
%     xlabel('Pore Width, $W ~ (r^*)$','Interpreter','latex');
%     ylabel('$\tau, (t^*)$','Interpreter','latex');
%     legend('off');
%     adjrsquare = lin_fit_goodness.adjrsquare;
%     rmse = lin_fit_goodness.rmse;
%     c = coeffvalues(lin_fit_curve);
%     axes(ax1);
%     text(0.725,0.85, ['$a =$ ' num2str(c(1)) '$\frac{r^*}{t^*}$'], 'Interpreter', 'latex', 'units', 'normalized')
%     text(0.725,0.8, ['$b =$ ' num2str(c(2)) '$t^*$'], 'Interpreter', 'latex', 'units', 'normalized')
%     text(0.725,0.75, ['Adj. $R^2$ Err. = ' num2str(adjrsquare)], 'Interpreter', 'latex', 'units', 'normalized')
%     text(0.725,0.7, ['RMS Err. = ' num2str(rmse)], 'Interpreter', 'latex', 'units', 'normalized')
%     print('10D_tau_lin_func_W_7points', '-dpng');
%     close(fig);
%     
%     fig = figure('Visible','on');
%     ax1 = axes('Position',[0 0 1 1],'Visible','off');
%     ax2 = axes('Position',[.1 .1 .6 .8],'Visible','off');
%     axes(ax2);
%     plot(exp_fit_curve,parList,tau_est);
%     hold on;
%     errorbar(parList, tau_est, tau_std, 'o');
%     title('$\tau(W) = a \cdot e^{b \cdot W}$','Interpreter','latex');
%     xlabel('Pore Width, $W ~ (r^*)$','Interpreter','latex');
%     ylabel('$\tau, (t^*)$','Interpreter','latex');
%     legend('off');
%     adjrsquare = exp_fit_goodness.adjrsquare;
%     rmse = exp_fit_goodness.rmse;
%     c = coeffvalues(exp_fit_curve);
%     axes(ax1);
%     text(0.725,0.85, ['$a =$ ' num2str(c(1))], 'Interpreter', 'latex', 'units', 'normalized')
%     text(0.725,0.8, ['$b =$ ' num2str(c(2))], 'Interpreter', 'latex', 'units', 'normalized')
%     text(0.725,0.75, ['Adj. $R^2$ Err. = ' num2str(adjrsquare)], 'Interpreter', 'latex', 'units', 'normalized')
%     text(0.725,0.7, ['RMS Err. = ' num2str(rmse)], 'Interpreter', 'latex', 'units', 'normalized')
%     print('10D_tau_exp_func_W_7points', '-dpng');
%     close(fig);
% 
%     fig = figure('Visible','on');
%     ax1 = axes('Position',[0 0 1 1],'Visible','off');
%     ax2 = axes('Position',[.1 .1 .6 .8],'Visible','off');
%     axes(ax2);
%     plot(pow_fit_curve,parList,tau_est);
%     hold on;
%     errorbar(parList, tau_est, tau_std, 'o');
%     title('$\tau(W) = a \cdot W^{b}$','Interpreter','latex');
%     xlabel('Pore Width, $W ~ (r^*)$','Interpreter','latex');
%     ylabel('$\tau, (t^*)$','Interpreter','latex');
%     legend('off');
%     adjrsquare = pow_fit_goodness.adjrsquare;
%     rmse = pow_fit_goodness.rmse;
%     c = coeffvalues(pow_fit_curve);
%     axes(ax1);
%     text(0.725,0.85, ['$a =$ ' num2str(c(1))], 'Interpreter', 'latex', 'units', 'normalized')
%     text(0.725,0.8, ['$b =$ ' num2str(c(2))], 'Interpreter', 'latex', 'units', 'normalized')
%     text(0.725,0.75, ['Adj. $R^2$ Err. = ' num2str(adjrsquare)], 'Interpreter', 'latex', 'units', 'normalized')
%     text(0.725,0.7, ['RMS Err. = ' num2str(rmse)], 'Interpreter', 'latex', 'units', 'normalized')
%     print('10D_tau_pow_func_W_7points', '-dpng');
%     close(fig);
end

varargout{1}.lin = {lin_fit_curve, lin_fit_goodness, lin_fit_output};
varargout{1}.exp = {exp_fit_curve, exp_fit_goodness, exp_fit_output};
varargout{1}.alg = {pow_fit_curve, pow_fit_goodness, pow_fit_output};


end

