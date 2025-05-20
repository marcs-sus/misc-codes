#!bin/bash

# Variables
INPUT_FILE="people.txt"
OUTPUT_FILE="people_ordened.txt"

# Check if input files exists
if [ ! -f "$INPUT_FILE" ]; then
	echo "$INPUT_FILE doesn't exist in the current context"
	exit 1
fi

# Check if output file have content
if [ ! -s "$INPUT_FILE" ]; then
	echo "$INPUT_FILE is empty!"
	exit 1
fi

# Sort file content
sort "$INPUT_FILE" | uniq > "$OUTPUT_FILE"
