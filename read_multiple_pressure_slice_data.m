function [ varargout ] = read_multiple_pressure_slice_data( varargin )
%Reads in thermo output data for simulations with two filter layers, thus
%three pressure regions of interest
%   Provided the simulation ensemble follows regular naming schemes and
%   thermo column ordering, combines the three pressure slice outputs from
%   multiple log files.

fPath = pwd;
dirParts = strsplit(fPath,'/');
nDirParts = size(dirParts,2);
simDir = dirParts(nDirParts);
simString = simDir{1,1};

logFileList = dir(fullfile(fPath, strcat('log_',simString,'_restart_*.lmp')));
nLogFiles = size(logFileList,1); %number of dump files for current pore
if nLogFiles > 0
    P = [];
    t = [];
end

for n = 1 : 1 : nLogFiles
    thermLogFile = fullfile(fPath, strcat('log_',simString,'_restart_',num2str(n-1),'.lmp'));
    try
        logData = readlog(thermLogFile);
    catch
        logData = readlog_fix(thermLogFile);
        error('ERROR: readlog.m failed presumably due to improper file termination. Attempting readlog_fix.m');
    end
    if n == 1
        dataIndex = 2;
    else
        dataIndex = 1;
    end
    thermNameStrings = logData.Chead{1,dataIndex};
    numThermTypes = max(size(thermNameStrings))-1;
    thermValueStrings = logData.data{1,dataIndex};
    nTimes = size(thermValueStrings,1)-1;
    thermData = zeros(nTimes,numThermTypes);
    for i = 1 : 1 : nTimes
        thermValueString = strtrim(thermValueStrings(i,:));
        thermValueWords = strsplit(thermValueString);
        nWords = size(thermValueWords,2);
        for j = 1 : 1 : nWords
            thermStartData(i,j) = str2double(thermValueWords(1,j));
        end
    end
    tn = thermStartData(:,1);
    Pfn = thermStartData(:,7);
    Pmn = thermStartData(:,8);
    Prn = thermStartData(:,9);
    
    if n == 1 %If restart_0 (start), copy single file output to head of output
        t = tn;
        P = Pn;
    elseif n >= 2 %If actual restart dump, copy find index of matching times and append single file data
        tIndex = 0;
        tMaxIndex = max(size(t));
        tMax = t(tMaxIndex);
        for i = 1 : 1 : nTimes %For all number of times in current log file
            if tn(i) == tMax %If time at index i equals final time in output vector
            	tIndex = i; %Record index of matching time
                break;
            end
        end
        for i = 1 : 1 : nTimes-tIndex %For the difference in matching index to total times in current log file
            Pf(tMaxIndex + i) = Pfn(i+tIndex); %Append next thermo value to output vectors
            Pm(tMaxIndex + i) = Pmn(i+tIndex);
            Pr(tMaxIndex + i) = Prn(i+tIndex);
            t(tMaxIndex + i) = tn(i+tIndex);
        end
    end
end
%----------Outputs-------------
%OUTPUTS IN SAME VARIABLE STRUCTURE
varargout{1}.P = [Pf, Pm, Pr];
varargout{1}.t = t;
%------------------------------
end

