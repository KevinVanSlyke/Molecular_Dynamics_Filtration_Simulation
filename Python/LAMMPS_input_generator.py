# -*- coding: utf-8 -*-
"""
Created on Fri Aug 18 14:46:50 2017

@author: Kevin Van Slyke
"""

import time
import os
import stat
def LAMMPS_input_generator(poreWidth, impurityDiameter, poreSpacing, dumpMovies):
#def LAMMPS_input_generator(poreWidth, impurityDiameter, dumpMovies):
    #randomSeed = [12461,6426357,32578,1247568,124158,12586]
    ##Frequently changed input variables
        #impurityDiameter, poreWidth, trialNum, poreSpacing, registryShift, filterSpacing, nTotal
    
    ##Spatial input parameters
    dimensions = 2
    nFilters = 1
    
    xMax = 2000
    xMin = 0
    yMax = 2000
    yMin = 0
    dx = 20
    dy = 20
    
    iRange = xMax/dx
    jRange = yMax/dy
    if dimensions == 2:
        zMax = 0.01
        zMin = -0.01
    if dimensions == 3:
        zMax = 25
        zMin = 0
        zPad = 1

    ##Currently filter must span entire z dimension and pore is open along this entire axis
#    poreWidth = 50
    if poreSpacing == 0:
        flagMultiPore = False
        flagPoreSpacing = False
    else:
        flagMultiPore = True
        flagPoreSpacing = True

    if poreWidth >= yMax:
        nFilters = 0
    filterDepth = 20
#    filterHeight = 3
    filterSpacing = 100
#    poreSpacing = 10
    registryShift = 0
    flagRegistryShift = False
    if registryShift != 0:
        flagRegistryShift = True
    
    ##Initialization temperature and velocity parameters
    fluidVelocity = 1
    fluidTemperature = 1
    
    flagPressureFromKineticOnly = False
    flagImpurityVel = False
    flagImpurityMom = False
    flagPairShift = True
    
#    flagPressFilterFaceOnly = True
#    flagPressVerticalSlicesOnly = True
    
    flagFrontPress = True
    flagRearPressure = False
    flagVCM = False
    
    flagRegionVcm = False
    flagChunkData = True
    
    ##Energy minimation parameters/thresholds
    eMin = 10**(-4)
    fMin = 10**(-4)
    maxIterations = 10**(6)
    maxEvaluations = 10**(6)
#    eqTime = 10**(4)

    ##Required Temporal input parameters
    timeStep = 0.005
    thermoTime = 10**(3)
    dynamicTime = 10**(3)
    restartTime = 10**(5)
    archiveRestartTime = 10**(6)
    totalTime = 10**(7)
    ##Reduced for 3D
#    totalTime = int(10**(6))

    ##Optional Temporal parameters and flags for extra analysis print outs
    ##Set times below to 0 to exclude print out
    poreDump = True
    
    tracerDump = False
    tracerTime = 10
    nTracers = 10
    
    makeRestarts = False
    
#    dumpMovies = True
    dumpImages = False
    dumpRawMovies = False
    rawHalfWidth = 125
    movieStartTime = 0
    movieDuration = 10**(4)
    movieFrameDelta = 100
    
#    velDumpTime = 0
    
    ##Default for 2D simulation of L_x = 2000, L_y = 2000
    nTotal = 100000
    ##Equal volume density to default 2D area density with L_x = 200, L_y= 200, L_z = 25
    #nTotal = 1000
    ##Equal volume density to default 2D area density with L_x = 500, L_y= 500, L_z = 25
    #nTotal = 57200
    nImpurities = int(nTotal*0.05)
#    impurityDiameter = 1
    
    idType = []
    nType = []
    diameterType = []
    massType = []
    ##idType[0] is Atom Type 1, Filter Molecules, n = 0 to make list entries line up
    idType.append(1)
    nType.append(0)
    diameterType.append(1.)
    massType.append(1000)

    if tracerDump == False:       
        ##idType[1] is Atom Type 2, Argon Molecules
        idType.append(2)
        diameterType.append(1.)
        massType.append(1)
        if impurityDiameter == 1:
            atomTypes = 2
            nType.append(nTotal)
        else:
            atomTypes = 3
            nType.append(nTotal-nImpurities)
            ##idType[2] is Atom Type 3, Large Impurity Molecules
            idType.append(3)
            nType.append(nImpurities)
            diameterType.append(impurityDiameter)
            if dimensions == 2:
                massType.append(impurityDiameter**2)
            elif dimensions == 3:
                massType.append(impurityDiameter**3)                
    else:
        if impurityDiameter == 1:
            atomTypes = 3
            ##idType[1] is Atom Type 2, Argon Molecules
            idType.append(2)
            nType.append(nTotal-nTracers)
            diameterType.append(1.)
            massType.append(1)
            ##idType[2] is Atom Type 3, Tracer Molecules
            idType.append(3)
            nType.append(nTracers)
            diameterType.append(1.)
            massType.append(1)
        else:
            atomTypes = 5
            ##idType[1] is Atom Type 2, Argon Molecules
            idType.append(2)
            nType.append(nTotal-2*nTracers-nImpurities)
            diameterType.append(1.)
            massType.append(1)
            ##idType[2] is Atom Type 3, Large Impurity Molecules
            idType.append(3)
            nType.append(nImpurities-nTracers)
            diameterType.append(impurityDiameter)
            if dimensions == 2:
                massType.append(impurityDiameter**2)
            elif dimensions == 3:
                massType.append(impurityDiameter**3)   
            ##idType[3] is Atom Type 4, Argon Tracer Molecules
            idType.append(4)
            nType.append(nTracers)
            diameterType.append(1.)
            massType.append(1)
            ##idType[4] is Atom Type 5, Large Impurity Tracer Molecules
            idType.append(5)
            nType.append(nTracers)
            diameterType.append(impurityDiameter)
            if dimensions == 2:
                massType.append(impurityDiameter**2)
            elif dimensions == 3:
                massType.append(impurityDiameter**3)
            

    ##Create a unique file name
    #    dirName = '{0}W_{1}D_{2}F'.format(poreWidth, impurityDiameter, filterSpacing)
    #    if trialNum >= 0:
    #        if flagRegistryShift :
    #            dirName = '{0}W_{1}D_{2}H_{3}T'.format(poreWidth, impurityDiameter, registryShift, trialNum)
    #        elif flagPoreSpacing:
    #            dirName = '{0}W_{1}D_{2}F_{3}T'.format(poreWidth, impurityDiameter, poreSpacing, trialNum)
    #        else:
    #            dirName = '{0}W_{1}D_{2}T'.format(poreWidth, impurityDiameter, trialNum)
    #    else:
    #        if flagRegistryShift:
    #            dirName = '{0}W_{1}D_{2}H'.format(poreWidth, impurityDiameter, registryShift)
    #        elif flagPoreSpacing:   
    #            dirName = '{0}W_{1}D_{2}F'.format(poreWidth, impurityDiameter, poreSpacing)
    #        else:
    #            dirName = '{0}W_{1}D'.format(poreWidth, impurityDiameter)
        
    #    if flagImpurityVel == True:
    #        dirName = dirName + '_IV'
    #    elif flagImpurityMom== True:
    #        dirName = dirName + '_IM'
    #    if flagVCM == True:
    #        dirName = dirName + '_VCM'
    
    if flagRegistryShift:
        dirName = '{0}W_{1}D_{2}H'.format(poreWidth, impurityDiameter, registryShift)
    elif flagPoreSpacing:   
        dirName = '{0}W_{1}D_{2}F'.format(poreWidth, impurityDiameter, poreSpacing)
    else:
        dirName = '{0}W_{1}D'.format(poreWidth, impurityDiameter)
        
#    if dumpMovies == False:
#    else:
#        trialName = dirName

    if (dumpMovies == True):
        startName = 'input_movie_' + dirName + '_r0.lmp'
        restartName = 'input_movie_' + dirName + '_r1.lmp'
        localStartName = 'input_movie_' + dirName + '_r0.sh'
#        localRestartName = 'movie_' + dirName + '_r1.sh'
        trialName = dirName
    else:
        trialName = dirName + '_${id}T'
        startName = 'input_' + dirName + '_r0.lmp'
#        restartName = 'input_' + dirName + '_r1.input'        

#    trialDir = os.getcwd()
#    if not os.path.exists(dirName):
#        os.makedirs(dirName)
#    os.chdir(dirName)
    
    """
        Primary LAMMPS start/restart files
    """
    if makeRestarts == True:
        sf = open(startName, 'w')
        rf = open(restartName, 'w')
        inputFiles = [sf, rf]
    else:
        sf = open(startName, 'w')
        inputFiles = [sf]

    for f in inputFiles:
        f.write('## LAMMPS input start file for filtration research  \n')
        f.write('## Written by Kevin Van Slyke  \n')
        f.write('## Dated: ' + time.strftime("%m_%d_%Y") + '\n')
        f.write('\n')
        
