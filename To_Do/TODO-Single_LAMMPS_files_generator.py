# -*- coding: utf-8 -*-
"""
Created on Fri Aug 18 14:46:50 2017

@author: Kevin Van Slyke
"""

import time
import os
import stat
import random

seed = random.seed()
randomSeed = []
for i in xrange(6):
    randomSeed.append(random.randint(i+1,(i+1)*100000))
##Spatial input parameters
dimensions = 2
nFilters = 2

xMax = 10
xMin = 0
yMax = 10
yMin = 0
yPad = 1
dx = 100
#    iRange = xMax/dx
if dimensions == 2:
    zMax = 0.01
    zMin = -0.01
if dimensions == 3:
    zMax = 5
    zMin = 0
    zPad = 1

##Currently filter must span entire z dimension and pore is open along this entire axis
poreWidth = 4
filterDepth = 1
#    filterHeight = 3
filterSpacing = 4
poreSpacing = poreWidth

##Initialization temperature and velocity parameters
fluidVelocity = 1
fluidTemperature = 1
flagPressureFromKineticOnly = False
flagImpurityFlow = False
#    flagPressFilterFaceOnly = True
#    flagPressVerticalSlicesOnly = True
flagRearPressure = True

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

##Optional Temporal parameters and flags for extra analysis print outs
##Set times below to 0 to exclude print out
poreDump = False

tracerDump = False
tracerTime = 10
nTracers = 10

dumpMovies = True
dumpRawMovies = False
rawHalfWidth = 125
movieStartTime = 0
movieDuration = 10**(5)
movieFrameDelta = 100

#    velDumpTime = 0


nTotal = 10
nImpurities = 1
impurityDiameter = 2

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
dirName = '{0}W_{1}D'.format(poreWidth, impurityDiameter)

if (dumpMovies == True):
    localStartName = 'local_movie_' + dirName + '_restart_0.sh'
    localRestartName = 'local_movie_' + dirName + '_restart_1.sh'
    startName = 'input_movie_' + dirName + '_restart_0.lmp'
    restartName = 'input_movie_' + dirName + '_restart_1.lmp'
else:
    startName = 'input_' + dirName + '_restart_0.lmp'
    rushStartName = 'sbatch_' + dirName + '_restart_0.sh'
    restartName = 'input_' + dirName + '_restart_1.lmp'
    rushRestartName = 'sbatch_' + dirName + '_restart_1.sh'

trialDir = os.getcwd()
if not os.path.exists(dirName):
    os.makedirs(dirName)
os.chdir(dirName)

"""
    Primary LAMMPS start/restart files
"""
sf = open(startName, 'w')
rf = open(restartName, 'w')
inputFiles = [sf, rf]
for f in inputFiles:
    f.write('## LAMMPS input start file for filtration research  \n')
    f.write('## Written by Kevin Van Slyke  \n')
    f.write('## Dated: ' + time.strftime("%m_%d_%Y") + '\n')
    f.write('\n')
    
rf.write('read_restart {0}_archive.rst \n'.format(dirName))

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
    if nFilters == 1:
        sf.write('region    box block {0} {1} {2} {3} {4} {5}    #Create extruded rectangular simulation volume in units of lattice sites, {0}<=x<{1}, {2}<=y<{3}, {4}<=z<{5} \n'.format(int(xMin), int(xMax+filterDepth), int(yMin-yPad), int(yMax+yPad), zMin, zMax))
    elif nFilters ==2:
        sf.write('region    box block {0} {1} {2} {3} {4} {5}    #Create extruded rectangular simulation volume in units of lattice sites, {0}<=x<{1}, {2}<=y<{3}, {4}<=z<{5} \n'.format(int(xMin), int(xMax+2*filterDepth), int(yMin-yPad), int(yMax+yPad), zMin, zMax))
elif dimensions == 3:
    sf.write('boundary    p f f    #Set boundaries such that x_axis=fixed, y_axis=periodic, z_axis=fixed \n')
    sf.write('lattice    sc 1    #Simple cubic lattice with one basis atom per cell, lattice_spacing=1/1=1, reduced density rho = 1 \n')
    if nFilters == 1:
        sf.write('region    box block {0} {1} {2} {3} {4} {5}    #Create extruded rectangular simulation volume in units of lattice sites, {0}<=x<{1}, {2}<=y<{3}, {4}<=z<{5} \n'.format(int(xMin), int(xMax+filterDepth), int(yMin-yPad), int(yMax+yPad), int(zMin-zPad), int(zMax+zPad)))
    elif nFilters ==2:
        sf.write('region    box block {0} {1} {2} {3} {4} {5}    #Create extruded rectangular simulation volume in units of lattice sites, {0}<=x<{1}, {2}<=y<{3}, {4}<=z<{5} \n'.format(int(xMin), int(xMax+2*filterDepth), int(yMin-yPad), int(yMax+yPad), int(zMin-zPad), int(zMax+zPad)))

sf.write('create_box    {0} box    #Create simulation volume in region box with {0} atom types \n'.format(atomTypes))
sf.write('timestep    {0}    #One timestep={0}*tau, tau=2.17*10^(-12)s for Argon \n'.format(timeStep))
sf.write('\n')

sf.write('## LJ potential: atom type 1, atom type 2, epsilon, sigma \n')
sf.write('pair_style    lj/cut 1.1225    #Lennard-Jones global cut-off=1.1225 \n')
epsilon = 1.0
for i in xrange(atomTypes):
    for j in xrange(atomTypes):
        if i <= j:
            sigma = diameterType[i]/2. + diameterType[j]/2.
            cutOff = sigma*1.1225 #1.1225 = 2**(1/6)
            if ((idType[i] == 1) and (idType[j] == 1)):
                cutOff = 0.5
            sf.write('pair_coeff     {0} {1} {2} {3} {4}     #Pairwise {0}-{1} interaction, epsilon={2}, sigma={3}, cut-off={4} \n'.format(idType[i], idType[j], epsilon, sigma, cutOff))
