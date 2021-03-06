#!/bin/bash
#PBS -A ONRDC17423173
#PBS -l select=8:ncpus=36:mpiprocs=36
#PBS -l walltime=24:00:00
#PBS -q standard
#PBS -j oe
#PBS -V
#PBS -N mcnpu0t4

cd $PBS_O_WORKDIR

cat $PBS_NODEFILE > nodes
num_per_job=36
pre="A_"

for (( i=0 ; i<4 ; i++ ))
do
	n1=$( expr $num_per_job \* \( $i + 1 \) )  #specify lines
	if (( $i <= 9 )) ; then
		j=00$i
	elif (( $i <= 99 )) ; then
		j=0$i
	else
		j=$i
	fi
	folder=$pre$j
	mkdir -p $folder
	cp -r bin  el_list.txt  io.py  main.py  mc.py  PSPs  reader.py  structure.xsf  templates $folder
	cd $folder

	cat $PBS_O_WORKDIR/nodes | head -n $n1 | tail -n $num_per_job > Nodes
	( export PBS_NODEFILE=Nodes; mkdir -p temp; cp Nodes temp; python main.py structure.xsf el_list.txt ) &
	sleep 2s

	cd $PBS_O_WORKDIR
done
wait
