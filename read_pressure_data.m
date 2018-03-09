function [ varargout ] = read_pressure_data( varargin )
%Reads pressure data from thermodynamic output in LAMMPS log files
%   Catenates pressure data from multiple restarts using the 7th collumn of
%   LAMMPS log file
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
    disp('ERROR: readlog.m failed presumably due to improper file termination. Attempting readlog_fix.m');
    logData = readlog_fix(fileName);
end
thermStartStrings = logData.data{1,2};
sTimes = size(thermStartStrings,1)-1;
thermData = zeros(sTimes,7);
for i = 1 : 1 : sTimes
    thermStartString = strtrim(thermStartStrings(i,:));
    thermStartWords = strsplit(thermStartString);
    nWords = size(thermStartWords,2);
    for j = 1 : 1 : nWords
        thermStartData(i,j) = str2double(thermStartWords(1,j));
    end
end
ts = thermStartData(:,1);
Ps = thermStartData(:,7);

files = dir(strcat('log_',sDir,'_restart_1.lmp'));
if ~isempty(files)
    fileName = files.name;
    try
        logData = readlog(fileName);
    catch
        disp('ERROR: readlog.m failed presumably due to improper file termination. Attempting readlog_fix.m');
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
    Pr = thermRestartData(:,7);
    
    rStrtIndx = 1;
    for i = 1 : 1 : rTimes
        if tr(i) == ts(sTimes)
            rStrtIndx = i;
            break;
        end
    end
    P = Ps;
    t = ts;
    for i = 1 : 1 : rTimes-rStrtIndx
        P(sTimes + i) = Pr(i+rStrtIndx);
        t(sTimes + i) = tr(i+rStrtIndx);
    end
else
    P = Ps;
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
            disp('ERROR: readlog.m failed presumably due to improper file termination. Attempting readlog_fix.m');
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
        Pr = thermRestartData(:,7);
        
        pTimes = size(t,1);
        rStrtIndx = 1;
        for i = 1 : 1 : rTimes
            if tr(i) == t(pTimes)
                rStrtIndx = i;
                break;
            end
        end
        
        for i = 1 : 1 : rTimes-rStrtIndx
            P(pTimes + i) = Pr(i+rStrtIndx);
            t(pTimes + i) = tr(i+rStrtIndx);
        end
    end
end

%----------Outputs-------------
%OUTPUTS IN SAME VARIABLE STRUCTURE
varargout{1}.P = P;
varargout{1}.t = t;
%------------------------------
end

