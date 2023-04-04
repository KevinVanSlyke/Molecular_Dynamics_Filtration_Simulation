function [orificeAverages] = get_orifice_averages(fileDir,rootName)

cd(fileDir);
fileList = dir(pwd);
for j=1:1:size(fileList,1)
    if endsWith(fileList(j).name,'.mat') && startsWith(fileList(j).name,'Mesh')
        load(fileList(j).name);
        break;
    end
end
[parNames, parVars, parVals] = ensemble_parameters(rootName);
for k=1:1:size(parVars,2)
    if strcmp(parVars(k),'D')
        dVal = parVals(k);
        break;
    end
end
[orificeIndices] = get_orifice_indices(countA);
for i = 1:1:size(orificeIndices,3)
    argonXVel(i,:) = mean(uA(orificeIndices(1,1,i):orificeIndices(2,1,i),orificeIndices(1,2,i):orificeIndices(2,2,i),:),[1 2]);
    argonCount(i,:) = mean(countA(orificeIndices(1,1,i):orificeIndices(2,1,i),orificeIndices(1,2,i):orificeIndices(2,2,i),:),[1 2]);
    argonTemp(i,:) = mean(tempA(orificeIndices(1,1,i):orificeIndices(2,1,i),orificeIndices(1,2,i):orificeIndices(2,2,i),:),[1 2]);
    argonInternalTemp(i,:) = mean(internalTempA(orificeIndices(1,1,i):orificeIndices(2,1,i),orificeIndices(1,2,i):orificeIndices(2,2,i),:),[1 2]);
    if dVal > 1
        impurityXVel(i,:) = mean(uI(orificeIndices(1,1,i):orificeIndices(2,1,i),orificeIndices(1,2,i):orificeIndices(2,2,i),:),[1 2]);
        impurityCount(i,:) = mean(countI(orificeIndices(1,1,i):orificeIndices(2,1,i),orificeIndices(1,2,i):orificeIndices(2,2,i),:),[1 2]);
        impurityTemp(i,:) = mean(tempI(orificeIndices(1,1,i):orificeIndices(2,1,i),orificeIndices(1,2,i):orificeIndices(2,2,i),:),[1 2]);
        impurityInternalTemp(i,:) = mean(internalTempI(orificeIndices(1,1,i):orificeIndices(2,1,i),orificeIndices(1,2,i):orificeIndices(2,2,i),:),[1 2]);
    else
        impurityXVel(i,:) = zeros(size(countA,3),1);
        impurityCount(i,:) = zeros(size(countA,3),1);
        impurityTemp(i,:) = zeros(size(countA,3),1);
        impurityInternalTemp(i,:) = zeros(size(countA,3),1);
    end
end
orificeAverages = [argonXVel; argonCount; argonTemp; argonInternalTemp; impurityXVel; impurityCount; impurityTemp; impurityInternalTemp];
end

    
    