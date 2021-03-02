function [] = spmd_chunk_wrapper(simString, atomType, nWorkers, trialIndex, nBinsX, nBinsY)
% MATLAB PCT wrapper, use with slurmMATLAB
debug = 1;
nWorkers = str2double(nWorkers);
parpool('local', nWorkers);

if debug == 1 %Outputs variable name, value, and class for debugging purposes
    disp('labindex')
    disp(labindex)
    disp(class(labindex))

    disp('numlabs')
    disp(numlabs)
    disp(class(numlabs))

    disp('atomType')
    disp(atomType)
    disp(class(atomType))
    atomType = convertCharsToStrings(atomType);
    disp(class(atomType))

    disp('simString')
    disp(simString)
    disp(class(simString))
    simString = convertCharsToStrings(simString);
    disp(class(simString))
end

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


        chunkFile = strcat(atomType, '_', dataType, '_', simString, '_', num2str(trialIndex), 'T.chunk');
        if debug == 1 %Outputs variable name, value, and class for debugging purposes
            disp('dataType')
            disp(dataType)
            disp(class(dataType))
            dataType = convertCharsToStrings(dataType);
            disp(class(dataType))

            disp('chunkFile')
            disp(chunkFile)
            disp(class(chunkFile))
            chunkFile = convertCharsToStrings(chunkFile);
            disp(class(chunkFile))
        end
        chunk_to_mesh(chunkFile, nBinsX, nBinsY);
    end
end
delete(gcp('nocreate'));
end