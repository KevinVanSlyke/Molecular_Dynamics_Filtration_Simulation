# -*- coding: utf-8 -*-
"""
Created on Thu Apr 12 15:17:28 2018

@author: Kevin
"""


import os
import filecmp
files = []
D = '18D'
for T in range(100):
    trialT = str(T) + 'T'
    pathT = '100W_' + D + '_' + trialT
    fileT = 'input_100W_' + D + '_' + trialT + '_restart_0.lmp'
    directory = '/home/Kevin/Documents/Dust_Data/Molecular/April_2018_Impurity_Statistics/High_Average_Data/D1_thru_D20/100W_' + D + '/'
    if os.path.exists(os.path.join(directory, pathT)):
        if os.path.isfile(os.path.join(directory, pathT, fileT)):
            files.append(os.path.join(directory, pathT, fileT))    
       
for aFile in files:
    for bFile in files:
        if aFile != bFile:
            if filecmp.cmp(aFile, bFile):
                print aFile
                print bFile
                print '\n'