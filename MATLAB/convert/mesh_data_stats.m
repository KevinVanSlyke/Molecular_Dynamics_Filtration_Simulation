function [] = mesh_data_stats(simString,x,y,t,uA,vA,countA,tempA,internalTempA,uI,vI,countI,tempI,internalTempI,debug)

nTimes = max(size(t));
t = t(1:nTimes-1);
uMeanA = mean(uA(:,:,2:nTimes,:),4);
uStdA = std(uA(:,:,2:nTimes,:),0,4);
vMeanA = mean(vA(:,:,2:nTimes,:),4);
vStdA = std(vA(:,:,2:nTimes,:),0,4);
countMeanA = mean(countA(:,:,2:nTimes,:),4);
countStdA = std(countA(:,:,2:nTimes,:),0,4);
tempMeanA = mean(tempA(:,:,2:nTimes,:),4);
tempStdA = std(tempA(:,:,2:nTimes,:),0,4);
internalTempMeanA = mean(internalTempA(:,:,2:nTimes,:),4);
internalTempStdA = std(internalTempA(:,:,2:nTimes,:),0,4);
clear chunkData dataDir dirParts nDirParts simDir dataDirList nFiles n
if debug == 1
    uSingleA = uA(:,:,100,1);
    uUncA = uStdA(:,:,100);
    uAvgA = uMeanA(:,:,100);
end
%Save all mesh values including or excluding impurity data depending on if the
%simulation included impurity of diameter not equal to 1
if exist('uI','var') == 1
    uMeanI = mean(uI(:,:,2:nTimes,:),4);
    uStdI = std(uI(:,:,2:nTimes,:),0,4);
    vMeanI = mean(vI(:,:,2:nTimes,:),4);
    vStdI = std(vI(:,:,2:nTimes,:),0,4);
    countMeanI = mean(countI(:,:,2:nTimes,:),4);
    countStdI = std(countI(:,:,2:nTimes,:),0,4);
    tempMeanI = mean(tempI(:,:,2:nTimes,:),4);
    tempStdI = std(tempI(:,:,2:nTimes,:),0,4);
    internalTempMeanI = mean(internalTempI(:,:,2:nTimes,:),4);
    internalTempStdI = std(internalTempI(:,:,2:nTimes,:),0,4);
    save(strcat('Mesh_Stat_Data_', simString,'.mat'),'simString','x','y','t','uMeanA','vMeanA','tempMeanA','internalTempMeanA','countMeanA','uMeanI','vMeanI','tempMeanI','internalTempMeanI','countMeanI','uStdA','vStdA','tempStdA','internalTempStdA','countStdA','uStdI','vStdI','tempStdI','internalTempStdI','countStdI');
else
    save(strcat('Mesh_Stat_Data_', simString,'.mat'),'simString','x','y','t','uMeanA','vMeanA','tempMeanA','internalTempMeanA','countMeanA','uStdA','vStdA','tempStdA','internalTempStdA','countStdA');
    
end
end