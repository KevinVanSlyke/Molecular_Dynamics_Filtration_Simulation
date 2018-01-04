function [stat_data] = calculate_ensemble_pressure_statistics(baseDir)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%LJ dimensionless unit conversion for Argon gas
%sigma = 3.4*10^(-10); %meters
%mass = 6.69*10^(-26); %kilograms
%epsilon = 1.65*10^(-21); %joules
%tau = 2.17*10^(-12); %seconds
%timestep = tau/200; %seconds
%kb = 1.38*10^(-23); %Joules/Kelvin
%x = (0:100:1900)'*sigma*1/(10^(-9)); %nm

nTimeMax = Inf;

nTrials = 5;

maxParam = 20;
minParam = 1;
stepParam = 1;
paramList = (minParam:stepParam:maxParam);
nParam = max(size(paramList));

%baseDir = '/home/Kevin/Documents/Dust_Data/Molecular/October_2017_Multiple_Parameters/Diameter/Diameter_Trials';
for n = 1 : 1 : nTrials
    trialString = ['Diameter_Trial' num2str(n)];
    for D = 1 : 1 : 20
        simString = ['D' num2str(D)];
        directory = strcat(baseDir,'/',trialString,'/',simString);
        cd(directory);
        rawPData = get_press_merge_11_13_17();
        
        
        t = rawPData.t; %timesteps
        P = rawPData.P; %LJ Dimensionless
        if max(size(t)) < nTimeMax
            nTimeMax = max(size(t));
            tF = t;
        end
        data{n,D} = {P};
    end
end
P_trial = zeros(nTimeMax,nTrials,nParam);
for n = 1 : 1 : nTrials
    for i = 1 : 1 : nParam
        P_trial(:,n,i) = data{n,i}{1,1}(1:nTimeMax);
    end
end
P_avg(:,:) = mean(P_trial,2);
P_std(:,:) = std(P_trial,0,2);


%----------Outputs-------------
%OUTPUTS IN SAME VARIABLE STRUCTURE
stat_data = {paramList; tF; P_avg; P_std};
%------------------------------
end

