#!/bin/bash

# Intro
echo "Enter a number and a limit to calculate its multiplication table"

# Read variables
read -p "Enter a number: " NUMBER
read -p "Define a limit: " LIMIT

if [[ ! $NUMBER =~ ^[0-9]+(\.[0-9]+)?$ || ! $LIMIT =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
	echo "Please enter valid numbers."
	exit 1
fi

echo "----------------------------"

for ((i = 1; i <= LIMIT; i++)); do
	echo "$NUMBER . $i = $((NUMBER * i))"
done

