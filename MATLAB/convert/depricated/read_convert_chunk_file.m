function [] = read_convert_chunk_file(simString, nBinsX, nBinsY, particleType, dataType, trialIndex)
% read_convert_chunk_file(simString, nBinsX, nBinsY, particleType, dataType) 
% Reads in specified LAMMPS chunk data structure/file and converts it to a
% MATLAB mesh data structure.
%   Takes as input the simulation ID string, number of horizontal and vertical cells, particle
%   type and date type. Chunk data is then converted to mesh via function
%   call and saved as a .mat file following standard naming convention.
%   No value returned.

debug = 1;
if debug == 1 %Outputs variable name, value, and class for debugging purposes
    disp('simString')
    disp(simString)
    disp(class(simString))
    simString = convertCharsToStrings(simString);

    disp('nBinsX')
    disp(nBinsX)
    disp(class(nBinsX))

    disp('nBinsY')
    disp(nBinsY)
    disp(class(nBinsY))

    disp('particleType')
    disp(particleType)
    disp(class(particleType))
    particleType = convertCharsToStrings(particleType);

    disp('dataType')
    disp(dataType)
    disp(class(dataType))
    dataType = convertCharsToStrings(dataType);
    disp(class(dataType))
end

% Old output style used 'pure' instead of 'argon' for pure argon systems.
% if particleType == 'pure' %Don't include particle type in file name
%     chunkFile=strcat(dataType,'_', simString, '.chunk');
% else %Include argon/impurity at head of file name
%     chunkFile=strcat(particleType,'_',dataType,'_', simString, '.chunk');
% end
chunkFile=strcat(particleType,'_',dataType,'_', simString,'_', trialIndex, 'T.chunk');

[chunkData] = read_chunk(chunkFile); %Read in LAMMPS formated 'chunk' data from .chunk file
[t,x,y,outVal] = chunkConvert(chunkData, nBinsX, nBinsY);
save(strcat(particleType,'_',dataType,'_', trialIndex, 'T_Mesh.mat'),'simString','t','x','y','outVal');

%Depending on data type we apply vector or scalar chunk conversion and save
%data as .mat file
% if strcmp(dataType,'vcm') %Apply vector chunk conversion, save velocity components as 'u' and 'v'
%     [t,x,y,outVal] = chunkConvert(chunkData, nBinsX, nBinsY);
%     u(:) = outVal(:,1);
%     v(:) = outVal(:,2);
%     save(strcat(particleType,'_',dataType,'_', trialIndex, 'T_Mesh.mat'),'simString','t','x','y','u','v');
% elseif strcmp(dataType,'temp') %Apply scalar chunk conversion, save as 'temp'
%     [t,x,y,outVal] = chunkConvert(chunkData, nBinsX, nBinsY);
%     temp(:) = outVal(:,1);
%     save(strcat(particleType,'_',dataType,'_', trialIndex, 'T_Mesh.mat'),'simString','t','x','y','temp');
% elseif strcmp(dataType,'count') %Apply scalar chunk conversion, save as 'count'
%     [t,x,y,outVal] = chunkConvert(chunkData, nBinsX, nBinsY);
%     count(:) = outVal(:,1);
%     save(strcat(particleType,'_',dataType,'_', trialIndex, 'T_Mesh.mat'),'simString','t','x','y','count');
% elseif strcmp(dataType,'internalTemp') || strcmp(dataType,'tempCom') %Apply scalar chunk conversion, save as 'internalTemp'
%     [t,x,y,outVal] = chunkConvert(chunkData, nBinsX, nBinsY);
%     internalTemp(:) = outVal(:,1);
%     save(strcat(particleType,'_',dataType,'_', trialIndex, 'T_Mesh.mat'),'simString','t','x','y','internalTemp');
% end

%Optional save during run to supplement function return
% save(strcat(particleType,'_',dataType,'_', trialIndex, 'T_Mesh.mat'),'simString','t','x','y','dataType','');
end