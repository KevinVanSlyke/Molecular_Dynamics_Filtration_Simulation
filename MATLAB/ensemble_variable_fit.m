function [ tauAvg, tauStd, expFitCurve, tPeaks, varPeaks, varPeakStds, expRSquare, expAdjRSquare, expRMSE ] = ensemble_variable_fit( time, varAvg, varStd, fundSampleFreq, plotFit )
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

%[equibVal, varAvgDiff, thermalValStd] = equilibrium_difference(time, varAvg);
[equibVal, ~, ~] = equilibrium_difference(time, varAvg);
pMax = max(varAvg);

minPeakDistance = round(3/4*(1/fundSampleFreq),0);
%minPeakDistance = 300;

% tPeaks = [];
% varPeakStds = [];
% varPeakWeights = [];
%[varPeakDiff, peakInd] = findpeaks(varAvgDiff,'MinPeakDistance',minPeakDistance);
%nPeaks = max(size(varPeakDiff));

[varPeaks, peakInd] = findpeaks(varAvg,'MinPeakDistance',minPeakDistance);
nPeaks = max(size(varPeaks));
tPeaks = zeros(nPeaks,1);
varPeakStds = zeros(nPeaks,1);
varPeakWeights = zeros(nPeaks,1);
for k = 1 : 1 : nPeaks
    tPeaks(k,1) = time(peakInd(k)); 
    %varPeaks(k,1) = varAvg(peakInd(k));
    varPeakStds(k,1) = varStd(peakInd(k));
    varPeakWeights(k,1) = varStd(peakInd(k))^(-2);
end

expFit = fittype('expShiftLine(x,a,b,c)');
if varPeakWeights ~= Inf
    [expFitCurve, expFitGoodness, expFitOutput] = fit(tPeaks,varPeaks,expFit,'Weights',varPeakWeights,'StartPoint', [equibVal, pMax-equibVal, 0.0005], 'DiffMaxChange', 1, 'DiffMinChange', 10^(-8), 'MaxFunEvals', 10000, 'MaxIter', 10000, 'TolFun', 10^(-20), 'TolX', 10^(-20) );
else
    [expFitCurve, expFitGoodness, expFitOutput] = fit(tPeaks,varPeaks,expFit,'StartPoint', [equibVal, pMax-equibVal, 0.0005], 'DiffMaxChange', 1, 'DiffMinChange', 10^(-8), 'MaxFunEvals', 10000, 'MaxIter', 10000, 'TolFun', 10^(-20), 'TolX', 10^(-20) );
end
%[expFitCurve, expFitGoodness, ~] = fit(tPeaks,varPeakDiff,'exp1');
%[expFitCurve, expFitGoodness, expFitOutput] = fit(tPeaks,varPeakDiff,'exp1','Weights',varPeakWeights, 'DiffMaxChange', 1, 'DiffMinChange', 10^(-8), 'MaxFunEvals', 10000, 'MaxIter', 10000, 'TolFun', 10^(-20), 'TolX', 10^(-20) );

expShiftFit = fittype('expShiftLine(x,a,b,c)');
%[expShiftFitCurve, expShiftFitGoodness, expShiftFitOutput] = fit(tPeaks,varPeaks,expshiftFit,'Weights',varPeakWeights,'StartPoint', [equibVal, pMax-equibVal, -0.0005, 2000], 'DiffMaxChange', 1, 'DiffMinChange', 10^(-8), 'MaxFunEvals', 10000, 'MaxIter', 10000, 'TolFun', 10^(-20), 'TolX', 10^(-20) );
genExpFit = fittype('genExpLine(x,a,b,c,d)');
%[genExpFitCurve, genExpFitGoodness, genExpFitOutput] = fit(tPeaks,varPeaks,genExpFit,'Weights',varPeakWeights, 'StartPoint', [equibVal, pMax-equibVal, -0.0005, 2000],'DiffMaxChange', 1, 'DiffMinChange', 10^(-8), 'MaxFunEvals', 10000, 'MaxIter', 10000, 'TolFun', 10^(-20), 'TolX', 10^(-20) );
sigFit = fittype('sigmoidLine(x,a,b,c)');

[sigFitCurve, sigFitGoodness, sigFitOutput] = fit(tPeaks,varPeaks,sigFit,'Weights',varPeakWeights, 'StartPoint', [equibVal, pMax-equibVal, -0.0005, 2000], 'DiffMaxChange', 1, 'DiffMinChange', 10^(-8), 'MaxFunEvals', 10000, 'MaxIter', 10000, 'TolFun', 10^(-20), 'TolX', 10^(-20) );

expFitCoef = coeffvalues(expFitCurve);
expCoefConfInt = confint(expFitCurve);

%Upper and lower confidence are 95% bounds
ampAvg = expFitCoef(2);
ampUpConf = expCoefConfInt(1,2);
ampLowConf = expCoefConfInt(2,2);
ampStd = abs((ampUpConf - ampLowConf))/3.92;

tauAvg = 1/expFitCoef(3); 
tauUpConf = 1/expCoefConfInt(1,3); 
tauLowConf = 1/expCoefConfInt(2,3); 
tauStd = abs((tauUpConf - tauLowConf))/3.92;

expRSquare = expFitGoodness.rsquare;
expAdjRSquare = expFitGoodness.adjrsquare;
expRMSE = expFitGoodness.rmse;

%expFitLine = feval(expFitCurve, time) + equibVal; %LJ Dimensionless

%genExpFit = fittype('genExpLine(x,a,b,c,d)');
%[genExpFitCurve, genExpFitGoodness, genExpFitOutput] = fit(tPeaks,varPeaks,genExpFit,'Weights',varPeakWeights, 'StartPoint', [equibVal, pMax-equibVal, 1/tauAvg, 2000],'DiffMaxChange', 1, 'DiffMinChange', 10^(-8), 'MaxFunEvals', 10000, 'MaxIter', 10000, 'TolFun', 10^(-20), 'TolX', 10^(-20) );

%expShiftFit = fittype('expShiftLine(x,a,b,c)');
%[expShiftFitCurve, expShiftFitGoodness, expShiftFitOutput] = fit(tPeaks,varPeaks,expShiftFit,'Weights',varPeakWeights,'StartPoint', [equibVal, pMax-equibVal, 1/tauAvg], 'DiffMaxChange', 1, 'DiffMinChange', 10^(-8), 'MaxFunEvals', 10000, 'MaxIter', 10000, 'TolFun', 10^(-20), 'TolX', 10^(-20) );

sigFit = fittype('sigmoidLine(x,a,b,c)');
[sigFitCurve, sigFitGoodness, sigFitOutput] = fit(tPeaks,varPeaks,sigFit,'Weights',varPeakWeights, 'StartPoint', [equibVal, pMax-equibVal, -1/tauAvg], 'DiffMaxChange', 1, 'DiffMinChange', 10^(-8), 'MaxFunEvals', 10000, 'MaxIter', 10000, 'TolFun', 10^(-20), 'TolX', 10^(-20) );

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

%cd('/home/Kevin/Documents/Dust_Data/Molecular/.../Figures');

%P_plot_peaks_dev = varPeakStds*epsilon/sigma^(3)*10^(-6); %kJoules/meter^3
%equibVal = equibVal*epsilon/sigma^(3)*10^(-6); %kJoules/meter^3

%----------Outputs-------------
%OUTPUTS IN SAME VARIABLE STRUCTURE


%------------------------------end


end

