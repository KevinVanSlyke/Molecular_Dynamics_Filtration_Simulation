# -*- coding: utf-8 -*-
"""
Created on Fri Aug 18 14:46:50 2017

@author: Kevin Van Slyke
"""
from LAMMPS_input_generator import LAMMPS_input_generator
from LAMMPS_sbatch_generator import LAMMPS_sbatch_generator
import random
import os
import shutil
import time

nTrialEnsemble = 1 #number of trials with differing random seed but otherwise identical parameters to create
timeout = 48 #hours


poreWidth = [120]
poreSpacing = [120]
impurityDiameter = [1,5,10,15]
filterSpacing = [100,200,300,400,500]
registryShift = [0]

movies = True
pyDir = os.getcwd()
os.chdir('../../')
projDir = os.getcwd()
simDir = os.path.join(projDir, 'Input_Files/')
os.chdir(simDir)
ensembleDir = 'Simulation_Ensemble_' + time.strftime("%m_%d_%Y")
if movies == True:
    ensembleDir = 'Local_' + ensembleDir
if not os.path.exists(ensembleDir):
    os.makedirs(ensembleDir)
shutil.copy2(os.path.join(pyDir, 'Nth_LAMMPS_restart_generator.py'),ensembleDir)
shutil.copy2(os.path.join(pyDir, 'run_Nth_LAMMPS_restarts.py'),ensembleDir)
shutil.copy2(os.path.join(pyDir, 'delete_extra_ensemble_files.py'),ensembleDir)
os.chdir(ensembleDir)

for width in poreWidth:
    for diameter in impurityDiameter:
        for spacing in poreSpacing:
            for separation in filterSpacing:
                for shift in registryShift:
                    paramDir = '{0}W_{1}D'.format(width, diameter)
                    if spacing != 0:
                        paramDir = paramDir + '_{0}F'.format(spacing)
                    if filterSpacing != 0:
                        paramDir = paramDir + '_{0}S'.format(separation)
                    if shift != 0:
                        paramDir = paramDir + '_{0}H'.format(shift)
                    if not os.path.exists(paramDir):
                        os.makedirs(paramDir)
                    os.chdir(paramDir)
                    if movies == False:
                        LAMMPS_input_generator(width, diameter, separation, spacing, shift, movies)
                        LAMMPS_sbatch_generator(paramDir, nTrialEnsemble, timeout)
                        os.chdir('..')
                    else:
                        random.seed()
                        randomSeed = []
                        for i in range(6):
                            randomSeed.append(random.randint(i+1,(i+1)*100000))
                        LAMMPS_input_generator(width, diameter, separation, spacing, shift, movies)
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
