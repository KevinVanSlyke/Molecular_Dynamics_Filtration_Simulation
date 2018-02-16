function [ varargout ] = plot_multiple_pressure_slices( )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%LJ dimensionless unit conversion for Argon gas
sigma = 3.4*10^(-10); %meters
mass = 6.69*10^(-26); %kilograms
epsilon = 1.65*10^(-21); %joules
tau = 2.17*10^(-12); %seconds
timestep = tau/200; %seconds
kb = 1.38*10^(-23); %Joules/Kelvin
x = (0:100:1900)'*sigma*1/(10^(-9)); %nm

outputPath = '/home/Kevin/Documents/Dust_Data/Molecular/February_2018_Movies_Boundary_DualFilter/Multi_Filter_Figures_and_Movies/';

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

rawPData = read_multiple_pressure_slice_data();

t = rawPData.t*timestep*(1/(10^(-9))); %ns; %timesteps
Pf = rawPData.Pf*epsilon/sigma^(2)*(1/(10^(-3))); %milliJoules/meter^2;
Pm = rawPData.Pm*epsilon/sigma^(2)*(1/(10^(-3))); %milliJoules/meter^2;
Pr = rawPData.Pr*epsilon/sigma^(2)*(1/(10^(-3))); %milliJoules/meter^2;

clear rawPData;

cd(outputPath);

fig = figure('Position',[100,100,1280,720],'Visible','off');
plot(t, Pf, 'b', t, Pm, 'r', t, Pr, 'black');
title(['Pressure in Vertical Slices for Pore Width W=' num2str(W) 'nm and Impurity Diameter D=' num2str(d) 'nm'], 'Interpreter', 'LaTex', 'FontSize', 8 );
xlabel('Time, $t ~ (ns)$','Interpreter','Latex');
ylabel('Pressure, $P ~ (\frac{mJ}{m^{2}})$','Interpreter','Latex');
legend('Front of 1st Layer', 'Between 1st and 2nd Layers', 'Rear of 2nd Layer');
print(strcat('Pressure_vs_Time_Layers_',simString), '-dpng');
close(fig);

cd(fPath);
%----------Outputs-------------
%OUTPUTS IN SAME VARIABLE STRUCTURE
varargout{1}.t = t;
varargout{1}.Pf = Pf;
varargout{1}.Pm = Pm;
varargout{1}.Pr = Pr;

%------------------------------end


end

