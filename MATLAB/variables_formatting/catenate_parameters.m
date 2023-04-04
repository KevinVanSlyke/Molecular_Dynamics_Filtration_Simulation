function [parString] = catenate_parameters(parVars,parVals)
%Create string of parVals[i]parVars[i]_..._parVals[nPars][parVars[nPars]
nPars = size(parVars,2);
parString = "";
for i = 1 : 1 : nPars 
    parString = strcat(parString, num2str(parVals(1,i)), parVars(1,i));
    if i < nPars
        parString = strcat(parString, '_');
    end
end
end

