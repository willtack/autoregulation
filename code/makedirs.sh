#!/bin/bash

n=1;
max=40;
while [ "$n" -le "$max" ]; do
	if [ "$n" -lt 10 ]; then
		mkdir "h00$n"
	else
		mkdir "h0$n"
	fi
	n=`expr "$n" + 1`;
done
