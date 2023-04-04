function [varTitle, varSym] = format_variable_name(selectedVar)
%Normalizes variable names
%   Step TotEng KinEng PotEng c_gasTemp Press v_hopperPress c_hopperVx v_hopperArgonCount v_hopperImpurityCount v_interLayerPress c_interLayerVx v_interLayerArgonCount v_interLayerImpurityCount 

% varList = {'Step'; 'TotEng'; 'KinEng'; 'PotEng'; 'c_gasTemp'; 'Press'; 'v_hopperPress'; 'c_hopperVx'; 'v_hopperArgonCount'; 'v_hopperImpurityCount'; 'v_interLayerPress'; 'c_interLayerVx'; 'v_interLayerArgonCount'; 'v_interLayerImpurityCount'};

if strcmp(selectedVar, 'Step')
    varTitle = 'Time Step';
    varSym = '$\Delta(t)$';
elseif strcmp(selectedVar, 'TotEng')
    varTitle = 'Total Energy';
    varSym = '$E^*$';
elseif strcmp(selectedVar, 'KinEng')
    varTitle = 'Kinetic Energy';
    varSym = '$KE^*$';
elseif strcmp(selectedVar, 'PotEng')
    varTitle = 'Potential Energy';
    varSym = '$PE^*$';
elseif strcmp(selectedVar, 'c_gasTemp')
    varTitle = 'Gas Temp.';
    varSym = '$T^*$';
elseif strcmp(selectedVar, 'v_P')
    varTitle = 'Pressure';
    varSym = '$P^*$';
elseif strcmp(selectedVar, 'v_frontSlicePress')
    varTitle = 'Region I Pressure';
    varSym = '$P_{I}^*$';
elseif strcmp(selectedVar, 'v_midSlicePress')
    varTitle = 'Region II Pressure';
    varSym = '$P_{II}^*$';
elseif strcmp(selectedVar, 'v_rearSlicePress')
    varTitle = 'Region III Pressure';
    varSym = '$P_{III}^*$';
elseif strcmp(selectedVar, 'v_hopperPress')
    varTitle = 'Source Pressure';
    varSym = 'P_{\marthrm{Src.}}';
elseif strcmp(selectedVar, 'c_hopperVx')
    varTitle = 'Source Velocity';
    varSym = '$v_{x,\marthrm{Src.}}$';    
elseif strcmp(selectedVar, 'v_hopperArgonCount')
    varTitle = 'Source Argon Count';
    varSym = '$N_{A,\marthrm{Src.}}$';    
elseif strcmp(selectedVar, 'v_hopperImpurityCount')
    varTitle = 'Source Impurity Count';
    varSym = '$N_{I,\marthrm{Src.}}$';
elseif strcmp(selectedVar, 'v_interLayerPress')
    varTitle = 'Interlayer Pressure';
    varSym = 'P_{\marthrm{Int.}}';
elseif strcmp(selectedVar, 'c_interLayerVx')
    varTitle = 'Interlayer Velocity';
    varSym = '$v_{x,\marthrm{Int.}}$';    
elseif strcmp(selectedVar, 'v_interLayerArgonCount')
    varTitle = 'Interlayer Argon Count';
    varSym = '$N_{A,\marthrm{Int.}}$';    
elseif strcmp(selectedVar, 'v_interLayerImpurityCount')
    varTitle = 'Interlayer Impurity Count';
    varSym = '$N_{I,\marthrm{Int.}}$';
end
    
end

