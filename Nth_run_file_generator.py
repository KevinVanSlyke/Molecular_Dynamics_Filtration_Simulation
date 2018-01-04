# -*- coding: utf-8 -*-
"""
Created on Fri Nov  3 07:56:30 2017

@author: Kevin
"""

import os

"""
Rush CCR LAMMPS srun start/restart sbatch files
"""
def Nth_run_file_generator(N):
        rushCores = 4
        mem = 512
        newRushRestartName = 'sbatch_restart_' + str(N) + '_' + dir + '.sh'
        r = open(newRushRestartName,'w')
        r.write('#!/bin/sh \n')
        r.write('#SBATCH --partition=general-compute \n')
        r.write('#SBATCH --time=12:00:00 \n')
        r.write('#SBATCH --nodes=1 \n')
        r.write('#SBATCH --ntasks-per-node={0} \n'.format(rushCores))
        r.write('##SBATCH --constraint=IB \n')
        r.write('##SBATCH --mem={0} \n'.format(mem))
        r.write('# Memory per node specification is in MB. It is optional. \n')
        r.write('# The default limit is 3000MB per core. \n')
        r.write('#SBATCH --mail-user=kgvansly@buffalo.edu \n')
        r.write('#SBATCH --mail-type=ALL \n')
        r.write('##SBATCH --requeue \n')
        r.write('#Specifies that the job will be requeued after a node failure. \n')
        r.write('#The default is that the job will not be requeued. \n')
            
        
        r.write('#SBATCH --job-name="' + str(N) + 'r' + dir + '" \n')
        r.write('#SBATCH --output="output_' + str(N) + 'r' + dir + '.txt" \n')
        r.write('#SBATCH --error="error_' + str(N) + 'r' + dir + '.txt" \n')
        
    
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
    
        r.write('echo "Echo... srun -n $NPROCS lmp_mpi -nocite -screen none -in input_' + dir + '_restart_' + str(N) + '.lmp -log log_' + dir + '_' + str(N) + '.lmp" \n')
        r.write('srun -n $NPROCS lmp_mpi -nocite -screen none in input_' + dir + '_restart_' + str(N) + '.lmp -log log_' + dir + '_' + str(N) + '.lmp \n')
    
        r.write('echo "All Done!"')
        r.close()
        
        
        copy = open('input_' + dir + '_restart_' + str(N-1) + '.lmp','r')
        lines = copy.readlines()
        copy.close()
        write = open('input_' + dir + '_restart_' + str(N) + '.lmp','w')
        for line in lines:
            if not line.startswith('dump'):
                write.write(line)
            else:
                dumpParts = line.split(' ')
                newLine = dumpParts[0]
                for i in xrange(len(dumpParts)):
                    if ((i > 0) and dumpParts[i].startswith('dump')):
                        fileParts = dumpParts[i]
                        parts = fileParts.split('_')
                        for j in xrange(len(parts)):
                            if j == 0:
                                newFileName = parts[0]+'_'
                            elif parts[j].startswith('restart'):
                                newFileName = newFileName + parts[j] + '_' + str(N) +'_'
                            elif parts[j].endswith('.lmp'):
                                newFileName = newFileName + parts[j]
                            else:
                                newFileName = newFileName + parts[j] + '_'
                        dumpParts[i] = newFileName
                    if (i > 0):
                        newLine = newLine + ' ' + dumpParts[i]
                write.write(newLine + '\n')
                
                return
                
                            