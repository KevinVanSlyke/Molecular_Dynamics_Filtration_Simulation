function [stat_data] = calculate_ensemble_mass_transport_statistics(~)
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

baseDir = '/home/Kevin/Documents/Dust_Data/Molecular/October_2017_Multiple_Parameters/Diameter/Diameter_Trials';
for n = 1 : 1 : nTrials
    trialString = ['Diameter_Trial' num2str(n)];
    for D = 1 : 1 : 20
        simString = ['D' num2str(D)];
        directory = strcat(baseDir,'/',trialString,'/',simString);
        cd(directory);
        if n == 1
            rawFluxData = calc_particle_flow_12_10_17();
        elseif D == 1
            rawFluxData = calc_particle_flow_12_10_17();
        elseif n >= 4
            rawFluxData = calc_particle_flow_11_12_17();
        else
            rawFluxData = calc_particle_flow_11_02_17();
        end
        
        t = rawFluxData.t; %timesteps
        argonFlow = rawFluxData.argonFlow;
        impurityFlow = rawFluxData.impurityFlow;
        argonSum = rawFluxData.argonSum;
        impuritySum = rawFluxData.impuritySum;
        if max(size(t)) < nTimeMax
            nTimeMax = max(size(t));
            tF = t;
        end
        aFdata{n,D} = {argonFlow};
        aSdata{n,D} = {argonSum};
        iFdata{n,D} = {impurityFlow};
        iSdata{n,D} = {impuritySum};

    end
end
aF_trial = zeros(nTimeMax,nTrials,nParam);
aS_trial = zeros(nTimeMax,nTrials,nParam);
iF_trial = zeros(nTimeMax,nTrials,nParam);
iS_trial = zeros(nTimeMax,nTrials,nParam);

for n = 1 : 1 : nTrials
    for i = 1 : 1 : nParam
        aF_trial(:,n,i) = aFdata{n,i}{1,1}(1:nTimeMax);
        aS_trial(:,n,i) = aSdata{n,i}{1,1}(1:nTimeMax);
        iF_trial(:,n,i) = iFdata{n,i}{1,1}(1:nTimeMax);
        iS_trial(:,n,i) = iSdata{n,i}{1,1}(1:nTimeMax);
    end
end
aF_avg(:,:) = mean(aF_trial,2);
aF_std(:,:) = std(aF_trial,0,2);
aS_avg(:,:) = mean(aS_trial,2);
aS_std(:,:) = std(aS_trial,0,2);
iF_avg(:,:) = mean(iF_trial,2);
iF_std(:,:) = std(iF_trial,0,2);
iS_avg(:,:) = mean(iS_trial,2);
iS_std(:,:) = std(iS_trial,0,2);

%----------Outputs-------------
%OUTPUTS IN SAME VARIABLE STRUCTURE
stat_data = {paramList; tF; aF_avg; aF_std; aS_avg; aS_std; iF_avg; iF_std; iS_avg; iS_std};
%------------------------------
end

