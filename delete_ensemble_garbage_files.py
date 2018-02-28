# -*- coding: utf-8 -*-
"""
Created on Tue Sep 19 15:01:53 2017

@author: kevin
"""

import os

topDir = os.getcwd()
for dir in os.listdir(topDir):
    if not dir.endswith('.py') and not dir.endswith('.pyc'):
        os.chdir(os.path.join(topDir,dir))
        for aFile in os.listdir(os.path.join(topDir,dir)):
            fileParts = aFile.split('.')            
            if (fileParts[1] == 'rst'):
                nameParts = fileParts[0].split('_')
                if (not nameParts[-1] == 'archive'):
                    os.remove(os.path.join('./',aFile))

