function [] = plot_raw_loaded_ensemble_stat_data()
cwd = pwd;

ensembleDataList = dir(fullfile(cwd));
nEnsembleData = size(ensembleDataList,1);
nEnsemble = 0;
for n = 1 : 1 : nEnsembleData
    if (endsWith(ensembleDataList(n).name(),'_stats_data.mat'))
        nEnsemble = nEnsemble + 1;
        load(ensembleDataList(n).name());
        
        [steps, ~] = select_thermo_var(varNames, ensembleAvgVals, ensembleStdVals, 'Step');
        [varAvg, varStd] = select_thermo_var(varNames, ensembleAvgVals, ensembleStdVals, selectedVar);
        
        if strcmp(plotFit, 'LJ') == 1
            t = steps/200; %LJ dimensionless, 0.005*t^*=step, 0.005 t^*/step=1, N*step*(0.005*t^*/step) = N*0.005*t^*
        elseif strcmp(plotFit, 'real') == 1
            t = steps/200*2.17*10^(-12)*10^9; %convert to ns with t^* = 2.17*10^(-12)s
        end
        [varTitle, varSym] = format_variable_name(selectedVar);
        [parString] = catenate_parameters(parVars,parVals);
        titleString = strcat(varTitle, " adjoining Filter with ");
        for i = 1 : 1 : size(parVars,2)
            titleString = strcat(titleString, parNames(1,i), " ", parVars(1,i), "=", num2str(parVals(1,i)), "r*");
            if i < size(parNames,2)
                titleString = strcat(titleString, ", ");
            end
        end
        rawFig = figure('Visible','on');
        ax = axes('Visible','off');
        plot(t, varAvg, '.');
        title(titleString, 'Interpreter', 'LaTex', 'FontSize', 8 );
        ylabel(strcat('Pressure (', varSym,')'),'Interpreter','Latex');
        %legend("Data", "Exp. Decay Fit");
        legend("Avg. $P_{front}$",'Interpreter','Latex');
        if parVals(1,1) < 2000
            axis([0 max(t) 0.9*min(varAvg) 1.1*max(varAvg)]);
        else
            axis([0 max(t) -0.001 0.001]);
        end
        if strcmp(plotFit, 'LJ') == 1
            xlabel("Time ($t^*$)",'Interpreter','Latex');
        elseif strcmp(plotFit, 'real') == 1
            xlabel("$t (ns)$",'Interpreter','Latex');
        end
        print(strcat("Raw_Statistical_",varTitle,"_vs_Time_",parString,"_",plotFit), '-dpng');
        savefig(rawFig, strcat("Raw_Statistical_",varTitle,"_vs_Time_",parString,"_",plotFit,".fig"));
        
        [ sampleFreq, fundSampleFreq, powerSpectrum ] = ensemble_variable_FFT( steps, varAvg );
        [parString] = catenate_parameters(parVars,parVals);
        [varTitle, ~] = format_variable_name(selectedVar);
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
        
        figFT = figure('Visible','on');
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
        axis([0 3*10^(-3) 0 1]);
        print(strcat("Raw_FT_",parString,"_",plotFFT,""), '-dpng');
        savefig(figFT, strcat("Raw_FT_",parString,"_",plotFFT,".fig"));

        close(rawFig);
        close(figFT);
    end
end