for i in xrange(atomTypes):
    sf.write('mass    {0} {1}    #Sets mass of particle type {0} to {1} \n'.format(idType[i], massType[i]))
sf.write('pair_modify    shift yes    #Shifts LJ potential to 0.0 at the cut-off \n')
sf.write('\n')

sf.write('## Define the filter area and fill it with atoms fixed to lattice sites \n')
if dimensions == 2 and nFilters == 1:
    sf.write('region    topWall block {0} {1} {2} {3} {4} {5}    #Top half of single pore filter \n'.format(int(xMax/2), int(xMax/2)+filterDepth-1, int((yMax+poreWidth)/2+1), int(yMax), 0, 0))
    sf.write('region    botWall block {0} {1} {2} {3} {4} {5}    #Bottom half of single pore filter \n'.format(int(xMax/2), int(xMax/2)+filterDepth-1, int(yMin), int((yMax+yPad-poreWidth)/2-1), 0, 0))
    sf.write('region    frontVacuum block {0} {1} {2} {3} {4} {5}    #Front Region to be filled by gas \n'.format(int(xMin + diameterType[-1] + 1), int(int(xMax/2)-(diameterType[-1] + 1)), int(yMin+diameterType[-1]+1), int(yMax-(diameterType[-1]+1)), 0, 0))
    sf.write('region    rearVacuum block {0} {1} {2} {3} {4} {5}    #Rear Region to be filled by gas \n'.format(int(int(xMax/2) + filterDepth + diameterType[-1] + 1), int(xMax + filterDepth - (diameterType[-1] + 1)), int(yMin+diameterType[-1]+1), int(yMax-(diameterType[-1]+1)), 0, 0))
    sf.write('region    vacuum union 2 frontVacuum rearVacuum \n')
    
elif dimensions == 3 and nFilters == 1:
    sf.write('region    topWall block {0} {1} {2} {3} {4} {5}    #Top half of single pore filter \n'.format(int(xMax/2), int(xMax/2)+filterDepth-1, int((yMax+poreWidth)/2+1), int(yMax), int(zMin), int(zMax)))
    sf.write('region    botWall block {0} {1} {2} {3} {4} {5}    #Bottom half of single pore filter \n'.format(int(xMax/2), int(xMax/2)+filterDepth-1, int(yMin), int((yMax+yPad-poreWidth)/2-1), int(zMin), int(zMax)))
    sf.write('region    vacuum block {0} {1} {2} {3} {4} {5}    #Region to be filled by gas \n'.format(int(xMin + diameterType[-1] + 1), int(xMax-(diameterType[-1] + filterDepth + 1)), int(yMin+diameterType[-1]+1), int(yMax-(diameterType[-1]+1)), int(zMin+diameterType[-1]+1), int(zMax-(diameterType[-1]+1))))
    sf.write('region    frontVacuum block {0} {1} {2} {3} {4} {5}    #Front Region to be filled by gas \n'.format(int(xMin + diameterType[-1] + 1), int(int(xMax/2) - (diameterType[-1]  + 1)), int(yMin+diameterType[-1]+1), int(yMax-(diameterType[-1]+1)), int(zMin+diameterType[-1]+1), int(zMax-(diameterType[-1]+1))))
    sf.write('region    rearVacuum block {0} {1} {2} {3} {4} {5}    #Rear Region to be filled by gas \n'.format(int(int(xMax/2) + filterDepth + diameterType[-1] + 1), int(xMax + filterDepth - (diameterType[-1] + 1)), int(yMin+diameterType[-1]+1), int(yMax-(diameterType[-1]+1)), int(zMin+diameterType[-1]+1), int(zMax-(diameterType[-1]+1))))
    sf.write('region    vacuum union 2 frontVacuum rearVacuum \n')
    
elif dimensions == 2 and nFilters == 2:
    sf.write('region    topWall1 block {0} {1} {2} {3} {4} {5}    #Top half of single pore filter \n'.format(int(xMax/2), int(xMax/2)+filterDepth-1, int((yMax+poreWidth)/2+1), int(yMax), 0, 0))
    sf.write('region    botWall1 block {0} {1} {2} {3} {4} {5}    #Bottom half of single pore filter \n'.format(int(xMax/2), int(xMax/2)+filterDepth-1, int(yMin), int((yMax+yPad-poreWidth)/2-1), 0, 0))
    sf.write('region    topWall2 block {0} {1} {2} {3} {4} {5}    #Top half of dual pore filter \n'.format(int(xMax/2)+filterSpacing+filterDepth, int(xMax/2)+filterSpacing+2*filterDepth-1, int((yMax+poreSpacing)/2+poreWidth+1), int(yMax), 0, 0))
    sf.write('region    midWall2 block {0} {1} {2} {3} {4} {5}    #Middle portion of dual pore filter \n'.format(int(xMax/2)+filterSpacing+filterDepth, int(xMax/2)+filterSpacing+2*filterDepth-1, int(yMax-poreSpacing)/2+1, int((yMax+poreSpacing)/2-1), 0, 0))
    sf.write('region    botWall2 block {0} {1} {2} {3} {4} {5}    #Bottom half of dual pore filter \n'.format(int(xMax/2)+filterSpacing+filterDepth, int(xMax/2)+filterSpacing+2*filterDepth-1, int(yMin), int((yMax+yPad-poreSpacing)/2-poreWidth-1), 0, 0))
    sf.write('region    frontVacuum block {0} {1} {2} {3} {4} {5}    #Front Region to be filled by gas \n'.format(int(xMin + diameterType[-1] + 1), int(int(xMax/2) - (diameterType[-1] + 1)), int(yMin+diameterType[-1]+1), int(yMax-(diameterType[-1]+1)), 0, 0))
    sf.write('region    midVacuum block {0} {1} {2} {3} {4} {5}    #Middle Region to be filled by gas \n'.format(int(int(xMax/2)+(diameterType[-1] + filterDepth + 1)), int(int(xMax/2) + filterSpacing + filterDepth - (diameterType[-1] + 1)), int(yMin+diameterType[-1]+1), int(yMax-(diameterType[-1]+1)), 0, 0))        
    sf.write('region    rearVacuum block {0} {1} {2} {3} {4} {5}    #Rear Region to be filled by gas \n'.format(int(int(xMax/2) + filterSpacing + 2*filterDepth + diameterType[-1] + 1), int(xMax + 2*filterDepth - (diameterType[-1] + 1)), int(yMin+diameterType[-1]+1), int(yMax-(diameterType[-1]+1)), 0, 0))
    sf.write('region    vacuum union 3 frontVacuum midVacuum rearVacuum \n')
    
