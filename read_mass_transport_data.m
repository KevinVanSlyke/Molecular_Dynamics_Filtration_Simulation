function [ varargout ] = read_mass_transport_data( varargin )
%CALC_MASS_FLOW Summary of this function goes here
%   Detailed explanation goes here

%LJ dimensionless unit conversion for Argon gas
sigma = 3.4*10^(-10); %meters
mass = 6.69*10^(-26); %kilograms
epsilon = 1.65*10^(-21); %joules
tau = 2.17*10^(-12); %seconds
timestep = tau/200; %seconds

fPath = pwd;
startFileList = dir(fullfile(fPath, 'dump_*_start_pore.lmp'));
startDumpFile = startFileList(1).name;
startDump = readdump_all(startDumpFile);

try
    time_step = startDump.timestep;
    Natoms = startDump.Natoms;
    x_bound = startDump.x_bound;
    y_bound = startDump.y_bound;
    z_bound = startDump.z_bound;
    atom_data = startDump.atom_data;
    x_min = x_bound(1,1);
    x_max = x_bound(1,2);
    y_min = y_bound(1,1);
    y_max = y_bound(1,2);
catch
    error('Data formats not matching!');
end

sTimes = size(atom_data,3);
sNAtoms = size(atom_data,1);
aStartFlowCount = [];
iStartFlowCount = [];
prevAtoms = [];
for i = 1 : 1 : sTimes
    ts(i) = time_step(i);
    curAtoms = [];
    k = 1;
    for j = 1 : 1 : sNAtoms
        curData = atom_data(j,:,i);
        if atom_data(j,1,i) ~= 0
            curAtoms(k,:) = curData;
            k = k+1;
        end
    end
    aStartFlowCount(i) = 0;
    iStartFlowCount(i) = 0;
    if (i > 1)
        prevNum = size(prevAtoms,1);
        curNum = size(curAtoms,1);
        ignoreIndex = zeros(prevNum);
        for l = 1 : 1 : prevNum
            for m = 1 : 1 : curNum
                if(prevAtoms(l,1) == curAtoms(m,1))
                    ignoreIndex(l) = 1;
                    break;
                else
                    ignoreIndex(l) = 0;
                end
            end
        end
        for l = 1 : 1 : prevNum
            if ((ignoreIndex(l) ~= 1) && (prevAtoms(l,3) > 0))
                if (prevAtoms(l,2)  == 2)
                    aStartFlowCount(i) = aStartFlowCount(i) + 1;
                else
                    iStartFlowCount(i) = iStartFlowCount(i) + 1;
                end
            elseif ((ignoreIndex(l) ~= 1) && (prevAtoms(l,3) < 0))
                if (prevAtoms(l,2)  == 2)
                    aStartFlowCount(i) = aStartFlowCount(i) - 1;
                else
                    iStartFlowCount(i) = iStartFlowCount(i) - 1;
                end
            end
        end
    end
    prevAtoms = curAtoms;
end

%%Need to fix this so that it can read in N restart files.
try
    restartFileList = dir(fullfile(fPath, 'dump_*_restart_*_pore.lmp'));
    restartDumpFile = restartFileList(1).name;
    restartDump = readdump_all(restartDumpFile);
    time_step = restartDump.timestep;
    Natoms = restartDump.Natoms;
    x_bound = restartDump.x_bound;
    y_bound = restartDump.y_bound;
    z_bound = restartDump.z_bound;
    atom_data = restartDump.atom_data;
    x_min = x_bound(1,1);
    x_max = x_bound(1,2);
    y_min = y_bound(1,1);
    y_max = y_bound(1,2);
catch
    error('Restart Data formats not matching!');
end

rTimes = size(atom_data,3);
rNAtoms = size(atom_data,1);
aRestartFlowCount = [];
iRestartFlowCount = [];
prevAtoms = [];
for i = 1 : 1 : rTimes
    tr(i) = time_step(i);
    curAtoms = [];
    k = 1;
    for j = 1 : 1 : rNAtoms
        curData = atom_data(j,:,i);
        if atom_data(j,1,i) ~= 0
            curAtoms(k,:) = curData;
            k = k+1;
        end
    end
    aRestartFlowCount(i) = 0;
    iRestartFlowCount(i) = 0;
    if (i > 1)
        prevNum = size(prevAtoms,1);
        curNum = size(curAtoms,1);
        ignoreIndex = zeros(prevNum);
        for l = 1 : 1 : prevNum
            for m = 1 : 1 : curNum
                if(prevAtoms(l,1) == curAtoms(m,1))
                    ignoreIndex(l) = 1;
                    break;
                else
                    ignoreIndex(l) = 0;
                end
            end
        end
        for l = 1 : 1 : prevNum
            if ((ignoreIndex(l) ~= 1) && (prevAtoms(l,3) > 0))
                if (prevAtoms(l,2)  == 2)
                    aRestartFlowCount(i) = aRestartFlowCount(i) + 1;
                else
                    iRestartFlowCount(i) = iRestartFlowCount(i) + 1;
                end
            elseif ((ignoreIndex(l) ~= 1) && (prevAtoms(l,3) < 0))
                if (prevAtoms(l,2) == 2)
                    aRestartFlowCount(i) = aRestartFlowCount(i) - 1;
                else
                    iRestartFlowCount(i) = iRestartFlowCount(i) - 1;
                end
            end
        end
    end
    prevAtoms = curAtoms;
end
%%Need to add in catenation of restart data...

rStrtIndx = 1;
for i = 1 : 1 : rTimes
    if tr(i) == ts(sTimes)
        rStrtIndx = i;
        break;
    end
end
t = ts;
aFlowCount = aStartFlowCount;
iFlowCount = iStartFlowCount;
for i = 1 : 1 : rTimes-rStrtIndx
    aFlowCount(sTimes + i) = aRestartFlowCount(i+rStrtIndx);
    iFlowCount(sTimes + i) = iRestartFlowCount(i+rStrtIndx);
    t(sTimes + i) = tr(i + rStrtIndx);
end
aFlowSum = [];
iFlowSum = [];
aFlowSum(1) = aFlowCount(1);
iFlowSum(1) = iFlowCount(1);
for i = 2 : 1 : max(size(t))
    aFlowSum(i) = aFlowCount(i) + aFlowSum(i-1);
    iFlowSum(i) = iFlowCount(i) + iFlowSum(i-1);
end



%----------Outputs-------------
%OUTPUTS IN SAME VARIABLE STRUCTURE
varargout{1}.argonFlow = aFlowCount;
varargout{1}.impurityFlow = iFlowCount;
varargout{1}.argonSum = aFlowSum;
varargout{1}.impuritySum = iFlowSum;
varargout{1}.t = t;
%------------------------------