#        f.write('print "starting run: id ${id}, ran0 = ${ran0}, ran1 = ${ran1}, ran2 = ${ran2}, ran3 = ${ran3}" \n')
    if makeRestarts == True:
        rf.write('read_restart {0}_archive.rst \n'.format(trialName))
    
    for f in inputFiles:
        f.write('## Multi neighbor and comm for efficiency \n')
        f.write('neighbor    1 multi \n')
        f.write('neigh_modify    delay 0 \n')
        f.write('comm_modify    mode multi \n')
        f.write('\n')
        f.write('thermo    {0}    #Print thermo vars every {0} timesteps \n'.format(thermoTime))
        f.write('\n')
    
    sf.write('## Set simulation unit and atom style to dimensionless LJ particles \n')
    sf.write('units    lj    #Simple Lennard-Jones cut-off potential \n')
    sf.write('atom_style     atomic     #Particles have mass \n')
    sf.write('dimension    {0}    #Fix simulation to {0}D \n'.format(dimensions))
    if dimensions == 2:
        sf.write('boundary    p f p    #Set boundaries such that x_axis=fixed, y_axis=periodic, z_axis=periodic \n')
        sf.write('lattice    sq 1    #Simple square lattice with one basis atom per cell, lattice_spacing=1/1=1, reduced density rho = 1 \n')
        if nFilters == 0:
            sf.write('region    box block {0} {1} {2} {3} {4} {5}    #Create extruded rectangular simulation volume in units of lattice sites, {0}<=x<{1}, {2}<=y<{3}, {4}<=z<{5} \n'.format(int(xMin), int(xMax), int(yMin), int(yMax+1), zMin, zMax))            
        elif nFilters == 1:
            sf.write('region    box block {0} {1} {2} {3} {4} {5}    #Create extruded rectangular simulation volume in units of lattice sites, {0}<=x<{1}, {2}<=y<{3}, {4}<=z<{5} \n'.format(int(xMin), int(xMax+filterDepth), int(yMin), int(yMax+1), zMin, zMax))
        elif nFilters ==2:
            sf.write('region    box block {0} {1} {2} {3} {4} {5}    #Create extruded rectangular simulation volume in units of lattice sites, {0}<=x<{1}, {2}<=y<{3}, {4}<=z<{5} \n'.format(int(xMin), int(xMax+2*filterDepth), int(yMin), int(yMax+1), zMin, zMax))
    elif dimensions == 3:
        sf.write('boundary    p f f    #Set boundaries such that x_axis=fixed, y_axis=periodic, z_axis=fixed \n')
        sf.write('lattice    sc 1    #Simple cubic lattice with one basis atom per cell, lattice_spacing=1/1=1, reduced density rho = 1 \n')
        if nFilters == 1:
            sf.write('region    box block {0} {1} {2} {3} {4} {5}    #Create extruded rectangular simulation volume in units of lattice sites, {0}<=x<{1}, {2}<=y<{3}, {4}<=z<{5} \n'.format(int(xMin), int(xMax+filterDepth), int(yMin), int(yMax+1), int(zMin-zPad), int(zMax+zPad)))
        elif nFilters ==2:
            sf.write('region    box block {0} {1} {2} {3} {4} {5}    #Create extruded rectangular simulation volume in units of lattice sites, {0}<=x<{1}, {2}<=y<{3}, {4}<=z<{5} \n'.format(int(xMin), int(xMax+2*filterDepth), int(yMin), int(yMax+1), int(zMin-zPad), int(zMax+zPad)))

    sf.write('create_box    {0} box    #Create simulation volume in region box with {0} atom types \n'.format(atomTypes))
    sf.write('timestep    {0}    #One timestep={0}*tau, tau=2.17*10^(-12)s for Argon \n'.format(timeStep))
    sf.write('\n')
    
    sf.write('## LJ potential: atom type 1, atom type 2, epsilon, sigma \n')
    sf.write('pair_style    lj/cut 1.122462    #Lennard-Jones global cut-off=1.122462 \n')
#    sf.write('pair_style    lj/cut 1.1    #Lennard-Jones global cut-off=1.122462 \n')
    epsilon = 1.0
    for i in xrange(atomTypes):
        for j in xrange(atomTypes):
            if i <= j:
                sigma = diameterType[i]/2. + diameterType[j]/2.
                cutOff = sigma*1.122462 #1.122462 = 2**(1/6)
#                cutOff = sigma #1.122462 = 2**(1/6)
#                cutOff = sigma*1.1 #1.122462 = 2**(1/6)
#                cutOff = sigma*1.5 #1.122462 = 2**(1/6)
                if ((idType[i] == 1) and (idType[j] == 1)):
                    cutOff = 0.5
                sf.write('pair_coeff     {0} {1} {2} {3} {4}     #Pairwise {0}-{1} interaction, epsilon={2}, sigma={3}, cut-off={4} \n'.format(idType[i], idType[j], epsilon, sigma, cutOff))
    for i in xrange(atomTypes):
        sf.write('mass    {0} {1}    #Sets mass of particle type {0} to {1} \n'.format(idType[i], massType[i]))
    if flagPairShift == True:
        sf.write('pair_modify    shift yes    #Shifts LJ potential to 0.0 at the cut-off \n')
    sf.write('\n')
    
    
