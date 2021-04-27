function [] = merge_mesh_data(debug)
%catenate_mesh_data() loads mesh data of single scalar/vector quantities from .mat files and combines to a
%single .mat saved locally. No inputs or returns.
%   Starting in current directory, walks over files looking for .mat
%   extension, loads data and imports scalar/vector mesh data based on file
%   name, including argon/impurity vcm/count/temp/internalTemp. The mesh
%   data is then saved as a single .mat file.

% debug = 1;
debug = str2double(debug);

dataDir = pwd;

%Check OS and parse directory name to get simulation string ID and file
%list of current directory
if ispc %Windows OS
    dirParts = strsplit(dataDir,'\');
elseif isunix %Unis OS
    dirParts = strsplit(dataDir,'/');
end
nDirParts = size(dirParts,2);
simDir = dirParts(nDirParts);
simString = simDir{1,1};
dataDirList = dir(dataDir);
nFiles = size(dataDirList,1);
%Potentially for use if each trial has a diff number of output times
% nTimes = Inf;

%Step through file list and load data if file is .mat extension, renames
%loaded data as appropriate, clearing intermediate data
for n = 1 : 1 : nFiles
    if endsWith(dataDirList(n).name(), 'mesh.mat') % && ~startsWith(dataDirList(n).name(), 'Mesh')
        trialString = convertCharsToStrings(strsplit(dataDirList(n).name(),'.'));
        trialParts = strsplit(trialString(1),'_');
        trialWord = strsplit(trialParts(end-1),'T');
        trialID = str2double(trialWord(1))+1;
        if startsWith(dataDirList(n).name(), 'argon_vcm')
            if trialID == 1
                load(dataDirList(n).name(),'x','y','t');
                %Will have to make robust for uneven length trials
                nTimes = size(t,1);
            end
            load(dataDirList(n).name(),'meshData');
            uA(:,:,:,trialID) = meshData(:,:,:,1);
            vA(:,:,:,trialID) = meshData(:,:,:,2);
            clear meshData
        elseif startsWith(dataDirList(n).name(), 'impurity_vcm')
            load(dataDirList(n).name(),'meshData');
            uI(:,:,:,trialID) = meshData(:,:,:,1);
            vI(:,:,:,trialID) = meshData(:,:,:,2);
            clear meshData
        elseif startsWith(dataDirList(n).name(), 'argon_count')
            load(dataDirList(n).name(),'meshData');
            countA(:,:,:,trialID) = meshData(:,:,:,1);
            clear meshData
        elseif startsWith(dataDirList(n).name(), 'impurity_count')
            load(dataDirList(n).name(),'meshData');
            countI(:,:,:,trialID) = meshData(:,:,:,1);
            clear meshData
        elseif startsWith(dataDirList(n).name(), 'argon_temp')
            load(dataDirList(n).name(),'meshData');
            tempA(:,:,:,trialID) = meshData(:,:,:,1);
            clear meshData
        elseif startsWith(dataDirList(n).name(), 'impurity_temp')
            load(dataDirList(n).name(),'meshData');
            tempI(:,:,:,trialID) = meshData(:,:,:,1);
            clear meshData
        elseif startsWith(dataDirList(n).name(), 'argon_internalTemp')
            load(dataDirList(n).name(),'meshData');
            internalTempA(:,:,:,trialID) = meshData(:,:,:,1);
            clear meshData
        elseif startsWith(dataDirList(n).name(), 'impurity_internalTemp')
            load(dataDirList(n).name(),'meshData');
            internalTempI(:,:,:,trialID) = meshData(:,:,:,1);
            clear meshData
        end

%Potentially for use if each trial has a diff number of output times
%         if size(meshData,3) < nTimes
%         nTimes = size(meshData,3);
%         end
    end
end
t = t(1:nTimes);
uMeanA = mean(uA(:,:,1:nTimes,:),4);
uStdA = std(uA(:,:,1:nTimes,:),0,4);
vMeanA = mean(vA(:,:,1:nTimes,:),4);
vStdA = std(vA(:,:,1:nTimes,:),0,4);
countMeanA = mean(countA(:,:,1:nTimes,:),4);
countStdA = std(countA(:,:,1:nTimes,:),0,4);
tempMeanA = mean(tempA(:,:,1:nTimes,:),4);
tempStdA = std(tempA(:,:,1:nTimes,:),0,4);
internalTempMeanA = mean(internalTempA(:,:,1:nTimes,:),4);
internalTempStdA = std(internalTempA(:,:,1:nTimes,:),0,4);
clear chunkData dataDir dirParts nDirParts simDir dataDirList nFiles n
if debug == 1
    uSingleA = uA(:,:,100,1);
    uUncA = uStdA(:,:,100);
    uAvgA = uMeanA(:,:,100);
end
%Save all mesh values including or excluding impurity data depending on if the
%simulation included impurity of diameter not equal to 1
if exist('uI','var') == 1
    uMeanI = mean(uI(:,:,1:nTimes,:),4);
    uStdI = std(uI(:,:,1:nTimes,:),0,4);
    vMeanI = mean(vI(:,:,1:nTimes,:),4);
    vStdI = std(vI(:,:,1:nTimes,:),0,4);
    countMeanI = mean(countI(:,:,1:nTimes,:),4);
    countStdI = std(countI(:,:,1:nTimes,:),0,4);
    tempMeanI = mean(tempI(:,:,1:nTimes,:),4);
    tempStdI = std(tempI(:,:,1:nTimes,:),0,4);
    internalTempMeanI = mean(internalTempI(:,:,1:nTimes,:),4);
    internalTempStdI = std(internalTempI(:,:,1:nTimes,:),0,4);
    save(strcat('Mesh_Stat_Data_', simString,'.mat'),'simString','x','y','t','uMeanA','vMeanA','tempMeanA','internalTempMeanA','countMeanA','uMeanI','vMeanI','tempMeanI','internalTempMeanI','countMeanI','uStdA','vStdA','tempStdA','internalTempStdA','countStdA','uStdI','vStdI','tempStdI','internalTempStdI','countStdI');
    save(strcat('Mesh_Raw_Data_', simString,'.mat'),'simString','x','y','t','uA','vA','tempA','internalTempA','countA','uI','vI','tempI','internalTempI','countI');
else
    save(strcat('Mesh_Stat_Data_', simString,'.mat'),'simString','x','y','t','uMeanA','vMeanA','tempMeanA','internalTempMeanA','countMeanA','uStdA','vStdA','tempStdA','internalTempStdA','countStdA');
    save(strcat('Mesh_Raw_Data_', simString,'.mat'),'simString','x','y','t','uA','vA','tempA','internalTempA','countA');

end
end