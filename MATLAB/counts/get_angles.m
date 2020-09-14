function [lowTheta,upTheta,centerTheta] = get_angles(orificeIndices, x)

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
        centerTheta(ii,jj) = rad2deg(atan((j-upperCenter)/(i-rightEdge)));
    end
end

end