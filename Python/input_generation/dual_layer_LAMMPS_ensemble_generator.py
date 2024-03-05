# -*- coding: utf-8 -*-
"""
Created on Fri Aug 18 14:46:50 2017

@author: Kevin Van Slyke

Creates and ensemble of LAMMPS input files and sbatch scripts
"""
import os
import random
import shutil
import time

from dual_layer_LAMMPS_input_generator import dual_layer_LAMMPS_input_generator
# from softscaling_layers_LAMMPS_input_generator import softscaling_layers_LAMMPS_input_generator
# from LAMMPS_input_generator import LAMMPS_input_generator

from dual_layer_LAMMPS_sbatch_generator import dual_layer_LAMMPS_sbatch_generator

movies = False
periodic = False

nTrialEnsemble = 5 #number of trials with differing random seed but otherwise identical parameters to create
timeout = 48 #hours

##Test study
poreWidth = [100]
poreSpacings = [0]
impurityDiameter = [1,5]#,10] #,3,5,6,7,8,9,10]
# impurityDiameter = [1,2,5,10]
# impurityDiameter = range(1,11,1)
filterSeparation = [2000]
# filterSeparation = [60,120,240,480]
# filterSeparation = range(40,401,40)
filterDepth = [60]
registryShift = [0]
timeSteps = 1*10**(6)
# nCores = [2,8]
nCores = range(1,17,1)
##Windows directories
# pyDir = 'E:\\Molecular_Dynamics_Simulation\\Python'
# simDir = 'E:\\scratch\\Input_Files'

##Unix directories
pyDir = '/mnt/e/Molecular_Dynamics_Filtration_Simulation/Python'
simDir = '/mnt/e/scratch/Input_Files/'

os.chdir(simDir)
if periodic:
    ensembleDir = 'Ensemble_' + time.strftime("%m_%d_%Y")
else:
    # ensembleDir = 'Dual_Layer_Ensemble_' + time.strftime("%m_%d_%Y")
    # ensembleDir = 'Chunkless_MultiD_Ensemble_' + time.strftime("%m_%d_%Y")
    ensembleDir = 'Soft_Scaling_Ensemble_' + time.strftime("%m_%d_%Y")
    # ensembleDir = 'Chunk_Ensemble_' + time.strftime("%m_%d_%Y")
if movies is True:
    ensembleDir = 'Local_' + ensembleDir
if not os.path.exists(ensembleDir):
    os.makedirs(ensembleDir)
#For new directory structure in Windows
# shutil.copy2(os.path.join(pyDir, 'run_scripts\\run_LAMMPS_ensemble.py'),ensembleDir)
# shutil.copy2(os.path.join(pyDir, 'file_manipulation\\delete_extra_files.py'),ensembleDir)
#For old directory structure in Unix
shutil.copy2(os.path.join(pyDir, 'run_scripts/run_LAMMPS_ensemble.py'),ensembleDir)
shutil.copy2(os.path.join(pyDir, 'file_manipulation/delete_extra_files.py'),ensembleDir)
os.chdir(ensembleDir)
for cores in nCores:
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
                            if cores != 0:
                                paramDir = paramDir + '_{0}N'.format(cores)
                            if not os.path.exists(paramDir):
                                os.makedirs(paramDir)
                            os.chdir(paramDir)
                            if movies is False:
                                dual_layer_LAMMPS_input_generator(timeSteps, periodic, width, diameter, depth, fSeparation, oSpacing, shift, movies, cores)
                                # softscaling_layers_LAMMPS_input_generator(timeSteps, periodic, width, diameter, depth, fSeparation, oSpacing, shift, movies, cores)
                                # LAMMPS_input_generator(width, diameter, fSeparation, oSpacing, shift, movies)
                                dual_layer_LAMMPS_sbatch_generator(paramDir, nTrialEnsemble, timeout, cores)
                                os.chdir('..')
                            else:
                                random.seed()
                                randomSeed = []
                                for i in range(6):
                                    randomSeed.append(random.randint(i+1,(i+1)*100000))
                                dual_layer_LAMMPS_input_generator(timeSteps, periodic, width, diameter, depth, fSeparation, oSpacing, shift, movies, cores)
                                # softscaling_layers_LAMMPS_input_generator(timeSteps, periodic, width, diameter, depth, fSeparation, oSpacing, shift, movies, cores)
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
