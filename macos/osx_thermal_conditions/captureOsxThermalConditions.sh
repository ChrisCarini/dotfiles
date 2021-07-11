#!/bin/bash

echo "$(date +"%Y-%m-%d %H:%M");$(pmset -g therm | awk '$1 ~/CPU_Scheduler_Limit/ {scl=$3;} $1 ~/CPU_Available_CPUs/ {avail=$3;} $1 ~/CPU_Speed_Limit/ {printf "%s,%s,%s\n", scl,avail,$3}')" >> ~/osx_thermal_conditions.csv
