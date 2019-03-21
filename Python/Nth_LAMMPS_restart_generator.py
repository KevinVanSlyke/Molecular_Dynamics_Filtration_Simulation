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
timeout = 48 #hours

ensembleDir = os.getcwd()
for paramDir in os.listdir(ensembleDir):
    if not (paramDir.endswith('.py') or paramDir.endswith('.pyc')):
        for trialDir in os.listdir(os.path.join(ensembleDir,paramDir)):
            if not (trialDir.endswith('.py') or trialDir.endswith('.pyc')):
                os.chdir(os.path.join(ensembleDir,paramDir, trialDir))
                rushCores = 8
                mem = 256
                newRushRestartName = 'sbatch_' + trialDir + '_restart_' + str(N) + '.sh'
                r = open(newRushRestartName,'w')
                r.write('#!/bin/sh \n')
                r.write('#SBATCH --partition=general-compute \n')
                r.write('#SBATCH --time={0}:00:00 \n'.format(timeout))
                r.write('#SBATCH --nodes=1 \n')
                r.write('#SBATCH --ntasks-per-node={0} \n'.format(rushCores))
                r.write('##SBATCH --constraint=IB \n')
                r.write('#SBATCH --mem={0} \n'.format(mem))
                r.write('# Memory per node specification is in MB. It is optional. \n')
                r.write('# The default limit is 3000MB per core. \n')
                r.write('#SBATCH --mail-user=kgvansly@buffalo.edu \n')
                r.write('#SBATCH --mail-type=ALL \n')
                r.write('##SBATCH --requeue \n')
                r.write('#Specifies that the job will be requeued after a node failure. \n')
                r.write('#The default is that the job will not be requeued. \n')
        
        
                r.write('#SBATCH --job-name="r' + str(N) + '_' + trialDir + '" \n')
                r.write('#SBATCH --output="output_' + trialDir + '_restart_' + str(N) + '.txt" \n')
                r.write('#SBATCH --error="error_' + trialDir + '_restart_' + str(N) + '.txt" \n')
        
        
                r.write('echo "SLURM_JOBID=$SLURM_JOBID" \n')
                r.write('echo "SLURM_JOB_NODELIST=$SLURM_JOB_NODELIST" \n')
                r.write('echo "SLURM_NNODES=$SLURM_NNODES" \n')
                r.write('echo "SLURMTMPDIR=$SLURMTMPDIR" \n')
                r.write('echo "Submit directory = $SLURM_SUBMIT_DIR" \n')
        
                r.write("NPROCS=`srun --nodes=${SLURM_NNODES} bash -c 'hostname' |wc -l` \n")
                r.write('echo "NPROCS=$NPROCS" \n')
        
                r.write('module load intel-mpi/2017.0.1 \n')
                r.write('module load lammps \n')
                r.write('module list \n')
                r.write('ulimit -s unlimited \n')
        
                r.write('#The PMI library is necessary for srun \n')
                r.write('export I_MPI_PMI_LIBRARY=/usr/lib64/libpmi.so \n')
        
                r.write('echo "Working directory = $PWD" \n')
        
                r.write('echo "Launch MPI LAMMPS air filtration simulation with srun" \n')
        
                r.write('echo "Echo... srun -n $NPROCS lmp_mpi -nocite -screen none -in input_' + trialDir + '_restart_' + str(N) + '.lmp -log log_' + trialDir + '_restart_' + str(N) + '.lmp" \n')
                r.write('srun -n $NPROCS lmp_mpi -nocite -screen none -in input_' + trialDir + '_restart_' + str(N) + '.lmp -log log_' + trialDir + '_restart_' + str(N) + '.lmp \n')
         
                r.write('echo "All Done!" \n')
                r.close()
        
        
                copy = open('input_' + trialDir + '_restart_{0}.lmp'.format(N-1),'r')
                lines = copy.readlines()
                copy.close()
                write = open('input_' + trialDir + '_restart_' + str(N) + '.lmp','w')
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
                                        newFileName = parts[0]+'_'
                                    elif parts[j].endswith('.lmp'):
                                        newFileName = newFileName + str(N) + '.lmp'
                                    else:
                                        newFileName = newFileName + parts[j] + '_'
                                dumpParts[i] = newFileName
                            if (i > 0):
                                newLine = newLine + ' ' + dumpParts[i]
                        write.write(newLine + '\n')
                    elif line.startswith('variable movieTimes'):
                        newLine = 'variable movieTimes equal stride2({0},{1},{2},{3},{4},{5}) \n'.format(N*5*10**(6), (N+1)*5*10**(6)+100, 10**7, N*5*10**(6) + 100, N*5*10**(6) + 10**5, 100)
                        write.write(newLine)
                    else:
                        write.write(line)