elif dimensions == 3 and nFilters == 2:
    sf.write('region    topWall1 block {0} {1} {2} {3} {4} {5}    #Top half of single pore filter \n'.format(int(xMax/2), int(xMax/2)+filterDepth-1, int((yMax+poreWidth)/2+1), int(yMax), int(zMin), int(zMax)))
    sf.write('region    botWall1 block {0} {1} {2} {3} {4} {5}    #Bottom half of single pore filter \n'.format(int(xMax/2), int(xMax/2)+filterDepth-1, int(yMin), int((yMax+yPad-poreWidth)/2-1), int(zMin), int(zMax)))
    sf.write('region    topWall2 block {0} {1} {2} {3} {4} {5}    #Top half of dual pore filter \n'.format(int(xMax/2)+filterSpacing+filterDepth, int(xMax/2)+filterSpacing+2*filterDepth-1, int((yMax+poreSpacing)/2+poreWidth+1), int(yMax), int(zMin), int(zMax)))
    sf.write('region    midWall2 block {0} {1} {2} {3} {4} {5}    #Middle portion of dual pore filter \n'.format(int(xMax/2)+filterSpacing+filterDepth, int(xMax/2)+filterSpacing+2*filterDepth-1, int(yMax-poreSpacing)/2+1, int((yMax+poreSpacing)/2-1), int(zMin), int(zMax)))
    sf.write('region    botWall2 block {0} {1} {2} {3} {4} {5}    #Bottom half of dual pore filter \n'.format(int(xMax/2)+filterSpacing+filterDepth, int(xMax/2)+filterSpacing+2*filterDepth-1, int(yMin), int((yMax+yPad-poreSpacing)/2-1), int(zMin), int(zMax)))
    sf.write('region    frontVacuum block {0} {1} {2} {3} {4} {5}    #Front Region to be filled by gas \n'.format(int(xMin + diameterType[-1] + 1), int(int(xMax/2)-(diameterType[-1] + 1)), int(yMin+diameterType[-1]+1), int(yMax-(diameterType[-1]+1)), int(zMin+diameterType[-1]+1), int(zMax-(diameterType[-1]+1))))
    sf.write('region    midVacuum block {0} {1} {2} {3} {4} {5}    #Front Region to be filled by gas \n'.format(int(int(xMax/2)+(diameterType[-1] + filterDepth + 1)), int(int(xMax/2) + filterSpacing + filterDepth - (diameterType[-1] + 1)), int(yMin+diameterType[-1]+1), int(yMax-(diameterType[-1]+1)), int(zMax-(diameterType[-1]+1))))
    sf.write('region    rearVacuum block {0} {1} {2} {3} {4} {5}    #Rear Region to be filled by gas \n'.format(int(int(xMax/2) + filterSpacing + 2*filterDepth + diameterType[-1] + 1), int(xMax + 2*filterDepth - (diameterType[-1] + 1)), int(yMin+diameterType[-1]+1), int(yMax-(diameterType[-1]+1)), int(zMin+diameterType[-1]+1), int(zMax-(diameterType[-1]+1))))
    sf.write('region    vacuum union 3 frontVacuum midVacuum rearVacuum \n')

if nFilters == 1:
    sf.write('create_atoms    {0} region topWall \n'.format(idType[0]))
    sf.write('create_atoms    {0} region botWall \n'.format(idType[0]))
    sf.write('group    topFilter region topWall \n')
    sf.write('group    botFilter region botWall \n')
    sf.write('group    filter union topFilter botFilter \n')
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
    sf.write('create_atoms    {0} random {1} {2} vacuum    #Create atoms: type={0}, placement=random, N={1}, seed={2}, region=vacuum \n'.format(idType[i], nType[i], randomSeed[i]))

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
    if poreWidth > 0:    
        f.write('fix    2 filter setforce 0.0 0.0 0.0  #Fix force on filter to zero \n')
    if dimensions == 2:
        f.write('fix    3 gas wall/reflect ylo {0} yhi {1}    #Fix walls parallel to xz plane at y={0} and y={1} to reflect particles \n'.format(int(yMin), int(yMax)))
        f.write('fix    4 all enforce2d    #Fix motion along the z-axis to simulate 2D \n')
    elif dimensions == 3:
        f.write('fix    3 gas wall/reflect ylo {0} yhi {1} zlo {2} zhi {3}    #Fix walls parallel to xz plane at y={0} and y={1} and xy plane at z={2} and z={3} to reflect particles \n'.format(int(yMin), int(yMax), int(zMin), int(zMax)))

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
sf.write('velocity	filter set 0.0 0.0 0.0     #Set initial velocity of walls to zero \n')
if impurityDiameter == 1:
    sf.write('velocity    gas create {0} {1} dist gaussian    #Create velocity of gas particles from a Gaussian distribution at temperature={0} with random seed={1} \n'.format(fluidTemperature, randomSeed[3]))
    sf.write('velocity    gas set {0} 0 0 sum yes units box    #Add initial fluid velocity bias of v_x={0} (towards the filter) \n'.format(fluidVelocity))
