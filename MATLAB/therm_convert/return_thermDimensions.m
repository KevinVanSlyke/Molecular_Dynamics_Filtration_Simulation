function [nLines, nVars] = return_thermDimensions(paramString, nRestarts, nTrials)
%Reads pressure data from thermodynamic output in LAMMPS log files
%   Catenates each data column in the LAMMPS log files from multiple restarts

% inputFile = strcat('input_',paramString,'_r',num2str(nRestarts),'.lmp');
inputFile = strcat('input_',paramString,'.lmp');
fid = fopen(inputFile, 'r');
thermCont = 0;
while feof(fid) == 0
    chunkLine = fgetl(fid);
    chunkWords = strsplit(chunkLine,' ');
    if strcmp(chunkWords{1,1},'run')
        maxTime = str2double(chunkWords{1,2});
    elseif strcmp(chunkWords{1,1},'thermo_style')
        nVars = size(chunkWords,2)-2;
        if strcmp(chunkWords(1,size(chunkWords,2)-1),'&')
            thermCont = thermCont + 1;
            nVars = nVars-2;
        end
    elseif thermCont >= 1
        if strcmp(chunkWords(1,size(chunkWords,2)-1),'&')
            nVars = nVars+size(chunkWords,2)-2;
            thermCont = thermCont + 1;
        else 
            nVars = nVars+size(chunkWords,2);
            thermCont = 0;
        end
    end
end
%Typical simulations have thermo output ever 1000 timesteps and are run for
%one extra timestep to ensure restart file is output, hence:
if mod(maxTime,1000) == 1
    nLines = (maxTime-1)/1000+1;
else
    nLines = maxTime/1000+1;
end

end