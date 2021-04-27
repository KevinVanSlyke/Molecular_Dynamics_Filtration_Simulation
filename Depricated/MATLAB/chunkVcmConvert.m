function [t,x,y,u,v] = chunkVcmConvert(vcmChunkData)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
nSteps = size(vcmChunkData,1);
nBinsX = 101;
nBinsY = 100;
t = zeros(nSteps,1);
x = zeros(nBinsX,nBinsY);
y = zeros(nBinsX,nBinsY);
u = zeros(nBinsX,nBinsY,nSteps);
v = zeros(nBinsX,nBinsY,nSteps);
for n=1:1:nSteps
    t(n)=(n-1)*1000/200;
    for k=1:1:10100
        i=floor(k/100)+1;
        j=mod(k,100);
        if j == 0
            i = i-1;
            j = 100;
        end
        u(i,j,n)=vcmChunkData(n,k,1);
        v(i,j,n)=vcmChunkData(n,k,2);
        if n == 1
            x(i,j)=20*(i-1)+10;
            y(i,j)=20*(j-1)+10;
        end
    end
end
clear vcmChunkData i j k n;
end

