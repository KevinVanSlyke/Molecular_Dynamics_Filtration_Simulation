function [ varargout ] = read_log_time_limit( varargin )
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

[q,w] = system(['tail -n ',num2str(60),' ',finalThermLog]);

%----------Outputs-------------
%OUTPUTS IN SAME VARIABLE STRUCTURE
varargout{1}.tmax = tmaax;
%------------------------------
end

