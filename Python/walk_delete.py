#!/usr/bin/env python2
# -*- coding: utf-8 -*-
"""
Created on Fri Jun 14 14:54:42 2019

@author: Kevin
"""
import os
localMachine = 1

executeChanges = 1
listChanges = 1

permanentlyDelete = 0

removeArchiveRestart = 0
removeRestartFiles = 1
removeErrorFiles = 1
removeOutputFiles = 1
removeTextFiles = 1
removeBackupFiles = 1
removeChunkFiles = 1

rootDir = '.'
for dirName, subdirList, fileList in os.walk(rootDir):
    for fName in fileList:
        if (not removeArchiveRestart and (fName.endswith('archive.restart') or fName.endswith('archive.rst'))): 
            print 'Keeping ' + os.path.join(dirName,fName) 
        elif (removeRestartFiles and (fName.endswith('.restart') or fName.endswith('.rst'))) \
        or (removeErrorFiles and (fName.endswith('.error') or fName.endswith('.err'))) \
        or (removeOutputFiles and (fName.endswith('.output') or fName.endswith('.out'))) \
        or (removeTextFiles and (fName.endswith('.text') or fName.endswith('.txt'))) \
        or (removeBackupFiles and (fName.endswith('.backup') or fName.endswith('.bak'))) \
        or (removeChunkFiles and (fName.endswith('.chunk'))):
            if permanentlyDelete:
                if listChanges:
                    print 'Removing ' + os.path.join(dirName,fName)
                if executeChanges:
                    os.remove(os.path.join(dirName,fName))
            elif localMachine:
                if listChanges:
                    print 'Moving ' + os.path.join(dirName,fName) + ' to ~/.local/share/Trash/files'
                if executeChanges:
                    os.system('gio trash ' + os.path.join(dirName,fName))
            else:
                if listChanges:
                    print 'Moving ' + os.path.join(dirName,fName) + ' to /scratch/kgvansly/trash'
                if executeChanges:
                    os.rename(os.path.join(dirName,fName), os.path.join('/scratch/kgvansly/trash',fName))

