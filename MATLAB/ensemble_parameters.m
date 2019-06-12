function [parNames, parVars, parVals] = ensemble_parameters(trialsDir)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
dirParts = strsplit(trialsDir,'/');
nDirParts = size(dirParts,2);
simDir = dirParts(nDirParts);
parString = simDir{1,1};
simPars = strsplit(parString, '_');
nPars = size(simPars,2);

%Format is assumed to be W -> D -> H -> F
for i = 1 : 1 : nPars
    nChar = size(simPars{1,i},2);
    parVals(i) = str2double(simPars{1,i}(1,1:nChar-1));
    parVars(i) = convertCharsToStrings(simPars{1,i}(1,nChar));
    if parVars(i) == 'W'
        parNames(i) = "Orifice Width";
    elseif parVars(i) == 'D'
        parNames(i) = "Impurity Diameter";
    elseif parVars(i) == 'H'
        parNames(i) = "Orifice Offset";
    elseif parVars(i) == 'F'
        parNames(i) = "Orifice Separation";
    end
end

