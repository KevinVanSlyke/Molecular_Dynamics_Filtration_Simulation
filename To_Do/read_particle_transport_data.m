function [ varargout ] = read_particle_transport_data( varargin )
%Counts number of particles by type that are transmitted through a given pore
%   Reads pore region dump, making an id list of particles currently inside the
%   region at each dumped timestep. If a particle is no longer in the
%   region during the following timestep dump its velocity in the previous
%   dump is used to count the as a positive or negative transmission of the
%   particles type.

%LJ dimensionless unit conversion for Argon gas
%sigma = 3.4*10^(-10); %meters
%mass = 6.69*10^(-26); %kilograms
%epsilon = 1.65*10^(-21); %joules
%tau = 2.17*10^(-12); %seconds
%timestep = tau/200; %seconds
%kb = 1.38*10^(-23); %Joules/Kelvin
nPore = varargin{1,1};
massType(1) = 1;


fPath = pwd;
dirParts = strsplit(fPath,'/');
nDirParts = size(dirParts,2);
simDir = dirParts(nDirParts);
simString = simDir{1,1};

%Need to generalize for arbitrary simulation folder name such as more/different
%parameters
aString = strsplit(simString,{'_'});
dString = strsplit(aString{1,2},{'D'});
if size(dString,1) > 0
    D = str2double(dString{1,1});
    %d=D*sigma*(10^(9)); %nanometers
    massType(2) = D^2;
end

dumpFileList = dir(fullfile(fPath, strcat('dump_',simString,'_', nPore,'_restart_*.lmp')));
nDumpFiles = size(dumpFileList,1); %number of dump files for current pore
if nDumpFiles > 0
    ptclTrans = [];
    t = [];
end
for n = 1 : 1 : nDumpFiles
    dataDumpFile = fullfile(fPath, strcat('dump_',simString,'_', nPore,'_restart_',num2str(n-1),'.lmp'));
    dataDump = readdump_all(dataDumpFile); %Creates 3D matrix, each timestep is NxM where N is the maximum number of particles in any timestep of the dump and M is the number of parameters output for each particle
    try
        time_step = dataDump.timestep;
        Natoms = dataDump.Natoms;
        atom_data = dataDump.atom_data;
        clear dataDump;
    catch
        error('ERROR: Data not matching expected format!');
    end
    
    nTimes = size(atom_data,3);
    nAtoms = size(atom_data,1);
    prevAtoms = [];
    currPtclTrans = [];
    for i = 1 : 1 : nTimes
        curAtoms = [];
        k = 1;
        for j = 1 : 1 : nAtoms
            curData = atom_data(j,:,i);
            if atom_data(j,1,i) ~= 0 %If atom ID is NOT equal to 0
                if D ~= 1
                    curAtoms(k,:) = [curData, curData(3)]; %Add that atoms parameters to current list with an additional column repeating it's velocity
                else
                    curAtoms(k,:) = [curData(1), 1, curData(2), curData(2)]; %Python file currently doesn't output mass if D = 1, so it's manually added here
                end
                k = k+1;
            end
        end
        for j = 1 : 1 : size(massType,2)
            currPtclTrans(i,j) = 0; %Count of type 1 particles transmitted at timestep i
        end
        prevNum = size(prevAtoms,1); %Number of atoms previously in the region
        curNum = size(curAtoms,1); %Number of atoms currently in the region
        if prevNum > 0 %Only start checking if atoms have left region if the previous dump time contained atoms
            %Start of routine to see what atoms have left the region between
            %dumped timesteps
            
            ignoreIndex = zeros(prevNum,1); %Matrix of length equal to the number of atoms previously in the region, first column indicates whether particle was previously held in region, second column indicates direction of particle entry
            for m = 1 : 1 : curNum
                for l = 1 : 1 : prevNum
                    if(curAtoms(m,1) == prevAtoms(l,1)) %Check if each current atom's id matches any previous id
                        ignoreIndex(l) = 1; %Ignore index of 1 will ignore the particle in transport counting
                        curAtoms(m,4) = prevAtoms(l,4);
                        break;
                    end
                end
            end
            for l = 1 : 1 : prevNum
                if (ignoreIndex(l) == 0 && prevAtoms(l,3)/prevAtoms(l,4) > 0) %If the atom isn't either still in the pore, or exiting the pore through the same side it entered
                    for j = 1 : 1 : size(massType,2)
                        if prevAtoms(l,2) == massType(j) %If atom mass in dump is of mass type j
                            if prevAtoms(l,3) > 0 %if velocity is positive
                                currPtclTrans(i,j) = currPtclTrans(i,j) + 1; %add one transport for time i
                            else
                                currPtclTrans(i,j) = currPtclTrans(i,j) - 1; %subtract one transport for time i
                            end
                        end
                    end
                end
            end
        end
        prevAtoms = curAtoms;
    end
    
    if n == 1 %If restart_0 (start), copy single file output to head of output
        ptclTrans = currPtclTrans;
        t = time_step;
    elseif n >= 2 %If actual restart dump, copy find index of matching times and append single file data
        tIndex = 0;
        tMaxIndex = max(size(t));
        tMax = t(tMaxIndex);
        for i = 1 : 1 : nTimes %For all number of times is current dump file
            if time_step(i) == tMax %If time at index i equals final time in output vector
                tIndex = i; %Record index of matching time
                break;
            end
        end
        for i = 1 : 1 : nTimes - tIndex %For the difference in matching index to total times in current dump file
            ptclTrans(tMaxIndex + i,:) = currPtclTrans(i + tIndex,:); %Append next dumped transport to output matrix
            t(tMaxIndex + i) = time_step(i + tIndex); %Append next dumped transport to output vector
        end
    end
end

netPtclTrans(1,:) = ptclTrans(1,:);
for i = 2 : 1 : max(size(ptclTrans))
    netPtclTrans(i,:) = netPtclTrans(i-1,:) + ptclTrans(i,:);
end



%----------Outputs-------------
%OUTPUTS IN SAME VARIABLE STRUCTURE
varargout{1}.ptclTrans = ptclTrans;
varargout{1}.netPtclTrans = netPtclTrans;
varargout{1}.t = t;
%------------------------------
