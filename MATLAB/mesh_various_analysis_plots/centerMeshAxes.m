function [xOut, yOut] = centerMeshAxes(paramString, xIn, yIn)
%Reads pressure data from thermodynamic output in LAMMPS log files
%   Catenates each data column in the LAMMPS log files from multiple restarts

% inputFile = strcat('input_',paramString,'_r',num2str(nRestarts),'.lmp');
inputFile = strcat('input_',paramString,'.lmp');
fid = fopen(inputFile, 'r');
% thermCont = 0;
% "compute argonChunks argon chunk/atom bin/2d x 880 20 y 780 20 bound x 880 1440 bound y 780 1340"
while feof(fid) == 0
    chunkLine = fgetl(fid);
    chunkWords = strsplit(chunkLine,' ');
    if strcmp(chunkWords{1,1},'compute') && strcmp(chunkWords{1,2},'argonChunks')
        xShift = str2num(chunkWords{1,7});
        yShift = str2num(chunkWords{1,10});
        break;
    end
end
xOut = xIn + xShift;
yOut = yIn + yShift;