function [ varargout ] = plot_pressure_fit( )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%LJ dimensionless unit conversion for Argon gas
sigma = 3.4*10^(-10); %meters
mass = 6.69*10^(-26); %kilograms
epsilon = 1.65*10^(-21); %joules
tau = 2.17*10^(-12); %seconds
timestep = tau/200; %seconds
kb = 1.38*10^(-23); %Joules/Kelvin
x = (0:100:1900)'*sigma*1/(10^(-9)); %nm

cwd = pwd;
dirs = strsplit(cwd,'/');
nDirParts = size(dirs,2);
cDir = dirs(nDirParts);
simString = cDir{1,1};

wString = strsplit(simString,{'W'});
W = str2double(wString{1,1});
w=W*sigma*(10^(9)); %nanometers

dString = strsplit(simString,{'_'});
DString = strsplit(dString{1,2},{'D'});
D = str2double(DString{1,1});
d=D*sigma*(10^(9)); %nanometers

rawPData = read_pressure_data();

t = rawPData.t; %timesteps
P = rawPData.P*epsilon/sigma^(2)*(1/(10^(-3))); %milliJoules/meter^2;

clear rawPData;


n_max = max(size(P));

P_thermal = 0;
count = 0;
for j = round(n_max*0.9,0) : 1 : n_max
    P_thermal = P_thermal + P(j);
    count = count + 1;
end
P_thermal = P_thermal/count;
P_diff = P - P_thermal;
P_thermal_stddev = std(P(round(n_max*0.9,0):n_max));

n = (1 : 1 : n_max)';
sampleFreq = n/(n_max);
mag = fft(P_diff);
power = (abs(mag)).^2;
[power_max,fundIndx] = max(power(1:n_max));
fundSampleFreq = sampleFreq(fundIndx);
peakDistance = 1/fundSampleFreq;
minPeakDistance = round(4/5*(1/fundSampleFreq),0);

t_peaks = [];
[P_diff_peaks, peak_ind] = findpeaks(P_diff,'MinPeakDistance',minPeakDistance);
num_peaks = max(size(P_diff_peaks));
for j = 1:1:num_peaks
    t_peaks(j,1) = t(peak_ind(j));
end

%Convert to real time
freq = sampleFreq/(1000*timestep*(1/(10^(-9)))); %GHz (1/ns)
fundFreq = fundSampleFreq/(1000*timestep*(1/(10^(-9)))); %GHz (1/ns)
t = t*timestep*(1/(10^(-9))); %ns
t_peaks = t_peaks*timestep*(1/(10^(-9))); %ns

[exp_fit_curve, exp_fit_goodness, exp_fit_output] = fit(t_peaks,P_diff_peaks,'exp1');

exp_fit_coef = coeffvalues(exp_fit_curve);
exp_coef_conf_int = confint(exp_fit_curve);

P_0_fit = exp_fit_coef(1); % \frac{mJ}{m^{2}}
P_0_up_95_conf = exp_coef_conf_int(1,1); % \frac{mJ}{m^{2}}
P_0_low_95_conf = exp_coef_conf_int(2,1); % \frac{mJ}{m^{2}}
P_0_stddev = (abs(P_0_fit-P_0_up_95_conf)/1.96 + abs(P_0_fit-P_0_low_95_conf)/1.96)/2; % \frac{mJ}{m^{2}}

tau_fit = -1/exp_fit_coef(2); % 1/ns (GHz)
tau_up_95_conf = -1/exp_coef_conf_int(1,2); % 1/ns (GHz)
tau_low_95_conf = -1/exp_coef_conf_int(2,2); % 1/ns (GHz)
tau_stddev = (abs(tau_fit-tau_up_95_conf)/1.96 + abs(tau_fit-tau_low_95_conf)/1.96)/2; % 1/ns (GHz)

exp_rsquare = exp_fit_goodness.rsquare;
exp_adjrsquare = exp_fit_goodness.adjrsquare;
exp_rmse = exp_fit_goodness.rmse;

