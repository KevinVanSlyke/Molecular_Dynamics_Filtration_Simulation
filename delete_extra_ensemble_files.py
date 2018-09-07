# -*- coding: utf-8 -*-
"""
Created on Tue Sep 19 15:01:53 2017

@author: kevin
"""
flagMakeBackups = True
flagRemoveBackups = False
flagCopyBackups = True
flagRemoveIntermediate = False
copyTarget = str(25000000)
import os
if flagMakeBackups:
    import shutil

ensembleDir = os.getcwd()
for paramDir in os.listdir(ensembleDir):
    if not (paramDir.endswith('.py') or paramDir.endswith('.pyc')):
        for trialDir in os.listdir(os.path.join(ensembleDir,paramDir)):
            if not (trialDir.endswith('.py') or trialDir.endswith('.pyc')):
                os.chdir(os.path.join(ensembleDir, paramDir, trialDir))
                for aFile in os.listdir(os.path.join(ensembleDir, paramDir, trialDir)):
                    fileParts = aFile.split('.')
                    ##If file IS a restart output and NOT a backup or for a specified timestep, delete said file
                    if (fileParts[1] == 'rst'):
                        nameParts = fileParts[0].split('_')
                        if (nameParts[-1] == copyTarget) and flagCopyBackups:
                            copyName = '_'.join(nameParts[0:-1])
                            shutil.copy2(fileParts[0] + '.rst', copyName + '.rst')
                            if flagCopyBackups:
                                shutil.copy2(fileParts[0] + '.rst', copyName + '.bak')
                            if flagRemoveIntermediate:
                                os.remove(os.path.join('./',aFile))
                        elif (not nameParts[-1] == 'archive') and flagRemoveIntermediate:
                            os.remove(os.path.join('./',aFile))
                        elif (nameParts[-1] == 'archive') and flagMakeBackups and (not flagCopyBackups):
                            shutil.copy2(fileParts[0] + '.rst', fileParts[0] + '.bak' )
                    elif flagRemoveBackups:
                        if (fileParts[1].startswith('bak')):
                            os.remove(os.path.join('./',aFile))
