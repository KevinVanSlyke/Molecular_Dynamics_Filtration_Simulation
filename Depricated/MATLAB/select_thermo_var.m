function [selectedDataAvg, selectedDataStd] = select_thermo_var(varNames, ensembleAvgVals, ensembleStdVals, selectedVarName)
%Takes data from first arguement and returns columns of data whose names
%match additional input arguements, returning 
nTypes = size(varNames,2);
nVals = size(ensembleAvgVals,1);
selectedDataAvg = zeros(nVals,1);
selectedDataStd = zeros(nVals,1);

for i = 1 : 1 : nTypes
    if selectedVarName == varNames(i)
        selectedDataAvg = ensembleAvgVals(:,i);
        selectedDataStd = ensembleStdVals(:,i);
        break;
    end
end    

end

