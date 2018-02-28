# -*- coding: utf-8 -*-
"""
Created on Tue Sep 19 15:01:53 2017

@author: kevin
"""

import os
topDir = os.getcwd()
for dir in os.listdir(topDir):
    if not (dir.endswith('.py') or dir.endswith('.pyc')):
        os.chdir(os.path.join(topDir,dir))
        os.system("python delete_ensemble_garbage_files.py")
