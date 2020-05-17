function [ nLines, nVars ] = trial_dimensions(trialLogFile)
%Reads pressure data from thermodynamic output in LAMMPS log files
%   Catenates each data column in the LAMMPS log files from multiple restarts

fileParts = strsplit(trialLogFile,'_');
nFileParts = size(fileParts,2);
trialString = '';
for i = 2 : 1 : nFileParts-1
    if i == 2
        trialString = fileParts{1,i};
    else
        trialString = strcat(trialString, '_', fileParts{1,i});
    end
end
logFileList = dir(fullfile(pwd, strcat('log_',trialString,'_r*.lmp')));
nLogFiles = size(logFileList,1); %number of dump files for current pore
finalThermLog = strcat('log_',trialString,'_r',num2str(nLogFiles-1),'.lmp');

[sid,chars] = system(['tail -n ',num2str(30),' ',finalThermLog]);
logTail = convertCharsToStrings(chars);
tailStrings = strsplit(logTail,'\n');
nStrings = size(tailStrings,2);
for i = 1 : 1 : nStrings
    if startsWith(tailStrings(i), 'Loop')
        finalThermLine = tailStrings(i-2);
        words = strsplit(finalThermLine, ' ');
        %Log files contain '\n' at the end of the variable line which is
        %counted as an additional word, hence:
        nVars = size(words,2)-1;
        tMax = str2double(words(1,1));
    end
end
%Typical simulations have thermo output ever 1000 timesteps and are run for
%one extra timestep to ensure restart file is output, hence:
nLines = (tMax-1)/1000;

end