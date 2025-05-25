#!/bin/bash

# File path with users names
USERS="users.txt"

# Counters
USERS_NUM=0
FOUND=0

# Loop each user name and check if it exists in this system
for USER in $(cat "$USERS"); do
	if id "$USER" >/dev/null 2>&1; then 
		echo -e "User $USER exists in the system"
		((FOUND++))
	else
		echo -e "User $USER was not found in the system"
	fi

	((USERS_NUM++))
done

# Print summary
echo -e "\033[1;35mThere were $USERS_NUM users searched in the system\033[0m"
echo -e "\033[1;32m$FOUND users were found\033[0m"

