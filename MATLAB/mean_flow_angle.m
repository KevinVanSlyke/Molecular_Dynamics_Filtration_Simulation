function [fullMeanPhi,earlyMeanPhi,dataLabels] = mean_flow_angle(phiAValues,phiIValues,regionLabels, separation, dVal, tStart, tEnd)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here

regionLabels = regionLabels';
fullMeanAPhi = mean(phiAValues,3)';
earlyMeanAPhi = mean(phiAValues(:,1,tStart:tEnd),3)';
if dVal ~= 1
    fullMeanIPhi = mean(phiIValues,3)';
    earlyMeanIPhi = mean(phiIValues(:,1,tStart:tEnd),3)';
else
    fullMeanIPhi = NaN(1,10);
    earlyMeanIPhi = NaN(1,10);
end
fullMeanPhi = [separation, dVal, fullMeanAPhi, fullMeanIPhi];
earlyMeanPhi = [separation, dVal, earlyMeanAPhi, earlyMeanIPhi];
dataLabels(1:2) = ["separation", "impurity"];
for i=3:1:12
    dataLabels(i) = strcat("Argon ",regionLabels(i-2));
end
for i=13:1:22
    dataLabels(i) = strcat("Impurity ",regionLabels(i-12));
end
end

