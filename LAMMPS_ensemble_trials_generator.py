# -*- coding: utf-8 -*-
"""
Created on Fri Aug 18 14:46:50 2017

@author: Kevin Van Slyke
"""
from LAMMPS_files_generator import LAMMPS_files_generator
import random
import os
import shutil
#import numpy as np

topDir = os.getcwd()

filterSpacing = 50

nTrialEnsemble = 5
for trial in xrange(nTrialEnsemble):
    trialDir = 'Multi_Filter_Spacing_{0}_Trial_{1}'.format(filterSpacing, trial)
    if not os.path.exists(trialDir):
        os.makedirs(trialDir)
    shutil.copy2('./Nth_restart_files_generator.py',trialDir)
    shutil.copy2('./run_Nth_LAMMPS_rush_ensemble.py',trialDir)

    os.chdir(trialDir)
    seed = random.seed()
    randomSeed = []
    for i in xrange(6):
        randomSeed.append(random.randint(i+1,(i+1)*100000))
    for impurityDiameter in [2,10]:
        for poreWidth in [20, 50, 200]:
            LAMMPS_files_generator(randomSeed, impurityDiameter, poreWidth, filterSpacing)
    os.chdir(topDir)    
    
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