##Update so that vacuum region is not excluding horizontal displacement at PBC
    sf.write('## Define the filter area and fill it with atoms fixed to lattice sites \n')
    if dimensions == 2 and nFilters == 0:
        sf.write('region    vacuum block {0} {1} {2} {3} {4} {5}    #Rear Region to be filled by gas \n'.format(int(xMin + diameterType[-1] + 1), int(xMax + filterDepth - (diameterType[-1]/2 + 1)), int(yMin+diameterType[-1]/2+1), int(yMax-(diameterType[-1]/2+1)), 0, 0))
   
    elif dimensions == 3 and nFilters == 0:
        sf.write('region    vacuum block {0} {1} {2} {3} {4} {5}    #Rear Region to be filled by gas \n'.format(int(xMin + diameterType[-1] + 1), int(xMax + filterDepth - (diameterType[-1]/2 + 1)), int(yMin+diameterType[-1]/2+1), int(yMax-(diameterType[-1]+1)), int(zMin+diameterType[-1]/2+1), int(zMax-(diameterType[-1]/2+1))))
    
    elif dimensions == 2 and nFilters == 1 and flagMultiPore == False:
        sf.write('region    topWall block {0} {1} {2} {3} {4} {5}    #Top half of single pore filter \n'.format(int(xMax/2), int(xMax/2)+filterDepth-1, int((yMax+poreWidth)/2+1), int(yMax), 0, 0))
        sf.write('region    botWall block {0} {1} {2} {3} {4} {5}    #Bottom half of single pore filter \n'.format(int(xMax/2), int(xMax/2)+filterDepth-1, int(yMin+1), int((yMax-poreWidth)/2), 0, 0))
        sf.write('region    frontVacuum block {0} {1} {2} {3} {4} {5}    #Front Region to be filled by gas \n'.format(int(xMin + 1), int(int(xMax/2)-(int(diameterType[-1]/2) + 1)), int(yMin + 1 + int(diameterType[-1]/2) + 1), int(yMax - (int(diameterType[-1]/2) + 1)), 0, 0))
        sf.write('region    rearVacuum block {0} {1} {2} {3} {4} {5}    #Rear Region to be filled by gas \n'.format(int(int(xMax/2) + filterDepth + int(diameterType[-1]/2) + 1), int(xMax + filterDepth - 1), int(yMin+1+int(diameterType[-1]/2) + 1), int(yMax-(int(diameterType[-1]/2) + 1)), 0, 0))
        sf.write('region    vacuum union 2 frontVacuum rearVacuum \n')
        
    elif dimensions == 3 and nFilters == 1 and flagMultiPore == False:
        sf.write('region    topWall block {0} {1} {2} {3} {4} {5}    #Top half of single pore filter \n'.format(int(xMax/2), int(xMax/2)+filterDepth-1, int((yMax+poreWidth)/2+1), int(yMax), int(zMin), int(zMax)))
        sf.write('region    botWall block {0} {1} {2} {3} {4} {5}    #Bottom half of single pore filter \n'.format(int(xMax/2), int(xMax/2)+filterDepth-1, int(yMin+1), int((yMax-poreWidth)/2), int(zMin), int(zMax)))
        sf.write('region    frontVacuum block {0} {1} {2} {3} {4} {5}    #Front Region to be filled by gas \n'.format(int(xMin + 1), int(int(xMax/2)-(int(diameterType[-1]/2) + 1)), int(yMin+1+diameterType[-1]/2+1), int(yMax-(diameterType[-1]/2+1)), int(zMin+diameterType[-1]/2+1), int(zMax-(diameterType[-1]/2+1))))
        sf.write('region    rearVacuum block {0} {1} {2} {3} {4} {5}    #Rear Region to be filled by gas \n'.format(int(int(xMax/2) + filterDepth + diameterType[-1]/2 + 1), int(xMax + filterDepth - 1), int(yMin+1+int(diameterType[-1]/2+1)), int(yMax-(diameterType[-1]/2+1)), int(zMin+diameterType[-1]/2+1), int(zMax-(diameterType[-1]/2+1))))
        sf.write('region    vacuum union 2 frontVacuum rearVacuum \n')
    
    elif dimensions == 2 and nFilters == 1 and flagMultiPore == True:
        sf.write('region    topWall block {0} {1} {2} {3} {4} {5}    #Top half of dual pore filter \n'.format(int(xMax/2), int(xMax/2)+filterDepth-1, int((yMax+poreSpacing)/2+poreWidth+1+registryShift), int(yMax), 0, 0))
        sf.write('region    midWall block {0} {1} {2} {3} {4} {5}    #Middle portion of dual pore filter \n'.format(int(xMax/2), int(xMax/2)+filterDepth-1, int(yMax-poreSpacing)/2+1+registryShift, int((yMax+poreSpacing)/2+registryShift), 0, 0))
        sf.write('region    botWall block {0} {1} {2} {3} {4} {5}    #Bottom half of dual pore filter \n'.format(int(xMax/2), int(xMax/2)+filterDepth-1, int(yMin+1), int((yMax-poreSpacing)/2-poreWidth)+registryShift, 0, 0))
        sf.write('region    frontVacuum block {0} {1} {2} {3} {4} {5}    #Front Region to be filled by gas \n'.format(int(xMin + diameterType[-1] + 1), int(int(xMax/2)-(diameterType[-1] + 1)), int(yMin+diameterType[-1]/2+1), int(yMax-(diameterType[-1]/2+1)), 0, 0))
        sf.write('region    rearVacuum block {0} {1} {2} {3} {4} {5}    #Rear Region to be filled by gas \n'.format(int(int(xMax/2) + filterDepth + diameterType[-1] + 1), int(xMax + filterDepth - (diameterType[-1]/2 + 1)), int(yMin+diameterType[-1]/2+1), int(yMax-(diameterType[-1]/2+1)), 0, 0))
        sf.write('region    vacuum union 2 frontVacuum rearVacuum \n')
        
    elif dimensions == 3 and nFilters == 1 and flagMultiPore == True:
        sf.write('region    topWall2 block {0} {1} {2} {3} {4} {5}    #Top half of dual pore filter \n'.format(int(xMax/2), int(xMax/2)+filterDepth-1, int((yMax+poreSpacing)/2+poreWidth+1), int(yMax), int(zMin), int(zMax)))
        sf.write('region    midWall2 block {0} {1} {2} {3} {4} {5}    #Middle portion of dual pore filter \n'.format(int(xMax/2), int(xMax/2)+filterDepth-1, int(yMax-poreSpacing)/2+1, int((yMax+poreSpacing)/2-1), int(zMin), int(zMax)))
        sf.write('region    botWall2 block {0} {1} {2} {3} {4} {5}    #Bottom half of dual pore filter \n'.format(int(xMax/2)+filterSpacing+filterDepth, int(xMax/2)+filterDepth-1, int(yMin+1), int((yMax-poreSpacing)/2-1), int(zMin), int(zMax)))
        sf.write('region    frontVacuum block {0} {1} {2} {3} {4} {5}    #Front Region to be filled by gas \n'.format(int(xMin + diameterType[-1] + 1), int(int(xMax/2) - (diameterType[-1]/2  + 1)), int(yMin+diameterType[-1]/2+1), int(yMax-(diameterType[-1]/2+1)), int(zMin+diameterType[-1]/2+1), int(zMax-(diameterType[-1]/2+1))))
        sf.write('region    rearVacuum block {0} {1} {2} {3} {4} {5}    #Rear Region to be filled by gas \n'.format(int(int(xMax/2) + filterDepth + diameterType[-1] + 1), int(xMax + filterDepth - (diameterType[-1]/2 + 1)), int(yMin+diameterType[-1]/2+1), int(yMax-(diameterType[-1]/2+1)), int(zMin+diameterType[-1]/2+1), int(zMax-(diameterType[-1]/2+1))))
        sf.write('region    vacuum union 2 frontVacuum rearVacuum \n')
        
    elif dimensions == 2 and nFilters == 2:
        sf.write('region    topWall1 block {0} {1} {2} {3} {4} {5}    #Top half of single pore filter \n'.format(int(xMax/2), int(xMax/2)+filterDepth-1, int((yMax+poreWidth)/2+1), int(yMax), 0, 0))
        sf.write('region    botWall1 block {0} {1} {2} {3} {4} {5}    #Bottom half of single pore filter \n'.format(int(xMax/2), int(xMax/2)+filterDepth-1, int(yMin+1), int((yMax-poreWidth)/2), 0, 0))
        sf.write('region    topWall2 block {0} {1} {2} {3} {4} {5}    #Top half of dual pore filter \n'.format(int(xMax/2)+filterSpacing+filterDepth, int(xMax/2)+filterSpacing+2*filterDepth-1, int((yMax+poreSpacing)/2+poreWidth+1+registryShift), int(yMax), 0, 0))
        sf.write('region    midWall2 block {0} {1} {2} {3} {4} {5}    #Middle portion of dual pore filter \n'.format(int(xMax/2)+filterSpacing+filterDepth, int(xMax/2)+filterSpacing+2*filterDepth-1, int(yMax-poreSpacing)/2+1+registryShift, int((yMax+poreSpacing)/2+registryShift), 0, 0))
        sf.write('region    botWall2 block {0} {1} {2} {3} {4} {5}    #Bottom half of dual pore filter \n'.format(int(xMax/2)+filterSpacing+filterDepth, int(xMax/2)+filterSpacing+2*filterDepth-1, int(yMin+1), int((yMax-poreSpacing)/2-poreWidth)+registryShift, 0, 0))
        sf.write('region    frontVacuum block {0} {1} {2} {3} {4} {5}    #Front Region to be filled by gas \n'.format(int(xMin + diameterType[-1]/2 + 1), int(int(xMax/2) - (diameterType[-1]/2 + 1)), int(yMin+diameterType[-1]/2+1), int(yMax-(diameterType[-1]/2)+1), 0, 0))
        sf.write('region    midVacuum block {0} {1} {2} {3} {4} {5}    #Middle Region to be filled by gas \n'.format(int(int(xMax/2)+(diameterType[-1]/2 + filterDepth + 1)), int(int(xMax/2) + filterSpacing + filterDepth - (diameterType[-1]/2 + 1)), int(yMin+diameterType[-1]/2+1), int(yMax-(diameterType[-1]/2+1)), 0, 0))        
        sf.write('region    rearVacuum block {0} {1} {2} {3} {4} {5}    #Rear Region to be filled by gas \n'.format(int(int(xMax/2) + filterSpacing + 2*filterDepth + diameterType[-1]/2 + 1), int(xMax + 2*filterDepth - (diameterType[-1]/2 + 1)), int(yMin+diameterType[-1]/2+1), int(yMax-(diameterType[-1]/2+1)), 0, 0))
        sf.write('region    vacuum union 3 frontVacuum midVacuum rearVacuum \n')
        
    elif dimensions == 3 and nFilters == 2:
        sf.write('region    topWall1 block {0} {1} {2} {3} {4} {5}    #Top half of single pore filter \n'.format(int(xMax/2), int(xMax/2)+filterDepth-1, int((yMax+poreWidth)/2+1), int(yMax), int(zMin), int(zMax)))
        sf.write('region    botWall1 block {0} {1} {2} {3} {4} {5}    #Bottom half of single pore filter \n'.format(int(xMax/2), int(xMax/2)+filterDepth-1, int(yMin+1+2*filterDepth), int((yMax-poreWidth)/2), int(zMin), int(zMax)))
        sf.write('region    topWall2 block {0} {1} {2} {3} {4} {5}    #Top half of dual pore filter \n'.format(int(xMax/2)+filterSpacing+filterDepth, int(xMax/2)+filterSpacing+2*filterDepth-1, int((yMax+poreSpacing)/2+poreWidth+1), int(yMax), int(zMin), int(zMax)))
        sf.write('region    midWall2 block {0} {1} {2} {3} {4} {5}    #Middle portion of dual pore filter \n'.format(int(xMax/2)+filterSpacing+filterDepth, int(xMax/2)+filterSpacing+2*filterDepth-1, int(yMax-poreSpacing)/2+1+2*filterDepth, int((yMax+poreSpacing)/2-1), int(zMin), int(zMax)))
        sf.write('region    botWall2 block {0} {1} {2} {3} {4} {5}    #Bottom half of dual pore filter \n'.format(int(xMax/2)+filterSpacing+filterDepth, int(xMax/2)+filterSpacing+2*filterDepth-1, int(yMin+1+2*filterDepth), int((yMax-poreSpacing)/2-1+2*filterDepth), int(zMin), int(zMax)))
        sf.write('region    frontVacuum block {0} {1} {2} {3} {4} {5}    #Front Region to be filled by gas \n'.format(int(xMin + diameterType[-1]/2 + 1), int(int(xMax/2)-(diameterType[-1]/2 + 1)), int(yMin+diameterType[-1]/2+1), int(yMax-(diameterType[-1]/2+1)), int(zMin+diameterType[-1]/2+1), int(zMax-(diameterType[-1]/2+1))))
        sf.write('region    midVacuum block {0} {1} {2} {3} {4} {5}    #Front Region to be filled by gas \n'.format(int(int(xMax/2)+(diameterType[-1]/2 + filterDepth + 1)), int(int(xMax/2) + filterSpacing + filterDepth - (diameterType[-1]/2 + 1)), int(yMin+diameterType[-1]/2+1+2*filterDepth), int(yMax-(diameterType[-1]/2+1)), int(zMax-(diameterType[-1]/2+1))))
        sf.write('region    rearVacuum block {0} {1} {2} {3} {4} {5}    #Rear Region to be filled by gas \n'.format(int(int(xMax/2) + filterSpacing + 2*filterDepth + diameterType[-1]/2 + 1), int(xMax + 2*filterDepth - (diameterType[-1]/2 + 1)), int(yMin+diameterType[-1]/2+1+2*filterDepth), int(yMax-(diameterType[-1]/2+1)), int(zMin+diameterType[-1]/2+1), int(zMax-(diameterType[-1]/2+1))))
        sf.write('region    vacuum union 3 frontVacuum midVacuum rearVacuum \n')
    

    if nFilters == 1 and flagMultiPore == False:
        sf.write('create_atoms    {0} region topWall \n'.format(idType[0]))
        sf.write('create_atoms    {0} region botWall \n'.format(idType[0]))
        sf.write('group    topFilter region topWall \n')
        sf.write('group    botFilter region botWall \n')
        sf.write('group    filter union topFilter botFilter \n')
    elif nFilters == 1 and flagMultiPore == True:
        sf.write('create_atoms    {0} region topWall \n'.format(idType[0]))
        sf.write('create_atoms    {0} region midWall \n'.format(idType[0]))
        sf.write('create_atoms    {0} region botWall \n'.format(idType[0]))
        sf.write('group    topFilter region topWall \n')
        sf.write('group    midFilter region midWall \n')
        sf.write('group    botFilter region botWall \n')
        sf.write('group    filter union topFilter midFilter botFilter \n')
    elif nFilters == 2:
        sf.write('create_atoms    {0} region topWall1 \n'.format(idType[0]))
        sf.write('create_atoms    {0} region botWall1 \n'.format(idType[0]))
        sf.write('group    topFilter1 region topWall1 \n')
        sf.write('group    botFilter1 region botWall1 \n')
        sf.write('group    filter1 union topFilter1 botFilter1 \n')
        sf.write('create_atoms    {0} region topWall2 \n'.format(idType[0]))
        sf.write('create_atoms    {0} region midWall2 \n'.format(idType[0]))
        sf.write('create_atoms    {0} region botWall2 \n'.format(idType[0]))
        sf.write('group    topFilter2 region topWall2 \n')
        sf.write('group    midFilter2 region midWall2 \n')
        sf.write('group    botFilter2 region botWall2 \n')
        sf.write('group    filter2 union topFilter2 midFilter2 botFilter2 \n')
        sf.write('group    filter union filter1 filter2 \n')


    sf.write('## Define the flow area and populate with gas molecules \n')
    for i in xrange(1,atomTypes):
        sf.write('create_atoms    {0} random {1} $'.format(idType[i], nType[i]) + '{ran' + str(i-1) + '} ' + 'vacuum    #Create atoms: type={0}, placement=random, N={1}, seed=$'.format(idType[i], nType[i]) + '{ran' + str(i-1) + '}, region=vacuum \n')
    
    if atomTypes == 2:
        sf.write('group    gas type {0}    #Create group of freely moving Argon gas particles \n'.format(idType[1]))
    elif (atomTypes == 3) and (impurityDiameter != 1):
        sf.write('group    gas type {0}:{1}    #Create group of freely moving particles \n'.format(idType[1], idType[2]))
        sf.write('group    argon type {0}    #Create group of freely moving Argon gas particles \n'.format(idType[1]))
        sf.write('group    impurity type {0}    #Create group of the less common impurity particles \n'.format(idType[2]))
    elif (atomTypes == 3) and (impurityDiameter == 1):
        sf.write('group    gas type {0}:{1}    #Create group of freely moving particles \n'.format(idType[1], idType[2]))
        sf.write('group    argon type {0} {1}   #Create group of freely moving Argon gas particles \n'.format(idType[1],idType[2]))
        sf.write('group    tracer type {0}    #Create group of the less common Argon tracer particles \n'.format(idType[2]))
    elif atomTypes == 5:
        sf.write('group    gas type {0}:{1}    #Create group of freely moving particles \n'.format(idType[1], idType[4]))
        sf.write('group    argon type {0} {1}  #Create group of freely moving Argon gas particles \n'.format(idType[1], idType[3]))
        sf.write('group    tracer type {0} {1}   #Create group of the less common Argon and impurity tracer particles \n'.format(idType[3], idType[5]))
        sf.write('group    impurity type {0} {1}   #Create group of the less common impurity particles \n'.format(idType[3], idType[5]))
    sf.write('\n')
    
    for f in inputFiles:
        f.write('## Thermodynamic calculation method and dynamics \n')
        f.write('fix    1 gas nve    #Fix microcanonical ensemble \n')
        if nFilters > 0:    
            f.write('fix    2 filter setforce 0.0 0.0 0.0  #Fix force on filter to zero \n')
        if dimensions == 2:
            f.write('fix    3 gas wall/reflect ylo {0} yhi {1}    #Fix walls parallel to xz plane at y={0} and y={1} to reflect particles \n'.format(int(yMin+1), int(yMax)))
            f.write('fix    4 all enforce2d    #Fix motion along the z-axis to simulate 2D \n')
        elif dimensions == 3:
            f.write('fix    3 gas wall/reflect ylo {0} yhi {1} zlo {2} zhi {3}    #Fix walls parallel to xz plane at y={0} and y={1} and xy plane at z={2} and z={3} to reflect particles \n'.format(int(yMin+1), int(yMax), int(zMin), int(zMax)))

        f.write('\n')
    
