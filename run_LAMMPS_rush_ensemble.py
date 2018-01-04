# -*- coding: utf-8 -*-
"""
Created on Tue Sep 19 15:01:53 2017

@author: kevin
"""

import os
from Nth_run_file_generator import Nth_run_file_generator
topDir = os.getcwd()
for dir in os.listdir(topDir):
    if not (dir.endswith('.py') or dir.endswith('.pyc')):
        trialDir = os.path.join(topDir,dir)
        os.chdir(trialDir)
        sbatchNum = 1
        outputNum = -1
        started = False
        for files in os.listdir(trialDir):
            if files.startswith('./sbatch_'):
                sbatchFileParts = files.split('_')
                if sbatchFileParts[-1] != 'start':
                    num = int(sbatchFileParts[-1])
                    if num >= sbatchNum:
                        sbatchNum = num
                        sbatchFile = files
            if files.startswith('./output_'):
                outputFileParts = files.split('_')
                if outputFileParts[-1] != 'start':
                    num = int(outputFileParts[-1])
                    if num > outputNum:
                        output = open(files,'r')
                        lines = output.readlines()
                        if lines[-1] == 'All Done!':
                            outputNum = num
                            outputFile = files
                        output.close()
                else:
                    output = open(files,'r')
                    lines = output.readlines()
                    if lines[-1] == 'All Done!':
                        if outputNum < 0:
                            outputNum = 0
        if started == False:
            script = './sbatch_' + dir + '_start.sh'
            os.system("sbatch " + script)
        elif sbatchNum >= 1 and outputNum == (sbatchNum-1):
            script = './sbatch_' + dir + '_restart_{0}.sh'.format(sbatchNum)
            os.system("sbatch " + script)
        elif sbatchNum == outputNum:
            Nth_run_file_generator(sbatchNum+1)
            script = './sbatch_' + dir + '_restart_{0}.sh'.format(sbatchNum+1)
            os.system("sbatch " + script)
        else:
            print 'Error?!'