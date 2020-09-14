function [lowTheta,upTheta,centeredX,centeredY] = get_angles_centeredEdges(orificeIndices, x, y)
middleY = orificeIndices(2,2,2)-1+(orificeIndices(1,2,3) - orificeIndices(2,2,2))/2;
indxHalfWidth = (orificeIndices(2,2,2)-orificeIndices(1,2,2))/2;
lowerCenter = orificeIndices(2,2,2)-indxHalfWidth;
upperCenter = orificeIndices(2,2,3)-indxHalfWidth;
rightEdge =  orificeIndices(2,1,2);
ii=0;
for i = rightEdge+1:1:size(x,1)
    ii=ii+1;
    ji=0;
    for j = 1:1:size(x,2)
        ji=ji+1;
        lowTheta(ii,ji) = rad2deg(atan((j-lowerCenter)/(i-rightEdge)));
        upTheta(ii,ji) = rad2deg(atan((j-upperCenter)/(i-rightEdge)));
    end
end
centeredY = y(1,:) - 20*middleY;
centeredX = x(1:size(lowTheta,1),:)+10;
end