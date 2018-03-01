# -*- coding: utf-8 -*-
"""
Created on Fri Aug 18 14:46:50 2017

@author: Kevin Van Slyke
"""
from LAMMPS_files_generator import LAMMPS_files_generator
import random

seed = random.seed()
randomSeed = []
for i in xrange(6):
    randomSeed.append(random.randint(i+1,(i+1)*100000))
for impurityDiameter in [2,10]:
    for poreWidth in [20, 50, 200]:
        LAMMPS_files_generator(randomSeed, impurityDiameter, poreWidth)
    
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
