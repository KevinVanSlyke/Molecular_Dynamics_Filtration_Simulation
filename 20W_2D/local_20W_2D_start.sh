#!/bin/bash 
echo "Launching molecular dynamics filtration simulation(s)..." 
echo "Running mpirun -n 2 /usr/local/LAMMPS/src/lmp_auto -nocite -in input_20W_2D_start.lmp -log log_20W_2D_start.lmp" 
mpirun -n 2 /usr/local/LAMMPS/src/lmp_auto -nocite -in input_20W_2D_start.lmp -log log_20W_2D_start.lmp 
echo "All Done!" 
