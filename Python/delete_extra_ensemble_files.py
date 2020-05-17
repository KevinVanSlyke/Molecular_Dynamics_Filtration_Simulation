# -*- coding: utf-8 -*-
"""
Created on Tue Sep 19 15:01:53 2017

@author: kevin
"""
flagMakeBackups = False
flagRemoveBackups = False
flagRemoveIntermediate = True
flagRemoveTerminalOutput = True
flagRemoveErrorLog = True
saveStepArchive = str(10000000)
import os
import shutil

ensembleDir = os.getcwd()
for paramDir in os.listdir(ensembleDir):
    if not (paramDir.endswith('.py') or paramDir.endswith('.pyc')):
        os.chdir(os.path.join(ensembleDir, paramDir))
        for aFile in os.listdir(os.path.join(ensembleDir, paramDir)):
            fileParts = aFile.split('.')
            ##If file IS a restart output and NOT a backup or for a specified timestep, delete said file
            if (fileParts[1] == 'rst'):
                nameParts = fileParts[0].split('_')
                if (nameParts[-1] == saveStepArchive):
                    continue
                elif (nameParts[-1] == 'archive') and flagMakeBackups:
                    shutil.copy2(fileParts[0] + '.rst', fileParts[0] + '.bak')
                elif flagRemoveIntermediate:
                    os.remove(os.path.join('./',aFile))
            if flagRemoveBackups and (fileParts[1].startswith('bak')):
                    os.remove(os.path.join('./',aFile))
            if flagRemoveTerminalOutput and (fileParts[0].startswith('out')):
                    os.remove(os.path.join('./',aFile))
            if flagRemoveErrorLog and (fileParts[0].startswith('err')):
                    os.remove(os.path.join('./',aFile))
