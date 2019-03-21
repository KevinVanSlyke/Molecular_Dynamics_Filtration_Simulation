# -*- coding: utf-8 -*-
"""
Created on Tue Sep 19 15:01:53 2017

@author: kevin
"""

import os
N = 0 #restart file number, 0 is initial start, 1 is pre-made, 2+ need to be created by Nth_LAMMPS_restart_generator.py
ensembleDir = os.getcwd()
for paramDir in os.listdir(ensembleDir):
    if not (paramDir.endswith('.py') or paramDir.endswith('.pyc')):
        os.chdir(os.path.join(ensembleDir, paramDir))
        script = 'sbatch_' + paramDir + '_r' + str(N) + '.sh'
        os.system("sbatch " + script)