else:
    sf.write('velocity    argon create {0} {1} dist gaussian    #Create velocity of Argon particles from a Gaussian distribution at temperature={0} with random seed={1} \n'.format(fluidTemperature, randomSeed[3]))
    sf.write('velocity    argon set {0} 0 0 sum yes units box    #Add initial fluid velocity bias of v_x={0} (towards the filter) to the Argon \n'.format(fluidVelocity))
    sf.write('velocity    impurity create {0} {1} dist gaussian    #Create velocity of large particles from a Gaussian distribution at temperature={0} with random seed={1} \n'.format(fluidTemperature, randomSeed[0]))
    if flagImpurityFlow == True:        
        sf.write('velocity    impurity set {0} 0 0 sum yes units box    #Add initial fluid velocity bias of v_x={0} (towards the filter) to the Impurities \n'.format(float(fluidVelocity)))

for f in inputFiles:
    if f == sf:
        dumpStringDiff = 'restart_0'
    elif f == rf:
        dumpStringDiff = 'restart_1'
    f.write('## Compute thermodynamic temperature based only on gas molecules \n')
    f.write('compute    gasTemp gas temp \n')
    if flagPressureFromKineticOnly == True:
        f.write('compute    kePress all pressure gasTemp ke \n')
    f.write('\n')

    if poreDump == True:
        f.write('## Define region inside pore as dynamic \n')
        if dimensions == 2:
            f.write('region    orifice block {0} {1} {2} {3} {4} {5}    #Define region immediately inside pore to use for dumping atom data \n'.format(int(xMax/2), int(xMax/2)+filterDepth-1, int((yMax+yPad-poreWidth)/2), int((yMax+poreWidth)/2), 0, 0))
            if nFilters == 2:
                f.write('region    orifice1 block {0} {1} {2} {3} {4} {5}    #Define region immediately inside pore1 to use for dumping atom data \n'.format(int(xMax/2)+filterSpacing+filterDepth, int(xMax/2)+filterSpacing+2*filterDepth-1, int((yMax+yPad+poreSpacing)/2), int((yMax+poreSpacing)/2+poreWidth), 0, 0))
                f.write('region    orifice2 block {0} {1} {2} {3} {4} {5}    #Define region immediately inside pore2 to use for dumping atom data \n'.format(int(xMax/2)+filterSpacing+filterDepth, int(xMax/2)+filterSpacing+2*filterDepth-1, int((yMax-poreSpacing)/2-poreWidth), int((yMax+yPad-poreSpacing)/2), 0, 0))
        
        elif dimensions == 3:
            f.write('region    orifice block {0} {1} {2} {3} {4} {5}    #Define region immediately inside pore to use for dumping atom data \n'.format(int(xMax/2), int(xMax/2)+filterDepth-1, int((yMax+yPad-poreWidth)/2), int((yMax+poreWidth)/2), int(zMin), int(zMax)))
            if nFilters == 2:
                f.write('region    orifice1 block {0} {1} {2} {3} {4} {5}    #Define region immediately inside pore1 to use for dumping atom data \n'.format(int(xMax/2)+filterSpacing+filterDepth, int(xMax/2)+filterSpacing+2*filterDepth-1, int((yMax+yPad+poreSpacing)/2), int((yMax+poreSpacing)/2+poreWidth), int(zMin), int(zMax)))
                f.write('region    orifice2 block {0} {1} {2} {3} {4} {5}    #Define region immediately inside pore2 to use for dumping atom data \n'.format(int(xMax/2)+filterSpacing+filterDepth, int(xMax/2)+filterSpacing+2*filterDepth-1, int((yMax-poreSpacing)/2-poreWidth), int((yMax+yPad-poreSpacing)/2), int(zMin), int(zMax)))
        
        f.write('group    pore dynamic gas region orifice every {0}    #Make a dynamic group of particles in pore region every N={0} timesteps \n'.format(dynamicTime))
        if nFilters == 2:
            f.write('group    pore1 dynamic gas region orifice1 every {0}    #Make a dynamic group of particles in pore1 region every N={0} timesteps \n'.format(dynamicTime))
            f.write('group    pore2 dynamic gas region orifice2 every {0}    #Make a dynamic group of particles in pore2 region every N={0} timesteps \n'.format(dynamicTime))
        
        
        f.write('\n')

    if nFilters >= 1:
        f.write('## Define regions in which Pressure will be calculated and inside of the pore \n')
        f.write('region    pressureRegion block {0} {1} {2} {3} {4} {5} \n'.format(int(xMax/2)-dx,int(xMax/2),yMin,yMax,zMin,zMax))
        f.write('group    pressureGroup dynamic gas region pressureRegion every {0} \n'.format(dynamicTime))
        if flagPressureFromKineticOnly == True:
            f.write('compute    Pp pressureGroup stress/atom gasTemp ke \n')
        else:
            f.write('compute    Pp pressureGroup stress/atom gasTemp ke pair \n')
        if dimensions == 2:
            f.write('compute    Ps pressureGroup reduce sum c_Pp[1] c_Pp[2] \n')
            f.write('variable    Px equal -(c_Ps[1])/({0}*{1}) \n'.format(dx,yMax-yMin))
            f.write('variable    Py equal -(c_Ps[2])/({0}*{1}) \n'.format(dx,yMax-yMin))
            f.write('variable    P equal (v_Px+v_Py)/2 \n')
        elif dimensions == 3:
            f.write('compute    Ps pressureGroup reduce sum c_Pp[1] c_Pp[2] c_Pp[3] \n')
            f.write('variable    Px equal -(c_Ps[1])/({0}*{1}*{2}) \n'.format(dx,yMax-yMin, zMax-zMin))
            f.write('variable    Py equal -(c_P{0}s[2])/({0}*{1}*{2}) \n'.format(dx,yMax-yMin, zMax-zMin))
            f.write('variable    Pz equal -(c_P{0}s[3])/({0}*{1}*{2}) \n'.format(dx,yMax-yMin, zMax-zMin))
            f.write('variable    P equal (v_Px+v_Py+v_Pz)/3 \n')
        f.write('\n')
        
    if nFilters == 2:
        f.write('## Define regions in which Pressure will be calculated and inside of the pore \n')
        f.write('region    midPressureRegion block {0} {1} {2} {3} {4} {5} \n'.format(int(xMax/2)+filterDepth,int(xMax/2)+filterDepth+filterSpacing,yMin,yMax,zMin,zMax))
        f.write('group    midPressureGroup dynamic gas region midPressureRegion every {0} \n'.format(dynamicTime))
        if flagPressureFromKineticOnly == True:
            f.write('compute    mPp midPressureGroup stress/atom gasTemp ke \n')
        else:
            f.write('compute    mPp midPressureGroup stress/atom gasTemp ke pair \n')
        if dimensions == 2:
            f.write('compute    mPs midPressureGroup reduce sum c_mPp[1] c_mPp[2] \n')
            f.write('variable    mPx equal -(c_mPs[1])/({0}*{1}) \n'.format(filterSpacing,yMax-yMin))
            f.write('variable    mPy equal -(c_mPs[2])/({0}*{1}) \n'.format(filterSpacing,yMax-yMin))
            f.write('variable    mP equal (v_mPx+v_mPy)/2 \n')
        elif dimensions == 3:
            f.write('compute    mPs midPressureGroup reduce sum c_mPp[1] c_mPp[2] c_mPp[3] \n')
            f.write('variable    mPx equal -(c_mPs[1])/({0}*{1}*{2}) \n'.format(filterSpacing,yMax-yMin, zMax-zMin))
            f.write('variable    mPy equal -(c_mP{0}s[2])/({0}*{1}*{2}) \n'.format(filterSpacing,yMax-yMin, zMax-zMin))
            f.write('variable    mPz equal -(c_mP{0}s[3])/({0}*{1}*{2}) \n'.format(filterSpacing,yMax-yMin, zMax-zMin))
            f.write('variable    mP equal (v_mPx+v_mPy+v_mPz)/3 \n')
        f.write('\n')
        
    if flagRearPressure == True:
        if nFilters == 1:
            f.write('region    rearPressureRegion block {0} {1} {2} {3} {4} {5} \n'.format(int(xMax/2)+filterDepth,int(xMax/2)+filterDepth+dx,yMin,yMax,zMin,zMax))
        elif nFilters == 2:
            f.write('region    rearPressureRegion block {0} {1} {2} {3} {4} {5} \n'.format(int(xMax/2)+filterSpacing+2*filterDepth,int(xMax/2)+filterSpacing+dx+2*filterDepth,yMin,yMax,zMin,zMax))
        
        f.write('group    rearPressureGroup dynamic gas region rearPressureRegion every {0} \n'.format(dynamicTime))
        if flagPressureFromKineticOnly == True:
            f.write('compute    rPp rearPressureGroup stress/atom gasTemp ke \n')
        else:
            f.write('compute    rPp rearPressureGroup stress/atom gasTemp ke pair \n')
        if dimensions == 2:
            f.write('compute    rPs rearPressureGroup reduce sum c_rPp[1] c_rPp[2] \n')
            f.write('variable    rPx equal -(c_rPs[1])/({0}*{1}) \n'.format(dx,yMax-yMin))
            f.write('variable    rPy equal -(c_rPs[2])/({0}*{1}) \n'.format(dx,yMax-yMin))
            f.write('variable    rP equal (v_rPx+v_rPy)/2 \n')
        elif dimensions == 3:
            f.write('compute    rPs rearPressureGroup reduce sum c_rPp[1] c_rPp[2] c_rPp[3] \n')
            f.write('variable    rPx equal -(c_rPs[1])/({0}*{1}*{2}) \n'.format(dx,yMax-yMin, zMax-zMin))
            f.write('variable    rPy equal -(c_rP{0}s[2])/({0}*{1}*{2}) \n'.format(dx,yMax-yMin, zMax-zMin))
            f.write('variable    rPz equal -(c_rP{0}s[3])/({0}*{1}*{2}) \n'.format(dx,yMax-yMin, zMax-zMin))
            f.write('variable    rP equal (v_rPx+v_rPy+v_rPz)/3 \n')
        f.write('\n')
        
    if nFilters == 1:
        if flagRearPressure == True:
            if flagPressureFromKineticOnly == True:
                f.write('thermo_style    custom step etotal ke pe c_gasTemp c_kePress v_P v_rP \n')
            else:
                f.write('thermo_style    custom step etotal ke pe c_gasTemp press v_P v_rP \n')
        else:
            if flagPressureFromKineticOnly == True:
                f.write('thermo_style    custom step etotal ke pe c_gasTemp c_kePress v_P \n')
            else:
                f.write('thermo_style    custom step etotal ke pe c_gasTemp press v_P \n')
    elif nFilters == 2:
        if flagRearPressure == True:
            if flagPressureFromKineticOnly == True:
                f.write('thermo_style    custom step etotal ke pe c_gasTemp c_kePress v_P v_mP v_rP \n')
            else:
                f.write('thermo_style    custom step etotal ke pe c_gasTemp press v_P v_mP v_rP \n')
        else:
            if flagPressureFromKineticOnly == True:
                f.write('thermo_style    custom step etotal ke pe c_gasTemp c_kePress v_P v_mP \n')
            else:
                f.write('thermo_style    custom step etotal ke pe c_gasTemp press v_P v_mP \n')
    else:
        if flagPressureFromKineticOnly == True:
            f.write('thermo_style    custom step etotal ke pe c_gasTemp c_kePress \n')
        else:
            f.write('thermo_style    custom step etotal ke pe c_gasTemp press \n')
    f.write('\n')

            
