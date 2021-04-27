function [] = spmd_chunk_wrapper(simString, atomType, nWorkers, trialIndex, nBinsX, nBinsY, debug)
% MATLAB PCT wrapper, use with slurmMATLAB

% debug = 1;
debug = str2double(debug);
nBinsX = str2double(nBinsX);
nBinsY = str2double(nBinsY);
nWorkers = str2double(nWorkers);
parpool('local', nWorkers);

if debug == 1 %Outputs variable name, value, and class for debugging purposes
    disp(' atomType')
    disp(atomType)
    disp(class(atomType))

    disp(' simString')
    disp(simString)
    disp(class(simString))    
    
    disp(' trialIndex')
    disp(trialIndex)
    disp(class(trialIndex))
end
disp('chunk_to_mesh(chunkFile, nBinsX, nBinsY, debug)')

spmd
    for i=labindex:numlabs:nWorkers
        switch i
            case 1
                dataType = 'vcm';
            case 2
                dataType = 'temp';
            case 3
                dataType = 'count';
            case 4
                dataType = 'internalTemp';
        end
               
        chunkFile = convertCharsToStrings(strcat(atomType, '_', dataType, '_', simString, '_', trialIndex, 'T.chunk'));
        if debug == 1 %Outputs variable name, value, and class for debugging purposes
            disp(' dataType')
            disp(dataType)
            disp(class(dataType))
            
            disp(' chunkFile')
            disp(chunkFile)
            disp(class(chunkFile))
        end
        disp(strcat('chunk_to_mesh(',chunkFile,{', '}, num2str(nBinsX),{', '}, num2str(nBinsY),{', '}, num2str(debug),')'));
        chunk_to_mesh(chunkFile, nBinsX, nBinsY, debug);
    end
end
delete(gcp('nocreate'));
end