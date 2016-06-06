#!/bin/bash

###############################################
####          CAPTURE STDOUT               ####
###############################################

comparison_file=					# this is the table

input1=							# these will be files of transcript names.
input2=							# they should be named "master_longest_accession.headers
input3=master_longest_same.headers			# the script will write these, you only need to provide a name

fasta1=							# These should be the fasta file from which the lengths were derived.
fasta2=							# input1 should have the same accession as fasta1 (same for fasta2).
fasta3=$fasta1						# grabs from this if length of transcript is equal in fasta1 and fasta2

## GENERATE master_longest_*

awk ' $2 > $4 ' $comparison_file | cut -f1 > $input1
awk ' $2 < $4 ' $comparison_file | cut -f3 > $input2
awk ' $2 == $4 ' $comparison_file | cut -f1 > $input3

###############################################
### NOTHING BEYOND HERE SHOULD NEED EDITED ####
###############################################

## LOOP 1

counter=0
lc=`wc -l $input1 | cut -f1 -d" "`
limit=$(( $lc + 1 ))

until [[ $counter -eq $limit ]]; do

	read line
	samtools faidx $fasta1 $line
	if (( $counter % 1000 == 0 )); then echo $counter; fi 1>&2
	counter=$(( $counter + 1 ))

done < $input1

## LOOP 2

counter=0
lc=`wc -l $input2 | cut -f1 -d" "`
limit=$(( $lc + 1 ))

until [[ $counter -eq $limit ]]; do

        read line
        samtools faidx $fasta2 $line
        if (( $counter % 1000 == 0 )); then echo $counter; fi 1>&2
        counter=$(( $counter + 1 ))

done < $input2

## LOOP 3

counter=0
lc=`wc -l $input3 | cut -f1 -d" "`
limit=$(( $lc + 1 ))

until [[ $counter -eq $limit ]]; do

        read line
        samtools faidx $fasta3 $line
        if (( $counter % 1000 == 0 )); then echo $counter; fi 1>&2
        counter=$(( $counter + 1 ))

done < $input3

