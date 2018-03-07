# -*- coding: utf-8 -*-
"""
Created on Tue Sep 19 15:01:53 2017

@author: kevin
"""

import os

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
                        if (not nameParts[-1] == 'archive'): 
                            os.remove(os.path.join('./',aFile))
    