#==============================================================================
#     ## Leaving out for now until first paper is out and we start to look at forcing
#     region push block 5000 7500 0 10000 0 0  #Defines region as the far half of the length of simulation area in which atoms will experience a linear added force
#     variable addforce_x atom "10^(-12)*(7500-x)"    #Defines the force linearly decreasing fx to add
#     variable addforce_energy atom "10^(-12)*(x^2/2 - 7499*x)" #Defines the energy of the added vector force field, must satisfy E = -del dot F for energy minimization to converge properly
#     fix     4 gas addforce v_addforce_x 0 0 region push energy v_addforce_energy    #Fixes an added vector force field in region push with the above defined fx and energy
#==============================================================================
    
    sf.write('## All parameters but filter and velocities are set so we minize energy to prevent overlap of particles \n')
    sf.write('minimize    {0} {1} {2} {3}  #Stopping tolerances: energy={0}, force={1}, max iterations={2}, max evaluations={3} \n'.format(eMin, fMin, maxIterations, maxEvaluations))
    sf.write('reset_timestep    0 \n')
    
    sf.write('\n')
    
    sf.write('## Define velocity for initialization of gas and fixing filter \n')
    if nFilters > 0:
        sf.write('velocity	filter set 0.0 0.0 0.0     #Set initial velocity of walls to zero \n')
    if impurityDiameter == 1:
        sf.write('velocity    gas create {0} $'.format(fluidTemperature) + '{ran3} dist gaussian ' + '#Create velocity of gas particles from a Gaussian distribution at ' + 'temperature={0}'.format(fluidTemperature) +  ' with random seed=${ran3} \n')
        sf.write('velocity    gas set {0} 0 0 sum yes units box    #Add initial fluid velocity bias of v_x={0} (towards the filter) \n'.format(fluidVelocity))
    else:
        sf.write('velocity    argon create {0} $'.format(fluidTemperature) + '{ran3} dist gaussian ' + '#Create velocity of gas particles from a Gaussian distribution at ' + 'temperature={0}'.format(fluidTemperature) +  ' with random seed=${ran3} \n')
        sf.write('velocity    argon set {0} 0 0 sum yes units box    #Add initial fluid velocity bias of v_x={0} (towards the filter) to the Argon \n'.format(fluidVelocity))
        sf.write('velocity    impurity create {0} $'.format(fluidTemperature) + '{ran2} dist gaussian ' +' #Create velocity of large particles from a Gaussian distribution at temperature={0}'.format(fluidTemperature) + ' with random seed=${ran2} \n')
        if flagImpurityVel == True:        
            sf.write('velocity    impurity set {0} 0 0 sum yes units box    #Add initial fluid velocity bias of v_x={0} (towards the filter) to the Impurities \n'.format(float(fluidVelocity)))
        if flagImpurityMom == True:        
            sf.write('velocity    impurity set {0} 0 0 sum yes units box    #Add initial fluid velocity bias of v_x={0} (towards the filter) to the Impurities \n'.format(float(fluidVelocity)/float(massType[2])))
    sf.write('\n')
    
