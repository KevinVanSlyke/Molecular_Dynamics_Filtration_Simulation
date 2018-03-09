function [stat_data] = calculate_ensemble_particle_transport_statistics()
%Calculates average and standard deviation of particle transport
%   For a given list of simulation ID's their particle transport data is iteratively read from
%   multiple runs differing only by random seed. Statistical average and
%   standard deviation are then calculated and output.

%LJ dimensionless unit conversion for Argon gas
%sigma = 3.4*10^(-10); %meters
%mass = 6.69*10^(-26); %kilograms
%epsilon = 1.65*10^(-21); %joules
%tau = 2.17*10^(-12); %seconds
%timestep = tau/200; %seconds
%kb = 1.38*10^(-23); %Joules/Kelvin

nTimeMax = Inf;

nTrials = 5;
%maxParam = 20;
%minParam = 1;
%stepParam = 1;
%paramList = (minParam:stepParam:maxParam);
%nParam = max(size(paramList));
simStrings = {'20W_10D'; '20W_2D'; '200W_10D'; '200W_2D'; '50W_10D'; '50W_2D'};
nSims = size(simStrings,1);
pores = {'pore'; 'pore1'; 'pore2'};
nPores = size(pores,1);
%baseDir = '/home/Kevin/Documents/Dust_Data/Molecular/.../';
baseDir = '/home/Kevin/Documents/Dust_Data/Molecular/February_2018_Movies_Boundary_DualFilter/Multi-Filter_Spacing_Data/Filter_Spacing_100';
for j = 1 : 1 : nPores
    pore = pores{j,1};
    for n = 1 : 1 : nTrials
        trialString = strcat('Multi_Filter_Trial_', num2str(n-1));
        for i = 1 : 1 : nSims
            simString = simStrings{i,1};
            directory = strcat(baseDir,'/',trialString,'/',simString);
            cd(directory);
            rawTransportData = read_particle_transport_data(pore);
            
            t = rawTransportData.t; %timesteps
            argonFlow = rawTransportData.ptclTrans(:,1);
            impurityFlow = rawTransportData.ptclTrans(:,2);
            argonSum = rawTransportData.netPtclTrans(:,1);
            impuritySum = rawTransportData.netPtclTrans(:,2);
            %%Need to move time trimming to the end
            if max(size(t)) < nTimeMax
                nTimeMax = max(size(t));
                tF = t;
            end
            %%Can make this smarter using 4D matrices
            aFdata{n,i} = {argonFlow};
            aSdata{n,i} = {argonSum};
            iFdata{n,i} = {impurityFlow};
            iSdata{n,i} = {impuritySum};
            
        end
    end
    aF_trial = zeros(nTimeMax,nTrials,nSims);
    aS_trial = zeros(nTimeMax,nTrials,nSims);
    iF_trial = zeros(nTimeMax,nTrials,nSims);
    iS_trial = zeros(nTimeMax,nTrials,nSims);
    aF_avg = zeros(nTimeMax,nSims);
    aF_std = zeros(nTimeMax,nSims);
    aS_avg = zeros(nTimeMax,nSims);
    aS_std = zeros(nTimeMax,nSims);
    iF_avg = zeros(nTimeMax,nSims);
    iF_std = zeros(nTimeMax,nSims);
    iS_avg = zeros(nTimeMax,nSims);
    iS_std = zeros(nTimeMax,nSims);
    for n = 1 : 1 : nTrials
        for i = 1 : 1 : nSims
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
    stat_data{:,j} = {pore; simStrings; tF; aF_avg; aF_std; aS_avg; aS_std; iF_avg; iF_std; iS_avg; iS_std};
end
%%Need to do time trimming at the end for all pores/trials/simulations

cd(baseDir);
%----------Outputs-------------
%OUTPUTS IN SAME VARIABLE STRUCTURE
varargout{1}.transport_stats = stat_data;
%------------------------------
end

