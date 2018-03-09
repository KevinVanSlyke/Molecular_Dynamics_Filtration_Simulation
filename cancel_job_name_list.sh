#!/bin/bash
T='T'
for i in {0..49}
do
 jobName='r0_20W_10D_'$i$T
 echo $jobName
 scancel -n $jobName
done
