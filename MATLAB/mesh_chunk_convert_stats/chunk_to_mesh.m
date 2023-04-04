function [] = chunk_to_mesh(chunkFile, nBinsX, nBinsY, debug)
%[chunkData] = read_chunk(varargin) Takes .chunk file name and reads in
%data as 'chunk' format, a series of value lists ordered by timestep
%   Input is name of .chunk file, output is a mesh data series.
%   Chunk data is a series of lists containing simulation values, lists are
%   ordered sequentially by timestep. Bin values are ordered as
%   (x1, y1), (x1, y2), (x1, y3)...(x2, y1), (x2, y2), (x2, y3)... such that
%   y is the most rapidly varying bin coordinate/index. The resulting mesh 
%   is a four dimensional tensor with dimensions/values: [nBinsX, nBinsY, nTimes, nVars].

% debug = 1;

try %Open file
    cFile = fopen(chunkFile, 'r');
catch
    error('Log file not found!');
end

if isunix %Unix OS, read 'head' and 'tail' terminal outputs as strings
    headCommand = convertCharsToStrings(strcat({'head -n '}, num2str(4),{' '}, chunkFile));
    if debug == 1
        disp(' headCommand')
        disp(headCommand)
        disp(class(headCommand))
    end

    [~, chars] = system(headCommand{1,1});
    chunkHead = convertCharsToStrings(chars);
    headStrings = strsplit(chunkHead, '\n');
    for i=3:1:4
        headWords = strsplit(headStrings(i),' ');
        if i == 3
            nVars = size(headWords, 2) - 2; %Third line in .chunk file lists the variable names
        elseif i == 4
            nChunks = str2double(headWords{1,2}); %Fourth line in .chunk file includes number of bins
        end
    end
    clear chars headStrings chunkHead headWords;
    
    [~,chars] = system(strcat({'tail -n '}, num2str(nChunks + 1), {' '}, chunkFile)); %Read in timestep variable line for last list output
    chunkTail = convertCharsToStrings(chars);
    tailWords = strsplit(chunkTail, ' ');
    nTimes = str2double(tailWords{1,1})/1000 + 1; %Convert final timestep to MATLAB list index
    if debug == 1
        nTimes = 101; %Read fewer times for debugging
    end
    clear chars chunkTail tailWords;
elseif ispc %Windows OS, read first four lines to get num variables and bins.
    numLines = 4;
    headChars = cell(numLines,1);
    for i = 1:numLines
        headChars(i) = {fgetl(cFile)};
    end
    headStrings = convertCharsToStrings(headChars);
    for i=3:1:4
        headWords = strsplit(headStrings(i), ' ');
        if i == 3
            nVars = size(headWords, 2) - 2;
        elseif i == 4
            nChunks = str2double(headWords{1,2});
        end
    end
    clear chars headStrings chunkHead headWords;
    nTimes = 1; %Initialize nTimes which will be updated later since Windows must read entire file
end
t = zeros(nTimes, 1);

meshData = zeros(nBinsX, nBinsY, nTimes, nVars);
ti = 1;
xi = 0;
yi = 0;
i = 0;

disp('Timesteps processed:')
while feof(cFile) == 0 %Read file line by line
    chunkLine = fgetl(cFile);
    chunkWords = strsplit(chunkLine,' ');
    [~,isNum]=str2num(chunkWords{1,1});
    if isNum == 1
        if (mod(str2double(chunkWords{1,1}), 1000) == 0) && strcmp(chunkWords{1,2}, num2str(nChunks)) %If line is the number of bins the following data will be at next output time
            ti = ti + 1;
            if debug == 1 && ti == 1001 %Shorten read for debugging
                break;
            end
            t(ti) = (ti - 1)*(1000/200); %Convert timestep to LJ time
            if (mod(ti, 1000) == 0) %Output timesteps processed.
                disp(ti)
            end
            i = 0;
        else
            i = i + 1;
            xi = floor(i/nBinsY) + 1; %x value is determined by number of fully read y index ranges
            yi = mod(i, nBinsY); %y value is modulus of bin index to number of x bins
            if yi == 0 %zero modulus means last element of previous x bin index
                xi = xi - 1;
                yi = nBinsY;
            end
            varWords = chunkWords(2:end); %Following columns are data values
            for n = 1:1:nVars
                var = varWords{1,n};
                meshData(xi, yi, ti, n) = str2double(var); %Convert read string to double, assign to 'chunkData'
            end
        end
    end
end
fclose(cFile);

[y,x] = meshgrid(0:20:(nBinsX-1)*20);

fileParts = strsplit(chunkFile, '.');
saveFile = convertCharsToStrings(strcat(fileParts(1),'_mesh.mat'));
disp(strcat('save(',saveFile,', t, x, y, meshData'))
save(saveFile,'t','x','y','meshData');
end
