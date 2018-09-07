function [ varargout ] = plot_statistical_pressure_fit( P_stats )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%LJ dimensionless unit conversion for Argon gas
sigma = 3.4*10^(-10); %meters
mass = 6.69*10^(-26); %kilograms
epsilon = 1.65*10^(-21); %joules
tau = 2.17*10^(-12); %seconds
timestep = tau/200; %seconds
kb = 1.38*10^(-23); %Joules/Kelvin

simList = P_stats{1,1}; %Char Array of Sim Parameters
times = P_stats{2,1}; %timesteps
P_avg = P_stats{3,1};
P_std = P_stats{4,1};

for i = 1 : 1 : size(simList,1)
    
    simString = simList{i,1};
    parStrings = strsplit(simString,{'_'});
    
    wString = strsplit(parStrings{1,1},{'W'});
    W = str2double(wString{1,1});
    w=W*sigma*(10^(9)); %nanometers
    
    dString = strsplit(parStrings{1,2},{'D'});
    D = str2double(dString{1,1});
    d=D*sigma*(10^(9)); %nanometers
    
%     hString = strsplit(parStrings{1,3},{'H'});
%     H = str2double(hString{1,1});
%     h=H*sigma*(10^(9)); %nanometers
    
    for j = 1 : 1 : size(P_avg,2)
        if j == 1
            region = 'Front';
        elseif j == 2
            region = 'Middle';
        elseif j == 3
            region = 'Rear';
        end
        t = times; %timesteps
        P(:,1) = P_avg(:,j,i); %LJ Dimensionless
        P_plot = P*epsilon/sigma^(3)*10^(-6); %kJoules/meter^3
        P_plot_dev(:,1) = P_std(:,j,i)*epsilon/sigma^(3)*10^(-6); %kJoules/meter^3
        P_dev(:,1) = P_std(:,j,i); %LJ Dimensionless
        P_weights = P_dev.^(-2); %LJ Dimensionless
        
        n_max = max(size(P));
        
        
        P_thermal = 0;
        count = 0;
        for k = round(n_max*0.9,0) : 1 : n_max
            P_thermal = P_thermal + P(k); %LJ Dimensionless
            count = count + 1;
        end
        P_thermal = P_thermal/count; %LJ Dimensionless
        P_diff = (P - P_thermal)*epsilon/sigma^(3)*10^(-6); %kJoules/meter^3
        P_thermal_stddev = std(P(round(n_max*0.9,0):n_max))*epsilon/sigma^(3)*10^(-6); %kJoules/meter^3
        
        n = (1 : 1 : n_max)';
        sampleFreq = n/(n_max);
        mag = fft(P_diff);
        power = (abs(mag)).^2;
        [power_max,fundIndx] = max(power(5:n_max-5));
        
        fundSampleFreq = sampleFreq(fundIndx);
        %peakDistance = 1/fundSampleFreq;
        
        %Convert to real time
        freq = sampleFreq/(1000*timestep*(1/(10^(-9)))); %GHz (1/ns)
        fundFreq = fundSampleFreq/(1000*timestep*(1/(10^(-9)))); %GHz (1/ns)
        t = t*timestep*(1/(10^(-9))); %ns
        
        if j ~= 2
            minPeakDistance = round(4/5*(1/fundSampleFreq),0);
            
            t_peaks = [];
            P_peaks_dev = [];
            P_peaks_weight = [];
            [P_diff_peaks, peak_ind] = findpeaks(P_diff,'MinPeakDistance',minPeakDistance);
            num_peaks = max(size(P_diff_peaks));
            for k = 1 : 1 : num_peaks
                t_peaks(k,1) = t(peak_ind(k)); %ns
                P_peaks_dev(k,1) = P_dev(peak_ind(k));
                P_peaks_weight(k,1) = P_dev(peak_ind(k))^(-2);
            end
            
            [exp_fit_curve, exp_fit_goodness, exp_fit_output] = fit(t_peaks,P_diff_peaks,'exp1','Weights',P_peaks_weight);
            
            %%TODO: Should not be multiplying both values by same unit
            %transmormation constants...
            exp_fit_coef = coeffvalues(exp_fit_curve);
            exp_coef_conf_int = confint(exp_fit_curve);
            
            P_0_fit = exp_fit_coef(1); % \frac{kJ}{m^{3}}
            P_0_up_95_conf = exp_coef_conf_int(1,1); % \frac{kJ}{m^{3}}
            P_0_low_95_conf = exp_coef_conf_int(2,1); % \frac{kJ}{m^{3}}
            P_0_stddev = (abs(P_0_fit-P_0_up_95_conf)/1.96 + abs(P_0_fit-P_0_low_95_conf)/1.96)/2; % \frac{mJ}{m^{2}}
            
            tau_fit = -1/exp_fit_coef(2); % 1/ns (GHz)
            tau_up_95_conf = -1/exp_coef_conf_int(1,2); % 1/ns (GHz)
            tau_low_95_conf = -1/exp_coef_conf_int(2,2); % 1/ns (GHz)
            tau_stddev = (abs(tau_fit-tau_up_95_conf)/1.96 + abs(tau_fit-tau_low_95_conf)/1.96)/2; % 1/ns (GHz)
            
            exp_rsquare = exp_fit_goodness.rsquare;
            exp_adjrsquare = exp_fit_goodness.adjrsquare;
            exp_rmse = exp_fit_goodness.rmse;
            
            exp_fit_line = feval(exp_fit_curve, t); %kJoules/meter^2
            
            
            [pow_fit_curve, pow_fit_goodness, pow_fit_output] = fit(t_peaks,P_diff_peaks,'power1','Weights', P_peaks_weight);
            
            pow_fit_coef = coeffvalues(pow_fit_curve);
            pow_coef_conf_int = confint(pow_fit_curve); 
            
            A_fit = pow_fit_coef(1); % \frac{kJ}{m^{3}}
            A_up_95_conf = pow_coef_conf_int(1,1); % \frac{kJ}{m^{3}}
            A_low_95_conf = pow_coef_conf_int(2,1); % \frac{kJ}{m^{3}}
            A_stddev = (abs(A_fit-A_up_95_conf)/1.96 + abs(A_fit-A_low_95_conf)/1.96)/2; % \frac{kJ}{m^{3}}
            
            beta_fit = pow_fit_coef(2);
            beta_up_95_conf = pow_coef_conf_int(1,2);
            beta_low_95_conf = pow_coef_conf_int(2,2);
            beta_stddev = (abs(beta_fit-beta_up_95_conf)/1.96 + abs(beta_fit-beta_low_95_conf)/1.96)/2;
            
            pow_rsquare = pow_fit_goodness.rsquare;
            pow_adjrsquare = pow_fit_goodness.adjrsquare;
            pow_rmse = pow_fit_goodness.rmse;
            
            pow_fit_line = feval(pow_fit_curve, t(2:size(t,1))); %kJoules/meter^3
            %t_cutoff = 10*tau_fit;
            
            %cd('/home/Kevin/Documents/Dust_Data/Molecular/.../Figures');
            fit_data{i,:,j} = {simString, tau_fit, tau_stddev, exp_rsquare, exp_adjrsquare, exp_rmse, beta_fit, beta_stddev, pow_rsquare, pow_adjrsquare, pow_rmse, fundFreq};
                 
            P_plot_peaks_dev = P_peaks_dev*epsilon/sigma^(3)*10^(-6); %kJoules/meter^3
            P_thermal = P_thermal*epsilon/sigma^(3)*10^(-6); %kJoules/meter^3
            
            fig = figure('Position',[100,100,1280,720],'Visible','off');
            ax0 = axes('Position',[0 0 1 1],'Visible','off');
            text(0.75,0.9, 'Assumed Pressure Function', 'Interpreter', 'Latex', 'units', 'normalized', 'FontSize', 9);
            text(0.75,0.85, '$P(t)=P_{\alpha,b}(t) \cdot cos(2 \pi f_0 t) + P_{eq}$', 'Interpreter', 'Latex', 'units', 'normalized');
            text(0.75,0.8, ['$f_0 =$ ' num2str(fundFreq,5) ' GHz'], 'Interpreter', 'Latex', 'units', 'normalized');
            text(0.75,0.75, ['$P_{eq} =$ ' num2str(P_thermal,5) ' $\frac{kJ}{m^{3}}$'], 'Interpreter', 'Latex', 'units', 'normalized');
            text(0.75,0.7, ['$\sigma_{eq} =$ ' num2str(P_thermal_stddev,5) ' $\frac{kJ}{m^{3}}$'], 'Interpreter', 'Latex', 'units', 'normalized');
            
            text(0.625,0.6, 'Exponential Amplitude Decay', 'Interpreter', 'Latex', 'units', 'normalized', 'FontSize', 9);
            text(0.625,0.55, '$P_{\alpha}(t) = P_{0} \cdot exp(-t/\tau)$', 'Interpreter', 'Latex', 'units', 'normalized');
            text(0.625,0.5, ['$P_{0} =$ ' num2str(P_0_fit,5) ' $\frac{kJ}{m^{3}}$'], 'Interpreter', 'Latex', 'units', 'normalized');
            text(0.625,0.45, ['$\sigma_{0} =$ ' num2str(P_0_stddev,5) ' $\frac{kJ}{m^{3}}$'], 'Interpreter', 'Latex', 'units', 'normalized');
            text(0.625,0.4, ['$\tau =$ ' num2str(tau_fit,5) ' $ns$'], 'Interpreter', 'Latex', 'units', 'normalized');
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
            errorbar(t_peaks, (P_diff_peaks+P_thermal), P_plot_peaks_dev, 'o');
            hold on;
            plot(t, (exp_fit_line+P_thermal), t(2:size(t,1)), (pow_fit_line+P_thermal));    %plot(t, P, '.', t_peaks, (P_diff_peaks+P_thermal), 'ro', t, (exp_fit_line+P_thermal), t(2:size(t,1)), (pow_fit_line+P_thermal));
