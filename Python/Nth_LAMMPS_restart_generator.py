# -*- coding: utf-8 -*-
"""
Created on Fri Nov  3 07:56:30 2017

@author: Kevin
"""

import os

"""
Create new Rush CCR LAMMPS sbatch files for Nth restart
"""
N = 2 #restart file number, 0 is initial start, 1 is pre-made and copied with alterations by this script
ensembleDir = os.getcwd()
for paramDir in os.listdir(ensembleDir):
    if not (paramDir.endswith('.py') or paramDir.endswith('.pyc')):
            os.chdir(os.path.join(ensembleDir,paramDir))
            dirName = str(paramDir)
            inputCopyName = 'input_' + dirName + '_r' + str(N-1) + '.lmp'
            inputName = 'input_' + dirName + '_r' + str(N) + '.lmp'
            sbatchCopyName = 'sbatch_' + dirName + '_r' + str(N-1) + '.sh'
            sbatchName = 'sbatch_' + dirName + '_r' + str(N) + '.sh'
            logName = 'log_' + dirName + '_${SLURM_ARRAY_TASK_ID}T_r' + str(N) + '.lmp'
            jobName = dirName + '_r' + str(N)
            outputName = 'output_' + dirName + '_%aT_r' + str(N) + '.txt'
            errorName = 'error_' + dirName + '_%aT_r' + str(N) + '.txt'
            
            sbatchCopy = open(sbatchCopyName,'r')
            lines = sbatchCopy.readlines()
            sbatchCopy.close()
            sbatch = open(sbatchName,'w')
            for line in lines:
                if line.startswith('#SBATCH --job-name="'):
                   sbatch.write('#SBATCH --job-name="' + jobName + '" \n')
                elif line.startswith('#SBATCH --output="'):
                   sbatch.write('#SBATCH --output="' + outputName + '" \n')
                elif line.startswith('#SBATCH --error="'):
                   sbatch.write('#SBATCH --error="' + errorName + '" \n')
                elif line.startswith('echo "srun -n'):
                   sbatch.write('echo "srun -n $NPROCS lmp_mpi -nocite -screen none -in ' + inputName + ' -log ' + logName + ' -var id ${SLURM_ARRAY_TASK_ID} " \n')
                elif line.startswith('srun -n'):
                   sbatch.write('srun -n $NPROCS lmp_mpi -nocite -screen none -in ' + inputName + ' -log ' + logName + ' -var id ${SLURM_ARRAY_TASK_ID}  \n')
                else:
                   sbatch.write(line)

            inputCopy = open(inputCopyName,'r')
            lines = inputCopy.readlines()
            inputCopy.close()
            inputFile = open(inputName,'w')
            for line in lines:
                if line.startswith('dump'):
                    dumpParts = line.split(' ')
                    newLine = dumpParts[0]
                    for i in xrange(len(dumpParts)):
                        if ((i > 0) and dumpParts[i].startswith('dump')):
                            fileParts = dumpParts[i]
                            parts = fileParts.split('_')
                            for j in xrange(len(parts)):
                                if j == 0:
                                    newFileName = parts[0] + '_'
                                elif parts[j].endswith('.lmp'):
                                    newFileName = newFileName + str(N) + '.lmp'
                                else:
                                    newFileName = newFileName + parts[j] + '_'
                            dumpParts[i] = newFileName
                        if (i > 0):
                            newLine = newLine + ' ' + dumpParts[i]
                    inputFile.write(newLine + '\n')
                elif line.startswith():
                    inputFile.write('fix chunksAvgVCM gas ave/time {0} {1} {2} c_chunkVCM[*] file avg_vcm_chunks_'.format(1000, 1, 1000) + dirName + '_r' + str(N) +'.lmp mode vector \n')
                elif line.startswith('variable movieTimes'):
                    inputFile.write('variable movieTimes equal stride2({0},{1},{2},{3},{4},{5}) \n'.format(N*5*10**(6), (N+1)*5*10**(6)+100, 10**7, N*5*10**(6) + 100, N*5*10**(6) + 10**5, 100))
                else:
                    inputFile.write(line)
