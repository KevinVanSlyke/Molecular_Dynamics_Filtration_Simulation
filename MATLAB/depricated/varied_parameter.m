function [variedPar] = varied_parameter(parVars, parValList)
%UNTITLED10 Summary of this function goes here
%   Detailed explanation goes here
nPar = size(parVars,2);
for i = 1 : 1 : nPar
    for j = 1 : 1 : size(parValList(i,2))-1
        if parValList(i,j) ~= parValList(i,j+1)
            variedPar = parVars(i);
        end
    end
end

end