##TODO: Note the variable group function vcm would return the center of mass velocity of a group of particles. This could be very useful data and not take up much hard drive space.
            
            
#==============================================================================
#              for i in xrange(iRange):
#                  if ((flagPressFilterFaceOnly != True) or (i == iRange-1)):
#                          xl = i*dx
#                          xu = (i+1)*dx-1
#                          f.write('region    block{0} block {1} {2} {3} {4} {5} {6} \n'.format(i,xl,xu,yMin,yMax,zMin,zMax))
#                          f.write('group    slice{0} dynamic gas region block{0} every {1} \n'.format(i,dynamicTime))
#                          if flagPressureFromKineticOnly == True:
#                              f.write('compute    P{0}p slice{0} stress/atom gasTemp ke \n'.format(i))
#                          else:
#                              f.write('compute    P{0}p slice{0} stress/atom gasTemp ke pair \n'.format(i))
#                          if dimensions == 2:
#                              f.write('compute    P{0}s slice{0} reduce sum c_P{0}p[1] c_P{0}p[2] \n'.format(i))
#                              f.write('variable    P{0}x equal -(c_P{0}s[1])/({1}*{2}) \n'.format(i,xu-xl+1,yMax-yMin))
#                              f.write('variable    P{0}y equal -(c_P{0}s[2])/({1}*{2}) \n'.format(i,xu-xl+1,yMax-yMin))
#                              f.write('variable    P{0} equal (v_P{0}x+v_P{0}y)/2 \n'.format(i))
#                          elif dimensions == 3:
#                              f.write('compute    P{0}s slice{0} reduce sum c_P{0}p[1] c_P{0}p[2] c_P{0}p[3] \n'.format(i))
#                              f.write('variable    P{0}x equal -(c_P{0}s[1])/({1}*{2}*{3}) \n'.format(i,xu-xl+1,yMax-yMin, zMax-zMin))
#                              f.write('variable    P{0}y equal -(c_P{0}s[2])/({1}*{2}*{3}) \n'.format(i,xu-xl+1,yMax-yMin, zMax-zMin))
#                              f.write('variable    P{0}z equal -(c_P{0}s[3])/({1}*{2}*{3}) \n'.format(i,xu-xl+1,yMax-yMin, zMax-zMin))
#                              f.write('variable    P{0} equal (v_P{0}x+v_P{0}y+v_P{0}z)/3 \n'.format(i))
#                          if velDumpTime > 0:
#                              if atomTypes < 4:
#                                  if dimensions == 2:
#                                      f.write('dump    {0} slice{1} custom {2}  dump_'.format(10+i, i, velDumpTime) + dirName + '_slice{0}_'.format(i) + dumpStringDiff + '.lmp vx vy #Dump pressure slice group slice{0} atom data every N={1} timesteps to file dump_'.format(10+i, i, velDumpTime) + dirName + '_slice{0}_'.format(i) + dumpStringDiff + '.lmp including atom: x velocity, y velocity in that order \n')
#                                  elif dimensions == 3:
#                                      f.write('dump    {0} slice{1} custom {2}  dump_'.format(10+i, i, velDumpTime) + dirName + '_slice{0}_'.format(i) + dumpStringDiff + '.lmp vx vy vz #Dump pressure slice group slice{0} atom data every N={1} timesteps to file dump_'.format(10+i, i, velDumpTime) + dirName + '_slice{0}_'.format(i) + dumpStringDiff + '.lmp including atom: x velocity, y velocity, z velocity in that order \n')                 
#                              else:
#                                  if dimensions == 2:
#                                      f.write('dump    {0} slice{1} custom {2}  dump_'.format(10+i, i, velDumpTime) + dirName + '_slice{0}_'.format(i) + dumpStringDiff + '.lmp vx vy mass #Dump pressure slice group slice{0} atom data every N={1} timesteps to file dump_'.format(10+i, i, velDumpTime) + dirName + '_slice{0}_'.format(i) + dumpStringDiff + '.lmp including atom: x velocity, y velocity and mass in that order \n')
#                                  elif dimensions == 3:
#                                      f.write('dump    {0} slice{1} custom {2}  dump_'.format(10+i, i, velDumpTime) + dirName + '_slice{0}_'.format(i) + dumpStringDiff + '.lmp vx vy vz mass #Dump pressure slice group slice{0} atom data every N={1} timesteps to file dump_'.format(10+i, i, velDumpTime) + dirName + '_slice{0}_'.format(i) + dumpStringDiff + '.lmp including atom: x velocity, y velocity, z velocity and mass in that order \n')
#                          f.write('dump_modify {0} flush yes \n'.format(10+i))
#                          f.write('\n')
#                     
#         if flagPressureFromKineticOnly == True:
#             f.write('thermo_style    custom step etotal ke pe c_gasTemp c_kePress ')
#         else:
#             f.write('thermo_style    custom step etotal ke pe c_gasTemp press ')
#             
#         
#         for i in xrange(0,iRange):
#             if ((flagPressFilterFaceOnly != True) or (i == iRange-1)):
#                 f.write('v_P{0} '.format(i))
#         f.write('\n')
#         
#         f.write('\n')
#==============================================================================
    
    if poreDump == True:  
        if impurityDiameter == 1:
            f.write('dump    10 pore custom {0} dump_'.format(dynamicTime) + dirName + '_pore_' + dumpStringDiff + '.lmp id vx    #Dump pore group atom data every N={0} timesteps to file dump_'.format(dynamicTime) + dirName + '_pore_' + dumpStringDiff + '.lmp including atom: id, x velocity in that order \n')
            if nFilters == 2:
                f.write('dump    11 pore1 custom {0} dump_'.format(dynamicTime) + dirName + '_pore1_' + dumpStringDiff + '.lmp id vx    #Dump pore1 group atom data every N={0} timesteps to file dump_'.format(dynamicTime) + dirName + '_pore_' + dumpStringDiff + '.lmp including atom: id, x velocity in that order \n')
                f.write('dump    12 pore2 custom {0} dump_'.format(dynamicTime) + dirName + '_pore2_' + dumpStringDiff + '.lmp id vx    #Dump pore2 group atom data every N={0} timesteps to file dump_'.format(dynamicTime) + dirName + '_pore_' + dumpStringDiff + '.lmp including atom: id, x velocity in that order \n')

        else:
            f.write('dump    10 pore custom {0} dump_'.format(dynamicTime) + dirName + '_pore_' + dumpStringDiff + '.lmp id mass vx    #Dump pore group atom data every N={0} timesteps to file dump_'.format(dynamicTime) + dirName + '_pore_' + dumpStringDiff + '.lmp including atom: id, mass, x velocity in that order \n')
            if nFilters == 2:
                f.write('dump    11 pore1 custom {0} dump_'.format(dynamicTime) + dirName + '_pore1_' + dumpStringDiff + '.lmp id mass vx    #Dump pore1 group atom data every N={0} timesteps to file dump_'.format(dynamicTime) + dirName + '_pore_' + dumpStringDiff + '.lmp including atom: id, mass, x velocity in that order \n')
                f.write('dump    12 pore2 custom {0} dump_'.format(dynamicTime) + dirName + '_pore2_' + dumpStringDiff + '.lmp id mass vx    #Dump pore2 group atom data every N={0} timesteps to file dump_'.format(dynamicTime) + dirName + '_pore_' + dumpStringDiff + '.lmp including atom: id, mass, x velocity in that order \n')
        
        f.write('dump_modify 10 flush yes \n')
        if nFilters == 2:
            f.write('dump_modify 11 flush yes \n')
            f.write('dump_modify 12 flush yes \n')

        f.write('\n')
    if tracerDump == True:
        if impurityDiameter == 1:
            if dimensions == 2:
                f.write('dump    2 tracer custom {0} dump_'.format(tracerTime) + dirName + '_tracer_' + dumpStringDiff + '.lmp id x y fx fy    #Dump argon tracer atom data every N={0} timesteps to file dump_'.format(tracerTime) + dirName + '_tracer_' + dumpStringDiff + '.lmp including atom: id, x position, y position, x force, y force in that order \n')
            elif dimensions == 3:
                f.write('dump    2 tracer custom {0} dump_'.format(tracerTime) + dirName + '_tracer_' + dumpStringDiff + '.lmp id x y z fx fy fz    #Dump argon tracer atom data every N={0} timesteps to file dump_'.format(tracerTime) + dirName + '_tracer_' + dumpStringDiff + '.lmp including atom: id, x position, y position, z position, x force, y force, z force in that order \n')
        else:
            if dimensions == 2:
                f.write('dump    2 tracer custom {0} dump_'.format(tracerTime) + dirName + '_tracer_' + dumpStringDiff + '.lmp id mass x y fx fy    #Dump argon and impurity tracer atom data every N={0} timesteps to file dump_'.format(tracerTime) + dirName + '_tracer_' + dumpStringDiff + '.lmp including atom: id, mass, x position, y position, x force, y force in that order \n')
            elif dimensions == 3:
                f.write('dump    2 tracer custom {0} dump_'.format(tracerTime) + dirName + '_tracer_' + dumpStringDiff + '.lmp id mass x y z fx fy fz    #Dump argon and impurity tracer atom data every N={0} timesteps to file dump_'.format(tracerTime) + dirName + '_tracer_' + dumpStringDiff + '.lmp including atom: id, mass, x position, y position, z position, x force, y force, z force in that order \n')
        f.write('dump_modify 2 flush yes \n')
        f.write('\n')
        
    ##This is meant to be used to write data in format readable by VMD, but futher reading seems to indicate that VMD only works with a combination of write_data and dump dcd methods.
    if dumpRawMovies == True:
        if f == sf:
            f.write('variable movieTimes equal stride2({0},{1},{2},{3},{4},{5}) \n'.format(movieStartTime, 2*totalTime + 100, totalTime + 100, movieStartTime, movieDuration, movieFrameDelta))
        else:
            f.write('variable movieTimes equal stride2({0},{1},{2},{3},{4},{5}) \n'.format(totalTime, 3*totalTime + 100, totalTime + 100, totalTime + movieStartTime, totalTime + movieDuration, movieFrameDelta))

        f.write('## Extra dump of mass and position in the region around the pore for making movies \n')
        f.write('region    rawPore block {0} {1} {2} {3} {4} {5}    #Define region immediately inside pore to use for dumping atom data \n'.format(int(xMax/2)-rawHalfWidth, int(xMax/2)+rawHalfWidth, int(yMax/2)-rawHalfWidth, int(yMax)/2+rawHalfWidth, int(zMin), int(zMax)))
        f.write('group    rawMovie dynamic all region rawPore every {0}    #Make a dynamic group of particles in pore region every N={0} timesteps \n'.format(movieFrameDelta))
        f.write('dump    100 rawMovie atom {0} dump_'.format(movieFrameDelta) + dirName + '_rawMovie_' + dumpStringDiff + '.lmp    #Dump pore group atom data every N={0} timesteps to file dump_'.format(movieFrameDelta) + dirName + '_rawMovie_' + dumpStringDiff + '.lmp including atom: id, type, x position, y position, z position in that order \n')
        f.write('dump_modify 100 flush yes scale no every v_movieTimes \n')
        f.write('\n')
        
    if dumpMovies == True:
        f.write('## Extra dump for movies \n')
        zoom = 50
        xScaled = 0.52725
        yScaled = 0.5
        zScaled = 0.5
        colorType = ['white', 'blue', 'red', 'yellow', 'green']
        f.write('dump    {0} all movie {1} dump_'.format(1000, movieFrameDelta) + dirName + '_movie_' + dumpStringDiff + '.mpg type type zoom {0} center s {1} {2} {3} size 1024 768 box yes 0.0001    #Dump movie of all atoms every N={4} timesteps, centered at scaled coordinates x={1} y={2} z={3} \n'.format(zoom, xScaled, yScaled, zScaled, movieFrameDelta))
        f.write('dump_modify    {0} '.format(1000))
        for i in range(atomTypes):
            f.write('adiam {0} {1} acolor {0} '.format(idType[i], diameterType[i]) + colorType[i] + ' ')
        f.write('\n')
        f.write('dump_modify    {0} flush yes \n'.format(1000))
        f.write('\n')

    f.write('thermo_modify flush yes \n')

    if dumpMovies == True:
        f.write('run {0} pre yes post yes \n'.format(movieDuration+1))
    else:
        f.write('restart {0} {1}_backup.rst {1}_archive.rst \n'.format(restartTime, dirName))
        f.write('restart {0} {1}_archive_*.rst \n'.format(archiveRestartTime, dirName))
        f.write('run {0} pre yes post yes \n'.format(totalTime+1))

    f.close()
    

