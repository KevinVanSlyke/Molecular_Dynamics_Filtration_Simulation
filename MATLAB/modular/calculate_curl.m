function [curlV] = calculate_curl(t,x,y,uA,vA)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

uA(isnan(uA)) = 0;
vA(isnan(vA)) = 0;
u = uA;
v = vA;
% u = (uA.*countA+uI.*countI)./(countA+countI);
% v = (vA.*countA+vI.*countI)./(countA+countI);

xTotal = size(x,1);
yTotal = size(y,2);
tTotal=size(t,1);
% maxT=200;

curlV = zeros(xTotal,yTotal,tTotal);
for i=1:1:tTotal
    curlV(:,:,i) = curl(u(:,:,i),v(:,:,i));
end

% minCurl = min(curlV,[],'all');
% maxCurl = max(curlV,[],'all');
% normCurl = curlV/maxCurl;
save('angularVel.mat', 't', 'x', 'y', 'curlV');


end