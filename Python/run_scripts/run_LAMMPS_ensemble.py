# -*- coding: utf-8 -*-
"""
Created on Tue Sep 19 15:01:53 2017
@author: Kevin Van Slyke

Run all sbatch scripts for LAMMPS simulations
"""

import os
ensembleDir = os.getcwd()
for paramDir in os.listdir(ensembleDir):
    if not (paramDir.endswith('.py') or paramDir.endswith('.pyc')):
        os.chdir(os.path.join(ensembleDir, paramDir))
        script = 'slurm_' + paramDir + '.sh'
        os.system("sbatch " + script)