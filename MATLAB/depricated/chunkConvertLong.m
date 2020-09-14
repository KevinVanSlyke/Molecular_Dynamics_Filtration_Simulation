function [t,x,y,u,v] = chunkConvert(vcmChunkData, chunkFileName)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

% fileParts = strsplit(chunkFileName, '.');
% nameParts = strsplit(fileParts{1,1}, '_');
% outputName = 'mesh';
% for i=1:1:size(nameParts,2)
%     outputName = strcat(outputName, '_', nameParts{1,i});
% end


% nSteps = 11;
% nSteps = 101;
% nSteps = 301;
nSteps = size(vcmChunkData,1);

%Zoomed chunk output
% nBinsX = 30;
% nBinsY = 30;

%Standard domain full chunk output
% nBinsX = 102;
% nBinsY = 100;

%Long domain full chunk output
nBinsX = 1002;
nBinsY = 100;

nBins = nBinsX*nBinsY;
t = zeros(nSteps,1);
x = zeros(nBinsX,nBinsY);
y = zeros(nBinsX,nBinsY);
u = zeros(nBinsX,nBinsY,nSteps);
v = zeros(nBinsX,nBinsY,nSteps);
for n=1:1:nSteps
    t(n)=(n-1)*1000/200;
    for k=1:1:nBins
%         i=floor(k/30)+1;
%         i=floor(k/100)+1;
        i=floor(k/1000)+1;
%         j=mod(k,30);
        j=mod(k,100);
%         j=mod(k,1000);
        if j == 0
            i = i-1;
%             j = 30;
            j = 100;
%             j = 1000;
        end
%         fprintf(num2str(k));
%         fprintf('\n');

        u(i,j,n)=vcmChunkData(n,k,1);
        v(i,j,n)=vcmChunkData(n,k,2);
        if n == 1
            x(i,j)=20*(i-1)+10;
            y(i,j)=20*(j-1)+10;     
%             x(i,j)=20*(i-1)+800;
%             y(i,j)=20*(j-1)+700;
        end
    end
end
clear vcmChunkData;
% save(strcat(outputName, '.mat'), 't', 'x', 'y', 'u', 'v');
end

