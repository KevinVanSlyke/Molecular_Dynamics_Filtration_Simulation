function [edgeSumA,edgeSumI, centeredX, centeredY] = edge_particle_counts(countA, countI, orificeIndices, sliceIndx,  x, y)
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here
middleY = orificeIndices(2,2,2)-1+(orificeIndices(1,2,3) - orificeIndices(2,2,2))/2;
centeredY = y(1,:) - 20*middleY;
centeredX = x(orificeIndices(1,2,3):size(x,1))+10;

edgeCountA = countA(size(countA,1)-10:size(countA,1),:,:);
edgeSumA = sum(edgeCountA(sliceIndx,:,:),3);
if size(countI,1) > 1
    edgeCountI = countI(size(countI,1)-10:size(countI,1),:,:);
    edgeSumI = sum(edgeCountI(sliceIndx,:,:),3);
else
    edgeSumI = 0;
end

end

