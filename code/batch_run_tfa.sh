#!/bin/bash
#
#
#  batch run run_tfa.m 
#

data_dir="/data/jux/detre_group/tfa/CARNet_software"
input_dir="/data/jux/detre_group/tfa/inputs"

cd $data_dir

for x in ${input_dir}/*.tsv
do
	filename=$(basename ${x})
	name=$(echo ${filename} | cut -d '_' -f 1)
	side=$(echo ${filename} | cut -d '_' -f 2)
	artery=$(echo ${filename} | cut -d '_' -f 3)
	echo "running script for subject ${name}'s ${side} ${artery}"
	matlab -nodisplay -r "run_tfa ${name} ${artery} ${side}; exit"
done
