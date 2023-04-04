function [orificeIndices] = get_orifice_indices(countA)
%Returns matrix indices of orifice corners from the argon count mesh
%   [orificeIndices] = get_orifice_indices(countA)
%   Sweeps over full time summed argon count and tags indices with a drop
%   or raise over cutoff value as an orifice edge.
%   Orifice idices are stored with x values in colum 1, y in colum 2, lows
%   in row 1, highs in row 2:
%   xlow=(1,1), xhi=(2,1), ylo=(1,2), yhi=(2,2)

debug = 0;

countSum = sum(countA,3);
% edgeDiff = mean(countSum,'all')/2;
edgeDiff = 200;
nOrifice = 0;
orificeIndices = zeros(2,2,1);

for i = 2:1:size(countA,1)
    if debug == 1
        disp("i="+num2str(i)+newline+"count(i-1,1)="+num2str(countSum(i-1,1))+newline+"count(i,1)="+num2str(countSum(i,1)));
    end
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