#########Hardcoded output        
    for f in inputFiles:
        if f == sf:
            dumpStringDiff = 'r0'
        elif f == rf:
            dumpStringDiff = 'r1'
        f.write('## Compute thermodynamic temperature based only on gas molecules \n')
        f.write('compute    gasTemp gas temp \n')
        if flagPressureFromKineticOnly == True:
            f.write('compute    kePress all pressure gasTemp ke \n')
        f.write('\n')
        
        if flagFrontPress == True:
            f.write('## Define regions in which Pressure will be calculated and inside of the pore \n')
            f.write('region    pressureRegion block {0} {1} {2} {3} {4} {5} \n'.format(int(xMax/2)-100,int(xMax/2)-1,yMin+1,yMax,0,0))
            f.write('group    pressureGroup dynamic gas region pressureRegion every {0} \n'.format(dynamicTime))
            if flagPressureFromKineticOnly == True:
                f.write('compute    Pp pressureGroup stress/atom gasTemp ke \n')
            else:
                f.write('compute    Pp pressureGroup stress/atom gasTemp ke pair \n')
            if dimensions == 2:
                f.write('compute    Ps pressureGroup reduce sum c_Pp[1] c_Pp[2] \n')
                f.write('variable    Px equal -(c_Ps[1])/({0}*{1}) \n'.format(100,yMax-yMin))
                f.write('variable    Py equal -(c_Ps[2])/({0}*{1}) \n'.format(100,yMax-yMin))
                f.write('variable    P equal (v_Px+v_Py)/2 \n')
            elif dimensions == 3:
                f.write('compute    Ps pressureGroup reduce sum c_Pp[1] c_Pp[2] c_Pp[3] \n')
                f.write('variable    Px equal -(c_Ps[1])/({0}*{1}*{2}) \n'.format(100,yMax-yMin, zMax-zMin))
                f.write('variable    Py equal -(c_Ps[2])/({0}*{1}*{2}) \n'.format(100,yMax-yMin, zMax-zMin))
                f.write('variable    Pz equal -(c_Ps[3])/({0}*{1}*{2}) \n'.format(100,yMax-yMin, zMax-zMin))
                f.write('variable    P equal (v_Px+v_Py+v_Pz)/3 \n')
            f.write('\n')
                    
        f.write('thermo_style    custom step etotal ke pe c_gasTemp v_P\n')
        f.write('\n')
        
        if flagChunkData == True:  
            if dimensions == 2 and nFilters == 1:
                f.write('compute chunks gas chunk/atom bin/2d x {0} {1} y {2} {3} bound x {4} {5} bound y {6} {7} \n'.format(int(xMin), int(dx), int(yMin+1), int(dy), int(xMin), int(xMax+filterDepth-1), int(yMin+1), int(yMax)))
                f.write('compute chunkVCM gas vcm/chunk chunks \n')
                f.write('fix chunksAvgVCM gas ave/time {0} {1} {2} c_chunkVCM[*] file vcm_'.format(dynamicTime, 1, dynamicTime) + trialName + '_' + dumpStringDiff +'.chunk mode vector \n')
                f.write('compute chunkTemp gas temp/chunk chunks internal \n')
                f.write('fix chunksAvgTemp gas ave/time {0} {1} {2} c_chunkTemp[*] file temp_'.format(dynamicTime, 1, dynamicTime) + trialName + '_' + dumpStringDiff +'.chunk mode vector \n')
                f.write('compute chunkCount gas property/chunk chunks count \n')
                f.write('fix chunksAvgCount gas ave/time {0} {1} {2} c_chunkCount[*] file count_'.format(dynamicTime, 1, dynamicTime) + trialName + '_' + dumpStringDiff +'.chunk mode vector \n')
            f.write('\n')

        if poreDump == True:
            f.write('## Define region inside pore as dynamic \n')
            if flagMultiPore == False:
                f.write('region    orifice block {0} {1} {2} {3} {4} {5}    #Define region immediately inside pore to use for dumping atom data \n'.format(int(xMax/2), int(xMax/2)+filterDepth-1, int((yMax-poreWidth)/2+1), int((yMax+poreWidth)/2), 0, 0))
                f.write('group    pore dynamic gas region orifice every {0}    #Make a dynamic group of particles in pore region every N={0} timesteps \n'.format(dynamicTime))
                f.write('dump    10 pore custom {0} orifice_'.format(dynamicTime) + trialName + dumpStringDiff + '.dump id mass vx    #Dump pore group atom data every N={0} timesteps to file '.format(dynamicTime) + trialName + '_pore_' + dumpStringDiff + '.dump including atom: id, mass, x velocity in that order \n')
                f.write('dump_modify 10 flush yes \n')
            elif flagMultiPore == True:
                f.write('region    orifice1 block {0} {1} {2} {3} {4} {5}    #Define region immediately inside pore1 to use for dumping atom data \n'.format(int(xMax/2), int(xMax/2)+filterDepth-1, int((yMax+poreSpacing)/2)+1, int((yMax+poreSpacing)/2+poreWidth), 0, 0))
                f.write('region    orifice2 block {0} {1} {2} {3} {4} {5}    #Define region immediately inside pore2 to use for dumping atom data \n'.format(int(xMax/2), int(xMax/2)+filterDepth-1, int((yMax-poreSpacing)/2-poreWidth)+1, int((yMax-poreSpacing)/2), 0, 0))
                f.write('group    pore1 dynamic gas region orifice1 every {0}    #Make a dynamic group of particles in pore1 region every N={0} timesteps \n'.format(dynamicTime))
                f.write('group    pore2 dynamic gas region orifice2 every {0}    #Make a dynamic group of particles in pore2 region every N={0} timesteps \n'.format(dynamicTime))
                f.write('dump    11 pore1 custom {0} orifice1_'.format(dynamicTime) + trialName + dumpStringDiff + '.dump id mass vx    #Dump pore1 group atom data every N={0} timesteps to file '.format(dynamicTime) + trialName + '_pore_' + dumpStringDiff + '.dump including atom: id, mass, x velocity in that order \n')
                f.write('dump    12 pore2 custom {0} orifice2_'.format(dynamicTime) + trialName  + dumpStringDiff + '.dump id mass vx    #Dump pore2 group atom data every N={0} timesteps to file '.format(dynamicTime) + trialName + '_pore_' + dumpStringDiff + '.dump including atom: id, mass, x velocity in that order \n')
                f.write('dump_modify 11 flush yes \n')
                f.write('dump_modify 12 flush yes \n')
            f.write('\n')
                        
        f.write('\n')
        
##Hardcoded pressure slice calculation
#        f.write('## Define regions in which Pressure will be calculated and inside of the pore \n')
#        f.write('region    pressureRegion block {0} {1} {2} {3} {4} {5} \n'.format(int(xMax/2)-dx,int(xMax/2)-1,yMin+1,yMax,0,0))
#        f.write('group    pressureGroup dynamic gas region pressureRegion every {0} \n'.format(dynamicTime))
#        f.write('compute    Pp pressureGroup stress/atom gasTemp ke pair \n')
#        f.write('compute    Ps pressureGroup reduce sum c_Pp[1] c_Pp[2] \n')
#        f.write('variable    Px equal -(c_Ps[1])/({0}*{1}) \n'.format(dx,yMax-yMin))
#        f.write('variable    Py equal -(c_Ps[2])/({0}*{1}) \n'.format(dx,yMax-yMin))
#        f.write('variable    P equal (v_Px+v_Py)/2 \n')
#        f.write('variable    fVCMx equal vcm(pressureGroup,x) \n')
#        f.write('\n')
#        
#        f.write('region    halfPressureRegion block {0} {1} {2} {3} {4} {5} \n'.format(int(xMin),int(xMin)+dx-1,yMin+1,yMax,0,0))
#        f.write('group    halfPressureGroup dynamic gas region halfPressureRegion every {0} \n'.format(dynamicTime))
#        f.write('compute    hPp halfPressureGroup stress/atom gasTemp ke pair \n')
#        f.write('compute    hPs halfPressureGroup reduce sum c_hPp[1] c_hPp[2] \n')
#        f.write('variable    hPx equal -(c_hPs[1])/({0}*{1}) \n'.format(dx,yMax-yMin))
#        f.write('variable    hPy equal -(c_hPs[2])/({0}*{1}) \n'.format(dx,yMax-yMin))
#        f.write('variable    hP equal (v_hPx+v_hPy)/2 \n')
#        f.write('variable    hVCMx equal vcm(halfPressureGroup,x) \n')
#        f.write('\n')
#        
#        f.write('region    midPressureRegion block {0} {1} {2} {3} {4} {5} \n'.format(int(xMax/4)-dx,int(xMax/4)-1,yMin+1,yMax,0,0))
#        f.write('group    midPressureGroup dynamic gas region midPressureRegion every {0} \n'.format(dynamicTime))
#        f.write('compute    mPp midPressureGroup stress/atom gasTemp ke pair \n')
#        f.write('compute    mPs midPressureGroup reduce sum c_mPp[1] c_mPp[2] \n')
#        f.write('variable    mPx equal -(c_mPs[1])/({0}*{1}) \n'.format(dx,yMax-yMin))
#        f.write('variable    mPy equal -(c_mPs[2])/({0}*{1}) \n'.format(dx,yMax-yMin))
#        f.write('variable    mP equal (v_mPx+v_mPy)/2 \n')
#        f.write('variable    mVCMx equal vcm(midPressureGroup,x) \n')
#        f.write('\n')
#        
#        f.write('region    rearPressureRegion block {0} {1} {2} {3} {4} {5} \n'.format(int(xMax/2)+filterDepth,int(xMax/2)+filterDepth+dx-1,yMin,yMax,0,0))
#        f.write('group    rearPressureGroup dynamic gas region rearPressureRegion every {0} \n'.format(dynamicTime))
#        f.write('compute    rPp rearPressureGroup stress/atom gasTemp ke pair \n')
#        f.write('compute    rPs rearPressureGroup reduce sum c_rPp[1] c_rPp[2] \n')
#        f.write('variable    rPx equal -(c_rPs[1])/({0}*{1}) \n'.format(dx,yMax-yMin))
#        f.write('variable    rPy equal -(c_rPs[2])/({0}*{1}) \n'.format(dx,yMax-yMin))
#        f.write('variable    rP equal (v_rPx+v_rPy)/2 \n')
#        f.write('variable    rVCMx equal vcm(rearPressureGroup,x) \n')
#        f.write('\n')
#
#        f.write('thermo_style    custom step etotal ke pe c_gasTemp press v_P v_mP v_hP v_rP v_VCMx v_fVCMx v_mVCMx v_hVCMx v_rVCMx \n')

