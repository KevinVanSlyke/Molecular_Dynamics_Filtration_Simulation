# -*- coding: utf-8 -*-
"""
Created on Tue Sep 19 15:01:53 2017

@author: kevin
"""

import os

topDir = os.getcwd()
for dir in os.listdir(topDir):
    if not dir.endswith('.py'):
        os.chdir(os.path.join(topDir,dir))
        for aFile in os.listdir(os.path.join(topDir,dir)):
            nameParts = aFile.split('_')
#            if (nameParts[0] == 'dump') and (nameParts[2] == 'tracer'):
#                os.remove(os.path.join('./',aFile))
#            if (nameParts[0] == 'dump') and (nameParts[3] == 'tracer'):
#                os.remove(os.path.join('./',aFile))
#            if (nameParts[0] == 'dump') and (nameParts[2].startswith('slice')):
#                os.remove(os.path.join('./',aFile))
#            if (nameParts[0] == 'dump') and (nameParts[3].startswith('slice')):
#                os.remove(os.path.join('./',aFile))
#            if (nameParts[0] == 'backup'):
#                os.remove(os.path.join('./',aFile))               
            if (nameParts[0] == 'archive') and (not nameParts[1].startswith(dir)):
                os.remove(os.path.join('./',aFile))
            if (nameParts[0] == 'error'):
                os.remove(os.path.join('./',aFile))
            if (aFile.endswith('.png')):
                os.remove(os.path.join('./',aFile))

