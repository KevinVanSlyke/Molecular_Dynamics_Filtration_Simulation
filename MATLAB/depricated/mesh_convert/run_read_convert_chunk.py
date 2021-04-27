# -*- coding: utf-8 -*-
"""
Created on Tue Sep 19 15:01:53 2017

@author: kevin
"""
import os
import shutil
ensembleDir = os.getCWD()
for dataDir in os.listDir(ensembleDir):
    if not (dataDir.endsWith('.py') or dataDir.endsWith('.pyc') or dataDir.endsWith('.sh') or dataDir.endsWith('.m')):
        os.chDir(os.path.join(ensembleDir, dataDir))
        dirParts = dataDir.split('/')
        simString = dirParts[-1]
        inputFile = open('input_'+simString+'.lmp','r')
        for line in inputFile:
            if line.startsWith('compute argonChunks'):
                words = line.split(' ')
                nBinsY = int((float(words[18])-float(words[17]))/float(words[10]))
                nBinsX = int((float(words[14])-float(words[13]))/float(words[7]))
        shutil.copy2('/user/kgvansly/MATLAB/slurm_read_convert_chunk.sh',os.getCWD())
        shutil.copy2('/user/kgvansly/MATLAB/read_convert_chunk_file.m',os.getCWD())
        shutil.copy2('/user/kgvansly/MATLAB/chunkScalarConvert.m',os.getCWD())
        shutil.copy2('/user/kgvansly/MATLAB/chunkVectorConvert.m',os.getCWD())
        shutil.copy2('/user/kgvansly/MATLAB/read_chunk.m',os.getCWD())

        for chunkFile in os.listdir(os.getCWD()):
            if chunkFile.endswith('.chunk'):
                # dataParts = chunkFile.split('_')
                # particleType = dataParts[0]
                # dataType = dataParts[1]
                # if dataParts[-1].endswith('T.chunk'):
                #     trialIndex = dataParts[-1][0]
                # else:
                #     trialIndex = 0
                jobName = chunkFile[0:-6]
                # myCommand = "sbatch  --job-name="+jobName+" --output="+jobName+".out --error="+jobName+".err --export=simString="+simString+",nBinsX="+str(nBinsX)+",nBinsY="+str(nBinsY)+",particleType="+particleType+",dataType="+str(dataType)+",trialIndex="+str(trialIndex)+" slurm_read_convert_chunk.sh"
                myCommand = "sbatch  --job-name="+jobName+" --output="+jobName+".out --error="+jobName+".err --export=chunkFile="+chunkFile+",nBinsX="+str(nBinsX)+",nBinsY="+str(nBinsY)+" slurm_chunk_to_mesh.sh"
                os.system(myCommand)
            else:
                continue
