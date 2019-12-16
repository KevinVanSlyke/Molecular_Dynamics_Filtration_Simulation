#!/bin/sh
#SBATCH --partition=general-compute
#SBATCH --time=24:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --array=0-4
##SBATCH --constraint=CPU-L5520
##SBATCH --mem-per-cpu=1024
#SBATCH --mail-user=kgvansly@buffalo.edu
#SBATCH --mail-type=ALL
#SBATCH --requeue
#SBATCH --job-name="m10W_1D_120F_100S_r0"
#SBATCH --output="m10W_1D_120F_100S_%aT_r0.out"
#SBATCH --error="m10W_1D_120F_100S_%aT_r0.err"

echo "SLURM_JOBID="$SLURM_JOBID
echo "SLURM_JOB_NODELIST"=$SLURM_JOB_NODELIST
echo "SLURM_NNODES"=$SLURM_NNODES
echo "SLURMTMPDIR="$SLURMTMPDIR
echo "SLURM_ARRAYID="$SLURM_ARRAYID
echo "SLURM_ARRAY_JOB_ID"=$SLURM_ARRAY_JOB_ID
echo "SLURM_ARRAY_TASK_ID"=$SLURM_ARRAY_TASK_ID
echo "Submit directory = "$SLURM_SUBMIT_DIR
NPROCS=`srun --nodes=${SLURM_NNODES} bash -c 'hostname' | wc -l`
echo "NPROCS=$NPROCS"

#The openmpi module is necessary for lammps
module load matlab
ulimit -s unlimited
echo "Working directory = $PWD"

# adjusting home directory reportedly yields a 10x MatLab speedup
export HOME=$SLURMTMPDIR

# adjust temporary directory
export TMP=$SLURMTMPDIR

echo "Launch chunk analysis of LAMMPS air filtration simulation with matlab"
echo "matlab -nodisplay -r "read_chunk_vcm('vcm_120W_1D_120F_100S_${SLURM_ARRAY_TASK_ID}T_r0.chunk')""
matlab -nodisplay -r "read_chunk_vcm('vcm_120W_1D_120F_100S_${SLURM_ARRAY_TASK_ID}T_r0.chunk')"

#srun --mpi=pmi2 -n $NPROCS lmp_mpi -nocite -screen none -in input_10W_1D_1000F_r0.lmp -log thermo_10W_1D_1000F_${SLURM_ARRAY_TASK_ID}T_r0.log -var id ${SLURM_ARRAY_TASK_ID} -var ran0 ${random0[${SLURM_ARRAY_TASK_ID}]} -var ran1 ${random1[${SLURM_ARRAY_TASK_ID}]} -var ran2 ${random2[${SLURM_ARRAY_TASK_ID}]} -var ran3 ${random3[${SLURM_ARRAY_TASK_ID}]}
echo "All Done!"
