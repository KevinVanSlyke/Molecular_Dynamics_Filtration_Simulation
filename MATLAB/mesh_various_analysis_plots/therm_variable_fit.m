function [fitCurve, fitGoodness] = therm_variable_fit( time, varAvg )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


% varWeights = 1./varStd.^2;

[polyFitCurve, polyFitGoodness, polyFitOutput] = fit(time,varAvg,'poly1');%,'Weights', varWeights, 'DiffMaxChange', 1, 'DiffMinChange', 10^(-8), 'MaxFunEvals', 10000, 'MaxIter', 10000, 'TolFun', 10^(-20), 'TolX', 10^(-20) );
[powFitCurve, powFitGoodness, powFitOutput] = fit(time(2:size(time)),varAvg(2:size(time)),'power1');%,'Weights', varWeights, 'DiffMaxChange', 1, 'DiffMinChange', 10^(-8), 'MaxFunEvals', 10000, 'MaxIter', 10000, 'TolFun', 10^(-20), 'TolX', 10^(-20) );
[expFitCurve, expFitGoodness, expFitOutput] = fit(time,varAvg,'exp1');%,'Weights',varWeights, 'DiffMaxChange', 1, 'DiffMinChange', 10^(-8), 'MaxFunEvals', 10000, 'MaxIter', 10000, 'TolFun', 10^(-20), 'TolX', 10^(-20) );
% [gaussFitCurve, gaussFitGoodness, gaussFitOutput] = fit(time,varAvg,'gauss1');%,'Weights',varWeights, 'DiffMaxChange', 1, 'DiffMinChange', 10^(-8), 'MaxFunEvals', 10000, 'MaxIter', 10000, 'TolFun', 10^(-20), 'TolX', 10^(-20) );

% expShiftFit = fittype('expShiftLine(x,a,b,c)');
% [expShiftFitCurve, expShiftFitGoodness, expShiftFitOutput] = fit(time,varAvg,expShiftFit);%,'Weights',varWeights, 'DiffMaxChange', 1, 'DiffMinChange', 10^(-8), 'MaxFunEvals', 10000, 'MaxIter', 10000, 'TolFun', 10^(-20), 'TolX', 10^(-20) );
% genExpFit = fittype('genExpLine(x,a,b,c,d)');
% [genExpFitCurve, genExpFitGoodness, genExpFitOutput] = fit(time,varAvg,genExpFit);%,'Weights',varWeights ,'DiffMaxChange', 1, 'DiffMinChange', 10^(-8), 'MaxFunEvals', 10000, 'MaxIter', 10000, 'TolFun', 10^(-20), 'TolX', 10^(-20) );
sigFit = fittype('sigmoidLine(x,a,b,c)');
[sigFitCurve, sigFitGoodness, sigFitOutput] = fit(time,varAvg,sigFit, 'StartPoint',[100000,-1,1]);%,'Weights',varWeights, 'DiffMaxChange', 1, 'DiffMinChange', 10^(-8), 'MaxFunEvals', 10000, 'MaxIter', 10000, 'TolFun', 10^(-20), 'TolX', 10^(-20) );

adjR2Diff = [1-polyFitGoodness.adjrsquare; 1-powFitGoodness.adjrsquare; 1-expFitGoodness.adjrsquare; 1-sigFitGoodness.adjrsquare];
% adjR2Diff = [1-polyFitGoodness.adjrsquare; 1-powFitGoodness.adjrsquare; 1-expFitGoodness.adjrsquare; 1-expShiftFitGoodness.adjrsquare; 1-genExpFitGoodness.adjrsquare; 1-sigFitGoodness.adjrsquare];
[aRdiff, ind] = min(adjR2Diff);
if ind == 1
    fitCurve = polyFitCurve;
    fitGoodness = polyFitGoodness;    
elseif ind == 2
    fitCurve = powFitCurve;
    fitGoodness = powFitGoodness;
elseif ind == 3
    fitCurve = expFitCurve;
    fitGoodness = expFitGoodness;
% elseif ind == 4
%     fitCurve = expShiftFitCurve;
%     fitGoodness = expShiftFitGoodness;
% elseif ind == 5
%     fitCurve = genExpFitCurve;
%     fitGoodness = genExpFitGoodness;
% elseif ind == 4
%     fitCurve = gaussFitCurve;
%     fitGoodness = gaussFitGoodness;
elseif ind == 4
    fitCurve = sigFitCurve;
    fitGoodness = sigFitGoodness;
end

end

