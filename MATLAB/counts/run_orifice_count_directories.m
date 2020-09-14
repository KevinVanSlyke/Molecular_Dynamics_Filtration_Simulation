function [] = run_orifice_count_directories()
rootDir = pwd;
rootList = dir(rootDir);
for i=1:1:size(rootList,1)
    if not(startsWith(rootList.name(i),'.'))
        fileDir = fullfile(rootList.folder(i),rootList.name(i));
        cd(fileDir);
        [varNames, ensembleData] = read_therm_log(trialDir);
        save(strcat('therm_data_',rootList.name(i),'.mat'),'varNames','ensembleData');
        fileList = dir(pwd);
        for j=1:1:size(fileList,1)
            if endsWith(fileList.name(j),'.mat')
                load(fileList.name(j));
                break;
            end
        end
        [orificeIndices] = get_orifice_indices(countA);
    end
    
end

end