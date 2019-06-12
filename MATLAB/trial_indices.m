function [ nLines, nVars ] = trial_indices( )
%Reads pressure data from thermodynamic output in LAMMPS log files
%   Catenates each data column in the LAMMPS log files from multiple restarts

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
        %Log files contain '\n' at the end of the variable line which is
        %counted as an additional word, hence:
        nVars = size(words,2)-2;
        tMax = str2double(words(1,2));
    end
end
%Typical simulations have thermo output ever 1000 timesteps and are run for
%one extra timestep to ensure restart file is output, hence:
nLines = (tMax-1)/1000;

end

