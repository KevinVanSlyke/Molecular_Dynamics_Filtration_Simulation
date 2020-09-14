function [] = save_orifice_averages()
rootDir = 'E:\Data\Molecular_Dynamics_Data\DualLayer_07_2020';
% rootDir = pwd;
rootList = dir(rootDir);
n=1;
for i=1:1:size(rootList,1)
    fileDir = fullfile(rootList(i).folder,rootList(i).name);
    if not(startsWith(rootList(i).name,'.')) && isfolder(fileDir) && not(startsWith(rootList(i).name,'Figures')) && not(endsWith(rootList(i).name,'.mat'))
        cd(fileDir);
        orificeAverages{n,1} = get_orifice_averages(fileDir,rootList(i).name);
        simStrings{n,1} = rootList(i).name;
        n=n+1;
    end
end
cd(rootDir);
orificeList = {'Front';'Upper';'Lower'};
varStrings = {'argonXVel'; 'argonCount'; 'argonTemp'; 'argonInternalTemp'; 'impurityXVel'; 'impurityCount'; 'impurityTemp'; 'impurityInternalTemp'};
save(strcat('orifice_averages.mat'),'simStrings','varStrings','orificeList','orificeAverages');
end