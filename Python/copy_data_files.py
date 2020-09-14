# -*- coding: utf-8 -*-
"""
Created on Fri Aug 18 14:46:50 2017

@author: Kevin Van Slyke
"""
import os
import shutil


##Local Unix test directories
# sourceDir = '/mnt/e/scratch/Input_Files/'
# copyDir = '/mnt/e/scratch/Copy_Files/'

sourceDir = os.getcwd()
rootDir = os.path.split(sourceDir)[0]
copyDir = os.path.join(rootDir,'Reduced_Data_Copy')
if not os.path.exists(copyDir):
    os.makedirs(copyDir)
for ensembleDir in os.listdir(sourceDir):
    if os.path.isdir(os.path.join(sourceDir,ensembleDir)):
        newEnsembleDir = os.path.join(copyDir,ensembleDir)
        if not os.path.exists(newEnsembleDir):
            os.makedirs(newEnsembleDir)
        for trialDir in os.listdir(os.path.join(sourceDir,ensembleDir)):
            if os.path.isdir(os.path.join(sourceDir,ensembleDir,trialDir)):
                newTrialDir = os.path.join(copyDir,ensembleDir,trialDir)
                if not os.path.exists(newTrialDir):
                    os.makedirs(newTrialDir)
                for fileName in os.listdir(os.path.join(sourceDir,ensembleDir,trialDir)):
                    if fileName.endswith('.log') or fileName.endswith('.lmp') \
                    or (fileName.startswith('Mesh_Data') and fileName.endswith('.mat')) \
                    or fileName.endswith('archive.rst') or fileName.endswith('steps.rst'):
                        filePath = os.path.join(sourceDir,ensembleDir, trialDir, fileName)
                        shutil.copy2(filePath,newTrialDir)
