function [ sampleFreq, fundSampleFreq, powerSpectrum ] = ensemble_variable_FFT_unnormalized( steps, varAvg )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%LJ dimensionless unit conversion for Argon gas
% sigma = 3.4*10^(-10); %meters
% mass = 6.69*10^(-26); %kilograms
% epsilon = 1.65*10^(-21); %joules
% tau = 2.17*10^(-12); %seconds
% timestep = tau/200; %seconds
% kb = 1.38*10^(-23); %Joules/Kelvin
% 
% T=time(2,1)-time(1,1);
% Fs=1/T;
% L=length(time);
% f = Fs*(1:L)'/L;
% Y = fft(varAvg);
% P = abs(Y/L);
% [maxP, fundIndx] = max(P(2:end));
% fund = P(fundIndx+1);
% norm = P/maxP;

% skip = 25;

%[equibVal, varAvgDiff, thermalValStd] = equilibrium_difference(steps, varAvg);

nMax = size(steps,1);
n = (1 : 1 : nMax)';
sampleFreq = n/(nMax);
mag = fft(varAvg);
powerThreshold = 10;
powerSpectrum = (abs(mag)).^2;
for i=1:1:size(powerSpectrum)
    if powerSpectrum(i) < powerThreshold
       skip = i;
       break;
    end
end
[~, skipToIndex] = max(powerSpectrum(1+skip:nMax-(skip+1)));
fundIndex = skipToIndex + skip;
normSpectrum = powerSpectrum/powerSpectrum(fundIndex);
% normSpectrum = powerSpectrum/max(powerSpectrum);

fundSampleFreq = sampleFreq(fundIndex);

% figure();
% plot(n, normSpectrum);
% axis([0 750 0 1]);
% ylabel("Power Spectrum");
% close();

% [equibVal, varAvgDiff, thermalValStd] = equilibrium_difference(steps, varAvg);
% nMax = size(steps,1);
% tMax = steps(nMax,1)/200;
% t=steps/200;
% sampleFreq = t/(tMax);
% mag = fft(varAvgDiff);


%Convert to LJ dimensionless time
% freq = sampleFreq/(1000*200); %1/t* LJ dimensionless Unit
% fundFreq = fundSampleFreq/(1000*200); %1/t* LJ dimensionless Unit

%Convert to real time
% freq = sampleFreq/(1000*timestep*(1/(10^(-9)))); %GHz (1/ns)
% fundFreq = fundSampleFreq/(1000*timestep*(1/(10^(-9)))); %GHz (1/ns)

end

