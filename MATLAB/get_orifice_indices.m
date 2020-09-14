function [orificeIndices] = get_orifice_indices(countA)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
countSum = sum(countA,3);
% edgeDiff = mean(countSum,'all')/2;
edgeDiff = 500;
nOrifice = 0;
orificeIndices = zeros(2,2,1);

for i = 2:1:size(countA,1)
    if ((countSum(i,1) < edgeDiff) && (countSum(i-1,1) > edgeDiff))
        for j = 2:1:size(countA,2)
            if ((countSum(i,j) > edgeDiff) && (countSum(i,j-1) < edgeDiff))
                nOrifice = nOrifice+1;   
                orificeIndices(1,:,nOrifice) = [i j];
            elseif ((countSum(i,j) < edgeDiff) && (countSum(i,j-1) > edgeDiff))
                orificeIndices(2,2,nOrifice) = j-1;
            end
        end
    elseif ((countSum(i,1) > edgeDiff) && (countSum(i-1,1) < edgeDiff))
        orificeIndices(2,1,nOrifice) = i-1;
    end
end

for k=1:1:size(orificeIndices,3)
    if orificeIndices(2,1,k) == 0
        orificeIndices(2,1,k) = orificeIndices(2,1,k+1);
    end
end

end
