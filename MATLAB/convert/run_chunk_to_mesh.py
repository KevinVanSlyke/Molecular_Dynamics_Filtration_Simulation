# -*- coding: utf-8 -*-
"""
Created on Tue Sep 19 15:01:53 2017

@author: kevin
"""
import os
import shutil
debug = 1
ensembleDir = os.getcwd()
for dataDir in os.listdir(ensembleDir):
    if not (dataDir.endswith('.py') or dataDir.endswith('.pyc') or dataDir.endswith('.sh') or dataDir.endswith('.m')):
        os.chdir(os.path.join(ensembleDir, dataDir))
        dirParts = dataDir.split('/')
        simString = dirParts[-1]

        nTrials = 0
        for files in os.listdir(os.getcwd()):
            if files.startswith('argon_vcm'):
                trialString = files.split('.')
                fileParts = trialString[0].split('_')
                trialPart = fileParts[-1].split('T')
                if debug:
                    print('file = '+str(files))
                    print('trialString = '+str(trialString))
                    print('fileParts = '+str(fileParts))
                    print('trialPart = '+str(trialPart))
                if int(trialPart[0]) > nTrials:
                    nTrials = int(trialPart[0])
        nTrials = nTrials + 1
        if debug:
            print('nTrials = '+str(nTrials))

        inputFile = open('input_'+simString+'.lmp', 'r')
        for line in inputFile:
            if line.startswith('compute argonChunks'):
                words = line.split(' ')
                nBinsY = int((float(words[18]) - float(words[17])) / float(words[10]))
                nBinsX = int((float(words[14]) - float(words[13])) / float(words[7]))
        if debug:
             print('nBinsX = '+str(nBinsX)+', nBinsY = '+str(nBinsY))
        if not debug:
            shutil.copy2('/user/kgvansly/MATLAB/slurm_chunk_to_mesh.sh',os.getcwd())
            shutil.copy2('/user/kgvansly/MATLAB/spmd_chunk_wrapper.m',os.getcwd())
            shutil.copy2('/user/kgvansly/MATLAB/chunk_to_mesh.m',os.getcwd())

        for trialIndex in range(nTrials):
            atomType = 'argon'
            jobName = simString+'_'+atomType+'_'+str(trialIndex)+'T'
            aCommand = "sbatch  --job-name="+jobName+" --output="+jobName+".out --error="+jobName+".err --export=simString="+simString+",atomType="+atomType+",trialIndex="+str(trialIndex)+",nBinsX="+str(nBinsX)+",nBinsY="+str(nBinsY)+" slurm_chunk_to_mesh.sh"
            if debug:
                print(aCommand)
            else:
                os.system(aCommand)
            if not simString[1].startswith('1'):
                atomType = 'impurity'
                jobName = simString+'_'+atomType+'_'+str(trialIndex)+'T'
                iCommand = "sbatch  --job-name="+jobName+" --output="+jobName+".out --error="+jobName+".err --export=simString="+simString+",atomType="+atomType+",trialIndex="+str(trialIndex)+",nBinsX="+str(nBinsX)+",nBinsY="+str(nBinsY)+" slurm_chunk_to_mesh.sh"
                if debug:
                    print(iCommand)
                else:
                    os.system(iCommand)
        if debug:
            break