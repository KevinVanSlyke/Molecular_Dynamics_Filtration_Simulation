function [paramString] = return_paramString(trialDir)

%%For windows
dirParts = strsplit(trialDir,'\');
%%For unix
% dirParts = strsplit(trialDir,'/');
nDirParts = size(dirParts,2);
paramString = convertCharsToStrings(dirParts{1,nDirParts});

end