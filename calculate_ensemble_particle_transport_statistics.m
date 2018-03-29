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

%%%Make this dynamic based on dir output%%%
%simStrings = {'20W_10D'; '20W_2D'; '200W_2D'; '50W_2D'; '20W_5D'; '50W_5D'};
widthStrings = {'20W'; '200W'};  %'50W_2D'; '50W_10D'; '20W_5D'; '50W_5D'};
diameterStrings = {'10D'; '2D'};
registryStrings = {'0H'; '1H'; '5H'; '10H'; '20H'; '50H'; '100H'; '200H'};
simCount = 1;
for i = 1 : 1 : max(size(widthStrings))
    for j = 1 : 1 : max(size(diameterStrings))
        for k = 1 : 1 : max(size(registryStrings))
            simStrings{simCount,1} = strcat(widthStrings{i,1}, '_',diameterStrings{j,1}, '_', registryStrings{k,1});;
            simCount = simCount + 1;
        end
    end
end
nSims = size(simStrings,1);
pores = {'pore'; 'pore1'; 'pore2'};
nPores = size(pores,1);
%baseDir = '/home/Kevin/Documents/Dust_Data/Molecular/.../';
baseDir = '/home/Kevin/Documents/Dust_Data/Molecular/March_2018_DualFilter_Statistical/Registry_Shift';
for j = 1 : 1 : nPores
    pore = pores{j,1};
    for i = 1 : 1 : nSims
        simString = simStrings{i,1};
        for n = 1 : 1 : nTrials
            trialString = strcat(simString, '_',num2str(n-1),'T');
            directory = strcat(baseDir,'/',simString,'/',trialString);
            cd(directory);
            rawTransportData = read_particle_transport_data(pore);
            
            trialT = rawTransportData.t; %timesteps
            %%Need to make seperate function to read only time from files
            if max(size(trialT)) < nTimeMax
                nTimeMax = max(size(trialT))-1;
                t = trialT(1:nTimeMax);
            end
            %%Can make this smarter using 4D matrices
        end
    end
    aFdata = zeros(nTrials, nSims, nTimeMax);
    aSdata = zeros(nTrials, nSims, nTimeMax);
    iFdata = zeros(nTrials, nSims, nTimeMax);
    iSdata = zeros(nTrials, nSims, nTimeMax);
    for i = 1 : 1 : nSims
        simString = simStrings{i,1};
        for n = 1 : 1 : nTrials
            trialString = strcat(simString, '_',num2str(n-1),'T');
            directory = strcat(baseDir,'/',simString,'/',trialString);
            cd(directory);
            rawTransportData = read_particle_transport_data(pore);
            
            argonFlow = rawTransportData.ptclTrans(:,1);
            impurityFlow = rawTransportData.ptclTrans(:,2);
            argonSum = rawTransportData.netPtclTrans(:,1);
            impuritySum = rawTransportData.netPtclTrans(:,2);
            %TODO: For some reason some trials only have N-1 particle transport data points but N times. 
                %Possibly because the last particle data is zero..?
            aFdata(n,i,:) = argonFlow(1:nTimeMax);
            aSdata(n,i,:) = argonSum(1:nTimeMax);
            iFdata(n,i,:) = impurityFlow(1:nTimeMax);
            iSdata(n,i,:) = impuritySum(1:nTimeMax);
        end
    end
    
    %     aF_trial = zeros(nTimeMax,nTrials,nSims);
    %     aS_trial = zeros(nTimeMax,nTrials,nSims);
    %     iF_trial = zeros(nTimeMax,nTrials,nSims);
    %     iS_trial = zeros(nTimeMax,nTrials,nSims);
    % %     aF_avg = zeros(nTimeMax,nSims);
    % %     aF_std = zeros(nTimeMax,nSims);
    % %     aS_avg = zeros(nTimeMax,nSims);
    % %     aS_std = zeros(nTimeMax,nSims);
    % %     iF_avg = zeros(nTimeMax,nSims);
    % %     iF_std = zeros(nTimeMax,nSims);
    % %     iS_avg = zeros(nTimeMax,nSims);
    % %     iS_std = zeros(nTimeMax,nSims);
    %     for i = 1 : 1 : nSims
    %         for n = 1 : 1 : nTrials
    %             aF_trial(:,n,i) = aFdata{n,i}{1,1}(1:nTimeMax);
    %             aS_trial(:,n,i) = aSdata{n,i}{1,1}(1:nTimeMax);
    %             iF_trial(:,n,i) = iFdata{n,i}{1,1}(1:nTimeMax);
    %             iS_trial(:,n,i) = iSdata{n,i}{1,1}(1:nTimeMax);
    %         end
    %     end
    aF_avg = mean(aFdata,1);
    aF_std = std(aFdata,0,1);
    aS_avg = mean(aSdata,1);
    aS_std = std(aSdata,0,1);
    iF_avg = mean(iFdata,1);
    iF_std = std(iFdata,0,1);
    iS_avg = mean(iSdata,1);
    iS_std = std(iSdata,0,1);
    
    stat_data{:,j} = {pore; simStrings; t; aF_avg; aF_std; aS_avg; aS_std; iF_avg; iF_std; iS_avg; iS_std};
end
%%Need to do time trimming at the end for all pores/trials/simulations

cd(baseDir);
%----------Outputs-------------
%OUTPUTS IN SAME VARIABLE STRUCTURE
varargout{1}.transport_stats = stat_data;
%------------------------------
end