"""
    Local LAMMPS run start/restart shell files
"""
if dumpMovies == True:
    localCores = 2
    ls = open(localStartName, 'w')
    lr = open(localRestartName, 'w')
    localFiles = [ls, lr]
    for l in localFiles:
        if l == ls:
            fName = startName
            dumpStringDiff = 'restart_0'
        elif l == lr:
            fName = restartName
            dumpStringDiff = 'restart_1'
        l.write('#!/bin/bash \n')
        l.write('echo "Launching molecular dynamics filtration simulation(s)..." \n')
        l.write('echo "Running mpirun -n {0} /usr/local/LAMMPS/src/lmp_auto -nocite -in '.format(localCores) + fName + ' -log log_movie_' + dirName + '_' + dumpStringDiff + '.lmp" \n')
        l.write('mpirun -n {0} /usr/local/LAMMPS/src/lmp_auto -nocite -in '.format(localCores) + fName + ' -log log_movie_' + dirName + '_' + dumpStringDiff + '.lmp \n')
        l.write('echo "All Done!" \n')
        l.close()
        
    st = os.stat(os.path.join('.',localStartName))
    os.chmod(os.path.join('.',localStartName), st.st_mode | stat.S_IEXEC)

    st = os.stat(os.path.join('.',localRestartName))
    os.chmod(os.path.join('.',localRestartName), st.st_mode | stat.S_IEXEC)