exp_fit_line = feval(exp_fit_curve, t);


[pow_fit_curve, pow_fit_goodness, pow_fit_output] = fit(t_peaks,P_diff_peaks,'power1');

pow_fit_coef = coeffvalues(pow_fit_curve);
pow_coef_conf_int = confint(pow_fit_curve);

A_fit = pow_fit_coef(1); % \frac{mJ}{m^{2}}
A_up_95_conf = pow_coef_conf_int(1,1); % \frac{mJ}{m^{2}}
A_low_95_conf = pow_coef_conf_int(2,1); % \frac{mJ}{m^{2}}
A_stddev = (abs(A_fit-A_up_95_conf)/1.96 + abs(A_fit-A_low_95_conf)/1.96)/2; % \frac{mJ}{m^{2}}

beta_fit = pow_fit_coef(2);
beta_up_95_conf = pow_coef_conf_int(1,2);
beta_low_95_conf = pow_coef_conf_int(2,2);
beta_stddev = (abs(beta_fit-beta_up_95_conf)/1.96 + abs(beta_fit-beta_low_95_conf)/1.96)/2;

pow_rsquare = pow_fit_goodness.rsquare;
pow_adjrsquare = pow_fit_goodness.adjrsquare;
pow_rmse = pow_fit_goodness.rmse;

pow_fit_line = feval(pow_fit_curve, t(2:size(t,1)));
%t_cutoff = 10*tau_fit;

%cd('/home/Kevin/Documents/Dust_Data/Molecular/.../Figures');

fig = figure('Position',[100,100,1280,720],'Visible','off');
ax0 = axes('Position',[0 0 1 1],'Visible','off');
text(0.75,0.9, 'Assumed Pressure Function', 'Interpreter', 'Latex', 'units', 'normalized', 'FontSize', 9);
text(0.75,0.85, '$P(t)=P_{\alpha,b}(t) \cdot cos(2 \pi f_0 t) + P_{eq}$', 'Interpreter', 'Latex', 'units', 'normalized');
text(0.75,0.8, ['$f_0 =$ ' num2str(fundFreq,5) ' GHz'], 'Interpreter', 'Latex', 'units', 'normalized');
text(0.75,0.75, ['$P_{eq} =$ ' num2str(P_thermal,5) ' $\frac{mJ}{m^{2}}$'], 'Interpreter', 'Latex', 'units', 'normalized');
text(0.75,0.7, ['$\sigma_{eq} =$ ' num2str(P_thermal_stddev,5) ' $\frac{mJ}{m^{2}}$'], 'Interpreter', 'Latex', 'units', 'normalized');

text(0.625,0.6, 'Exponential Amplitude Decay', 'Interpreter', 'Latex', 'units', 'normalized', 'FontSize', 9);
text(0.625,0.55, '$P_{\alpha}(t) = P_{0} \cdot exp(-t/\tau)$', 'Interpreter', 'Latex', 'units', 'normalized');
text(0.625,0.5, ['$P_{0} =$ ' num2str(P_0_fit,5) ' $\frac{mJ}{m^{2}}$'], 'Interpreter', 'Latex', 'units', 'normalized');
text(0.625,0.45, ['$\sigma_{0} =$ ' num2str(P_0_stddev,5) ' $\frac{mJ}{m^{2}}$'], 'Interpreter', 'Latex', 'units', 'normalized');
text(0.625,0.4, ['$\tau =$ ' num2str(tau_fit,5) ' $ns$'], 'Interpreter', 'Latex', 'units', 'normalized');
text(0.625,0.35, ['$\sigma_{\tau} =$ ' num2str(tau_stddev,5) ' $ns$'], 'Interpreter', 'Latex', 'units', 'normalized');

