function [] = run_directories(plotFunction, vars)
rootDir = pwd;
rootList = dir(rootDir);
for i=1:1:size(rootList,1)
    if not(startsWith(rootList.name(i),'.'))
        fileDir = fullfile(rootList.folder(i),rootList.name(i));
        cd(fileDir);
        fileList = dir(pwd);
        for j=1:1:size(fileList,1)
            plotFunction(vars);
        end
        
    end
    
end

end