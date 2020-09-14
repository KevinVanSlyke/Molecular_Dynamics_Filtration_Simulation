function [] = save_therm_ensemble()
rootDir = 'E:\Data\Molecular_Dynamics_Data\DualLayer_07_2020';
% rootDir = pwd;
% rootList = dir(rootDir);
n=1;
for i=1:1:size(rootList,1)
    rootList(i).name
    fileDir = fullfile(rootList(i).folder,rootList(i).name);
    if not(startsWith(rootList(i).name,'.')) && isfolder(fileDir) && not(startsWith(rootList(i).name,'Figures')) && not(endsWith(rootList(i).name,'.mat'))
        [varNames{n,1}(:), ensembleData{n,1}(:,:)] = read_therm_log(fileDir);
        simStrings{n,1} = rootList(i).name;
        n=n+1;
    end
end
cd(rootDir);
save(strcat('therm_data.mat'),'simStrings','varNames','ensembleData');

end