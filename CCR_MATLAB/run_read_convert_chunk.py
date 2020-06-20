# -*- coding: utf-8 -*-
"""
Created on Tue Sep 19 15:01:53 2017

@author: kevin
"""

import os
N = 0 #restart file number, 0 is initial start, 1 is pre-made, 2+ need to be created by Nth_LAMMPS_restart_generator.py
simString = '120W_1D_120F_100S'
nBinsX = 102
nBinsY = 100
dataDir = os.getcwd()
for dataFile in os.listdir(dataDir):
    if dataFile.endswith('.chunk'):
        dataParts = dataFile.split('_')
        if dataFile.startswith('a'):
            particleType = 'argon'
            dataType = dataParts[1]
        elif dataFile.startswith('i'):
            particleType = 'impurity'
            dataType = dataParts[1]
        else:
            particleType = 'pure'
            dataType = dataParts[0]
        myCommand = "sbatch  --job-name="+simString+"_"+particleType+"_"+dataType+" --output="+simString+"_"+particleType+"_"+dataType+".out --error="+simString+"_"+particleType+"_"+dataType+".err --export=simString="+simString+",nBinsX="+str(nBinsX)+",nBinsY="+str(nBinsY)+",particleType="+particleType+",dataType="+str(dataType)+" slurm_read_convert_chunk.sh"
        #myCommand = "sbatch  --job-name="+particleType+"_"+dataType+" --output="+particleType+"_"+dataType+".out --error="+particleType+"_"+dataType+".err --export=chunkFile="+dataFile+" slurm_read_convert_chunk.sh"
        os.system(myCommand)
    else:
        continue
