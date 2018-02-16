# -*- coding: utf-8 -*-
"""
Created on Tue Sep 19 15:01:53 2017

@author: kevin
"""

import os
from Nth_run_file_generator import Nth_run_file_generator
topDir = os.getcwd()
for dirName in os.listdir(topDir):
    if not (dirName.endswith('.py') or dirName.endswith('.pyc')):
        trialDir = os.path.join(topDir,dirName)
        os.chdir(trialDir)
        sbatchNum = -1
        outputNum = -1
        running = True
        for files in os.listdir(trialDir):
            if files.startswith('sbatch'):
                sbatchFileParts = files.split('_')
                sbatchRestartParts = sbatchFileParts[-1].split('.')
                if int(sbatchRestartParts[0]) > sbatchNum:
                    sbatchNum = int(sbatchRestartParts[0])
            if files.startswith('output'):
                started = True
                outputFileParts = files.split('_')
                outputRestartParts = outputFileParts[1].split('.')
                outputNumPart = outputFileParts[0].split('D')

                if int(outputNumPart) > outputNum:
                    outputNum = int(outputNumPart)
        if outputNum >= 0 :                
            output = open('output_r'+ str(outputNum)  + dirName + '.txt','r')
            lines = output.readlines() 
            for line in lines:
                if line.startswith('All Done!'):
                    running = False
                        
        if outputNum < 0:
            script = './sbatch_' + dirName + '_restart_{0}.sh'.format(0)
            os.system("sbatch " + script)
        elif running == True:
            continue
        elif sbatchNum == outputNum + 1:
            script = './sbatch_' + dirName + '_restart_{0}.sh'.format(sbatchNum)
            os.system("sbatch " + script)
        elif sbatchNum == outputNum:
            Nth_run_file_generator(sbatchNum+1, dirName)
            script = './sbatch_' + dirName + '_restart_{0}.sh'.format(sbatchNum+1)
            os.system("sbatch " + script)
        else:
            print 'Error?!'