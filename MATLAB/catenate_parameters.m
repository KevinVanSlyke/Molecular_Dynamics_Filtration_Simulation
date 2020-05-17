function [parString] = catenate_parameters(parVars,parVals)
%UNTITLED11 Summary of this function goes here
%   Detailed explanation goes here
nPars = size(parVars,2);
parString = "";
for i = 1 : 1 : nPars 
    parString = strcat(parString, num2str(parVals(1,i)), parVars(1,i));
    if i < nPars
        parString = strcat(parString, '_');
    end
end
end

