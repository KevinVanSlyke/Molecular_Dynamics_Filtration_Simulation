#!/usr/bin/env python2
# -*- coding: utf-8 -*-
"""
Created on Tue Feb 19 14:04:54 2019

@author: Kevin
"""
def LAMMPS_sbatch_generator(poreWidth, poreSpacing, impurityDiameter, nTrials, timeout):
    
    dirName = '{0}W_{1}D_{2}F'.format(poreWidth, impurityDiameter, poreSpacing)
#    inputStartName = 'input_' + dirName + '_${SLURM_ARRAY_TASK_ID}T_r0.lmp'
#    inputRestartName = 'input_' + dirName + '_${SLURM_ARRAY_TASK_ID}T_r1.lmp'
    inputStartName = 'input_' + dirName + '_r0.lmp'
    inputRestartName = 'input_' + dirName + '_r1.lmp'
    sbatchStartName = 'sbatch_' + dirName + '_r0.sh'
    sbatchRestartName = 'sbatch_' + dirName + '_r1.sh'
    
    logStartName = 'log_' + dirName + '_${SLURM_ARRAY_TASK_ID}T_r0.lmp'
    logRestartName = 'log_' + dirName + '_${SLURM_ARRAY_TASK_ID}T_r1.lmp'
    
    """
        Rush CCR LAMMPS srun start/restart sbatch files
    """
    rushCores = 8
    mem = 1024
    rs = open(sbatchStartName,'w')
    rr = open(sbatchRestartName,'w')
    rushFiles = [rs, rr]
    for r in rushFiles:
        r.write('#!/bin/sh \n')
        r.write('#SBATCH --partition=general-compute \n')
        r.write('#SBATCH --time={0}:00:00 \n'.format(timeout))
        r.write('#SBATCH --nodes=1 \n')
        r.write('#SBATCH --ntasks-per-node={0} \n'.format(rushCores))
        r.write('#SBATCH --array=0-{0} \n'.format(nTrials-1))
        r.write('##SBATCH --constraint=IB \n')
        r.write('##SBATCH --mem-per-cpu={0} \n'.format(mem))
        r.write('# Memory per node specification is in MB. It is optional. \n')
        r.write('# The default limit is 3000MB per core. \n')
        r.write('#SBATCH --mail-user=kgvansly@buffalo.edu \n')
        r.write('#SBATCH --mail-type=ALL \n')
        r.write('#SBATCH --requeue \n')
        r.write('#Specifies that the job will be requeued after a node failure. \n')
        r.write('#The default is that the job will not be requeued. \n')
        
        
    rs.write('#SBATCH --job-name="' + dirName + '_r0" \n')
    rs.write('#SBATCH --output="output_' + dirName + '_%aT_r0.txt" \n')
    rs.write('#SBATCH --error="error_' + dirName + '_%aT_r0.txt" \n')

    rr.write('#SBATCH --job-name="' + dirName + '_r1" \n')
    rr.write('#SBATCH --output="output_' + dirName + '_%aT_r1.txt" \n')
    rr.write('#SBATCH --error="error_' + dirName + '_%aT_r1.txt" \n')
    
    for r in rushFiles:
        if r == rs:
            inputName = inputStartName
            logName = logStartName
        elif r == rr:
            inputName = inputRestartName
            logName = logRestartName
        r.write('echo "SLURM_JOBID="$SLURM_JOBID \n')
        r.write('echo "SLURM_JOB_NODELIST"=$SLURM_JOB_NODELIST \n')
        r.write('echo "SLURM_NNODES"=$SLURM_NNODES \n')
        r.write('echo "SLURMTMPDIR="$SLURMTMPDIR \n')
        r.write('echo "SLURM_ARRAYID="$SLURM_ARRAYID \n')
        r.write('echo "SLURM_ARRAY_JOB_ID"=$SLURM_ARRAY_JOB_ID \n')
        r.write('echo "SLURM_ARRAY_TASK_ID"=$SLURM_ARRAY_TASK_ID \n')
        r.write('echo "Submit directory = "$SLURM_SUBMIT_DIR \n')
    
        r.write("NPROCS=`srun --nodes=${SLURM_NNODES} bash -c 'hostname' | wc -l` \n")
        r.write('echo "NPROCS=$NPROCS" \n')
        
        r.write('module unload intel-mpi \n')
        r.write('module load intel-mpi/2017.0.1 \n')
        r.write('module load lammps \n')
        r.write('module list \n')
        r.write('ulimit -s unlimited \n')
    
        r.write('#The PMI library is necessary for srun \n')
        r.write('export I_MPI_PMI_LIBRARY=/usr/lib64/libpmi.so \n')
        r.write('echo "Working directory = $PWD" \n')
        
        r.write('random0=(32034 187340 111868 337650 322015 409460 604421 604389 360922 987764 361639 885505 318349 51238 185029 95693 1019097 1050500 1389878 1329148 1694023 450738 649587 1576767 687526 2448777 2267603 872114 1571442 510802 586044 2500056 2114133 701920 2576267 149604 2993347 3125615 1012478 1830849 2937697 1199530 1969080 1711041 534919 1774685 4535223 3487080 3921163 4732515 2522628 2038247 4864228 1239573 1564371 4000178 2165924 3624490 462794 3256784 3049488 828959 4082006 2176741 2038039 1927583 5491595 2039744 5181117 2255768 5209815 4164412 3504296 604443 6983105 3166878 3917997 7465642 1624192 129897 7997949 3658318 6941506 6048431 1714364 3840052 3644303 4768254 4505595 3485950 7377183 6623784 5512823 551945 4875190 1688655 6828804 8592166 1426838 8198655) \n')
        r.write('random1=(33773 43396 168003 49452 299880 11498 565711 410569 657377 105597 934913 367704 625916 963940 1092264 596018 1669819 325486 446274 49844 439025 268453 890468 262491 134786 2202102 1655180 119400 179294 1614946 2001110 2953920 1638227 1593492 2041022 3303287 413797 2527848 2358267 2750372 1784125 3136126 1426349 2380306 846224 3181111 1102061 4544548 2993278 1109908 1499451 2453782 4966428 1435847 130238 4416530 3648027 5737332 2976648 328442 5104126 5773319 1132273 3939499 2429990 5300329 4902318 6550989 6752478 594878 296309 1347553 3002663 5876875 972485 5882295 6268212 2677556 5497539 5712161 2377890 2207696 3159102 4434538 6975370 5527004 3809164 8120788 2131196 4359292 7573283 8568637 8647857 1223828 6816923 391322 3224177 7362190 9482521 7209717) \n')
        r.write('random2=(63820 62495 218069 388660 464762 596355 594814 692653 366832 234463 850199 441338 488548 1002287 1449345 10266 1541480 972529 391210 316021 161156 2190359 1210307 597986 1503072 11485 2305728 2523329 618770 1564034 434608 2418395 1748663 322565 1796686 3215077 817578 2643712 1767087 2220849 1859687 2885881 425755 4272411 3420246 2249620 1688721 955123 4301471 1486823 4258870 3719796 2734224 1874871 1163263 4210102 4372811 2812561 3773072 5954294 5348774 734193 2113664 5468250 5678815 956236 549996 2210414 529495 4850500 3754371 1262500 954419 976950 2027583 4394717 7020060 477917 3170869 1235534 3884356 4180200 1731219 6402417 5192083 946284 3671783 2510253 8720847 7281623 1984482 1131893 2864278 824698 805939 5322629 6763702 4329993 3932092 1751183) \n')
        r.write('random3=(4605 135949 13538 170621 33900 526130 250308 347772 70920 599631 240170 940560 777356 1194769 318145 1444451 43905 793093 138832 1699591 1234584 401877 893699 1170509 1102773 1308336 710519 2579798 2208858 460540 1411580 57820 3177194 310002 2969834 1681471 1827779 776795 3804178 2816992 305048 282730 638150 3094677 952834 4395940 4511175 717534 2516147 2732522 1358374 705240 2363982 4986895 1149239 4821022 2063261 2880969 1598547 57633 4111725 2096025 557399 822985 179643 2516649 6018522 1076872 3634786 3366087 4797660 1535848 3998114 460210 965899 1910497 2496167 3732038 53496 4931143 5064876 6428358 2161013 3821821 4899022 407904 6418054 3769815 3728841 1058067 7430573 3075819 5774593 8912524 5996353 323195 4125381 8126280 4580995 1288612) \n')
