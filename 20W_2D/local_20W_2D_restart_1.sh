#!/bin/bash 
echo "Launching molecular dynamics filtration simulation(s)..." 
echo "Running mpirun -n 2 /usr/local/LAMMPS/src/lmp_auto -nocite -in input_20W_2D_restart_1.lmp -log log_20W_2D_restart.lmp" 
mpirun -n 2 /usr/local/LAMMPS/src/lmp_auto -nocite -in input_20W_2D_restart_1.lmp -log log_20W_2D_restart.lmp 
echo "All Done!" 
