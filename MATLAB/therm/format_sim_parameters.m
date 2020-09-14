function [parNames, parVars, parVals] = format_sim_parameters(simString)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
simPars = strsplit(simString, '_');
nPars = size(simPars,2);

%Format is assumed to be W -> D -> L -> F -> S -> H
for i = 1 : 1 : nPars
    nChar = size(simPars,2);
    parVals(i) = str2double(simPars{1,i}(1,1:nChar-1));
    parVars(i) = convertCharsToStrings(simPars{1,i}(1,nChar));
    if parVars(i) == 'W'
        parNames(i) = "Orifice Width";
    elseif parVars(i) == 'D'
        parNames(i) = "Impurity Diameter";
    elseif parVars(i) == 'L'
        parNames(i) = "Filter Thickness";
    elseif parVars(i) == 'F'
        parNames(i) = "Orifice Separation";
    elseif parVars(i) == 'S'
        parNames(i) = "Filter Spacing"; 
    elseif parVars(i) == 'H'
        parNames(i) = "Orifice Offset";
    end
end

