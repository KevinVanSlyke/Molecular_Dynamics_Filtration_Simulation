# -*- coding: utf-8 -*-
"""
Created on Fri Aug 18 14:46:50 2017

@author: Kevin Van Slyke
"""
import os
import random
import shutil
import time

from channel_LAMMPS_input_generator import channel_LAMMPS_input_generator
# from LAMMPS_input_generator import LAMMPS_input_generator
from dual_layer_LAMMPS_sbatch_generator import dual_layer_LAMMPS_sbatch_generator

movies = True

nTrialEnsemble = 1 #number of trials with differing random seed but otherwise identical parameters to create
timeout = 72 #hours
timeSteps = 5*10**(6)

# poreWidth = [60,120]
# poreSpacing = [60,120,240,480]
# impurityDiameter = [1,5,10]
# filterSpacing = [60,120,240,480]
# registryShift = [0]
# filterDepth = [60]

##Baseline
# poreWidth = [40,120,400]
# impurityDiameter = [1,2,5]
# filterDepth = [2,20,600]

##Test Study
poreWidth = [40]
impurityDiameter = [2]
filterDepth = [20]

# numberAtoms = [4*10^4, 8*10^4, 4*10^5]
# poreWidth = [2]
# poreSpacing = [2]
# impurityDiameter = [1,2]
# filterSpacing = [2]
# registryShift = [0]
# filterDepth = [2]

# pyDir = 'E:\\Molecular_Dynamics_Filtration_Simulation\\Python'
# simDir = 'E:\\Input_Files'

pyDir = '/mnt/e/Molecular_Dynamics_Filtration_Simulation/Python'
simDir = '/mnt/e/scratch/Input_Files/'

os.chdir(simDir)
ensembleDir = 'Channel_Ensemble_' + time.strftime("%m_%d_%Y")
if movies == True:
    ensembleDir = 'Local_' + ensembleDir
if not os.path.exists(ensembleDir):
    os.makedirs(ensembleDir)
shutil.copy2(os.path.join(pyDir, 'dual_layer_run_LAMMPS_ensemble.py'),ensembleDir)
shutil.copy2(os.path.join(pyDir, 'dual_layer_delete_extra_ensemble_files.py'),ensembleDir)
os.chdir(ensembleDir)
for depth in filterDepth:
    for width in poreWidth:
        for diameter in impurityDiameter:
            paramDir = '{0}W_{1}D'.format(width, diameter)
            if depth != 0:
                paramDir = paramDir + '_{0}L'.format(depth)
            if not os.path.exists(paramDir):
                os.makedirs(paramDir)
            os.chdir(paramDir)
            if movies == False:
                channel_LAMMPS_input_generator(timeSteps, width, diameter, depth, movies)
                # LAMMPS_input_generator(width, diameter, separation, spacing, shift, movies)
                dual_layer_LAMMPS_sbatch_generator(paramDir, nTrialEnsemble, timeout)
                os.chdir('..')
            else:
                random.seed()
                randomSeed = []
                for i in range(6):
                    randomSeed.append(random.randint(i+1,(i+1)*100000))
                channel_LAMMPS_input_generator(timeSteps, width, diameter, depth, movies)
                # LAMMPS_input_generator(width, diameter, separation, spacing, shift, movies)
                os.chdir('..')



#    for impurityDiameter in [2,10]:
#        for poreWidth in [20, 50, 200]:
#            LAMMPS_files_generator(randomSeed, impurityDiameter, poreWidth, filterSpacing)
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
