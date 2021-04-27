#!/bin/bash
#SBATCH --time=12:00:00
#SBATCH --nodes=1
#SBATCH --tasks-per-node=4
##SBATCH --mem=6000
#SBATCH --mail-user=kgvansly@buffalo.edu
#SBATCH --mail-type=END
##SBATCH --job-name=${particleType}_${dataType}
##SBATCH --output=${particleType}_${dataType}.out
##SBATCH --error=${particleType}_${dataType}.err
#SBATCH --partition=general-compute

module load matlab
ulimit -s unlimited

# adjusting home directory reportedly yields a 10x MatLab speedup
export HOME=$SLURMTMPDIR

# adjust temporary directory
export TMP=$SLURMTMPDIR
# echo -e "simString=${simString} \n"
echo -e "simString=${simString} \n"
echo -e "atomType=${atomType} \n"
echo -e "trialIndex=${trialIndex} \n"
echo -e "nBinsX=${nBinsX} \n"
echo -e "nBinsY=${nBinsY} \n"
echo -e "nWorkers=$SLURM_NTASKS \n"
echo -e "debug=${debug} \n"
# echo -e "particleType=${particleType} \n"
# echo -e "dataType=${dataType} \n"
# echo -e "trialIndex=${trialIndex} \n"

#echo -e 'matlab -nodisplay -r "addpath(~/MATLAB)"'
#matlab -nodisplay -r "addpath('~/MATLAB')"

echo -e 'matlab -nodisplay -r "spmd_chunk_wrapper(${simString}, ${atomType}, $SLURM_NTASKS, ${trialIndex}, ${nBinsX}, ${nBinsY}, ${debug})"'
matlab -nodisplay -r "spmd_chunk_wrapper('${simString}', '${atomType}', '$SLURM_NTASKS', '${trialIndex}', '${nBinsX}', '${nBinsY}', '${debug}')"
