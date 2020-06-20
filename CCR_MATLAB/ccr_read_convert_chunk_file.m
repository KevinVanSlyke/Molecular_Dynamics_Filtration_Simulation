function [] = ccr_read_convert_chunk_file(simString, nBinsX, nBinsY, particleType, dataType)

disp('simString')
disp(simString)
disp(class(simString))
simString = convertCharsToStrings(simString);

disp('nBinsX')
disp(nBinsX)
disp(class(nBinsX))

disp('nBinsY')
disp(nBinsY)
disp(class(nBinsY))

disp('particleType')
disp(particleType)
disp(class(particleType))
particleType = convertCharsToStrings(particleType);

disp('dataType')
disp(dataType)
disp(class(dataType))
dataType = convertCharsToStrings(dataType);
disp(class(dataType))

if particleType == 'pure'
    chunkFile=strcat(dataType,'_', simString, '_0T_r0.chunk');
else
    chunkFile=strcat(particleType,'_',dataType,'_', simString, '_0T_r0.chunk');
end

[chunkData] = ccr_read_chunk(chunkFile);
if dataType == 'vcm'
    [t,x,y,uA,vA] = ccr_chunkVectorConvert(chunkData, nBinsX, nBinsY);
elseif dataType == 'temp'
    [t,x,y,temp] = ccr_chunkScalarConvert(chunkData, nBinsX, nBinsY);
elseif dataType == 'count'
    [t,x,y,count] = ccr_chunkScalarConvert(chunkData, nBinsX, nBinsY);
end
    save(strcat(particleType,'_',dataType,'_Mesh.mat'));
end