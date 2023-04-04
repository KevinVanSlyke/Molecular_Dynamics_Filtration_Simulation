function [parNames, parVars, parVals] = ensemble_parameters(trialsDir)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
dirParts = strsplit(trialsDir,'\');
nDirParts = size(dirParts,2);
simDir = dirParts(nDirParts);
parString = simDir{1,1};
simPars = strsplit(parString, '_');
nPars = size(simPars,2);

%Format is assumed to be W -> D -> L -> F -> S -> H
for i = 1 : 1 : nPars
    nChar = size(simPars{1,i},2);
    parVals(i) = str2double(simPars{1,i}(1,1:nChar-1));
    parVars(i) = convertCharsToStrings(simPars{1,i}(1,nChar));
    if parVars(i) == 'W'
        parNames(i) = "Orifice Width";
    elseif parVars(i) == 'D'
        parNames(i) = "Impurity Diameter";
    elseif parVars(i) == 'L'
        parNames(i) = "Filter Thickness";
    elseif parVars(i) == 'S'
        parNames(i) = "Orifice Separation";
    elseif parVars(i) == 'F'
        parNames(i) = "Filter Spacing"; 
    elseif parVars(i) == 'H'
        parNames(i) = "Registry Shift";
    end
end
if nPars < 6
    parVals(6) = 0;
    parVars(6) = 'H';
    parNames(6) = "Orifice Offset";
end

