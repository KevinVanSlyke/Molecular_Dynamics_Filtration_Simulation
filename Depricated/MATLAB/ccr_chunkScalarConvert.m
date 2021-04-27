function [t,x,y,meshData] = ccr_chunkScalarConvert(chunkData, nBinsX, nBinsY)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

% fileParts = strsplit(chunkFileName, '.');
% nameParts = strsplit(fileParts{1,1}, '_');
% outputName = 'mesh';
% for i=1:1:size(nameParts,2)
%     outputName = strcat(outputName, '_', nameParts{1,i});
% end

%Standard domain full chunk output
nSteps = size(chunkData,1);

% nBinsX = 102;
% nBinsY = 100;
nBins = nBinsX*nBinsY;
t = zeros(nSteps,1);
x = zeros(nBinsX,nBinsY);
y = zeros(nBinsX,nBinsY);
meshData = zeros(nBinsX,nBinsY,nSteps);

for n=1:1:nSteps
    t(n)=(n-1)*1000/200;
    for k=1:1:nBins
%         i=floor(k/30)+1;
        i=floor(k/nBinsY)+1;
%         i=floor(k/1000)+1;
%         j=mod(k,30);
        j=mod(k,nBinsY);
%         j=mod(k,1000);
        if j == 0
            i = i-1;
%             j = 30;
            j = nBinsY;
%             j = 1000;
        end
%         fprintf(num2str(k));
%         fprintf('\n');

        meshData(i,j,n)=chunkData(n,k,1);
        if n == 1
            x(i,j)=20*(i-1);
            y(i,j)=20*(j-1);     
%             x(i,j)=20*(i-1)+800;
%             y(i,j)=20*(j-1)+700;
        end
    end
end
clear chunkData i j k n;
% save(strcat(outputName, '.mat'), 't', 'x', 'y', 'count');
end

