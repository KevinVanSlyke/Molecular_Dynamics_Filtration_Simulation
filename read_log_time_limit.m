function [ tMax ] = read_log_time_limit( varargin )
%Reads pressure data from thermodynamic output in LAMMPS log files
%   Catenates pressure data from multiple restarts using the 7th collumn of
%   LAMMPS log file

fPath = pwd;
dirParts = strsplit(fPath,'/');
nDirParts = size(dirParts,2);
simDir = dirParts(nDirParts);
simString = simDir{1,1};

logFileList = dir(fullfile(fPath, strcat('log_',simString,'_restart_*.lmp')));
nLogFiles = size(logFileList,1); %number of dump files for current pore
finalThermLog = fullfile(fPath, strcat('log_',simString,'_restart_',num2str(nLogFiles-1),'.lmp'));

[sid,chars] = system(['tail -n ',num2str(30),' ',finalThermLog]);
logTail = convertCharsToStrings(chars);
tailStrings = strsplit(logTail,'\n');
nStrings = size(tailStrings,2);
for i = 1 : 1 : nStrings
    if startsWith(tailStrings(i), 'Loop')
        finalThermLine = tailStrings(i-1);
        words = strsplit(finalThermLine, ' ');
        tMax = str2double(words(1,1));
    end
end
%----------Outputs-------------
%OUTPUTS Defined in function declaration
% tMax
%------------------------------
end

