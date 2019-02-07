function [varargout] = plot_statistical_particle_transport( varargin )
%Plots statistical particle count passing through each pore
%   Given the pore transport statistics as input, plots the cumulative
%   particle count through the given pore
%LJ dimensionless unit conversion for Argon gas
sigma = 3.4*10^(-10); %meters
mass = 6.69*10^(-26); %kilograms
epsilon = 1.65*10^(-21); %joules
tau = 2.17*10^(-12); %seconds
timestep = tau/200; %seconds

transport_data = varargin{1,1};
nPores = size(transport_data,2);
simList = transport_data{1,1}{2,1};
nSims = size(simList,1);

nTimes = inf;
for n = 1 : 1 : nPores
    
    pore{n} = transport_data{1,n}{1,1};
    time{n} = transport_data{1,n}{3,1}*timestep*(1/10^(-9)); %nanoseconds
    %%Need to move this time trimming to the
    %%calculate_ensemble_*_statistics.m files
    if size(time{n},2) < nTimes
        nTimes = size(time{n},2);
        t = time{n};
    end
    %    aF_avg{n} = transport_data{1,n}{4,1};
    %    aF_std{n} = transport_data{1,n}{5,1};
    aS_avg{n} = transport_data{1,n}{6,1};
    aS_std{n} = transport_data{1,n}{7,1};
    %    iF_avg{n} = transport_data{1,n}{8,1};
    %    iF_std{n} = transport_data{1,n}{9,1};
    iS_avg{n} = transport_data{1,n}{10,1};
    iS_std{n} = transport_data{1,n}{11,1};
end

