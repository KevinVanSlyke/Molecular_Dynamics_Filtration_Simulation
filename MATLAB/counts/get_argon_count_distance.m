function [argonEdgeCounts] = get_argon_count_distance(countA)
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here
argonEdgeCounts = countA(size(countA,1)-10:size(countA,1),:,:);
% argonEdgeTotal = sum(argonEdgeCounts,3);

end

