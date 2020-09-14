function [argonCountSlice,impurityCountSlice,centeredX,centeredY] = get_count_slice(fileDir,rootName,sliceIndx)
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
[lowTheta,upTheta,centeredX,centeredY] = get_angles_centeredEdges(orificeIndices, x, y);

if dVal == 1
    [argonEdgeCounts] = get_argon_count_distance(countA);
    argonCountSlice(:,:) = argonEdgeCounts(sliceIndx,:,:);
    impurityCountSlice = 0;
else
    [argonEdgeCounts,impurityEdgeCounts] = get_particle_count_distance(countA, countI);
    argonCountSlice(:,:) = argonEdgeCounts(sliceIndx,:,:);
    impurityCountSlice(:,:) = impurityEdgeCounts(sliceIndx,:,:);
end
lowTheta = lowTheta(sliceIndx,:);
upTheta = upTheta(sliceIndx,:);
centeredX = centeredX(sliceIndx,1);
end

    
    