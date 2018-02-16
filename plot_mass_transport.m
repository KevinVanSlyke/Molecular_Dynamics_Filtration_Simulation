function [varargout] = plot_mass_transport()
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%LJ dimensionless unit conversion for Argon gas
sigma = 3.4*10^(-10); %meters
mass = 6.69*10^(-26); %kilograms
epsilon = 1.65*10^(-21); %joules
tau = 2.17*10^(-12); %seconds
timestep = tau/200; %seconds

fPath = pwd;
dirs = strsplit(fPath,'/');
nDirParts = size(dirs,2);
cDir = dirs(nDirParts);
simString = cDir{1,1};
wString = strsplit(simString,{'W'});
W = str2double(wString{1,1});
w=W*sigma*(10^(9)); %nanometers

dString = strsplit(simString,{'_'});
DString = strsplit(dString{1,2},{'D'});
D = str2double(DString{1,1});
d=D*sigma*(10^(9)); %nanometers

outputDir = '/home/Kevin/Documents/Dust_Data/Molecular/February_2018_Movies_Boundary_DualFilter/Multi_Filter_Figures_and_Movies/';

pores = {'pore','pore1','pore2'};

for i = 1 : 1 : 3
    pore = pores{1,i};
    try
        transport_data = read_mass_transport_data(pore);
        t{i} = transport_data.t*timestep*(1/10^(-9)); %nanoseconds
        aS{i} = transport_data.argonSum;
        iS{i} = transport_data.impuritySum;
        aF{i} = transport_data.argonFlow;
        iF{i} = transport_data.impurityFlow;
    catch
        error('Wrong data format used in plot_mass_transport(), to use statistically formatted data see plot_ptcl_flux_11_13_17');
    end
end

cd(outputDir);

fig = figure('Visible','off');
p1 = plot(t{1},aS{1},'b');
hold on;
p2 = plot(t{2},aS{2},'r');
p3 = plot(t{3},aS{3},'black');
p4 = plot(t{3},aS{3}+aS{2},'b:');

title(['Net Argon Count Transmitted through Pores of Width W=' num2str(W) 'nm for Impurity Diameter D=' num2str(d) 'nm'], 'Interpreter', 'LaTex', 'FontSize', 8 );
xlabel('Time, $t ~ (ns)$','Interpreter','Latex');
ylabel('Net Argon Particles Transmitted','Interpreter','latex');
legend([p1 p2 p3 p4], {'Argon, 1st Layer', 'Argon, 2nd Layer Upper Pore', 'Argon, 2nd Layer Lower Pore', 'Argon, 2nd Layer Combined'},'Location','NorthWest');
print(['Net_Argon_Particle_Transmitted_W' num2str(W) '_D' num2str(D)], '-dpng');
close(fig);

fig = figure('Visible','off');
p1 = plot(t{1},iS{1},'b');
hold on;
p2 = plot(t{2},iS{2},'r');
p3 = plot(t{3},iS{3},'black');
p4 = plot(t{3},iS{3}+iS{2},'b:');

title(['Net Impurity Count Transmitted through Pores of Width W=' num2str(W) 'nm for Impurity Diameter D=' num2str(d) 'nm'], 'Interpreter', 'LaTex', 'FontSize', 8 );
xlabel('Time, $t ~ (ns)$','Interpreter','Latex');
ylabel('Net Impurity Particles Transmitted','Interpreter','latex');
legend([p1 p2 p3 p4], {'Impurity, 1st Layer', 'Impurity, 2nd Layer Upper Pore', 'Impurity, 2nd Layer Lower Pore', 'Impurity, 2nd Layer Combined'},'Location','NorthWest');
print(['Net_Impurity_Particle_Transmitted_W' num2str(W) '_D' num2str(D)], '-dpng');
close(fig);

cd(fPath);
%----------Outputs-------------
%OUTPUTS IN SAME VARIABLE STRUCTURE
varargout{1}.t = t;
varargout{1}.aF = aF;
varargout{1}.iF = iF;
varargout{1}.aS = aS;
varargout{1}.iS = iS;

%------------------------------
end

