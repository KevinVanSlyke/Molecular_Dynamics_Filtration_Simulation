import os
import shutil


##Local Unix test directories
# dataDir = '/mnt/e/scratch/Input_Files/'
# copyDir = '/mnt/e/scratch/Copy_Files/'

dataDir = os.getcwd()
for ensembleDir in os.listdir(dataDir):
    if os.path.isdir(os.path.join(dataDir,ensembleDir)):
        for trialDir in os.listdir(os.path.join(dataDir,ensembleDir)):
            if os.path.isdir(os.path.join(dataDir,ensembleDir,trialDir)):
                for fileName in os.listdir(os.path.join(dataDir,ensembleDir,trialDir)):
                    if fileName.startswith('thermo'):
                        with open(fileName) as f:
                            for ind, line in enumerate(f):
                                if line.startswith('Loop Time'):
                                    break
                                else:
                                     