##Dynamic file generation from variables
##Needs fixing!
#    for f in inputFiles:
#        if f == sf:
#            dumpStringDiff = 'r0'
#        elif f == rf:
#            dumpStringDiff = 'r1'
#        f.write('## Compute thermodynamic temperature based only on gas molecules \n')
#        f.write('compute    gasTemp gas temp \n')
#        if flagPressureFromKineticOnly == True:
#            f.write('compute    kePress all pressure gasTemp ke \n')
#        f.write('\n')
#        
#        if flagChunkData == True:  
#            if dimensions == 2 and nFilters == 1:
#                f.write('compute chunks gas chunk/atom bin/2d x {0} {1} y {2} {3} bound x {4} {5} bound y {6} {7} \n'.format(int(xMin), int(dx-1), int(yMin+1), int(dy), int(xMin), int(xMax+filterDepth-1), int(yMin+1), int(yMax)))
#                f.write('compute chunkVCM gas vcm/chunk chunks \n')
#                f.write('fix chunksAvgVCM gas ave/time {0} {1} {2} c_chunkVCM[*] file avg_vcm_chunks_'.format(dynamicTime, 1, dynamicTime) + trialName + '_' + dumpStringDiff +'.dump mode vector \n')
#                f.write('compute chunkTemp gas temp/chunk chunks internal \n')
#                f.write('fix chunksAvgTemp gas ave/time {0} {1} {2} c_chunkTemp[*] file avg_temp_chunks_'.format(dynamicTime, 1, dynamicTime) + trialName + '_' + dumpStringDiff +'.dump mode vector \n')
#                f.write('compute chunkCount gas property/chunk chunks count \n')
#                f.write('fix chunksAvgCount gas ave/time {0} {1} {2} c_chunkCount[*] file avg_count_chunks_'.format(dynamicTime, 1, dynamicTime) + trialName + '_' + dumpStringDiff +'.dump mode vector \n')
#            f.write('\n')
#        
#        if poreDump == True:
#            f.write('## Define region inside pore as dynamic \n')
#            if dimensions == 2:
#                f.write('region    orifice block {0} {1} {2} {3} {4} {5}    #Define region immediately inside pore to use for dumping atom data \n'.format(int(xMax/2), int(xMax/2)+filterDepth-1, int((yMax-poreWidth)/2+1+2*filterDepth), int((yMax+poreWidth)/2), 0, 0))
#                if nFilters == 2:
#                    f.write('region    orifice1 block {0} {1} {2} {3} {4} {5}    #Define region immediately inside pore1 to use for dumping atom data \n'.format(int(xMax/2)+filterSpacing+filterDepth, int(xMax/2)+filterSpacing+2*filterDepth-1, int((yMax+poreSpacing)/2)+registryShift+1+2*filterDepth, int((yMax+poreSpacing)/2+poreWidth)+registryShift, 0, 0))
#                    f.write('region    orifice2 block {0} {1} {2} {3} {4} {5}    #Define region immediately inside pore2 to use for dumping atom data \n'.format(int(xMax/2)+filterSpacing+filterDepth, int(xMax/2)+filterSpacing+2*filterDepth-1, int((yMax-poreSpacing)/2-poreWidth)+1+2*filterDepth+registryShift, int((yMax+1+2*filterDepth-poreSpacing)/2)+registryShift, 0, 0))
#            
#            elif dimensions == 3:
#                f.write('region    orifice block {0} {1} {2} {3} {4} {5}    #Define region immediately inside pore to use for dumping atom data \n'.format(int(xMax/2), int(xMax/2)+filterDepth-1, int((yMax-poreWidth)/2+1+2*filterDepth), int((yMax+poreWidth)/2), int(zMin), int(zMax)))
#                if nFilters == 2:
#                    f.write('region    orifice1 block {0} {1} {2} {3} {4} {5}    #Define region immediately inside pore1 to use for dumping atom data \n'.format(int(xMax/2)+filterSpacing+filterDepth, int(xMax/2)+filterSpacing+2*filterDepth-1, int((yMax+poreSpacing)/2)+1+2*filterDepth+registryShift, int((yMax+poreSpacing)/2+poreWidth)+registryShift, int(zMin), int(zMax)))
#                    f.write('region    orifice2 block {0} {1} {2} {3} {4} {5}    #Define region immediately inside pore2 to use for dumping atom data \n'.format(int(xMax/2)+filterSpacing+filterDepth, int(xMax/2)+filterSpacing+2*filterDepth-1, int((yMax-poreSpacing)/2)-poreWidth+1+2*filterDepth+registryShift, int((yMax+1+2*filterDepth-poreSpacing)/2)+registryShift, int(zMin), int(zMax)))
#            
#            f.write('group    pore dynamic gas region orifice every {0}    #Make a dynamic group of particles in pore region every N={0} timesteps \n'.format(dynamicTime))
#            if nFilters == 2:
#                f.write('group    pore1 dynamic gas region orifice1 every {0}    #Make a dynamic group of particles in pore1 region every N={0} timesteps \n'.format(dynamicTime))
#                f.write('group    pore2 dynamic gas region orifice2 every {0}    #Make a dynamic group of particles in pore2 region every N={0} timesteps \n'.format(dynamicTime))
#            f.write('\n')
#        
#        if flagVCM == True:
#            f.write('variable    VCMx equal vcm(gas,x) \n')
#            f.write('variable    VCMy equal vcm(gas,y) \n')
#            f.write('\n')

#        if nFilters == 2:
#            f.write('## Define regions in which Pressure will be calculated and inside of the pore \n')
#            f.write('region    midPressureRegion block {0} {1} {2} {3} {4} {5} \n'.format(int(xMax/2)+filterDepth,int(xMax/2)+filterDepth+filterSpacing-1,yMin+1+2*filterDepth,yMax,zMin,zMax))
#            f.write('group    midPressureGroup dynamic gas region midPressureRegion every {0} \n'.format(dynamicTime))
#            if flagPressureFromKineticOnly == True:
#                f.write('compute    mPp midPressureGroup stress/atom gasTemp ke \n')
#            else:
#                f.write('compute    mPp midPressureGroup stress/atom gasTemp ke pair \n')
#            if dimensions == 2:
#                f.write('compute    mPs midPressureGroup reduce sum c_mPp[1] c_mPp[2] \n')
#                f.write('variable    mPx equal -(c_mPs[1])/({0}*{1}) \n'.format(filterSpacing,yMax-yMin))
#                f.write('variable    mPy equal -(c_mPs[2])/({0}*{1}) \n'.format(filterSpacing,yMax-yMin))
#                f.write('variable    mP equal (v_mPx+v_mPy)/2 \n')
#            elif dimensions == 3:
#                f.write('compute    mPs midPressureGroup reduce sum c_mPp[1] c_mPp[2] c_mPp[3] \n')
#                f.write('variable    mPx equal -(c_mPs[1])/({0}*{1}*{2}) \n'.format(filterSpacing,yMax-yMin, zMax-zMin))
#                f.write('variable    mPy equal -(c_mPs[2])/({0}*{1}*{2}) \n'.format(filterSpacing,yMax-yMin, zMax-zMin))
#                f.write('variable    mPz equal -(c_mPs[3])/({0}*{1}*{2}) \n'.format(filterSpacing,yMax-yMin, zMax-zMin))
#                f.write('variable    mP equal (v_mPx+v_mPy+v_mPz)/3 \n')
#            f.write('\n')
            
