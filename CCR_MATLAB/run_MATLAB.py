# -*- coding: utf-8 -*-
"""
Created on Tue Sep 19 15:01:53 2017

@author: kevin
"""

import os
import string
N = 0 #restart file number, 0 is initial start, 1 is pre-made, 2+ need to be created by Nth_LAMMPS_restart_generator.py
simString = '120W_600L_5D'
nBinsX = 500
nBinsY = 100
dataDir = os.getcwd()
for dataFile in os.listdir(dataDir):
    if dataFile.endswith('.sh'):
        dataParts = dataFile.split('_')
        if dataFile.startswith('a'):
            particleType = 'argon'
            dataType = dataParts(0)
        elif dataFile.startswith('i'):
            particleType = 'impurity'
            dataType = dataParts(0)
        else:
            particleType = 'none'
            dataType = dataParts(1)
        myCommand = string.join("sbatch --export=simString=",simString,"nBinsX=",nBinsX,"nBinsY=",nBinsY,"particleType=",particleType,"dataType=",str(dataType)," slurm_read_convert_chunk.sh")
        os.system(myCommand)
