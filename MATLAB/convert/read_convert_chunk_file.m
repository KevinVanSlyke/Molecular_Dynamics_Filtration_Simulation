function [] = read_convert_chunk_file(simString, nBinsX, nBinsY, particleType, dataType)

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
    chunkFile=strcat(dataType,'_', simString, '.chunk');
else
    chunkFile=strcat(particleType,'_',dataType,'_', simString, '.chunk');
end

[chunkData] = read_chunk(chunkFile);
if dataType == 'vcm'
    [t,x,y,u,v] = chunkVectorConvert(chunkData, nBinsX, nBinsY);
elseif dataType == 'temp'
    [t,x,y,temp] = chunkScalarConvert(chunkData, nBinsX, nBinsY);
elseif dataType == 'count'
    [t,x,y,count] = chunkScalarConvert(chunkData, nBinsX, nBinsY);
elseif dataType == 'internalTemp' || dataType == 'tempCom'
    [t,x,y,internalTemp] = chunkScalarConvert(chunkData, nBinsX, nBinsY);
end
    clear chunkData
    save(strcat(particleType,'_',dataType,'_Mesh.mat'),'simString','t','x','y','u','v','temp','count','internalTemp');
end