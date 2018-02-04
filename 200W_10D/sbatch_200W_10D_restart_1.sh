#!/bin/sh 
#SBATCH --partition=general-compute 
#SBATCH --time=12:00:00 
#SBATCH --nodes=1 
#SBATCH --ntasks-per-node=4 
##SBATCH --constraint=IB 
#SBATCH --mem=256 
# Memory per node specification is in MB. It is optional. 
# The default limit is 3000MB per core. 
#SBATCH --mail-user=kgvansly@buffalo.edu 
#SBATCH --mail-type=ALL 
##SBATCH --requeue 
#Specifies that the job will be requeued after a node failure. 
#The default is that the job will not be requeued. 
#SBATCH --job-name="r200W_10D" 
#SBATCH --output="output_r200W_10D.txt" 
#SBATCH --error="error_r200W_10D.txt" 
echo "SLURM_JOBID=$SLURM_JOBID" 
echo "SLURM_JOB_NODELIST=$SLURM_JOB_NODELIST" 
echo "SLURM_NNODES=$SLURM_NNODES" 
echo "SLURMTMPDIR=$SLURMTMPDIR" 
echo "Submit directory = $SLURM_SUBMIT_DIR" 
NPROCS=`srun --nodes=${SLURM_NNODES} bash -c 'hostname' |wc -l` 
echo "NPROCS=$NPROCS" 
module load intel-mpi/2017.0.1 
module load lammps 
module list 
ulimit -s unlimited 
#The PMI library is necessary for srun 
export I_MPI_PMI_LIBRARY=/usr/lib64/libpmi.so 
echo "Working directory = $PWD" 
echo "Launch MPI LAMMPS air filtration simulation with srun" 
echo "Echo... srun -n $NPROCS lmp_mpi -nocite -screen none -in input_200W_10D_restart_1.lmp -log log_200W_10D_restart.lmp" 
srun -n $NPROCS lmp_mpi -nocite -screen none -in input_200W_10D_restart_1.lmp -log log_200W_10D_restart.lmp 
echo "All Done!"