#!/bin/bash

# Create 'names.txt' if it doesn't exist
FILE="names.txt"
if [[ ! -f "$FILE" ]]; then
	touch "$FILE"
fi

# Read names until "exit" is typed
COUNT=0
echo "Enter names to be stored. Type 'exit' to quit."
while true; do
	read -p "Enter name: " NAME
	
	# Break if 'exit' it typed
	if [[ "$NAME" == "exit" ]]; then
		break;
	fi
	
	# Append new name
	echo $NAME >> "$FILE"
	((COUNT++))
done

# Display each name
N=1
echo "Saved names: "
for NAME_FOR in $(cat $FILE); do
	echo "$N - $NAME_FOR"
	((N++))
done

# Print summary
echo "There were saved $COUNT names in this iteration"

