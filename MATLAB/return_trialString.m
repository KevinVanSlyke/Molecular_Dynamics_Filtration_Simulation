function [ trialString ] = return_trialString(logFileString)

logFileParts = strsplit(logFileString,'.');
logParts = strsplit(logFileParts{1,1},'_');
nLogParts = size(logParts,2);
trialPart = logParts(nLogParts-1);
trialString = trialPart{1,1};

end