#        if flagRearPressure == True:
#            if nFilters == 1:
#                f.write('region    rearPressureRegion block {0} {1} {2} {3} {4} {5} \n'.format(int(xMax/2)+filterDepth,int(xMax/2)+filterDepth+dx-1,yMin,yMax,0,0))#,zMin,zMax))
#            elif nFilters == 2:
#                f.write('region    rearPressureRegion block {0} {1} {2} {3} {4} {5} \n'.format(int(xMax/2)+filterSpacing+2*filterDepth,int(xMax/2)+filterSpacing+dx+2*filterDepth-1,yMin,yMax,0,0))#,zMin,zMax))          
#            f.write('group    rearPressureGroup dynamic gas region rearPressureRegion every {0} \n'.format(dynamicTime))
#            if flagPressureFromKineticOnly == True:
#                f.write('compute    rPp rearPressureGroup stress/atom gasTemp ke \n')
#            else:
#                f.write('compute    rPp rearPressureGroup stress/atom gasTemp ke pair \n')
#            if dimensions == 2:
#                f.write('compute    rPs rearPressureGroup reduce sum c_rPp[1] c_rPp[2] \n')
#                f.write('variable    rPx equal -(c_rPs[1])/({0}*{1}) \n'.format(dx,yMax-yMin))
#                f.write('variable    rPy equal -(c_rPs[2])/({0}*{1}) \n'.format(dx,yMax-yMin))
#                f.write('variable    rP equal (v_rPx+v_rPy)/2 \n')
#            elif dimensions == 3:
#                f.write('compute    rPs rearPressureGroup reduce sum c_rPp[1] c_rPp[2] c_rPp[3] \n')
#                f.write('variable    rPx equal -(c_rPs[1])/({0}*{1}*{2}) \n'.format(dx,yMax-yMin, zMax-zMin))
#                f.write('variable    rPy equal -(c_rPs[2])/({0}*{1}*{2}) \n'.format(dx,yMax-yMin, zMax-zMin))
#                f.write('variable    rPz equal -(c_rPs[3])/({0}*{1}*{2}) \n'.format(dx,yMax-yMin, zMax-zMin))
#                f.write('variable    rP equal (v_rPx+v_rPy+v_rPz)/3 \n')
#            f.write('\n')
#                        
#        if nFilters == 1:
#            if flagRearPressure == True:
#                if flagPressureFromKineticOnly == True:
#                    if flagRegionVcm == True:
#                        f.write('thermo_style    custom step etotal ke pe c_gasTemp c_kePress v_P v_rP v_VCMx v_VCMy c_VcmFront[1] c_VcmFront[2] \n')
#                    elif flagVCM == True:
#                        f.write('thermo_style    custom step etotal ke pe c_gasTemp c_kePress v_P v_rP v_VCMx v_VCMy\n')
#                    else:
#                        f.write('thermo_style    custom step etotal ke pe c_gasTemp c_kePress v_P v_rP v_VCMx v_VCMy \n')
#                else:
#                    if flagRegionVcm == True:
#                        f.write('thermo_style    custom step etotal ke pe c_gasTemp press v_P v_rP v_VCMx v_VCMy c_VcmAvg[1] c_VcmAvg[2] \n')
#                    elif flagVCM == False:
#                        f.write('thermo_style    custom step etotal ke pe c_gasTemp press v_P v_rP \n')
#                    else:
#                        f.write('thermo_style    custom step etotal ke pe c_gasTemp press v_P v_rP v_VCMx v_VCMy \n')
#            else:
#                if flagPressureFromKineticOnly == True:
#                    if flagVCM == False:
#                        f.write('thermo_style    custom step etotal ke pe c_gasTemp c_kePress v_P \n')
#                    else:
#                        f.write('thermo_style    custom step etotal ke pe c_gasTemp c_kePress v_P v_VCMx v_VCMy \n')                        
#                else:
#                    if flagVCM == False:
#                        f.write('thermo_style    custom step etotal ke pe c_gasTemp press v_P \n')
#                    else:
#                        f.write('thermo_style    custom step etotal ke pe c_gasTemp press v_P v_VCMx v_VCMy \n')
#        elif nFilters == 2:
#            if flagRearPressure == True:
#                if flagPressureFromKineticOnly == True:
#                    if flagVCM == False:
#                        f.write('thermo_style    custom step etotal ke pe c_gasTemp c_kePress v_P v_mP v_rP \n')
#                    else:
#                        f.write('thermo_style    custom step etotal ke pe c_gasTemp c_kePress v_P v_mP v_rP v_VCMx v_VCMy \n')
#                else:
#                    if flagVCM == False:
#                        f.write('thermo_style    custom step etotal ke pe c_gasTemp press v_P v_mP v_rP \n')
#                    else:
#                        f.write('thermo_style    custom step etotal ke pe c_gasTemp press v_P v_mP v_rP v_VCMx v_VCMy \n')
#            else:
#                if flagPressureFromKineticOnly == True:
#                    if flagVCM == False:
#                        f.write('thermo_style    custom step etotal ke pe c_gasTemp c_kePress v_P v_mP \n')
#                    else:
#                        f.write('thermo_style    custom step etotal ke pe c_gasTemp c_kePress v_P v_mP v_VCMx v_VCMy \n')
#                else:
#                    if flagVCM == False:
#                        f.write('thermo_style    custom step etotal ke pe c_gasTemp press v_P v_mP \n')
#                    else:
#                        f.write('thermo_style    custom step etotal ke pe c_gasTemp press v_P v_mP v_VCMx v_VCMy \n')
#        else:
#            if flagPressureFromKineticOnly == True:
#                if flagVCM == False:
#                    f.write('thermo_style    custom step etotal ke pe c_gasTemp c_kePress \n')
#                else:
#                    f.write('thermo_style    custom step etotal ke pe c_gasTemp c_kePress v_VCMx v_VCMy \n')
#            else:
#                if flagVCM == False:
#                    f.write('thermo_style    custom step etotal ke pe c_gasTemp press \n')
#                else:
#                    f.write('thermo_style    custom step etotal ke pe c_gasTemp press v_VCMx v_VCMy \n')
#
#        f.write('\n')
        
        
###Gives a "too many groups error" when using 20x20 chunks, and with 20X2000, it looks like aroung 30 groups is the maximum
#        if flagPressureChunks == True:
#            for i in xrange(iRange+nFilters):
#                  for j in xrange(jRange):
#                              xl = i*dx
#                              xu = (i+1)*dx-1
#                              yl = j*dy + 1
#                              yu = (j+1)*dy
#                              f.write('region    block{0}i{1}j block {2} {3} {4} {5} {6} {7} \n'.format(i,j,xl,xu,yl,yu,zMin,zMax))
#                              f.write('group    chunk{0}i{1}j dynamic gas region block{0}i{1}j every {2} \n'.format(i,j,dynamicTime))
#                              f.write('compute    Pp{0}i{1}j chunk{0}i{1}j stress/atom gasTemp ke pair \n'.format(i,j))
#                              if dimensions == 2:
#                                  f.write('compute    Ps{0}i{1}j chunk{0}i{1}j reduce sum c_Pp{0}i{1}j[1] c_Pp{0}i{1}j[2] \n'.format(i,j))
#                                  f.write('variable    Px{0}i{1}j equal -(c_Ps{0}i{1}j[1])/({2}*{3}) \n'.format(i,j,xu-xl+1,yu-yl+1))
#                                  f.write('variable    Py{0}i{1}j equal -(c_Ps{0}i{1}j[2])/({2}*{3}) \n'.format(i,j,xu-xl+1,yu-yl+1))
#                                  f.write('variable    P{0}i{1}j equal (v_Px{0}i{1}j+v_Py{0}i{1}j)/2 \n'.format(i,j))
#                              elif dimensions == 3:
#                                  f.write('compute    Ps{0}i{1}j chunk{0}i{1}j reduce sum c_Pp{0}i{1}j[1] c_Pp{0}i{1}j[2] c_Pp{0}i{1}j[3] \n'.format(i,j))
#                                  f.write('variable    P{0}x equal -(c_Ps{0}i{1}j[1])/({2}*{3}*{4}) \n'.format(i,j,xu-xl+1,yu-yl+1, zMax-zMin))
#                                  f.write('variable    P{0}y equal -(c_Ps{0}i{1}j[2])/({2}*{3}*{4}) \n'.format(i,j,xu-xl+1,yu-yl+1, zMax-zMin))
#                                  f.write('variable    P{0}z equal -(c_Ps{0}i{1}j[3])/({2}*{3}*{4}) \n'.format(i,j,xu-xl+1,yu-yl+1, zMax-zMin))
#                                  f.write('variable    P{0} equal (v_Px{0}i{1}j+v_Py{0}i{1}j+v_Pz{0}i{1}j)/3 \n'.format(i,j))
##                              if velDumpTime > 0:
##                                  if atomTypes < 4:
##                                      if dimensions == 2:
##                                          f.write('dump    {0} slice{1} custom {2}  '.format(10+i, i, velDumpTime) + trialName + '_slice{0}_'.format(i) + dumpStringDiff + '.dump vx vy #Dump pressure slice group slice{0} atom data every N={1} timesteps to file '.format(10+i, i, velDumpTime) + trialName + '_slice{0}_'.format(i) + dumpStringDiff + '.dump including atom: x velocity, y velocity in that order \n')
##                                      elif dimensions == 3:
##                                          f.write('dump    {0} slice{1} custom {2}  '.format(10+i, i, velDumpTime) + trialName + '_slice{0}_'.format(i) + dumpStringDiff + '.dump vx vy vz #Dump pressure slice group slice{0} atom data every N={1} timesteps to file '.format(10+i, i, velDumpTime) + trialName + '_slice{0}_'.format(i) + dumpStringDiff + '.dump including atom: x velocity, y velocity, z velocity in that order \n')                 
##                                  else:
##                                      if dimensions == 2:
##                                          f.write('dump    {0} slice{1} custom {2}  '.format(10+i, i, velDumpTime) + trialName + '_slice{0}_'.format(i) + dumpStringDiff + '.dump vx vy mass #Dump pressure slice group slice{0} atom data every N={1} timesteps to file '.format(10+i, i, velDumpTime) + trialName + '_slice{0}_'.format(i) + dumpStringDiff + '.dump including atom: x velocity, y velocity and mass in that order \n')
##                                      elif dimensions == 3:
##                                          f.write('dump    {0} slice{1} custom {2}  '.format(10+i, i, velDumpTime) + trialName + '_slice{0}_'.format(i) + dumpStringDiff + '.dump vx vy vz mass #Dump pressure slice group slice{0} atom data every N={1} timesteps to file '.format(10+i, i, velDumpTime) + trialName + '_slice{0}_'.format(i) + dumpStringDiff + '.dump including atom: x velocity, y velocity, z velocity and mass in that order \n')
##                              f.write('dump_modify {0} flush yes \n'.format(10+i))
#                  f.write('\n')
#                         
#
#
#            f.write('thermo_style    custom step etotal ke pe c_gasTemp press ')
#             
#            for i in xrange(0,iRange):
#                f.write('v_P{0} '.format(i))
#            f.write('\n')
#         
#        f.write('\n')
            
