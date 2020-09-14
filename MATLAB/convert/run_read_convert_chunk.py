# -*- coding: utf-8 -*-
"""
Created on Tue Sep 19 15:01:53 2017

@author: kevin
"""
import os
import shutil
ensembleDir = os.getcwd()
for dataDir in os.listdir(ensembleDir):
    if not (dataDir.endswith('.py') or dataDir.endswith('.pyc') or dataDir.endswith('.sh') or dataDir.endswith('.m')):
        os.chdir(os.path.join(ensembleDir, dataDir))
        dirParts = dataDir.split('/')
        simString = dirParts[-1]
        inputFile = open('input_'+simString+'.lmp','r')
        for line in inputFile:
            if line.startswith('compute argonChunks'):
                words = line.split(' ')
                nBinsY = int((float(words[18])-float(words[17]))/float(words[10]))
                nBinsX = int((float(words[14])-float(words[13]))/float(words[7]))
        shutil.copy2('/user/kgvansly/MATLAB/slurm_read_convert_chunk.sh',os.getcwd())
        shutil.copy2('/user/kgvansly/MATLAB/read_convert_chunk_file.m',os.getcwd())
        shutil.copy2('/user/kgvansly/MATLAB/chunkScalarConvert.m',os.getcwd())
        shutil.copy2('/user/kgvansly/MATLAB/chunkVectorConvert.m',os.getcwd())
        shutil.copy2('/user/kgvansly/MATLAB/read_chunk.m',os.getcwd())

        for chunkFile in os.listdir(os.getcwd()):
            if chunkFile.endswith('.chunk'):
                dataParts = chunkFile.split('_')
                if chunkFile.startswith('a'):
                    particleType = 'argon'
                    dataType = dataParts[1]
                elif chunkFile.startswith('i'):
                    particleType = 'impurity'
                    dataType = dataParts[1]
                else:
                    particleType = 'pure'
                    dataType = dataParts[0]
                myCommand = "sbatch  --job-name="+simString+"_"+particleType+"_"+dataType+" --output="+simString+"_"+particleType+"_"+dataType+".out --error="+simString+"_"+particleType+"_"+dataType+".err --export=simString="+simString+",nBinsX="+str(nBinsX)+",nBinsY="+str(nBinsY)+",particleType="+particleType+",dataType="+str(dataType)+" slurm_read_convert_chunk.sh"
                #myCommand = "sbatch  --job-name="+particleType+"_"+dataType+" --output="+particleType+"_"+dataType+".out --error="+particleType+"_"+dataType+".err --export=chunkFile="+chunkFile+" slurm_read_convert_chunk.sh"
                os.system(myCommand)
            else:
                continue
