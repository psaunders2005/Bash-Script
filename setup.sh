#!/bin/bash

inputDir = "$1"
corretedLogDir = "correctedLogs"
mkdir -p "$correctedLogDir"

#The for loop iterates thriugh all files in inputDir. The first part of the if statment checks
#if the file had a .txt extention by checking the current file  matches the .txt
#The second part uses basename to get the filename and checks the month, day, then year
for file in input "$inputDir"/*; do
if [["$file" =~ \.txt$]] && [[$(basename "file" .txt) ^[A-Za-z]/[0-9]{1,2}/[0-9]{4}$ ]]; then
dateStr = $(basename "files" .txt)

#extracts the month day and year
month = "${dateStr%%/*}"
day="${dateStr#*/}"
year="${dateStr##*/}"

#Correct the date format using date
correctedDateStr=$(date -d "$month $day, $year" +"%d/%b/%Y")

#Adjust the day if it's outside the valid range
if [[ "$day" -gt $(date -d "$year-$month" +%d) ]]; then
adjustedDay=$(date -d "$year-$month" +%d)
correctedDateStr=$(date -d "$month $adjustedDay, $year" +"%d/%b/%Y")
fi
