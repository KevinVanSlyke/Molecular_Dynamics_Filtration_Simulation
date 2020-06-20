#!/bin/bash
#SBATCH --time=72:00:00
#SBATCH --nodes=1
#SBATCH --tasks-per-node=1
#SBATCH --mail-user=kgvansly@buffalo.edu
#SBATCH --mail-type=END
#SBATCH --job-name=tempA
#SBATCH --output=tempA.out
#SBATCH --error=tempA.err
#SBATCH --partition=general-compute

module load matlab
ulimit -s unlimited

# adjusting home directory reportedly yields a 10x MatLab speedup
export HOME=$SLURMTMPDIR

# adjust temporary directory
export TMP=$SLURMTMPDIR
matlab -nodisplay -r "ccr_read_convert_chunk_file($simString, $nBinsX, $nBinsY, 'argon', 'temp')"
