function [] = catenate_mesh_data()

dataDir = pwd;
%%Windows
% dirParts = strsplit(dataDir,'\');
%%Unix
dirParts = strsplit(dataDir,'/');
nDirParts = size(dirParts,2);
simDir = dirParts(nDirParts);
simString = simDir{1,1};
dataDirList = dir(dataDir);
nFiles = size(dataDirList,1);
for n = 1 : 1 : nFiles
    if startsWith(dataDirList(n).name(), 'argon_vcm')
        load(dataDirList(n).name(),'x','y','t','uA','vA');
        uArgon = uA(:,:,2:size(uA,3));
        vArgon = vA(:,:,2:size(vA,3));
        t = t(2:size(t,1));
        clear uA vA
    elseif startsWith(dataDirList(n).name(), 'impurity_vcm')
        load(dataDirList(n).name(),'uA','vA');
        uI = uA(:,:,2:size(uA,3));
        vI = vA(:,:,2:size(vA,3));
        clear uA vA
    elseif startsWith(dataDirList(n).name(), 'argon_count')
        load(dataDirList(n).name(),'count');
        countA = count(:,:,2:size(count,3));
        clear count
    elseif startsWith(dataDirList(n).name(), 'impurity_count')
        load(dataDirList(n).name(),'count');
        countI = count(:,:,2:size(count,3));  
        clear count
    elseif startsWith(dataDirList(n).name(), 'argon_temp')
        load(dataDirList(n).name(),'temp');
        tempA = temp(:,:,2:size(temp,3));
        clear temp
    elseif startsWith(dataDirList(n).name(), 'impurity_temp')
        load(dataDirList(n).name(),'temp');
        tempI = temp(:,:,2:size(temp,3));
        clear temp
    elseif startsWith(dataDirList(n).name(), 'argon_internalTemp')
        load(dataDirList(n).name(),'internalTemp');
        internalTempA = internalTemp(:,:,2:size(internalTemp,3));
        clear internalTemp
    elseif startsWith(dataDirList(n).name(), 'impurity_internalTemp')
        load(dataDirList(n).name(),'internalTemp');
        internalTempI = internalTemp(:,:,2:size(internalTemp,3));
        clear internalTemp
    end
end
uA = uArgon;
vA = vArgon;
clear dataDir dirParts nDirParts simDir dataDirList nFiles n count uArgon vArgon

if exist('uI','var') == 1
    save(strcat('Mesh_Data_', simString,'.mat'),'simString','x','y','t','uA','vA','tempA','internalTempA','countA','uI','vI','tempI','internalTempI','countI');
else
    save(strcat('Mesh_Data_', simString,'.mat'),'simString','x','y','t','uA','vA','tempA','internalTempA','countA');
end
end