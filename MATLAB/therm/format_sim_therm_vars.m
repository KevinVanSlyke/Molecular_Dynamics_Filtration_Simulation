function [axisLabel,varString] = format_sim_therm_vars(varNames)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
nVars = size(varNames,2);

%Format is assumed to be W -> D -> L -> F -> S -> H
for i = 1 : 1 : nVars
    if strcmp(varNames(i),"Step")
        axisLabel = "Time $(10^4~t^*)$";
    elseif strcmp(varNames(i),"TotEng")
        varString = "TotEng";
        axisLabel = "Total Energy $(E^*)$";
    elseif strcmp(varNames(i),"KinEng")
        varString = "KinEng";
        axisLabel = "Kinetic Energy $(E^*)$";
    elseif strcmp(varNames(i),"PotEng")
        varString = "PotEng";
        axisLabel = "Potential Energy $(E^*)$";
    elseif strcmp(varNames(i),"c_gasTemp")
        varString = "Temp";
        axisLabel = "Temperature $(T^*)$";
    elseif strcmp(varNames(i),"Press")
        varString = "GlobPress";
        axisLabel = "Global Pressure $(P^*)$";
    elseif strcmp(varNames(i),"v_hopperPress")
        varString = "HopperPress";
        axisLabel = "Source Pressure, $P_0~(P^*)$";
    elseif strcmp(varNames(i),"v_hopperVx")
        varString = "HopperVx";
        axisLabel = "Source Horizontal Velocity, $v_x~(r^*/t^*)$";
    elseif strcmp(varNames(i),"v_hopperArgonCount")
        varNames(i) = "Orifice Separation";
    elseif strcmp(varNames(i),"v_hopperImpurityCount")
        varNames(i) = "Filter Spacing";     
    elseif strcmp(varNames(i),"v_interLayerPress")
        varNames(i) = "Impurity Diameter";
    elseif strcmp(varNames(i),"v_interLayerVx")
        varNames(i) = "Filter Thickness";
    elseif strcmp(varNames(i),"v_interLayerArgonCount")
        varNames(i) = "Orifice Separation";
    elseif strcmp(varNames(i),"v_interLayerImpurityCount")
        varNames(i) = "Filter Spacing"; 
    end
end

