function [t,x,y,u,v] = chunkConvert(vcmChunkData, chunkFileName)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

% fileParts = strsplit(chunkFileName, '.');
% nameParts = strsplit(fileParts{1,1}, '_');
% outputName = 'mesh';
% for i=1:1:size(nameParts,2)
%     outputName = strcat(outputName, '_', nameParts{1,i});
% end

% nSteps = size(vcmChunkData,1);
nSteps = 300;
% nBinsX = 102;
nBinsX = 1002;
nBinsY = 100;
t = zeros(nSteps,1);
x = zeros(nBinsX,nBinsY);
y = zeros(nBinsX,nBinsY);
u = zeros(nBinsX,nBinsY,nSteps);
v = zeros(nBinsX,nBinsY,nSteps);
for n=1:1:nSteps
    t(n)=(n-1)*1000/200;
    for k=1:1:nBinsX*nBinsY
        i=floor(k/100)+1;
%         i=floor(k/1000)+1;
        j=mod(k,100);
%         j=mod(k,1000);
        if j == 0
            i = i-1;
%             j = 100;
            j = 1000;
        end
        u(i,j,n)=vcmChunkData(n,k,1);
        v(i,j,n)=vcmChunkData(n,k,2);
        if n == 1
            x(i,j)=20*(i-1)+10;
            y(i,j)=20*(j-1)+10;
        end
    end
end
clear vcmChunkData;
% save(strcat(outputName, '.mat'), 't', 'x', 'y', 'u', 'v');
end