#        if poreDump == True:  
#            if impurityDiameter == 1:
#                f.write('dump    10 pore custom {0} '.format(dynamicTime) + trialName + '_pore_' + dumpStringDiff + '.dump id vx    #Dump pore group atom data every N={0} timesteps to file '.format(dynamicTime) + trialName + '_pore_' + dumpStringDiff + '.dump including atom: id, x velocity in that order \n')
#                if nFilters == 2:
#                    f.write('dump    5 pore1 custom {0} '.format(dynamicTime) + trialName + '_pore1_' + dumpStringDiff + '.dump id vx    #Dump pore1 group atom data every N={0} timesteps to file '.format(dynamicTime) + trialName + '_pore_' + dumpStringDiff + '.dump including atom: id, x velocity in that order \n')
#                    f.write('dump    12 pore2 custom {0} '.format(dynamicTime) + trialName + '_pore2_' + dumpStringDiff + '.dump id vx    #Dump pore2 group atom data every N={0} timesteps to file '.format(dynamicTime) + trialName + '_pore_' + dumpStringDiff + '.dump including atom: id, x velocity in that order \n')
#            else:
#                f.write('dump    10 pore custom {0} '.format(dynamicTime) + trialName + '_pore_' + dumpStringDiff + '.dump id mass vx    #Dump pore group atom data every N={0} timesteps to file '.format(dynamicTime) + trialName + '_pore_' + dumpStringDiff + '.dump including atom: id, mass, x velocity in that order \n')
#                if nFilters == 2:
#                    f.write('dump    5 pore1 custom {0} '.format(dynamicTime) + trialName + '_pore1_' + dumpStringDiff + '.dump id mass vx    #Dump pore1 group atom data every N={0} timesteps to file '.format(dynamicTime) + trialName + '_pore_' + dumpStringDiff + '.dump including atom: id, mass, x velocity in that order \n')
#                    f.write('dump    12 pore2 custom {0} '.format(dynamicTime) + trialName + '_pore2_' + dumpStringDiff + '.dump id mass vx    #Dump pore2 group atom data every N={0} timesteps to file '.format(dynamicTime) + trialName + '_pore_' + dumpStringDiff + '.dump including atom: id, mass, x velocity in that order \n')
#            
#            f.write('dump_modify 10 flush yes \n')
#            if nFilters == 2:
#                f.write('dump_modify 11 flush yes \n')
#                f.write('dump_modify 12 flush yes \n')
#            f.write('\n')
            
#        if tracerDump == True:
#            if impurityDiameter == 1:
#                if dimensions == 2:
#                    f.write('dump    2 tracer custom {0} '.format(tracerTime) + trialName + '_tracer_' + dumpStringDiff + '.dump id x y fx fy    #Dump argon tracer atom data every N={0} timesteps to file '.format(tracerTime) + trialName + '_tracer_' + dumpStringDiff + '.dump including atom: id, x position, y position, x force, y force in that order \n')
#                elif dimensions == 3:
#                    f.write('dump    2 tracer custom {0} '.format(tracerTime) + trialName + '_tracer_' + dumpStringDiff + '.dump id x y z fx fy fz    #Dump argon tracer atom data every N={0} timesteps to file '.format(tracerTime) + trialName + '_tracer_' + dumpStringDiff + '.dump including atom: id, x position, y position, z position, x force, y force, z force in that order \n')
#            else:
#                if dimensions == 2:
#                    f.write('dump    2 tracer custom {0} '.format(tracerTime) + trialName + '_tracer_' + dumpStringDiff + '.dump id mass x y fx fy    #Dump argon and impurity tracer atom data every N={0} timesteps to file '.format(tracerTime) + trialName + '_tracer_' + dumpStringDiff + '.dump including atom: id, mass, x position, y position, x force, y force in that order \n')
#                elif dimensions == 3:
#                    f.write('dump    2 tracer custom {0} '.format(tracerTime) + trialName + '_tracer_' + dumpStringDiff + '.dump id mass x y z fx fy fz    #Dump argon and impurity tracer atom data every N={0} timesteps to file '.format(tracerTime) + trialName + '_tracer_' + dumpStringDiff + '.dump including atom: id, mass, x position, y position, z position, x force, y force, z force in that order \n')
#            f.write('dump_modify 2 flush yes \n')
#            f.write('\n')
            
        ##This is meant to be used to write data in format readable by VMD, but futher reading seems to indicate that VMD only works with a combination of write_data and dump dcd methods.
        if dumpRawMovies == True:
            if f == sf:
                f.write('variable movieTimes equal stride2({0},{1},{2},{3},{4},{5}) \n'.format(movieStartTime, 2*totalTime + 100, totalTime + 100, movieStartTime, movieDuration, movieFrameDelta))
            else:
                f.write('variable movieTimes equal stride2({0},{1},{2},{3},{4},{5}) \n'.format(totalTime, 3*totalTime + 100, totalTime + 100, totalTime + movieStartTime, totalTime + movieDuration, movieFrameDelta))
    
            f.write('## Extra dump of mass and position in the region around the pore for making movies \n')
            f.write('region    rawPore block {0} {1} {2} {3} {4} {5}    #Define region immediately inside pore to use for dumping atom data \n'.format(int(xMax/2)-rawHalfWidth, int(xMax/2)+rawHalfWidth, int(yMax/2)-rawHalfWidth, int(yMax)/2+rawHalfWidth, int(zMin), int(zMax)))
            f.write('group    rawMovie dynamic all region rawPore every {0}    #Make a dynamic group of particles in pore region every N={0} timesteps \n'.format(movieFrameDelta))
            f.write('dump    100 rawMovie atom {0} '.format(movieFrameDelta) + trialName + dumpStringDiff + '_raw.mpg    #Dump pore group atom data every N={0} timesteps to file '.format(movieFrameDelta) + trialName + '_rawMovie_' + dumpStringDiff + '_raw.mpg including atom: id, type, x position, y position, z position in that order \n')
            f.write('dump_modify 100 flush yes scale no every v_movieTimes \n')
            f.write('\n')
            
        if dumpMovies == True:
            f.write('## Extra dump for movies \n')
            zoom = 20
            xScaled = 0.5
            yScaled = 0.5
            zScaled = 0.5
            colorType = ['black', 'blue', 'red', 'yellow', 'green']
            f.write('dump    {0} all movie {1} '.format(1000, movieFrameDelta) + trialName + '_movie_' + dumpStringDiff + '.mpg type type zoom {0} center s {1} {2} {3} size 1024 768 box yes 0.0001    #Dump movie of all atoms every N={4} timesteps, centered at scaled coordinates x={1} y={2} z={3} \n'.format(zoom, xScaled, yScaled, zScaled, movieFrameDelta))
            f.write('dump_modify    {0} '.format(1000))
            for i in range(atomTypes):
                f.write('adiam {0} {1} acolor {0} '.format(idType[i], diameterType[i]) + colorType[i] + ' ')
            f.write('\n')
            f.write('dump_modify    {0} flush yes \n'.format(1000))
            f.write('\n')
            
        if dumpImages == True:
            f.write('dump    {0} all image {1} *_'.format(1001, movieFrameDelta) + trialName + dumpStringDiff + '.jpg type type zoom {0} center s {1} {2} {3} size 1024 768 box yes 0.0001    #Dump movie of all atoms every N={4} timesteps, centered at scaled coordinates x={1} y={2} z={3} \n'.format(zoom, xScaled, yScaled, zScaled, movieFrameDelta))
            f.write('dump_modify    {0} '.format(1001))
            for i in range(atomTypes):
                f.write('adiam {0} {1} acolor {0} '.format(idType[i], diameterType[i]) + colorType[i] + ' ')
            f.write('\n')
            f.write('dump_modify    {0} flush yes \n'.format(1001))
            f.write('\n')
    
        f.write('thermo_modify flush yes \n')
    
        if dumpMovies == True:
            f.write('run {0} pre yes post yes \n'.format(movieDuration+1))
        else:
            f.write('restart {0} {1}_backup.rst {1}_archive.rst \n'.format(restartTime, trialName))
            f.write('restart {0} {1}_*.rst \n'.format(archiveRestartTime, trialName))
            f.write('run {0} pre yes post yes \n'.format(totalTime+1))
    
        f.close()
    """
        Local LAMMPS run start/restart shell files
    """
    if dumpMovies == True:
        localCores = 2
        if makeRestarts == True:
            ls = open(localStartName, 'w')
            lr = open(localRestartName, 'w')
            localFiles = [ls, lr]
        else:
            ls = open(localStartName, 'w')
            localFiles = [ls]
            
        for l in localFiles:
            if l == ls:
                fName = startName
                dumpStringDiff = 'r0'

            elif l == lr:
                fName = restartName
                dumpStringDiff = 'r1'
            l.write('#!/bin/bash \n')
            l.write('echo "Launching molecular dynamics filtration simulation(s)..." \n')
            l.write('echo "Running mpirun -n {0} /usr/local/LAMMPS/src/lmp_auto -nocite -in '.format(localCores) + fName + ' -log movie_' + trialName + '_' + dumpStringDiff + '.log" \n')
            l.write('mpirun -n {0} /usr/local/LAMMPS/src/lmp_auto -nocite -in '.format(localCores) + fName + ' -log log_movie_' + trialName + '_' + dumpStringDiff + '.log \n')
            l.write('echo "All Done!" \n')
            l.close()
            
        st = os.stat(os.path.join('.',localStartName))
        os.chmod(os.path.join('.',localStartName), st.st_mode | stat.S_IEXEC)
    if makeRestarts == True:
        st = os.stat(os.path.join('.',localRestartName))
        os.chmod(os.path.join('.',localRestartName), st.st_mode | stat.S_IEXEC)
    
    return