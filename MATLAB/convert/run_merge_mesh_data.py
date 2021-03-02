# -*- coding: utf-8 -*-
"""
Created on Tue Sep 19 15:01:53 2017

@author: kevin
"""
import os
import shutil
ensembleDir = os.getcwd()
for dataDir in os.listdir(ensembleDir):
    if os.path.isdir(os.path.join(ensembleDir, dataDir)):
        os.chdir(os.path.join(ensembleDir, dataDir))
        dirParts = dataDir.split('/')
        simString = dirParts[-1]
        shutil.copy2('/user/kgvansly/MATLAB/slurm_merge_mesh_data.sh',os.getcwd())
        shutil.copy2('/user/kgvansly/MATLAB/merge_mesh_data.m',os.getcwd())
        jobName = simString+'_Merge'
        myCommand = "sbatch  --job-name="+simString+" --output="+simString+".out --error="+simString+".err slurm_merge_mesh_data.sh"
        os.system(myCommand)
    else:
        continue
