#!/bin/bash

db=filter_rfam.sqlite
short_list=						# .header file of those that found matched to the Rfam database
long_list=						# acc.no_annotation.headers
output=							# whatever you want the output file to be called

sort $long_list| uniq | sed 's/|/:/g' > long.scratch
sort $short_list | uniq | sed 's/|/:/g' > short.scratch

sqlite3 $db "CREATE TABLE long_list(transcript_id)"
sqlite3 $db ".import long.scratch long_list"

sqlite3 $db "CREATE TABLE short_list(transcript_id)"
sqlite3 $db ".import short.scratch short_list"

sqlite3 $db "SELECT transcript_id FROM long_list
	    WHERE transcript_id NOT IN
	    	(SELECT transcript_id from short_list)" > $output

sed -i 's/:/|/g' $output
rm *.scratch
