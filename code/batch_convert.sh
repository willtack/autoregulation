#!/bin/bash
#
#
#  convert all the figs in /outputs with CARNet_software/export_figs.m
#

data_dir="/data/jux/detre_group/tfa/CARNet_software"
input_dir="/data/jux/detre_group/tfa/outputs"

cd $data_dir

for subdir in ${input_dir}/*
do
	count=`ls -1 ${subdir}/*.fig 2>/dev/null | wc -l`
	if [ $count != 0 ] #only convert if there are figs to convert
	then 
		echo "converting figures in ${subdir}"
		matlab -nodisplay -r "export_figs ${subdir} 'png'; exit"
	fi
done
