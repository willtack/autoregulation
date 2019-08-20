#!/usr/bin/env bash
#
# Call python script to convert xlsx's to tsv's
# 8/19/2019

# Rename. e.g. RECAST H001 LEFT ACA.xlsx --> h001_left_aca.tsv

for i in *.xlsx
do
	name=$(echo ${i} | cut -d ' ' -f 2)
	side=$(echo ${i} | cut -d ' ' -f 3)
	artery=$(echo ${i} | cut -d ' ' -f 4)
	new_filename="${name}_${side}_${artery}"
	new_filename_lc=`echo ${new_filename} | tr [:upper:] [:lower:]` # Change to lower case
	mv "${i}" ${new_filename_lc}
	python3 convert_excel_to_tsv.py ${new_filename_lc}
done
