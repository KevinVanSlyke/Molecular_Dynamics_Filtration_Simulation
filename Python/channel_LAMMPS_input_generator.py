# -*- coding: utf-8 -*-
"""
Created on Fri Aug 18 14:46:50 2017
@author: Kevin Van Slyke
"""
import time
import os
import stat

def channel_LAMMPS_input_generator(timeSteps, orificeWidth, impurityDiameter, filterDepth, dumpMovies):

    ##Dimension and number of filters assumed to be 2
    # nFilters = 1
    dimensions = 2

    bufferWidth = 20*5
    xFilter = 2000
    ##Spatial input parameters
    xMax = xFilter+filterDepth+2*bufferWidth
    xMin = 0
    yMax = 2000
    yMin = 0
    dx = 20
    dy = 20
    zMax = 0.01
    zMin = -0.01

    halfOrificeWidth = int(orificeWidth/2)
    ##Filter limits
    xLeftMin = xFilter
    xLeftMax = xLeftMin+filterDepth-1
    yHalf = int((yMax-1)/2)
    yLeftLowerMax = yHalf-halfOrificeWidth
    yLeftUpperMin = yHalf+halfOrificeWidth+1

    ##Chunk data limits, set to square region for easy plotting

    ##X*9,Y*9
    # xChunkLow=xLeftMin-bufferWidth-1
    # xChunkHigh=xMax-1
    # yChunkLow=yHalf-halfOrificeWidth-bufferWidth
    # yChunkHigh=yHalf+halfOrificeWidth+bufferWidth
   
    ##X*0,Y*0
    xChunkLow=xLeftMin-bufferWidth
    xChunkHigh=xMax
    yChunkLow=round(yLeftLowerMax-bufferWidth+1,-1)
    yChunkHigh=round(yLeftUpperMin+bufferWidth+1,-1)
    
    ##X*0,Y*9
    # xChunkLow=xLeftMin-bufferWidth
    # xChunkHigh=xMax
    # yChunkLow=yHalf-halfOrificeWidth-bufferWidth
    # yChunkHigh=yHalf+halfOrificeWidth+bufferWidth
   
    ##X*9,Y*0
    # xChunkLow=xLeftMin-bufferWidth-1
    # xChunkHigh=xMax-1
    # yChunkLow=yHalf-halfOrificeWidth-bufferWidth+1
    # yChunkHigh=yHalf+halfOrificeWidth+bufferWidth+1

    numChunkX = (xChunkHigh-xChunkLow)/dx
    numChunkY = (yChunkHigh-yChunkLow)/dy

    if (xChunkHigh-xChunkLow) > (yChunkHigh-yChunkLow):
        yChunkLow=round(yHalf-int(dy*numChunkX/2)+1,-1)
        yChunkHigh=round(yHalf+int(dy*numChunkX/2)+1,-1)
    elif (xChunkHigh-xChunkLow) < (yChunkHigh-yChunkLow):
        xChunkLow=xChunkHigh-int(dx*numChunkY)
        # xChunkHigh=xFilter-yHalf+yChunkHigh

    ##Default for 2D simulation of L_x = 2000, L_y = 2000
    nTotal = 4*10**(5)
    nImpurities = int(nTotal*0.05)

    ##Initialization temperature and velocity parameters
    fluidTemperature = 1

    ##Required Temporal input parameters
    timeStep = 0.005
    thermoTime = 10**(3)
    dynamicTime = 10**(3)
    totalTime = timeSteps
    archiveTime = totalTime

    ##Energy minimation parameters/thresholds
    eMin = 10**(-6)
    fMin = 10**(-6)
    maxIterations = 10**(9)
    maxEvaluations = 10**(9)

    ##Time information for output of video
    movieDuration = 1*10**(4)
    movieFrameDelta = 1000

    ##Init empty arrays for atom attributes
    idType = []
    nType = []
    diameterType = []
    massType = []
    ##idType[0] is Atom Type 1, Filter Molecules, n = 0 to make list entries line up
    idType.append(1)
    nType.append(0)
    diameterType.append(1.)
    massType.append(1000)

    ##idType[1] is Atom Type 2, Argon Molecules
    idType.append(2)
    diameterType.append(1.)
    massType.append(1)

    ##add idType[2] for impurities, else just make more argon
    if impurityDiameter != 1:
        atomTypes = 3
        nType.append(nTotal-nImpurities)
        idType.append(3)
        nType.append(nImpurities)
        diameterType.append(impurityDiameter)
        if dimensions == 2:
            massType.append(impurityDiameter**2)
        elif dimensions == 3:
            massType.append(impurityDiameter**3)
    else:
        atomTypes = 2
        nType.append(nTotal)

    ##Create a unique identifier for the run
    trialName = '{0}W_{1}D'.format(orificeWidth, impurityDiameter)
    if filterDepth != 0:
        trialName = trialName + '_{0}L'.format(filterDepth)

    inputFile = 'input_' + trialName + '.lmp'

    """
        Primary LAMMPS start/restart files
    """
    sf = open(inputFile, 'w')

    ##Write header
    sf.write('## LAMMPS input start file for filtration research  \n')
    sf.write('## Written by Kevin Van Slyke  \n')
    sf.write('## Dated: ' + time.strftime("%m_%d_%Y") + '\n')
    sf.write('\n')
    ##Write neighborhood and thermo frequency
    sf.write('## Multi neighbor and comm for efficiency \n')
    sf.write('neighbor    1 multi \n')
    sf.write('neigh_modify    delay 0 \n')
    sf.write('comm_modify    mode multi \n')
    sf.write('\n')
    sf.write('thermo    {0}    #Print thermo vars every {0} timesteps \n'.format(thermoTime))
    sf.write('\n')
    ##Write LJ parameters
    sf.write('## Set simulation unit and atom style to dimensionless LJ particles \n')
    sf.write('units    lj    #Simple Lennard-Jones cut-off potential \n')
    sf.write('atom_style     atomic     #Particles have mass \n')
    sf.write('dimension    {0}    #Fix simulation to {0}D \n'.format(dimensions))
    ##Write simulation domain
    # sf.write('boundary    p f p    #Set boundaries such that x_axis=periodic, y_axis=fixed, z_axis=periodic \n')
    # sf.write('boundary    f f p    #Set boundaries such that x_axis=fixed, y_axis=fixed, z_axis=periodic \n')
    sf.write('boundary    f p p    #Set boundaries such that x_axis=fixed, y_axis=periodic, z_axis=periodic \n')
    # sf.write('boundary    fm p p    #Set boundaries such that x_axis=fixedMinShrinkwrap, y_axis=periodic, z_axis=periodic \n')

    sf.write('lattice    sq 1    #Simple square lattice with one basis atom per cell, lattice_spacing=1/1=1, reduced density rho = 1 \n')
    sf.write('region    box block {0} {1} {2} {3} {4} {5}    #Create extruded rectangular simulation volume in units of lattice sites, {0}<=x<{1}, {2}<=y<{3}, {4}<=z<{5} \n'.format(xMin,xMax,yMin,yMax,zMin,zMax))

    sf.write('create_box    {0} box    #Create simulation volume in region box with {0} atom types \n'.format(atomTypes))
    sf.write('timestep    {0}    #One timestep={0}*tau, tau=2.17*10^(-12)s for Argon \n'.format(timeStep))
    sf.write('\n')

    ##Cutoff is set so filter molecules don't self interact, all other species is (radius1+radius2)*2**(1/6)
    sf.write('## LJ potential: atom type 1, atom type 2, epsilon, sigma \n')
    sf.write('pair_style    lj/cut 1.122462    #Lennard-Jones global cut-off=1.122462 \n')
    epsilon = 1.0
    for i in range(atomTypes):
        for j in range(atomTypes):
            if i <= j:
                sigma = diameterType[i]/2. + diameterType[j]/2.
                if ((idType[i] == 1) and (idType[j] == 1)): #Wall self interaction
                    cutOff = 0.5
                else:
                    cutOff = sigma*1.122462 #1.122462 = 2**(1/6)
                sf.write('pair_coeff     {0} {1} {2} {3} {4}     #Type:{0}-{1}, E={2}, sigma={3}, r_c={4} \n'.format(idType[i], idType[j], epsilon, sigma, cutOff))
    ##Shift potential to zero at minima
    sf.write('pair_modify    shift yes    #Shifts LJ potential to 0.0 at the cut-off \n')
    sf.write('\n')

    ##Write masses
    for i in range(atomTypes):
        sf.write('mass    {0} {1}    #Sets mass of particle type {0} to {1} \n'.format(idType[i], massType[i]))
    sf.write('\n')

    ##Create filter regions, add atoms and assign group
    sf.write('## Define the filter area and fill it with atoms fixed to lattice sites \n')
    sf.write('region    topWall block {0} {1} {2} {3} {4} {5}    #Top half of single pore filter \n'.format(xLeftMin, xLeftMax, yLeftUpperMin, yMax, 0, 0))
    sf.write('region    botWall block {0} {1} {2} {3} {4} {5}    #Bottom half of single pore filter \n'.format(xLeftMin, xLeftMax, yMin, yLeftLowerMax, 0, 0))
    sf.write('create_atoms    {0} region topWall \n'.format(idType[0]))
    sf.write('create_atoms    {0} region botWall \n'.format(idType[0]))
    sf.write('group    topFilter region topWall \n')
    sf.write('group    botFilter region botWall \n')
    sf.write('group    filter union topFilter botFilter \n')
   

    ##Create hopper region, add atoms and assign group
    # sf.write('region    hopper block {0} {1} {2} {3} {4} {5}    #Front Region to be filled by gas \n'.format(xMin+diameterType[-1]/2+1, xLeftMin-diameterType[-1]/2-1, yMin+diameterType[-1]/2+1, yMax-diameterType[-1]/2-1, 0, 0))
    sf.write('region    hopper block {0} {1} {2} {3} {4} {5}    #Front Region to be filled by gas \n'.format(xMin+diameterType[-1]/2, xLeftMin-diameterType[-1]/2, yMin+diameterType[-1]/2, yMax-diameterType[-1]/2, 0, 0))
    sf.write('## Define the flow area and populate with gas molecules \n')
    for i in range(1,atomTypes):
        sf.write('create_atoms    {0} random {1} $'.format(idType[i], nType[i]) + '{ran' + str(i-1) + '} ' + 'hopper    #Create atoms: type={0}, placement=random, N={1}, seed=$'.format(idType[i], nType[i]) + '{ran' + str(i-1) + '}, region=vacuum \n')
    if atomTypes == 2:
        sf.write('group    gas type {0}    #Create group of freely moving Argon gas particles \n'.format(idType[1]))
        sf.write('group    argon type {0}    #Create group of freely moving Argon gas particles \n'.format(idType[1]))
    else:
        sf.write('group    gas type {0}:{1}    #Create group of freely moving particles \n'.format(idType[1], idType[2]))
        sf.write('group    argon type {0}    #Create group of freely moving Argon gas particles \n'.format(idType[1]))
        sf.write('group    impurity type {0}    #Create group of the less common impurity particles \n'.format(idType[2]))
    sf.write('\n')

    ##Set fixes for 2D, reflective boundaries when desired
    sf.write('## Thermodynamic calculation method and dynamics \n')
    sf.write('fix    1 gas nve    #Fix microcanonical ensemble \n')
    sf.write('fix    2 filter setforce 0.0 0.0 0.0  #Fix force on filter to zero \n')
    # sf.write('fix    3 gas wall/reflect xlo {0} ylo {1} yhi {2}    #Fix walls parallel to xz plane at x={0}, y={1} and y={2} to reflect particles \n'.format(xMin,yMin,yMax-1))
    sf.write('fix    3 gas wall/reflect xlo {0}    #Fix wall parallel to xz plane at x={0} to reflect particles \n'.format(xMin))
    sf.write('fix    4 all enforce2d    #Fix motion along the z-axis to simulate 2D \n')
    sf.write('\n')

    ##Minimize energy to prevent atom loss from overlap
    sf.write('## All parameters but filter and velocities are set so we minize energy to prevent overlap of particles \n')
    sf.write('minimize    {0} {1} {2} {3}  #Stopping tolerances: energy={0}, force={1}, max iterations={2}, max evaluations={3} \n'.format(eMin, fMin, maxIterations, maxEvaluations))
    sf.write('reset_timestep    0 \n')
    sf.write('\n')

    ##Set initial velocities from MB distribution
    sf.write('## Define velocity for initialization of gas and fixing filter \n')
    sf.write('velocity	filter set 0.0 0.0 0.0     #Set initial velocity of walls to zero \n')
    sf.write('velocity    gas create {0} $'.format(fluidTemperature) + '{ran3} dist gaussian ' + '#Create velocity of gas particles from a Gaussian distribution at ' + 'temperature={0}'.format(fluidTemperature) +  ' with random seed=${ran3} \n')
    sf.write('\n')

    ##Output regions and calculations
    calcRegions = ['hopper',  'channel']
    regionXMin = [xMin-1, xLeftMin-1]
    regionXMax = [xLeftMin+1, xLeftMax+1+1]
    regionYMin = [yMin-1, yLeftLowerMax]
    regionYMax = [yMax+1, yLeftUpperMin+1]
    sf.write('## Compute thermodynamic temperature based only on gas molecules \n')
    sf.write('compute    gasTemp gas temp \n')
    sf.write('\n')
    sf.write('## Define regions in which Pressure will be calculated and inside of the pore \n')
    for i in range(len(calcRegions)):
        ##Define region and dynamic group
        sf.write('region    {0}Region block {1} {2} {3} {4} {5} {6} \n'.format(calcRegions[i], regionXMin[i], regionXMax[i], regionYMin[i], regionYMax[i], 0, 0))
        sf.write('group    {0}GasGroup dynamic gas region {0}Region every {1} \n'.format(calcRegions[i], dynamicTime))
        ##Compute pressure from stress tensor
        sf.write('compute    {0}Pp {0}GasGroup stress/atom gasTemp ke pair \n'.format(calcRegions[i]))
        sf.write('compute    {0}Ps {0}GasGroup reduce sum c_{0}Pp[1] c_{0}Pp[2] \n'.format(calcRegions[i]))
        sf.write('variable    {0}Px equal -(c_{0}Ps[1])/({1}*{2}) \n'.format(calcRegions[i], regionXMax[i]-regionXMin[i]-2, regionYMax[i]-regionYMin[i]-2))
        sf.write('variable    {0}Py equal -(c_{0}Ps[2])/({1}*{2}) \n'.format(calcRegions[i], regionXMax[i]-regionXMin[i]-2, regionYMax[i]-regionYMin[i]-2))
        sf.write('variable    {0}Press equal (v_{0}Px+v_{0}Py)/2 \n'.format( calcRegions[i]))
        sf.write('\n')
        ##Compute center of mass velocity in x direction
        sf.write('compute    {0}Vxs {0}GasGroup property/atom vx \n'.format(calcRegions[i]))
        sf.write('compute    {0}Vx {0}GasGroup reduce ave c_{0}Vxs \n'.format(calcRegions[i]))
        sf.write('\n')

        ##Compute number of argon and impurities if applicable
        if atomTypes == 2:
            sf.write('compute    {0}ArgonMasses {0}GasGroup property/atom mass \n'.format(calcRegions[i]))
            sf.write('compute    {0}ArgonMass {0}GasGroup reduce sum c_{0}ArgonMasses \n'.format(calcRegions[i]))
            sf.write('variable     {0}ArgonCount equal c_{0}ArgonMass/{1}'.format(calcRegions[i], massType[1]))
            sf.write('\n')
        else:
            sf.write('group    {0}ArgonGroup dynamic argon region {0}Region every {1} \n'.format(calcRegions[i], dynamicTime))
            sf.write('compute    {0}ArgonMasses {0}ArgonGroup property/atom mass \n'.format(calcRegions[i]))
            sf.write('compute    {0}ArgonMass {0}ArgonGroup reduce sum c_{0}ArgonMasses \n'.format(calcRegions[i]))
            sf.write('variable     {0}ArgonCount equal c_{0}ArgonMass/{1}'.format(calcRegions[i], massType[1]))
            sf.write('\n')
            sf.write('group    {0}ImpurityGroup dynamic impurity region {0}Region every {1} \n'.format(calcRegions[i], dynamicTime))
            sf.write('compute    {0}ImpurityMasses {0}ImpurityGroup property/atom mass \n'.format(calcRegions[i]))
            sf.write('compute    {0}ImpurityMass {0}ImpurityGroup reduce sum c_{0}ImpurityMasses \n'.format(calcRegions[i]))
            sf.write('variable     {0}ImpurityCount equal c_{0}ImpurityMass/{1}'.format(calcRegions[i], massType[2]))
            sf.write('\n')
        sf.write('\n')

    ##Write out custom thermo data
    sf.write('thermo_style    custom step etotal ke pe c_gasTemp press & \n')
    for i in range(len(calcRegions)):
        if atomTypes == 2:
            sf.write('v_{0}Press c_{0}Vx v_{0}ArgonCount'.format(calcRegions[i]))
        else:
            sf.write('v_{0}Press c_{0}Vx v_{0}ArgonCount v_{0}ImpurityCount'.format(calcRegions[i]))
        if i < len(calcRegions)-1:
            sf.write(' & \n')
    sf.write('\n')
    sf.write('thermo_modify flush yes lost ignore \n')
    sf.write('\n')    
    
    ##Define chunk grid for more detailed analysis
    sf.write('compute argonChunks argon chunk/atom bin/2d x {0} {1} y {2} {3} bound x {4} {5} bound y {6} {7} \n'.format(xChunkLow, dx, yChunkLow, dy, xChunkLow, xChunkHigh, yChunkLow, yChunkHigh))
    sf.write('compute argonChunkVCM argon vcm/chunk argonChunks \n')
    sf.write('fix argonChunksAvgVCM argon ave/time {0} {1} {2} c_argonChunkVCM[*] file argon_vcm_{3}.chunk mode vector \n'.format(dynamicTime, 1, dynamicTime, trialName))
    sf.write('compute argonChunkTemp argon temp/chunk argonChunks temp \n')
    sf.write('fix argonChunksAvgTemp argon ave/time {0} {1} {2} c_argonChunkTemp[*] file argon_temp_{3}.chunk mode vector \n'.format(dynamicTime, 1, dynamicTime, trialName))
    sf.write('compute argonChunkInternalTemp argon temp/chunk argonChunks temp com yes \n')
    sf.write('fix argonChunksAvgInternalTemp argon ave/time {0} {1} {2} c_argonChunkInternalTemp[*] file argon_internalTemp_{3}.chunk mode vector \n'.format(dynamicTime, 1, dynamicTime, trialName))
    if dumpMovies:
        sf.write('compute argonChunkInternalKE argon temp/chunk argonChunks internal \n')
        sf.write('fix argonChunksAvgInternalKE argon ave/time {0} {1} {2} c_argonChunkInternalKE[*] file argon_internalKE_{3}.chunk mode vector \n'.format(dynamicTime, 1, dynamicTime, trialName))
    sf.write('compute argonChunkCount argon property/chunk argonChunks count \n')
    sf.write('fix argonChunksAvgCount argon ave/time {0} {1} {2} c_argonChunkCount[*] file argon_count_{3}.chunk mode vector \n'.format(dynamicTime, 1, dynamicTime, trialName))
    sf.write('\n')

    if atomTypes != 2:
        sf.write('compute impurityChunks impurity chunk/atom bin/2d x {0} {1} y {2} {3} bound x {4} {5} bound y {6} {7} \n'.format(xChunkLow, dx, yChunkLow, dy, xChunkLow, xChunkHigh, yChunkLow, yChunkHigh))
        sf.write('compute impurityChunkVCM impurity vcm/chunk impurityChunks \n')
        sf.write('fix impurityChunksAvgVCM impurity ave/time {0} {1} {2} c_impurityChunkVCM[*] file impurity_vcm_{3}.chunk mode vector \n'.format(dynamicTime, 1, dynamicTime, trialName))
        sf.write('compute impurityChunkTemp impurity temp/chunk impurityChunks temp \n')
        sf.write('fix impurityChunksAvgTemp impurity ave/time {0} {1} {2} c_impurityChunkTemp[*] file impurity_temp_{3}.chunk mode vector \n'.format(dynamicTime, 1, dynamicTime, trialName))
        sf.write('compute impurityChunkInternalTemp impurity temp/chunk impurityChunks temp com yes \n')
        sf.write('fix impurityChunksAvgInternalTemp impurity ave/time {0} {1} {2} c_impurityChunkInternalTemp[*] file impurity_internalTemp_{3}.chunk mode vector \n'.format(dynamicTime, 1, dynamicTime, trialName))
        if dumpMovies:
            sf.write('compute impurityChunkInternalKE impurity temp/chunk impurityChunks internal \n')
            sf.write('fix impurityChunksAvgInternalKE impurity ave/time {0} {1} {2} c_impurityChunkInternalKE[*] file impurity_internalKE_{3}.chunk mode vector \n'.format(dynamicTime, 1, dynamicTime, trialName))
        sf.write('compute impurityChunkCount impurity property/chunk impurityChunks count \n')
        sf.write('fix impurityChunksAvgCount impurity ave/time {0} {1} {2} c_impurityChunkCount[*] file impurity_count_{3}.chunk mode vector \n'.format(dynamicTime, 1, dynamicTime, trialName))
        sf.write('\n')

    ##This is meant to be used to write data in format readable by VMD, but futher reading seems to indicate that VMD only works with a combination of write_data and dump dcd methods.
    if dumpMovies == True:
        sf.write('## Extra dump for movies \n')
        zoom = 25
        xScaled = (xFilter+filterDepth/2)/xMax
        yScaled = 0.5
        zScaled = 0.5
        colorType = ['white', 'blue', 'red']
        dumpID = 1000
        sf.write('dump    {0} all movie {1} {2}_center_movie.mpg type type zoom {3} center s {4} {5} {6} size 720 720 box yes 0.0001    #Dump movie of all atoms every N={4} timesteps, centered at scaled coordinates x={1} y={2} z={3} \n'.format(dumpID, movieFrameDelta, trialName, zoom, xScaled, yScaled, zScaled))
        sf.write('dump_modify    {0} '.format(dumpID))
        for i in range(atomTypes):
            sf.write('adiam {0} {1} acolor {0} {2} '.format(idType[i], diameterType[i], colorType[i]))
        sf.write('\n')
        sf.write('dump_modify    {0} flush yes \n'.format(1000))
        sf.write('\n')

        
        # sf.write('dump    {0} all movie {1} {2}_top_movie.mpg type type zoom {3} center s {4} {5} {6} size 720 720 box yes 0.0001    #Dump movie of all atoms every N={4} timesteps, centered at scaled coordinates x={1} y={2} z={3} \n'.format(dumpID+1, movieFrameDelta, trialName, 50, xFilter/xMax, 1, zScaled))
        # sf.write('dump_modify    {0} '.format(dumpID+1))
        # for i in range(atomTypes):
        #     sf.write('adiam {0} {1} acolor {0} {2} '.format(idType[i], diameterType[i], colorType[i]))
        # sf.write('\n')
        # sf.write('dump_modify    {0} flush yes \n'.format(dumpID+1))
        # sf.write('\n')

        # sf.write('dump    {0} all movie {1} {2}_bottom_movie.mpg type type zoom {3} center s {4} {5} {6} size 720 720 box yes 0.0001    #Dump movie of all atoms every N={4} timesteps, centered at scaled coordinates x={1} y={2} z={3} \n'.format(dumpID+2, movieFrameDelta, trialName, 50, xFilter/xMax, 0, zScaled))
        # sf.write('dump_modify    {0} '.format(dumpID+2))
        # for i in range(atomTypes):
        #     sf.write('adiam {0} {1} acolor {0} {2} '.format(idType[i], diameterType[i], colorType[i]))
        # sf.write('\n')
        # sf.write('dump_modify    {0} flush yes \n'.format(dumpID+2))
        # sf.write('\n')

        # sf.write('dump    {0} all image {1} {2}_*_image.jpg type type zoom {3} center s {4} {5} {6} size 720 720 box yes 0.0001    #Dump movie of all atoms every N={4} timesteps, centered at scaled coordinates x={1} y={2} z={3} \n'.format(101, 1000, trialName, zoom, xScaled, yScaled, zScaled))
        # sf.write('dump_modify    {0} '.format(101))
        # for i in range(atomTypes):
        #     sf.write('adiam {0} {1} acolor {0} '.format(idType[i], diameterType[i]) + colorType[i] + ' ')
        # sf.write('\n')
        # sf.write('dump_modify    {0} flush yes \n'.format(101))
        # sf.write('\n')

    ##Run shorter if using movies for local debug
    if dumpMovies == True:
        sf.write('run {0} pre yes post yes \n'.format(movieDuration))
    else:
        # sf.write('restart {0} {1}_backup.rst {1}_archive.rst \n'.format(archiveTime, trialName))
        sf.write('restart {0} {1}_*steps.rst \n'.format(totalTime, trialName))
        sf.write('run {0} pre yes post yes \n'.format(totalTime))
        sf.close()
    """
        Local LAMMPS run start/restart shell files
    """

    if dumpMovies == True:
        localRunScript = 'run_movie_' + trialName + '.sh'
        localCores = 2
        ls = open(localRunScript, 'w')
        ls.write('#!/bin/bash \n')
        ls.write('echo "echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope" \n')
        ls.write('echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope \n')
        ls.write('echo "Launching molecular dynamics filtration simulation(s)..." \n')
        ls.write('echo "Running mpirun -n {0} /mnt/c/lammps/src/lmp_auto -nocite -in {1} -log thermo_movie_{2}.log" \n'.format(localCores, inputFile, trialName))
        ls.write('mpirun -n {0} /mnt/c/lammps/src/lmp_auto -nocite -in {1} -log thermo_movie_{2}.log -var ran0 235625 -var ran1 60924386 -var ran2 93561784 -var ran3 4512349 \n'.format(localCores, inputFile, trialName))
        ls.write('echo "All Done!" \n')
        ls.close()

        # st = os.stat(os.path.join('.',localRunScript))
        # os.chmod(os.path.join('.',localRunScript), st.st_mode | stat.S_IEXEC)
    return