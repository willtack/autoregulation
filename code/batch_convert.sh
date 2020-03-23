#!/bin/bash
#
#
#  convert all the figs in /outputs with CARNet_software/export_figs.m
#

input_dir="/home/will/Repositories/autoregulation/outputs_norm"

for subdir in ${input_dir}/*
do
	count=`ls -1 ${subdir}/*.fig 2>/dev/null | wc -l`
	if [ $count != 0 ] #only convert if there are figs to convert
	then 
		echo "converting figures in ${subdir}"
		/usr/local/MATLAB/R2019a/bin/matlab -nodisplay -r "export_figs ${subdir} 'png'; exit"
	fi
done
