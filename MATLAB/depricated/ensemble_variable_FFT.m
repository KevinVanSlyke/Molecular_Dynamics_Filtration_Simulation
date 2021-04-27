function [ sampleFreq, fundSampleFreq, powerSpectrum ] = ensemble_variable_FFT( steps, varAvg )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%LJ dimensionless unit conversion for Argon gas
% sigma = 3.4*10^(-10); %meters
% mass = 6.69*10^(-26); %kilograms
% epsilon = 1.65*10^(-21); %joules
% tau = 2.17*10^(-12); %seconds
% timestep = tau/200; %seconds
% kb = 1.38*10^(-23); %Joules/Kelvin
skip = 10;

[equibVal, varAvgDiff, thermalValStd] = equilibrium_difference(steps, varAvg);

nMax = size(steps,1);
n = (1 : 1 : nMax)';
sampleFreq = n/(nMax);
mag = fft(varAvgDiff);
powerSpectrum = (abs(mag)).^2;
[powerMax, fundIndx] = max(powerSpectrum(skip:nMax));

fundSampleFreq = sampleFreq(fundIndx);
%peakDistance = 1/fundSampleFreq;

%Convert to LJ dimensionless time
% freq = sampleFreq/(1000*200); %1/t* LJ dimensionless Unit
% fundFreq = fundSampleFreq/(1000*200); %1/t* LJ dimensionless Unit

%Convert to real time
% freq = sampleFreq/(1000*timestep*(1/(10^(-9)))); %GHz (1/ns)
% fundFreq = fundSampleFreq/(1000*timestep*(1/(10^(-9)))); %GHz (1/ns)

end

