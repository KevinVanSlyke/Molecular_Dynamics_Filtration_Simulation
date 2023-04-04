LAMMPS based MD particle filtration simulation. 

Project includes:

./Python/ includes all input generation, job submission, and file manipulation scripts
	./Python/input_generation/ includes all scripts to generate input/sbatch files for LAMMPS software
	./Python/run_scripts/ includes scripts to run shell scripts to start simulation/analysis
	./Python/file_manipulation/ includes various scripts to manipulate files

#==========================================================================

./Shell/ includes scripts to submit MATLAB analysis as slurm jobs on CCR

#==========================================================================

./MATLAB/ includes all analysis scripts
	./MATLAB/therm_analysis_plots/ functions used to analyze the LAMMPS therm output to determine frequency and decay constant as function of input parameters 
	./MATLAB/variables_formatting/ functions used to get/format simulation parameters and variables
	./MATLAB/fit_functions/ simple definitions of functions used in non-linear least squares fitting

	./MATLAB/mesh_chunk_convert_stats/ functions used to convert LAMMPS chunk data as a mesh of cells
	./MATLAB/mesh_various_analysis_plots/ functions for surface/quiver, thermo region comparison and other tiled plots from mesh data
	./MATLAB/mesh_velocity_outflow/ functions to calculate outflow angles from meshed center of mass velocity in outflow region
	./MATLAB/mesh_counts_outflow/ functions to calculate outflow angles geometrically from meshed atom counts in outflow region
	./MATLAB/mesh_curl_analysis/ functions to calculate curl from meshed atom count and velocity

	./MATLAB/dump_particle_analysis/ functions to analyze LAMMPS dump files for particle transport through orifice

	./MATLAB/scratch/ is a directory for temprorary/in progress functions which need to be cleaned/organized and single use scripts
	./MATLAB/diagrams/ functions to plot simple diagrams

	#--------------------------------------------------------------------------

	./MATLAB/therm_LAMMPS/ as well as the LAMMPS software used to run the simulations are created by other authors at SANDIA National Labs.
	./MATLAB/plot_utilities/ developed by other authors on MATLAB repository
