function [dataLabels, phiStatData] = Phi_vel_mean(phiAValues, phiIValues, separation, dVal, tStart, tEnd)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here

meanAPhi = mean(phiAValues(tStart:tEnd,:),1);
stdAPhi = std(phiAValues(tStart:tEnd,:),1);
if dVal ~= 1
    meanIPhi = mean(phiIValues(tStart:tEnd,:),1);
    stdIPhi = std(phiIValues(tStart:tEnd,:),1);
else
    meanIPhi = NaN(1,2);
    stdIPhi = NaN(1,2);
end

phiStatData = [separation, dVal, meanAPhi, stdAPhi, meanIPhi, stdIPhi];
dataLabels = ["Filter Separation", "Impurity Diameter", "meanAPhi_SL1", "meanAPhi_SL2", "stdAPhi_SL1", "stdAPhi_SL2", "meanIPhi_SL1", "meanIPhi_SL2", "stdIPhi_SL1", "stdIPhi_SL2"];

end

% fullMeanAPhi = mean(phiAValues,1);
% fullStdAPhi = std(phiAValues,1);
% earlyMeanAPhi = mean(phiAValues(tStart:tEnd,:),1);
% earlyStdAPhi = std(phiAValues(tStart:tEnd,:),1);
% lateMeanAPhi = mean(phiAValues(tEnd:max(size(t)),:),1);
% lateStdAPhi = std(phiAValues(tEnd:max(size(t)),:),1);
% if dVal ~= 1
%     fullMeanIPhi = mean(phiIValues,1);
%     fullStdIPhi = std(phiIValues,1);
%     earlyMeanIPhi = mean(phiIValues(tStart:tEnd,:),1);
%     earlyStdIPhi = std(phiIValues(tStart:tEnd,:),1);
%     lateMeanIPhi = mean(phiIValues(tEnd:max(size(t)),:),1);
%     lateStdIPhi = std(phiIValues(tEnd:max(size(t)),:),1);
% else
%     fullMeanIPhi = NaN(1);
%     fullStdIPhi = NaN(1);
%     earlyMeanIPhi = NaN(1);
%     lateMeanIPhi = NaN(1);
%     lateStdIPhi = NaN(1);
%     earlyStdIPhi = NaN(1);
% end

% phiStatData = [separation, dVal, fullMeanAPhi, fullStdAPhi, earlyMeanAPhi, earlyStdAPhi, lateMeanAPhi, lateStdAPhi, fullMeanIPhi, fullStdIPhi, earlyMeanIPhi, earlyStdIPhi, lateMeanIPhi, lateStdIPhi];
% fullPhi = [separation, dVal, fullMeanAPhi, fullMeanIPhi];
% earlyPhi = [separation, dVal, earlyMeanAPhi, earlyMeanIPhi];
% latePhi = [separation, dVal, lateMeanAPhi, lateMeanIPhi];
% dataLabels = ["Filter Separation", "Impurity Diameter", "fullMeanAPhi", "fullStdAPhi", "earlyMeanAPhi", "earlyStdAPhi", "lateMeanAPhi", "lateStdAPhi", "fullMeanIPhi", "fullStdIPhi", "earlyMeanIPhi", "earlyStdIPhi", "lateMeanIPhi", "lateStdIPhi"];


