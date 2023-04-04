# -*- coding: utf-8 -*-
"""
Created on Tue Apr 10 12:39:21 2018

@author: Kevin Van Slyke

A hard coded script to iteratively change file names 
"""

import os
import shutil

destination = '/mnt/e/Presentations/Molecular_Dynamics_Presentations/'
source = '/mnt/e/Presentations/Molecular_Dynamics_Presentations/'
movedToList = []
movedFromList = []
for aFile in os.listdir(source):
    if not aFile.startswith(2):
        fileParts = aFile.split('_')

        monthText = fileParts[0]
        if monthText == 'Jan':
            month = 1
        elif monthText == 'Feb':
            month = 2
        elif monthText == 'March':
            month = 3
        elif monthText == 'April':
            month = 4
        elif monthText == 'May':
            month = 5
        elif monthText == 'June':
            month = 6
        elif monthText == 'July':
            month = 7
        elif monthText == 'Aug':
            month = 8
        elif monthText == 'Sept':
            month = 9
        elif monthText == 'OCt':
            month = 10
        elif monthText == 'Nov':
            month = 11
        elif monthText == 'Dec':
            month = 12            

        dayText = fileParts[1]
        dayInd = 0
        for char in dayText:
            if char == 'r' or char == 't' or char == 'n':
                day = dayText[0:dayInd]
                break
            dayInd = dayInd +1

        year = fileParts[2]

        newFileName = year + '_' + month + '_' + day + fileParts[3:-1]

        shutil.move(os.path.join(destination, aFile), os.path.join(destination, newFileName))