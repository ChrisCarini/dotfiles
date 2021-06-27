#!/bin/bash

header "=" "Grabbing current defaults before settings change..."
defaults read > defaults.before.txt

header "-" "Go ahead and make the change in the System Preferences."
read -n 1 -s -r -p "Press any key when done."

header "=" "Grabbing current defaults after settings change..."
defaults read > defaults.after.txt

header "=" "Here is what changed."
diff defaults.before.txt defaults.after.txt

echo;echo;
read -p "Changed variable name: " CHANGED_VAR

cat defaults.after.txt | grep -A10 -B10 "$CHANGED_VAR"

rm defaults.before.txt defaults.after.txt