%            title(strcat('Statistical Pressure at~', region, ' of Filter with Pore Width W=', num2str(W), 'd, Impurity Diameter D=', num2str(D), 'd and Registry Shift H=', num2str(H),'d'), 'Interpreter', 'LaTex', 'FontSize', 8 );
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
            text(0.825,0.75, ['$P_{eq} =$ ' num2str(P_thermal,5) ' $\frac{kJ}{m^{3}}$'], 'Interpreter', 'Latex', 'units', 'normalized');
            text(0.825,0.7, ['$\sigma_{eq} =$ ' num2str(P_thermal_stddev,5) ' $\frac{kJ}{m^{3}}$'], 'Interpreter', 'Latex', 'units', 'normalized');
       
            text(0.825,0.6, 'Exponential Amplitude Decay', 'Interpreter', 'Latex', 'units', 'normalized', 'FontSize', 9);
            text(0.825,0.55, '$P_{A}(t) = P_{0} \cdot exp(-t/\tau)$', 'Interpreter', 'Latex', 'units', 'normalized');
            text(0.825,0.5, ['$P_{0} =$ ' num2str(P_0_fit,5) ' $\frac{kJ}{m^{3}}$'], 'Interpreter', 'Latex', 'units', 'normalized');
            text(0.825,0.45, ['$\sigma_{0} =$ ' num2str(P_0_stddev,5) ' $\frac{kJ}{m^{3}}$'], 'Interpreter', 'Latex', 'units', 'normalized');
            text(0.825,0.4, ['$\tau =$ ' num2str(tau_fit,5) ' $ns$'], 'Interpreter', 'Latex', 'units', 'normalized');
            text(0.825,0.35, ['$\sigma_{\tau} =$ ' num2str(tau_stddev,5) ' $ns$'], 'Interpreter', 'Latex', 'units', 'normalized');
            
            text(0.825,0.25, 'Goodness of Fit for $P_{A}(t)$', 'Interpreter', 'Latex', 'units', 'normalized');
            text(0.825,0.2, ['$R^2$ Value = ' num2str(exp_rsquare,5)], 'Interpreter', 'Latex', 'units', 'normalized');
            text(0.825,0.15, ['Adj. $R^2$ Value = ' num2str(exp_adjrsquare,5)], 'Interpreter', 'Latex', 'units', 'normalized');
            text(0.825,0.1, ['RMS Error = ' num2str(exp_rmse,5)], 'Interpreter', 'Latex', 'units', 'normalized');
                
       
            ax1 = axes('Position',[.1 .1 .7 .8],'Visible','off');
            %errorbar(t,P_plot, P_plot_dev, '.');
            plot(t, P_plot, '.');
            hold on;
            errorbar(t_peaks, (P_diff_peaks+P_thermal), P_plot_peaks_dev, 'o');
            hold on;
            plot(t, (exp_fit_line+P_thermal));    %plot(t, P, '.', t_peaks, (P_diff_peaks+P_thermal), 'ro', t, (exp_fit_line+P_thermal), t(2:size(t,1)), (pow_fit_line+P_thermal));
