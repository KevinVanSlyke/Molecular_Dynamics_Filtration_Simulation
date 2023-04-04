function [ tauAvg, tauStd, bestFitCurve, bestFitGoodness, expShiftFitCurve, expShiftFitGoodness, tPeaks, varPeaks, varPeakStds] = ensemble_variable_fit( time, varAvg, varStd, fundSampleFreq, plotFit )
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

minPeakDistance = round(7/8*(1/fundSampleFreq),0);
%minPeakDistance = 300;

% tPeaks = [];
% varPeakStds = [];
% varPeakWeights = [];
%[varPeakDiff, peakInd] = findpeaks(varAvgDiff,'MinPeakDistance',minPeakDistance);
%nPeaks = max(size(varPeakDiff));

[varPeaks, peakInd] = findpeaks(varAvg,'MinPeakDistance',minPeakDistance);
nPeaks = max(size(varPeaks));
tPeaks = zeros(nPeaks,1);
varPeakWeights = [];
varPeakStds = zeros(nPeaks,1);
% varPeakWeights = zeros(nPeaks,1); 
for k = 1 : 1 : nPeaks
    tPeaks(k,1) = time(peakInd(k)); 
    %varPeaks(k,1) = varAvg(peakInd(k));
    varPeakStds(k,1) = varStd(peakInd(k));
    varPeakWeights(k,1) = varStd(peakInd(k))^(-2);
end

if varPeakWeights(1,1) == inf
    varPeakWeights = [];
end
tauEst = 10000;
expCoefEst = -1/tauEst;
baseOptions = fitoptions('Weights', varPeakWeights,'Method', 'NonlinearLeastSquares', 'DiffMaxChange', 1, 'MaxFunEvals', 10000, 'MaxIter', 10000, 'TolFun', 10^(-20), 'TolX', 10^(-20));
% expOptions = fitoptions(baseOptions, 'StartPoint', [pMax, expCoefEst]);
% if size(varPeakWeights,1) > 2
%     powOptions = fitoptions(baseOptions,'Weights', varPeakWeights(2:size(varPeakWeights)), 'StartPoint', [1, 1]);
% else
%     powOptions = fitoptions(baseOptions, 'StartPoint', [1, 1]);
% end
expShiftOptions = fitoptions(baseOptions, 'StartPoint', [equibVal, expCoefEst, pMax-equibVal]);
% genExpOptions = fitoptions(baseOptions, 'StartPoint', [equibVal, expCoefEst, pMax-equibVal, 0]);
% sigOptions = fitoptions(baseOptions, 'StartPoint', [1, 1, 1]);
% gaussOptions = fitoptions(baseOptions, 'StartPoint', [1, 1, 1]);

% [poly1FitCurve, poly1FitGoodness, poly1FitOutput] = fit(tPeaks,varPeaks,'poly1','Weights', varPeakWeights);
% [exp1FitCurve, exp1FitGoodness, expFitOutput] = fit(tPeaks,varPeaks,'exp1',expOptions );
% [powFitCurve, powFitGoodness, powFitOutput] = fit(tPeaks(2:size(tPeaks)),varPeaks(2:size(tPeaks)),'power1',powOptions);
expShiftFit = fittype('expShiftLine(x,a,b,c)');
[expShiftFitCurve, expShiftFitGoodness, expShiftFitOutput] = fit(tPeaks,varPeaks,expShiftFit,expShiftOptions );
% [expShiftFitCurveRand, expShiftFitGoodnessRand, expShiftFitOutputRand] = fit(tPeaks,varPeaks,expShiftFit,baseOptions );
% genExpFit = fittype('genExpLine(x,a,b,c,d)');
% [genExpFitCurve, genExpFitGoodness, genExpFitOutput] = fit(tPeaks,varPeaks,genExpFit,genExpOptions);
% [genExpFitCurveRand, genExpFitGoodnessRand, genExpFitOutputRand] = fit(tPeaks,varPeaks,genExpFit,baseOptions );
% [gauss1FitCurve, gauss1FitGoodness, gauss1FitOutput] = fit(tPeaks,varPeaks,'gauss1',gaussOptions );
% sigFit = fittype('sigmoidLine(x,a,b,c)');
% [sigFitCurve, sigFitGoodness, sigFitOutput] = fit(tPeaks,varPeaks,sigFit,sigOptions );
% [sigFitCurveRand, sigFitGoodnessRand, sigFitOutputRand] = fit(tPeaks,varPeaks,sigFit,baseOptions );

% fitCurves = ...
% [poly1FitCurve;...
% exp1FitCurve;...
% exp1FitCurve;...
% expFitCurveRand;...
% powFitCurve;...
% expShiftFitCurve;...
% genExpFitCurve;...
% gauss1FitCurve;...
% sigFitCurve];
% 
% adjRSqrDiff = ...
% [1-poly1FitGoodness.adjrsquare;...
% 1-exp1FitGoodness.adjrsquare;...
% 1-powFitGoodness.adjrsquare;...
% 1-expShiftFitGoodness.adjrsquare;...
% 1-genExpFitGoodness.adjrsquare;...
% 1-gauss1FitGoodness.adjrsquare;...
% 1-sigFitGoodness.adjrsquare];
% 
% fitGoodnesses = ...
% [poly1FitGoodness;...
% exp1FitGoodness;...
% pow1FitGoodness;...
% expShiftFitGoodness;...
% genExpFitGoodness;...
% gauss1FitGoodness;...
% sigFitGoodness];

% adjR2Diff(:) = 1 - fitGoodnesses(:).adjrsquare;
% adjR2Diff(:) = 1 - expShiftFitGoodness(:).adjrsquare;

% [minAdjR2Diff, bestFitIndx] = min(adjRSqrDiff);
% bestFitCurve = fitCurves(bestFitIndx);
% bestFitGoodness = fitGoodnesses(bestFitIndx);

% [sigFitCurve, sigFitGoodness, sigFitOutput] = fit(tPeaks,varPeaks,sigFit,'Weights',varPeakWeights, 'StartPoint', [equibVal, pMax-equibVal, -0.0005, 2000], 'DiffMaxChange', 1, 'DiffMinChange', 10^(-8), 'MaxFunEvals', 10000, 'MaxIter', 10000, 'TolFun', 10^(-20), 'TolX', 10^(-20) );

expShiftFitCoef = coeffvalues(expShiftFitCurve);
expShiftCoefConfInt = confint(expShiftFitCurve);

%Upper and lower confidence are 95% bounds
ampAvg = expShiftFitCoef(1);
ampUpConf = expShiftCoefConfInt(1,1);
ampLowConf = expShiftCoefConfInt(2,1);
ampStd = abs((ampUpConf - ampLowConf))/3.92;

eqAvg = expShiftFitCoef(3);
eqUpConf = expShiftCoefConfInt(1,1);
eqLowConf = expShiftCoefConfInt(2,1);
eqStd = abs((eqUpConf - eqLowConf))/3.92;

tauAvg = 1/expShiftFitCoef(2); 
tauUpConf = 1/expShiftCoefConfInt(1,2); 
tauLowConf = 1/expShiftCoefConfInt(2,2); 
tauStd = abs((tauUpConf - tauLowConf))/3.92;

expRSquare = expShiftFitGoodness.rsquare;
expAdjRSquare = expShiftFitGoodness.adjrsquare;
expRMSE = expShiftFitGoodness.rmse;

%expFitLine = feval(expFitCurve, time) + equibVal; %LJ Dimensionless

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

