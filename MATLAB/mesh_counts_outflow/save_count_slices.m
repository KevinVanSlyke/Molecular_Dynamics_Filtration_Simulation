function [] = save_count_slices()
rootDir = 'E:\Data\Molecular_Dynamics_Data\Pending\DualLayer_MonoOrifice_Hopper_07_2020\Assymetric_DualLayer_Hopper_Ensemble';
sliceIndx = 3;
% rootDir = pwd;
rootList = dir(rootDir);
n=1;
for i=1:1:size(rootList,1)
    fileDir = fullfile(rootList(i).folder,rootList(i).name);
    if not(startsWith(rootList(i).name,'.')) && isfolder(fileDir) && not(startsWith(rootList(i).name,'Figures')) && not(endsWith(rootList(i).name,'.mat')) && not(endsWith(rootList(i).name,'.m'))
        cd(fileDir);
        [argonCountSlice{n,1}(:,:),impurityCountSlice{n,1}(:,:),centeredX,centeredY{n,1}(:)] = get_count_slice(fileDir,rootList(i).name,sliceIndx);
        simStrings{n,1} = rootList(i).name;
        n=n+1;
    end
end
cd(rootDir);
save(strcat('count_slice_',num2str(centeredX),'x.mat'),'simStrings','argonCountSlice','impurityCountSlice','centeredX','centeredY');
end