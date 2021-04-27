# -*- coding: utf-8 -*-
"""
Created on Fri Aug 18 14:46:50 2017

@author: Kevin Van Slyke
Creates an ensemble of LAMMPS input files.
"""
import os
import random
import shutil
import time

from dual_layer_LAMMPS_input_generator import dual_layer_LAMMPS_input_generator
from LAMMPS_input_generator import LAMMPS_input_generator
from LAMMPS_sbatch_generator import LAMMPS_sbatch_generator

movies = False
periodic = True

nTrialEnsemble = 10 #number of trials with differing random seed but otherwise identical parameters to create
timeout = 72 #hours

##Test study
poreWidth = [120]
poreSpacings = [120]
impurityDiameter = [5]
# impurityDiameter = [1,2,5,10]
# impurityDiameter = range(1,11,1)
# filterSeparation = [120]
# filterSeparation = [60,120,240,480]
filterSeparation = range(40,401,40)
filterDepth = [60]
registryShift = [0]
timeSteps = 5*10**(5)

# ##Orifice Spacing study
# poreWidth = [120]
# poreSpacings = [40,120,240,480]
# impurityDiameter = [1,2,5]
# filterSeparation = [120]
# filterDepth = [60]
# registryShift = [0]
# timeSteps = 1*10**(7)

# ##Filter Separation study
# poreWidth = [120]
# poreSpacings = [120]
# impurityDiameter = [1,2,5]
# filterSeparation = [60,120,240,480]
# filterDepth = [60]
# registryShift = [0]
# timeSteps = 1*10**(7)

# ##Assymetry study
# poreWidth = [120]
# poreSpacings = [120]
# impurityDiameter = [1,2,5]
# filterSeparation = [120]
# filterDepth = [60]
# registryShift = [0,60,120,240,480]
# timeSteps = 1*10**(7)

# ##Reflective BC
# periodic = False
# poreWidth = [120]
# poreSpacings = [120]
# impurityDiameter = [5]
# filterSeparation = [120]
# filterDepth = [60]
# registryShift = [0,120,480]
# timeSteps = 1*10**(7)

""" # ##Small
# poreWidth = [40]
# poreSpacings = [40]
# impurityDiameter = [5]
# filterSeparation = [40]
# filterDepth = [20]
# registryShift = [0]
# timeSteps = 1*10**(7)

# ##Large
# poreWidth = [240]
# poreSpacings = [240]
# impurityDiameter = [5]
# filterSeparation = [240]
# filterDepth = [120]
# registryShift = [0]
# timeSteps = 1*10**(7)

# ##Huge
# poreWidth = [480]
# poreSpacings = [480]
# impurityDiameter = [5]
# filterSeparation = [480]
# filterDepth = [240]
# registryShift = [0]
# timeSteps = 10**(6) """

""" # ##Skew Square
# poreWidth = [120]
# poreSpacings = [240]
# impurityDiameter = [5]
# filterSeparation = [240]
# filterDepth = [60]
# registryShift = [60]
# timeSteps = 1*10**(7)

# ##Skew Wide
# poreWidth = [120]
# poreSpacings = [240]
# impurityDiameter = [5]
# filterSeparation = [300]
# filterDepth = [60]
# registryShift = [120]
# timeSteps = 1*10**(7)

# ##Skew Tall
# poreWidth = [120]
# poreSpacings = [300]
# impurityDiameter = [5]
# filterSeparation = [240]
# filterDepth = [60]
# registryShift = [120]
# timeSteps = 1*10**(7) """

##Windows directories
# pyDir = 'E:\\Molecular_Dynamics_Filtration_Simulation\\Python'
# simDir = 'E:\\Input_Files'

##Unix directories
pyDir = '/mnt/e/Molecular_Dynamics_Filtration_Simulation/Python'
simDir = '/mnt/e/scratch/Input_Files/'

os.chdir(simDir)
if periodic:
    ensembleDir = 'Dual_Layer_Periodic_Ensemble_' + time.strftime("%m_%d_%Y")
else:
    ensembleDir = 'Dual_Layer_Ensemble_' + time.strftime("%m_%d_%Y")
if movies == True:
    ensembleDir = 'Local_' + ensembleDir
if not os.path.exists(ensembleDir):
    os.makedirs(ensembleDir)
shutil.copy2(os.path.join(pyDir, 'run_LAMMPS_ensemble.py'),ensembleDir)
shutil.copy2(os.path.join(pyDir, 'delete_extra_files.py'),ensembleDir)
os.chdir(ensembleDir)
for depth in filterDepth:
    for width in poreWidth:
        for diameter in impurityDiameter:
            for oSpacing in poreSpacings:
                for fSeparation in filterSeparation:
                    for shift in registryShift:
                        paramDir = '{0}W_{1}D'.format(width, diameter)
                        if depth != 0:
                            paramDir = paramDir + '_{0}L'.format(depth)
                        if fSeparation != 0:
                            paramDir = paramDir + '_{0}F'.format(fSeparation)
                        if oSpacing != 0:
                            paramDir = paramDir + '_{0}S'.format(oSpacing)
                        if shift != 0:
                            paramDir = paramDir + '_{0}H'.format(shift)
                        if not os.path.exists(paramDir):
                            os.makedirs(paramDir)
                        os.chdir(paramDir)
                        if movies == False:
                            dual_layer_LAMMPS_input_generator(timeSteps, periodic, width, diameter, depth, fSeparation, oSpacing, shift, movies)
                            # LAMMPS_input_generator(width, diameter, fSeparation, oSpacing, shift, movies)
                            dual_layer_LAMMPS_sbatch_generator(paramDir, nTrialEnsemble, timeout)
                            os.chdir('..')
                        else:
                            random.seed()
                            randomSeed = []
                            for i in range(6):
                                randomSeed.append(random.randint(i+1,(i+1)*100000))
                            dual_layer_LAMMPS_input_generator(timeSteps, periodic, width, diameter, depth, fSeparation, oSpacing, shift, movies)
                            # LAMMPS_input_generator(width, diameter, fSeparation, oSpacing, shift, movies)
                            os.chdir('..')



#    for impurityDiameter in [2,10]:
#        for poreWidth in [20, 50, 200]:
#            LAMMPS_files_generator(randomSeed, impurityDiameter, poreWidth, filterSeparation)
#    os.chdir(trialsDir)

    #for firstVar in range(2,42):
        #for secondVar in [2, 5, 10]:
            #LAMMPS_files_generator(randomSeed, firstVar, secondVar)
            #os.chdir(simDir)
            #for thirdVar in [secondVar*2, secondVar*4]:
                #LAMMPS_files_generator(randomSeed, firstVar, secondVar, thirdVar)
                #os.chdir(simDir)
                #for fourthVar in [5000, 20000]:
                    #LAMMPS_files_generator(randomSeed, firstVar, secondVar, thirdVar, fourthVar)
                    #os.chdir(simDir)