for i = 1 : 1 : nSims
    
    simString = simList{i,1};
    parStrings = strsplit(simString,{'_'});
    
    wString = strsplit(parStrings{1,1},{'W'});
    W = str2double(wString{1,1});
    w=W*sigma*(10^(9)); %nanometers
    
    dString = strsplit(parStrings{1,2},{'D'});
    D = str2double(dString{1,1});
    d=D*sigma*(10^(9)); %nanometers
    
    %     hString = strsplit(parStrings{1,3},{'H'});
    %     H = str2double(hString{1,1});
    %     h=H*sigma*(10^(9)); %nanometers
    
    for j = 1 : 1 : nPores
        %    aFlowCount(:,j) = aF_avg{1,j}(1:nTimes,i);
        %    iFlowCount(:,j) = iF_avg{1,j}(1:nTimes,i);
        %        test = aS_avg{1,j};
        aSumCount(:,j) = aS_avg{1,j}(1,i,1:nTimes);
        iSumCount(:,j) = iS_avg{1,j}(1,i,1:nTimes);
        %    aFlowStd(:,j) = aF_std{1,j}(1:nTimes,i);
        %    iFlowStd(:,i,j) = iF_std{1,j}(1:nTimes,i);
        aSumStd(:,j) = aS_std{1,j}(1,i,1:nTimes);
        iSumStd(:,j) = iS_std{1,j}(1,i,1:nTimes);
        aSumUpConf(:,j) = aSumCount(1:nTimes,j) + aSumStd(1:nTimes,j);
        aSumLowConf(:,j) = aSumCount(1:nTimes,j) - aSumStd(1:nTimes,j);
        iSumUpConf(:,j) = iSumCount(1:nTimes,j) + iSumStd(1:nTimes,j);
        iSumLowConf(:,j) = iSumCount(1:nTimes,j) - iSumStd(1:nTimes,j);
    end
    if nPores == 1
        minC = min(aSumLowConf(:,1));
        maxC = max(aSumUpConf(:,1));
        
        fig = figure('Visible','off');
        p0a = plot(t,aSumCount(:,1),'b');
        hold on;
        p0au = plot(t,aSumUpConf(:,1),'b:');
        p0al = plot(t,aSumLowConf(:,1),'b:');
        %    title(['Net Argon Count Transmitted through Layers with Pores of Width W=' num2str(W) 'd, Impurity Diameter D=', num2str(D), 'd and Registry Shift H=', num2str(H),'d'], 'Interpreter', 'LaTex', 'FontSize', 8 );
        title(['Net Argon Count Transmitted through Layer with Pore of Width W=' num2str(W) 'd, Impurity Diameter D=', num2str(D), 'd'], 'Interpreter', 'LaTex', 'FontSize', 8 );
        xlabel('Time, $t ~ (ns)$','Interpreter','Latex');
        ylabel('Net Argon Particles Transmitted','Interpreter','latex');
        axis([0 max(t) minC maxC]);
        legend([p0a p0au], {'Avg. Particle Transmission', '95% Conf. Interval'},'Location','SouthEast');
        print(strcat('Net_Statistical_Argon_Particle_Transmitted_',simString), '-dpng');
        close(fig);
        
        minC = min(iSumLowConf(:,1));
        maxC = max(iSumUpConf(:,1));

        fig = figure('Visible','off');
        p0i = plot(t,iSumCount(:,1),'b');
        hold on;
        p0iu = plot(t,iSumUpConf(:,1),'b:');
        p0il = plot(t,iSumLowConf(:,1),'b:');
        %    title(['Impurity Count thru Layers with Pores of Width W=' num2str(W) 'd, Impurity Diameter D=', num2str(D), 'd and Registry Shift H=', num2str(H),'d'], 'Interpreter', 'LaTex', 'FontSize', 8 );
        title(['Impurity Count thru Layer with Pore of Width W=' num2str(W) 'd, Impurity Diameter D=', num2str(D), 'd'], 'Interpreter', 'LaTex', 'FontSize', 8 );
        xlabel('Time, $t ~ (ns)$','Interpreter','Latex');
        ylabel('Net Impurity Particles Transmitted','Interpreter','latex');
        axis([0 max(t) minC maxC]);
        legend([p0i p0iu], {'Avg. Particle Transmission', '95% Conf. Interval'},'Location','SouthEast');
        print(strcat('Net_Statistical_Impurity_Particle_Transmitted_',simString), '-dpng');
        close(fig);
        
    elseif nPores == 3
        if min(aSumLowConf(:,1)) < min(aSumLowConf(:,2)+aSumLowConf(:,3))
            minC = min(aSumLowConf(:,1));
        else
            minC = min(aSumLowConf(:,2)+aSumLowConf(:,3));
        end
        if max(aSumUpConf(:,1)) > max(aSumUpConf(:,2)+aSumUpConf(:,3))
            maxC = max(aSumUpConf(:,1));
        else
            maxC = max(aSumUpConf(:,2)+aSumUpConf(:,3));
        end
        fig = figure('Visible','off');
        p0a = plot(t,aSumCount(:,1),'b');
        hold on;
        p0au = plot(t,aSumUpConf(:,1),'b:');
        p0al = plot(t,aSumLowConf(:,1),'b:');
        p3a = plot(t,aSumCount(:,2)+aSumCount(:,3),'r');
        p3au = plot(t,aSumUpConf(:,2)+aSumUpConf(:,3),'r:');
        p3al = plot(t,aSumLowConf(:,2)+aSumLowConf(:,3),'r:');
        %    title(['Net Argon Count Transmitted through Layers with Pores of Width W=' num2str(W) 'd, Impurity Diameter D=', num2str(D), 'd and Registry Shift H=', num2str(H),'d'], 'Interpreter', 'LaTex', 'FontSize', 8 );
        title(['Net Argon Count Transmitted through Layers with Pores of Width W=' num2str(W) 'd, Impurity Diameter D=', num2str(D), 'd'], 'Interpreter', 'LaTex', 'FontSize', 8 );
        xlabel('Time, $t ~ (ns)$','Interpreter','Latex');
        ylabel('Net Argon Particles Transmitted','Interpreter','latex');
        axis([0 max(t) minC maxC]);
        legend([p0a p0au p3a p3au], {'1st Layer Avg.', '1st Layer 95% Conf.','2nd Layer Avg.', '2nd Layer 95% Conf.'},'Location','NorthWest');
        print(strcat('Net_Layer_Statistical_Argon_Particle_Transmitted_',simString), '-dpng');
        close(fig);
        
        if min(iSumLowConf(:,1)) < min(iSumLowConf(:,2)+iSumLowConf(:,3))
            minC = min(iSumLowConf(:,1));
        else
            minC = min(iSumLowConf(:,2)+iSumLowConf(:,3));
        end
        if max(iSumUpConf(:,1)) > max(iSumUpConf(:,2)+iSumUpConf(:,3))
            maxC = max(iSumUpConf(:,1));
        else
            maxC = max(iSumUpConf(:,2)+iSumUpConf(:,3));
        end
        fig = figure('Visible','off');
        p0i = plot(t,iSumCount(:,1),'b');
        hold on;
        p0iu = plot(t,iSumUpConf(:,1),'b:');
        p0il = plot(t,iSumLowConf(:,1),'b:');
        p1i = plot(t,iSumCount(:,2)+iSumCount(:,3),'r');
        p1iu = plot(t,iSumUpConf(:,2)+iSumUpConf(:,3),'r:');
        p1il = plot(t,iSumLowConf(:,2)+iSumLowConf(:,3),'r:');
        %    title(['Impurity Count thru Layers with Pores of Width W=' num2str(W) 'd, Impurity Diameter D=', num2str(D), 'd and Registry Shift H=', num2str(H),'d'], 'Interpreter', 'LaTex', 'FontSize', 8 );
        title(['Impurity Count thru Layers with Pores of Width W=' num2str(W) 'd, Impurity Diameter D=', num2str(D), 'd'], 'Interpreter', 'LaTex', 'FontSize', 8 );
        xlabel('Time, $t ~ (ns)$','Interpreter','Latex');
        ylabel('Net Impurity Particles Transmitted','Interpreter','latex');
        axis([0 max(t) minC maxC]);
        legend([p0i p0iu p1i p1iu], {'1st Layer Avg.', '1st Layer 95% Conf.','2nd Layer Avg.', '2nd Layer 95% Conf.'},'Location','NorthWest');
        print(strcat('Net_Layer_Statistical_Impurity_Particle_Transmitted_',simString), '-dpng');
        close(fig);
        
        if min(aSumLowConf(:,2)) < min(aSumLowConf(:,3))
            minC = min(aSumLowConf(:,2));
        else
            minC = min(aSumLowConf(:,3));
        end
        if max(aSumUpConf(:,2)) > max(aSumUpConf(:,3))
            maxC = max(aSumUpConf(:,2));
        else
            maxC = max(aSumUpConf(:,3));
        end
        fig = figure('Visible','off');
        p2a = plot(t,aSumCount(:,2),'b');
        hold on;
        p2au = plot(t,aSumUpConf(:,2),'b:');
        p1al = plot(t,aSumLowConf(:,2),'b:');
        p3a = plot(t,aSumCount(:,3),'r');
        p3au = plot(t,aSumUpConf(:,3),'r:');
        p3al = plot(t,aSumLowConf(:,3),'r:');
        %    title(['Argon Count thru 2nd Layer Pores of Width W=' num2str(W) 'd, Impurity Diameter D=', num2str(D), 'd and Registry Shift H=', num2str(H),'d'], 'Interpreter', 'LaTex', 'FontSize', 8 );
        title(['Argon Count thru 2nd Layer Pores of Width W=' num2str(W) 'd, Impurity Diameter D=', num2str(D), 'd'], 'Interpreter', 'LaTex', 'FontSize', 8 );
        xlabel('Time, $t ~ (ns)$','Interpreter','Latex');
        ylabel('Net Argon Particles Transmitted','Interpreter','latex');
        axis([0 max(t) minC maxC]);
        legend([p2a p2au p3a p3au], {'Upper Pore Avg.', 'Upper Pore 95% Conf.','Lower Pore Avg.', 'Lower Pore 95% Conf.'},'Location','SouthWest');
        print(strcat('Net_Dual_Pore_Statistical_Argon_Particle_Transmitted_',simString), '-dpng');
        close(fig);
        
        if min(iSumLowConf(:,2)) < min(iSumLowConf(:,3))
            minC = min(iSumLowConf(:,2));
        else
            minC = min(iSumLowConf(:,3));
        end
        if max(iSumUpConf(:,2)) > max(iSumUpConf(:,3))
            maxC = max(iSumUpConf(:,2));
        else
            maxC = max(iSumUpConf(:,3));
        end
        fig = figure('Visible','off');
        p2i = plot(t,iSumCount(:,2),'b');
        hold on;
        p2iu = plot(t,iSumUpConf(:,2),'b:');
        p1il = plot(t,iSumLowConf(:,2),'b:');
        p3i = plot(t,iSumCount(:,3),'r');
        p3iu = plot(t,iSumUpConf(:,3),'r:');
        p3il = plot(t,iSumLowConf(:,3),'r:');
        %    title(['Impurity Count thru 2nd Layer Pores of Width W=' num2str(W) 'd, Impurity Diameter D=', num2str(D), 'd and Registry Shift H=', num2str(H),'d'], 'Interpreter', 'LaTex', 'FontSize', 8 );
        title(['Impurity Count thru 2nd Layer Pores of Width W=' num2str(W) 'd, Impurity Diameter D=', num2str(D), 'd'], 'Interpreter', 'LaTex', 'FontSize', 8 );
        xlabel('Time, $t ~ (ns)$','Interpreter','Latex');
        ylabel('Net Impurity Particles Transmitted','Interpreter','latex');
        axis([0 max(t) minC maxC]);
        legend([p2i p2iu p3i p3iu], {'Upper Pore Avg.', 'Upper Pore 95% Conf.','Lower Pore Avg.', 'Lower Pore 95% Conf.'},'Location','SouthWest');
        print(strcat('Net_Dual_Pore_Statistical_Impurity_Particle_Transmitted_', simString), '-dpng');
        close(fig);
    end
    clear aSumCount aSumLowConf aSumUpConf aSumStd iSumCount iSumLowConf iSumUpConf iSumStd;
end

%----------Outputs-------------
%OUTPUTS IN SAME VARIABLE STRUCTURE
varargout{1}.t = t;
%------------------------------
end

