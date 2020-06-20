#!/bin/bash
#SBATCH --time=72:00:00
#SBATCH --nodes=1
#SBATCH --tasks-per-node=1
#SBATCH --mem=6000
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
echo -e "simString=${simString} \n"
echo -e "nBinsX=${nBinsX} \n"
echo -e "nBinsY=${nBinsY} \n"
echo -e "particleType=${particleType} \n"
echo -e "dataType=${dataType} \n"

#echo -e 'matlab -nodisplay -r "addpath(~/MATLAB)"'
#matlab -nodisplay -r "addpath('~/MATLAB')"

echo -e 'matlab -nodisplay -r "ccr_read_convert_chunk_file(${simString}, ${nBinsX}, ${nBinsY}, ${particleType}, ${dataType})"'
matlab -nodisplay -r "ccr_read_convert_chunk_file('${simString}', ${nBinsX}, ${nBinsY}, '${particleType}', '${dataType}')"