#        r.write('random4=(19339 194610 283902 137118 33176 312099 61074 605773 258572 235245 1099950 257083 34192 1331368 588470 228156 360315 910212 890104 1750558 1700984 1346837 436879 646333 2083044 1203577 1585808 180127 481450 2901184 1684988 1298364 1068844 2043993 3183593 2228850 3637488 3328760 1165047 3404832 467364 120506 2500301 3944840 732734 1832930 2159321 3919943 644777 3779862 4988402 4862147 833314 3938799 5434315 3600639 2389465 4243628 5589842 1634312 1915066 6157037 2118971 1791039 1352166 1736375 2038376 2453289 3790701 916489 2547662 2176620 1370330 6867736 2883238 6105554 7280086 7763989 3609160 6237568 1191664 1643449 4371147 4937899 5166702 374144 3815904 2483060 7442053 2384100 8322932 7197337 6473307 748884 2742450 8276023 4096254 6587049 1094476 4080763) \n')
#        r.write('random5=(76816 31182 50538 378602 497612 158189 657054 544217 423500 577075 979628 798527 583306 1222843 10882 121588 1239633 759898 704896 954739 325955 1705354 1353947 2205138 1838981 440942 981728 523780 1836436 2991398 2022883 1683843 1151629 640453 2550889 1086068 1531062 3338695 1374983 115675 2352956 447111 3357857 3718733 3701180 4571136 888875 3460145 1911982 4523644 807754 2663390 782217 793632 560810 4799350 5543947 3087829 5206445 2665025 808856 6144843 3271337 3698639 3540037 1514741 4253001 4883506 5851212 2239222 688323 2104716 4092633 5997781 1246548 5356209 1847273 4606974 1969154 5316181 1115548 7929493 1805205 4599467 995564 5368378 3033966 5272075 6467331 6742866 1991333 3390288 7513824 7560052 8383864 9387152 721461 6911816 9266547 2428374) \n')
        r.write('echo "srun -n $NPROCS lmp_mpi -nocite -screen none -in ' + inputName + ' -log ' + logName + ' -var id ${SLURM_ARRAY_TASK_ID} -var ran0 ${random0[${SLURM_ARRAY_TASK_ID}]} -var ran1 ${random1[${SLURM_ARRAY_TASK_ID}]} -var ran2 ${random2[${SLURM_ARRAY_TASK_ID}]} -var ran3 ${random3[${SLURM_ARRAY_TASK_ID}]}" \n')
        r.write('srun -n $NPROCS lmp_mpi -nocite -screen none -in ' + inputName + ' -log ' + logName + ' -var id ${SLURM_ARRAY_TASK_ID} -var ran0 ${random0[${SLURM_ARRAY_TASK_ID}]} -var ran1 ${random1[${SLURM_ARRAY_TASK_ID}]} -var ran2 ${random2[${SLURM_ARRAY_TASK_ID}]} -var ran3 ${random3[${SLURM_ARRAY_TASK_ID}]} \n')
        r.write('echo "Launch MPI LAMMPS air filtration simulation with srun" \n')

    
#        r.write('echo "Echo... srun -n $NPROCS lmp_mpi -nocite -screen none -in ' + inputName + ' -log ' + logName + '" \n')
#        r.write('srun -n $NPROCS lmp_mpi -nocite -screen none -in ' + inputName + ' -log ' + logName + ' \n')
    
        r.write('echo "All Done!"')
        r.close()

    return