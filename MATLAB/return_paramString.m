function [paramString] = return_paramString(trialDir)

dirParts = strsplit(trialDir,'/');
nDirParts = size(dirParts,2);
paramString = dirParts{1,nDirParts};

end