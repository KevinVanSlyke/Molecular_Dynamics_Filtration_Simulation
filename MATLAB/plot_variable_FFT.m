function [] = plot_variable_FFT(sampleFreq, fundSampleFreq, powerSpectrum, selectedVar, parNames, parVars, parVals, plotFFT)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

[parString] = catenate_parameters(parVars,parVals);
%Mute output of varName since y-axis is always power spectral density
[varTitle, ~] = format_variable_name(selectedVar);
%LJ dimensionless unit conversion for Argon gas
% sigma = 3.4*10^(-10); %meters
% mass = 6.69*10^(-26); %kilograms
% epsilon = 1.65*10^(-21); %joules
% tau = 2.17*10^(-12); %seconds
% timestep = tau/200; %seconds
% kb = 1.38*10^(-23); %Joules/Kelvin

%Convert from sample frequency to inverse timestep
freq = sampleFreq/1000; %Units of 1/timestep
fundFreq = fundSampleFreq/1000; %Units of 1/timestep
nMax = size(freq,1);

if strcmp(plotFFT, 'LJ') %Convert to LJ dimensionless time
    freq = freq*200; %1/t* LJ dimensionless Unit
    fundFreq = fundFreq*200;
elseif  strcmp(plotFFT, 'real')     %Convert to real time
	freq = freq*200/(2.17*10^(-12)*(10^(9))); %GHz (1/ns)
	fundFreq = fundFreq*200/(2.17*10^(-12)*(10^(9))); %GHz (1/ns)
end
normPower = powerSpectrum(1:nMax);

figFT = figure('Visible','off');
ax = axes('Visible','off');
plot(freq, normPower);
titleString = strcat("FT of", " ", varTitle, " ", "adjoining Filter with");
for i = 1 : 1 : size(parVars,2)
    titleString = strcat(titleString, " ", parNames(1,i), " ", parVars(1,i), "=", num2str(parVals(1,i)), "r*");
    if i < size(parNames,2)
        titleString = strcat(titleString, ",");
    end
end
title( titleString, 'Interpreter', 'LaTex', 'FontSize', 8 ); 
ylabel("Power Spectral Density",'Interpreter','latex');
if strcmp(plotFFT, 'LJ')
    xlabel("Frequency, $f ~ (\frac{1}{t*})$",'Interpreter','Latex');
elseif  strcmp(plotFFT, 'real')
    xlabel("Frequency, $f ~ (GHz)$",'Interpreter','Latex');
end
axis([0 5*fundFreq 0 1]);
print(strcat("FT_",parString,"_",plotFFT), '-dpng');
%savefig(figFT, strcat("FT_",parString,"_",plotFFT,".fig"));

close(figFT);
end