%            title(strcat('Statistical Pressure at~', region, ' of Filter with Pore Width W=', num2str(W), 'd, Impurity Diameter D=', num2str(D), 'd and Registry Shift H=', num2str(H),'d'), 'Interpreter', 'LaTex', 'FontSize', 8 );
            title(strcat('Statistical Pressure at~', region, ' of Filter with Pore Width W=', num2str(W), 'd, Impurity Diameter D=', num2str(D), 'd'), 'Interpreter', 'LaTex', 'FontSize', 8 );
            xlabel('Time, $t ~ (ns)$','Interpreter','Latex');
            ylabel('Pressure, $P ~ (\frac{kJ}{m^{3}})$','Interpreter','Latex');
            legend('Raw Data', 'Peak (Fit) Values', 'Exponential Fit');
            %axis([0 t_cutoff 0.9*min(P) 1.1*max(P)]);
            axis([0 max(t) 0.9*min(P_plot) 1.1*max(P_plot)]);
            print(strcat(region,'_Clean_Statistical_Pressure_vs_Time_',simString), '-dpng');
            close(fig1);
            
        else
            fig = figure('Visible','off');
            plot(t, P_plot, '.');
%            title(strcat('Average Pressure at~', region, ' of Filter with Pore Width W=', num2str(W), 'd, Impurity Diameter D=', num2str(D), 'd and Registry Shift H=', num2str(H),'d'), 'Interpreter', 'LaTex', 'FontSize', 8 );
            title(strcat('Average Pressure at~', region, ' of Filter with Pore Width W=', num2str(W), 'd, Impurity Diameter D=', num2str(D), 'd'), 'Interpreter', 'LaTex', 'FontSize', 8 );
            xlabel('Time, $t ~ (ns)$','Interpreter','Latex');
            ylabel('Pressure, $P ~ (\frac{kJ}{m^{3}})$','Interpreter','Latex');
            legend('Raw Data');
            %axis([0 t_cutoff 0.9*min(P) 1.1*max(P)]);
            axis([0 max(t) 0.9*min(P_plot) 1.1*max(P_plot)]);
            print(strcat(region,'_Statistical_Pressure_vs_Time_',simString), '-dpng');
            close(fig);
        end
        
        norm_power = power/max(power);
        fig = figure('Visible','off');
        plot(freq, norm_power);
%        title(strcat('FT of Gas Pressure at~', region, ' of Filter with Pore Width W=', num2str(W), 'd, Impurity Diameter D=', num2str(D), 'd and Shift H=', num2str(H),'d'), 'Interpreter', 'LaTex', 'FontSize', 8 );
        title(strcat('FT of Gas Pressure at~', region, ' of Filter with Pore Width W=', num2str(W), 'd, Impurity Diameter D=', num2str(D), 'd'), 'Interpreter', 'LaTex', 'FontSize', 8 );
        xlabel('Frequency, $f ~ (GHz)$','Interpreter','Latex');
        ylabel('Power Spectral Density','Interpreter','latex');
        axis([0 5*fundFreq 0 1]);
        print(strcat(region,'_Statistical_FFT_',simString), '-dpng');
        close(fig);
    end
end


%----------Outputs-------------
%OUTPUTS IN SAME VARIABLE STRUCTURE

varargout{1}.fit_data = fit_data;

%------------------------------end


end

