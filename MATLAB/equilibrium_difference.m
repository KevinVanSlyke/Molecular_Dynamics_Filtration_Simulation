function [equibVal, varAvgDiff, thermalValStd] = equilibrium_difference(steps, varAvg)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
nMax = max(size(steps));
equibVal = 0;
count = 0;
for k = round(nMax*0.9,0) : 1 : nMax
    equibVal = equibVal + varAvg(k); %LJ Dimensionless
    count = count + 1;
end

%    thermalValStd = std(varAvg(round(n_max*0.9,0):n_max))*epsilon/sigma^(3)*10^(-6); %kJoules/meter^3
%    varAvg_diff = (varAvg - thermalVal)*epsilon/sigma^(3)*10^(-6); %kJoules/meter^3

equibVal = equibVal/count; %LJ Dimensionless
varAvgDiff = (varAvg - equibVal); %LJ Dimensionless
thermalValStd = std(varAvg(round(nMax*0.9,0):nMax)); %LJ Dimensionless

end

