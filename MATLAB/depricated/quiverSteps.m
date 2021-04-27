function [] = quiverSteps(x,y,u,v)
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here
stepIndices = [1,6,51,101,501,1001,2001,2501,5001,10001];
%stepIndices = [1,6];
% xLow = 900;
% xUp = 1120;
% yLow = 900;
% yUp = 1100;

xLow = 900;
xUp = 1120;
yLow = 700;
yUp = 1320;

nSteps = max(size(stepIndices));
for n=1:1:nSteps
    stepIndex = stepIndices(n);
    quiverStep(stepIndex,x,y,u(:,:,stepIndex),v(:,:,stepIndex),xLow,xUp,yLow,yUp,1);
end

end

