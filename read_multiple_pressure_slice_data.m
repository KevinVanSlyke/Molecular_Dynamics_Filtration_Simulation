function [ varargout ] = read_multiple_pressure_slice_data( varargin )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
cwd = pwd;
dirs = strsplit(cwd,'/');
nDirParts = size(dirs,2);
cDir = dirs(nDirParts);
sDir = cDir{1,1};
files = dir(strcat('log_',sDir,'_restart_0.lmp'));
fileName = files.name;
try
    logData = readlog(fileName);
catch
    print 'readlog failed, attempting original readlog';
    logData = readlog_fix(fileName);
end
thermStartStrings = logData.data{1,2};
sTimes = size(thermStartStrings,1)-1;
thermData = zeros(sTimes,9);
for i = 1 : 1 : sTimes
    thermStartString = strtrim(thermStartStrings(i,:));
    thermStartWords = strsplit(thermStartString);
    nWords = size(thermStartWords,2);
    for j = 1 : 1 : nWords
        thermStartData(i,j) = str2double(thermStartWords(1,j));
    end
end
ts = thermStartData(:,1);
Pfs = thermStartData(:,7);
Pms = thermStartData(:,8);
Prs = thermStartData(:,9);

files = dir(strcat('log_',sDir,'_restart_1.lmp'));
if ~isempty(files)
    fileName = files.name;
    try
        logData = readlog(fileName);
    catch
        print 'readlog failed, attempting original readlog';
        logData = readlog_fix(fileName);
    end
    thermRestartStrings = logData.data{1,1};
    rTimes = size(thermRestartStrings,1)-1;
    thermRestartData = zeros(rTimes,9);
    for i = 1 : 1 : rTimes
        thermRestartString = strtrim(thermRestartStrings(i,:));
        thermRestartWords = strsplit(thermRestartString);
        nWords = size(thermRestartWords,2);
        for j = 1 : 1 : nWords
            thermRestartData(i,j) = str2double(thermRestartWords(1,j));
        end
    end
    tr = thermRestartData(:,1);
    Pfr = thermRestartData(:,7);
    Pmr = thermRestartData(:,8);
    Prr = thermRestartData(:,9);

    rStrtIndx = 1;
    for i = 1 : 1 : rTimes
        if tr(i) == ts(sTimes)
            rStrtIndx = i;
            break;
        end
    end
    Pf = Pfs;
    Pm = Pms;
    Pr = Prs;
    t = ts;
    for i = 1 : 1 : rTimes-rStrtIndx
        Pf(sTimes + i) = Pfr(i+rStrtIndx);
        Pm(sTimes + i) = Pmr(i+rStrtIndx);
        Pr(sTimes + i) = Prr(i+rStrtIndx);

        t(sTimes + i) = tr(i+rStrtIndx);
    end
else
    Pf = Pfs;
    Pm = Pms;
    Pr = Prs;  
    t = ts;
end

files = dir(strcat('log_',sDir,'_restart_*.lmp'));
if ~isempty(files)
    nDirs = size(files,1);
    for i = 2 : 1 : nDirs-1
        fileName = strcat('log_', sDir, '_restart_', num2str(i), '.lmp');
        try
            logData = readlog(fileName);
        catch
            print 'readlog failed, attempting original readlog';
            logData = readlog_fix(fileName);
        end
        thermRestartStrings = logData.data{1,1};
        rTimes = size(thermRestartStrings,1)-1;
        thermRestartData = zeros(rTimes,7);
        for i = 1 : 1 : rTimes
            thermRestartString = strtrim(thermRestartStrings(i,:));
            thermRestartWords = strsplit(thermRestartString);
            nWords = size(thermRestartWords,2);
            for j = 1 : 1 : nWords
                thermRestartData(i,j) = str2double(thermRestartWords(1,j));
            end
        end
        tr = thermRestartData(:,1);
        Pfr = thermRestartData(:,7);
        Pmr = thermRestartData(:,8);
        Prr = thermRestartData(:,9);
        
        pTimes = size(t,1);
        rStrtIndx = 1;
        for i = 1 : 1 : rTimes
            if tr(i) == t(pTimes)
                rStrtIndx = i;
                break;
            end
        end

        for i = 1 : 1 : rTimes-rStrtIndx
            Pf(pTimes + i) = Pfr(i+rStrtIndx);
            Pm(pTimes + i) = Pmr(i+rStrtIndx);
            Pr(pTimes + i) = Prr(i+rStrtIndx);
            t(pTimes + i) = tr(i+rStrtIndx);
        end
    end
end

%----------Outputs-------------
%OUTPUTS IN SAME VARIABLE STRUCTURE
varargout{1}.P = [Pf, Pm, Pr];
varargout{1}.t = t;
%------------------------------
end

