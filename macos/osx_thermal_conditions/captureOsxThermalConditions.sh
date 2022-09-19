#!/bin/bash

OUTPUT_FILE="$HOME/osx_thermal_conditions.csv"

DATE_STRING=$(date +"%Y-%m-%d %H:%M")
DATA_STRING=$(pmset -g therm | awk '$1 ~/CPU_Scheduler_Limit/ {scl=$3;} $1 ~/CPU_Available_CPUs/ {avail=$3;} $1 ~/CPU_Speed_Limit/ {printf "%s,%s,%s\n", scl,avail,$3}')
HEADER_STRING="datetime;CPU_Scheduler_Limit,CPU_Available_CPUs,CPU_Speed_Limit"

# Clear the last line of the file; it is the 'header' for ease of viewing during `tail`.
# Ref: https://stackoverflow.com/a/4881990
sed -i "" -e '$ d' "${OUTPUT_FILE}"

echo -e "${DATE_STRING};${DATA_STRING}\n${HEADER_STRING}" >> "${OUTPUT_FILE}"
