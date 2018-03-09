# -*- coding: utf-8 -*-
"""
Created on Fri Aug 18 14:46:50 2017

@author: Kevin Van Slyke
"""
from LAMMPS_files_generator import LAMMPS_files_generator
import random
import os
import shutil
import time

nTrialEnsemble = 50 #number of trials with differing random seed but otherwise identical parameters to create
timeout = 72 #hours
filterSpacing = [100]
poreWidth = [20]
impurityDiamter = [10]
#poreWidth = [20, 50, 200]
#impurityDiamter = [2, 5, 10]

topDir = os.getcwd()
ensembleDir = 'Simulation_Ensemble_' + time.strftime("%m_%d_%Y")
if not os.path.exists(ensembleDir):
    os.makedirs(ensembleDir)
shutil.copy2('./Nth_LAMMPS_restart_generator.py',ensembleDir)
shutil.copy2('./run_Nth_LAMMPS_restarts.py',ensembleDir)
shutil.copy2('./delete_extra_ensemble_files.py',ensembleDir)
os.chdir(ensembleDir)

for width in poreWidth:
    for diameter in impurityDiamter:
        for spacing in filterSpacing:
            paramDir = '{0}W_{1}D_{2}L_Trials'.format(width, diameter, spacing)
            if not os.path.exists(paramDir):
                os.makedirs(paramDir)
            os.chdir(paramDir)
            for trial in xrange(nTrialEnsemble):
                seed = random.seed()
                randomSeed = []
                for i in xrange(6):
                    randomSeed.append(random.randint(i+1,(i+1)*100000))
                LAMMPS_files_generator(randomSeed, width, diameter, trial, timeout)
        os.chdir('..')
#    for impurityDiameter in [2,10]:
#        for poreWidth in [20, 50, 200]:
#            LAMMPS_files_generator(randomSeed, impurityDiameter, poreWidth, filterSpacing)
#    os.chdir(trialsDir)    
    
    #for firstVar in range(2,42):
        #for secondVar in [2, 5, 10]:
            #LAMMPS_files_generator(randomSeed, firstVar, secondVar)
            #os.chdir(topDir)
            #for thirdVar in [secondVar*2, secondVar*4]:
                #LAMMPS_files_generator(randomSeed, firstVar, secondVar, thirdVar)
                #os.chdir(topDir)
                #for fourthVar in [5000, 20000]:
                    #LAMMPS_files_generator(randomSeed, firstVar, secondVar, thirdVar, fourthVar)
                    #os.chdir(topDir)
