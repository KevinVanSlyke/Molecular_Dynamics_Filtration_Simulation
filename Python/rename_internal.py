# -*- coding: utf-8 -*-
"""
Created on Fri Aug 18 14:46:50 2017

@author: Kevin Van Slyke
Replaces variable names inside files
"""
import os
import shutil


##Local Unix test directories
# dataDir = '/mnt/e/scratch/Input_Files/'
# copyDir = '/mnt/e/scratch/Copy_Files/'

dataDir = os.getcwd()
# dataDir = '/mnt/e/Data/Molecular_Dynamics_Data/Focused_Mesh_07_2020/'
for ensembleDir in os.listdir(dataDir):
    if os.path.isdir(os.path.join(dataDir,ensembleDir)):
        for trialDir in os.listdir(os.path.join(dataDir,ensembleDir)):
            if os.path.isdir(os.path.join(dataDir,ensembleDir,trialDir)):
                for fileName in os.listdir(os.path.join(dataDir,ensembleDir,trialDir)):
                    if fileName.startswith('argon_InternalTemp') or fileName.startswith('impurity_InternalTemp') \
                    or fileName.startswith('argon_tempCom') or fileName.startswith('impurity_tempCom'):
                        fileParts = fileName.split('_')
                        tempFileName = fileParts[0] + '_internalTemp.mat'
                        newFileName = fileParts[0] + '_internalTemp_' + fileParts[2]
                        filePath = os.path.join(dataDir,ensembleDir,trialDir,fileName)
                        tempFilePath = os.path.join(dataDir,ensembleDir,trialDir,tempFileName)
                        newFilePath = os.path.join(dataDir,ensembleDir,trialDir,newFileName)
                        os.rename(filePath,tempFilePath)
                        os.rename(tempFilePath,newFilePath)
                    elif fileName.endswith('.sbatch'):
                        filePath = os.path.join(dataDir,ensembleDir, trialDir, fileName)
                        os.remove(filePath)