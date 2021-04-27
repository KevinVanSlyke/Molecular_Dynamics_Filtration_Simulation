dataDump = readdump_all('orifice2_120W_5D_120F_100S_0T_r0.dump'); %Creates 3D matrix, each timestep is NxM where N is the maximum number of particles in any timestep of the dump and M is the number of parameters output for each particle
time_step = dataDump.timestep;
Natoms = dataDump.Natoms;
atom_data = dataDump.atom_data;
clear dataDump;
n=1;
D=5;
massType(1) = 1;
massType(2) = 25;
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

netPtclTrans(1,:) = currPtclTrans(1,:);
for i = 2 : 1 : max(size(currPtclTrans))
netPtclTrans(i,:) = netPtclTrans(i-1,:) + currPtclTrans(i,:);
end

figure();
plot(t, netPtclTrans);
legend('Argon','Impurity');
title('Front Orifice');
ylabel('Particle Count');
xlabel('Time');