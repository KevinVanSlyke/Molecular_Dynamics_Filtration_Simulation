function [nLines, nVars] = return_thermDimensions(paramString, nRestarts, nTrials)
%Reads pressure data from thermodynamic output in LAMMPS log files
%   Catenates each data column in the LAMMPS log files from multiple restarts

varLogStartString = strcat('log_',paramString,'_*T_r*.lmp');
logFileList = dir(fullfile(pwd, varLogStartString));
nTimes = 10^100;
for n = 1:1:nTrials
    finalRestartIndex = strcat('log_',paramString,'_',num2str(n),'T_r',num2str(nRestarts),'.lmp');
    [sid,chars] = system(['tail -n ',num2str(30),' ',finalRestartIndex]);
    logTail = convertCharsToStrings(chars);
    tailStrings = strsplit(logTail,'\n');
    nStrings = size(tailStrings,2);
    for i = 1 : 1 : nStrings
        if startsWith(tailStrings(i), 'Loop')
            finalThermLine = tailStrings(i-1);
            words = strsplit(finalThermLine, ' ');
            %Log files contain '\n' at the end of the variable line which is
            %counted as an additional word, hence:
            nVars = size(words,2)-1;
            tMax = str2double(words(1,1));
            if tMax < nTimes
                nTimes = tMax;
            end
        end
    end
end
%Typical simulations have thermo output ever 1000 timesteps and are run for
%one extra timestep to ensure restart file is output, hence:
nLines = (nTimes-1)/1000;

end