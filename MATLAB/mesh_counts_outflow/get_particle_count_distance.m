function [argonEdgeCounts,impurityEdgeCounts] = get_particle_count_distance(countA, countI)
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here
argonEdgeCounts = countA(size(countA,1)-10:size(countA,1),:,:);
% argonEdgeTotal = sum(argonEdgeCounts,3);

if size(countI,1) > 1
    impurityEdgeCounts = countI(size(countI,1)-10:size(countI,1),:,:);
% impurityEdgeTotal = sum(impurityEdgeCounts,3);
else
    impurityEdgeCounts = 0;
end

end

