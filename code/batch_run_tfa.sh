#!/bin/bash
#
#
#  batch run run_tfa.m
#

input_dir="/home/will/Repositories/autoregulation/inputs2/200Hz"

for x in ${input_dir}/*.tsv
do
	filename=$(basename ${x})
	name=$(echo ${filename} | cut -d '_' -f 1)
	side=$(echo ${filename} | cut -d '_' -f 2)
	artery=$(echo ${filename} | cut -d '_' -f 3)
	echo "running script for subject ${name}'s ${side} ${artery}"
	/usr/local/MATLAB/R2019a/bin/matlab -nodisplay -r "run_tfa ${name} ${artery} ${side}; exit" #|| continue
done