"""
    Rush CCR LAMMPS srun start/restart sbatch files
"""
if dumpMovies == False:
    rushCores = 4
    mem = 512
    rs = open(rushStartName,'w')
    rr = open(rushRestartName,'w')
    rushFiles = [rs, rr]
    for r in rushFiles:
        r.write('#!/bin/sh \n')
        r.write('#SBATCH --partition=general-compute \n')
        r.write('#SBATCH --time={0}:00:00 \n'.format(timeout))
        r.write('#SBATCH --nodes=1 \n')
        r.write('#SBATCH --ntasks-per-node={0} \n'.format(rushCores))
        r.write('##SBATCH --constraint=IB \n')
        r.write('#SBATCH --mem={0} \n'.format(mem))
        r.write('# Memory per node specification is in MB. It is optional. \n')
        r.write('# The default limit is 3000MB per core. \n')
        r.write('#SBATCH --mail-user=kgvansly@buffalo.edu \n')
        r.write('#SBATCH --mail-type=ALL \n')
        r.write('##SBATCH --requeue \n')
        r.write('#Specifies that the job will be requeued after a node failure. \n')
        r.write('#The default is that the job will not be requeued. \n')
        
    rs.write('#SBATCH --job-name="r0_' + dirName + '" \n')
    rs.write('#SBATCH --output="output_' + dirName + '_restart_0.txt" \n')
    rs.write('#SBATCH --error="error_' + dirName + '_restart_0.txt" \n')
    
    rr.write('#SBATCH --job-name="r1_' + dirName + '" \n')
    rr.write('#SBATCH --output="output_' + dirName + '_restart_1.txt" \n')
    rr.write('#SBATCH --error="error_' + dirName + '_restart_1.txt" \n')
    
    for r in rushFiles:
        if r == rs:
            fName = startName
            dumpStringDiff = 'restart_0'
        elif r == rr:
            fName = restartName
            dumpStringDiff = 'restart_1'
        r.write('echo "SLURM_JOBID=$SLURM_JOBID" \n')
        r.write('echo "SLURM_JOB_NODELIST=$SLURM_JOB_NODELIST" \n')
        r.write('echo "SLURM_NNODES=$SLURM_NNODES" \n')
        r.write('echo "SLURMTMPDIR=$SLURMTMPDIR" \n')
        r.write('echo "Submit directory = $SLURM_SUBMIT_DIR" \n')
    
        r.write("NPROCS=`srun --nodes=${SLURM_NNODES} bash -c 'hostname' |wc -l` \n")
        r.write('echo "NPROCS=$NPROCS" \n')
        
        r.write('module unload intel-mpi \n')
        r.write('module load intel-mpi/2017.0.1 \n')
        r.write('module load lammps \n')
        r.write('module list \n')
        r.write('ulimit -s unlimited \n')
    
        r.write('#The PMI library is necessary for srun \n')
        r.write('export I_MPI_PMI_LIBRARY=/usr/lib64/libpmi.so \n')
    
        r.write('echo "Working directory = $PWD" \n')
    
        r.write('echo "Launch MPI LAMMPS air filtration simulation with srun" \n')
    
        r.write('echo "Echo... srun -n $NPROCS lmp_mpi -nocite -screen none -in ' + fName + ' -log log_' + dirName + '_' + dumpStringDiff + '.lmp" \n')
        r.write('srun -n $NPROCS lmp_mpi -nocite -screen none -in ' + fName + ' -log log_' + dirName + '_' + dumpStringDiff + '.lmp \n')
    
        r.write('echo "All Done!"')
        r.close()

os.chdir(trialDir)
