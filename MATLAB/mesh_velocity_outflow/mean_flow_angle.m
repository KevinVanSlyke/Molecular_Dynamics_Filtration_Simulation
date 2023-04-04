function [dataLabels,fullMeanPhi,earlyMeanPhi] = mean_flow_angle(phiAValues,phiIValues,regionLabels, separation, dVal, tStart, tEnd)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
phiAValues = reshape(phiAValues,size(phiAValues,2),size(phiAValues,3));
phiIValues = reshape(phiIValues,size(phiIValues,2),size(phiIValues,3));
regionLabels = regionLabels';
fullMeanAPhi = mean(phiAValues,2)';
earlyMeanAPhi = mean(phiAValues(:,tStart:tEnd),2)';
if dVal ~= 1
    fullMeanIPhi = mean(phiIValues,2)';
    earlyMeanIPhi = mean(phiIValues(:,tStart:tEnd),2)';
else
    fullMeanIPhi = NaN(1,10);
    earlyMeanIPhi = NaN(1,10);
end
fullMeanPhi = [separation, dVal, fullMeanAPhi, fullMeanIPhi];
earlyMeanPhi = [separation, dVal, earlyMeanAPhi, earlyMeanIPhi];
dataLabels(1:2) = ["Filter Separation", "Impurity Diameter" ];
% dataLabels(1:2) = ["Orifice Spacing",  "Impurity Diameter" ];
for i=3:1:12
    dataLabels(i) = strcat("Argon, ",regionLabels(i-2));
end
for i=13:1:22
    dataLabels(i) = strcat("Impurity, ",regionLabels(i-12));
end
end

