# -*- coding: utf-8 -*-
"""
Created on Tue Apr 10 12:39:21 2018

@author: Kevin
"""

import os
import shutil
D = '20D'
destination = '/mnt/e/Molecular_Dynamics_Filtration_Simulation/Python/100W_' + D + '_Test/'
source = '/mnt/e/Molecular_Dynamics_Filtration_Simulation/Python/100W_' + D + '/'
movedToList = []
movedFromList = []
for t in reversed(range(100)):
    trialFind = str(t)+'T'
    pathFind = '100W_' + D + '_' + trialFind
    if os.path.exists(os.path.join(source, pathFind)):
        for T in range(t):
            trialReplace = str(T) + 'T'
            pathReplace = '100W_' + D + '_' + trialReplace
            if not os.path.exists(os.path.join(source, pathReplace)) and not os.path.exists(os.path.join(destination, pathReplace)):
                shutil.move(os.path.join(source, pathFind), os.path.join(destination, pathReplace))
                for aFile in os.listdir(os.path.join(destination, pathReplace)):
                    newFileName = ''
                    fileParts = aFile.split('_')
                    for filePart in fileParts:
                        if trialFind in filePart:
                            newFileName = newFileName + trialReplace + '_'
                        elif '.' in filePart:
                            newFileName = newFileName + filePart
                        else:
                            newFileName = newFileName + filePart + '_'
                    shutil.move(os.path.join(destination, pathReplace, aFile), os.path.join(destination, pathReplace, newFileName))
                    movedFromList.append(t)
                    movedToList.append(T)
                break
movedList = []
for i in range(len(movedFromList)):
    movedList.append([movedFromList[i], movedToList[i]])
    
print(movedList)