text(0.625,0.25, 'Goodness of Fit for $P_{\alpha}(t)$', 'Interpreter', 'Latex', 'units', 'normalized');
text(0.625,0.2, ['$R^2$ Value = ' num2str(exp_rsquare,5)], 'Interpreter', 'Latex', 'units', 'normalized');
text(0.625,0.15, ['Adj. $R^2$ Value = ' num2str(exp_adjrsquare,5)], 'Interpreter', 'Latex', 'units', 'normalized');
text(0.625,0.1, ['RMS Error = ' num2str(exp_rmse,5)], 'Interpreter', 'Latex', 'units', 'normalized');

text(0.825,0.6, 'Algebraic Amplitude Decay', 'Interpreter', 'Latex', 'units', 'normalized', 'FontSize', 9);
text(0.825,0.55, '$P_{b}(t) = A \cdot t^{~\beta}$', 'Interpreter', 'Latex', 'units', 'normalized');
text(0.825,0.5, ['$A =$ ' num2str(A_fit,5) ' $\frac{mJ}{m^{2}}$'], 'Interpreter', 'Latex', 'units', 'normalized');
text(0.825,0.45, ['$\sigma_{A} =$ ' num2str(A_stddev,5) ' $\frac{mJ}{m^{2}}$'], 'Interpreter', 'Latex', 'units', 'normalized');
text(0.825,0.4, ['$\beta =$ ' num2str(beta_fit,5)], 'Interpreter', 'Latex', 'units', 'normalized');
text(0.825,0.35, ['$\sigma_{\beta} =$ ' num2str(beta_stddev,5)], 'Interpreter', 'Latex', 'units', 'normalized');

text(0.825,0.25, 'Goodness of Fit for $P_{b}(t)$', 'Interpreter', 'Latex', 'units', 'normalized');
text(0.825,0.2, ['$R^2$ Value = ' num2str(pow_rsquare,5)], 'Interpreter', 'Latex', 'units', 'normalized');
text(0.825,0.15, ['Adj. $R^2$ Value = ' num2str(pow_adjrsquare,5)], 'Interpreter', 'Latex', 'units', 'normalized');
text(0.825,0.1, ['RMS Error = ' num2str(pow_rmse,5)], 'Interpreter', 'Latex', 'units', 'normalized');

ax1 = axes('Position',[.1 .1 .5 .8],'Visible','off');
plot(t, P, '.', t_peaks, (P_diff_peaks+P_thermal), 'ro', t, (exp_fit_line+P_thermal), t(2:size(t,1)), (pow_fit_line+P_thermal));
title(['Pressure at Front of Filter for Pore Width W=' num2str(W) 'nm and Impurity Diameter D=' num2str(d) 'nm'], 'Interpreter', 'LaTex', 'FontSize', 8 );
xlabel('Time, $t ~ (ns)$','Interpreter','Latex');
ylabel('Pressure, $P ~ (\frac{mJ}{m^{2}})$','Interpreter','Latex');
legend('Raw Data', 'Peak (Fit) Values', 'Exponential Fit', 'Algebraic Fit');
%axis([0 t_cutoff 0.9*min(P) 1.1*max(P)]);
axis([0 max(t) 0.9*min(P) 1.1*max(P)]);
print(strcat('Pressure_vs_Time_',simString), '-dpng');
close(fig);


norm_power = power/max(power);
fig = figure('Visible','off');
plot(freq, norm_power);
title(['Fourier Transform of Gas Pressure for Pore Width W=' num2str(W) 'nm and Impurity Diameter D=' num2str(d) 'nm'], 'Interpreter', 'LaTex', 'FontSize', 8 );
xlabel('Frequency, $f ~ (GHz)$','Interpreter','Latex');
ylabel('Power Spectral Density','Interpreter','latex');
axis([0 5*fundFreq 0 1]);
print(strcat('FFT_',simString), '-dpng');
close(fig);

%----------Outputs-------------
%OUTPUTS IN SAME VARIABLE STRUCTURE
varargout{1}.t = t;
varargout{1}.P = P;

%------------------------------end


end
