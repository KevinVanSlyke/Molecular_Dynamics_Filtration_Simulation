#!/usr/bin/env python2
# -*- coding: utf-8 -*-
"""
Created on Tue Feb 19 14:04:54 2019
@author: Kevin
"""

def LAMMPS_nonarray_sbatch_generator(randomSeed, poreWidth, poreSpacing, impurityDiameter, nTrials, timeout):
    
    dirName = '{0}W_{1}D_{2}F'.format(poreWidth, impurityDiameter, poreSpacing)
    inputStartName = 'input_' + dirName + '_%aT_restart_0.lmp'
    inputRestartName = 'input_' + dirName + '_%aT_restart_1.lmp'

    sbatchStartName = 'sbatch_' + dirName + '_restart_0.sh'
    sbatchRestartName = 'sbatch_' + dirName + '_restart_1.sh'

    logStartName = 'log_' + dirName + '${SLURM_ARRAY_TASK_ID}T_restart_0.lmp'
    logRestartName = 'log_' + dirName + '${SLURM_ARRAY_TASK_ID}T_restart_1.lmp'
    
    """
        Rush CCR LAMMPS srun start/restart sbatch files
    """
    rushCores = 4
    mem = 1024
    rs = open(sbatchStartName,'w')
    rr = open(sbatchRestartName,'w')
    rushFiles = [rs, rr]
    for r in rushFiles:
        r.write('#!/bin/sh \n')
        r.write('#SBATCH --partition=general-compute \n')
        r.write('#SBATCH --time={0}:00:00 \n'.format(timeout))
        r.write('#SBATCH --nodes=1 \n')
        r.write('#SBATCH --ntasks-per-node={0} \n'.format(rushCores))
        r.write('#SBATCH --array=0-{0} \n'.format(nTrials))
        r.write('##SBATCH --constraint=IB \n')
        r.write('##SBATCH --mem-per-cpu={0} \n'.format(mem))
        r.write('# Memory per node specification is in MB. It is optional. \n')
        r.write('# The default limit is 3000MB per core. \n')
        r.write('#SBATCH --mail-user=kgvansly@buffalo.edu \n')
        r.write('#SBATCH --mail-type=END \n')
        r.write('##SBATCH --requeue \n')
        r.write('#Specifies that the job will be requeued after a node failure. \n')
        r.write('#The default is that the job will not be requeued. \n')
        
        
    rs.write('#SBATCH --job-name="r0_' + dirName + '" \n')
    rs.write('#SBATCH --output="output_' + dirName + '_%aT_restart_0.txt" \n')
    rs.write('#SBATCH --error="error_' + dirName + '_%aT_restart_0.txt" \n')

    rr.write('#SBATCH --job-name="r1_' + dirName + '_%aT" \n')
    rr.write('#SBATCH --output="output_' + dirName + '_%aT_restart_1.txt" \n')
    rr.write('#SBATCH --error="error_' + dirName + '_%aT_restart_1.txt" \n')
    
    for r in rushFiles:
        if r == rs:
            inputName = inputStartName
            logName = logStartName
        elif r == rr:
            inputName = inputRestartName
            logName = logRestartName
        r.write('echo "SLURM_JOBID="$SLURM_JOBID \n')
        r.write('echo "SLURM_JOB_NODELIST"=$SLURM_JOB_NODELIST \n')
        r.write('echo "SLURM_NNODES"=$SLURM_NNODES \n')
        r.write('echo "SLURMTMPDIR="$SLURMTMPDIR \n')
        r.write('echo "SLURM_ARRAYID="$SLURM_ARRAYID \n')
        r.write('echo "SLURM_ARRAY_JOB_ID"=$SLURM_ARRAY_JOB_ID \n')
        r.write('echo "SLURM_ARRAY_TASK_ID"=$SLURM_ARRAY_TASK_ID \n')
        r.write('echo "Submit directory = "$SLURM_SUBMIT_DIR \n')
    
        r.write("NPROCS=`srun --nodes=${SLURM_NNODES} bash -c 'hostname' |wc -l` \n")
        r.write('echo "NPROCS=$NPROCS" \n')
        
        r.write('module unload intel-mpi \n')
        r.write('module load intel-mpi/2017.0.1 \n')
        r.write('module load lammps \n')
        r.write('module list \n')
        r.write('ulimit -s unlimited \n')
    
        r.write('#The PMI library is necessary for srun \n')
        r.write('export I_MPI_PMI_LIBRARY=/usr/lib64/libpmi.so \n')
    
        r.write('echo "Working directory = $PWD" \n')
    
        r.write('echo "Launch MPI LAMMPS air filtration simulation with srun" \n')
    
        r.write('echo "Echo... srun -n $NPROCS lmp_mpi -nocite -screen none -in ' + inputName + ' -log ' + logName + '" \n')
        r.write('srun -n $NPROCS lmp_mpi -nocite -screen none -in ' + inputName + ' -log ' + logName + '" \n')
    
        r.write('echo "All Done!"')
        r.close()

    return