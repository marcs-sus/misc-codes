#!/bin/bash

# Services to be checked
SERVICES=("systemd-networkd" "systemd-resolved" "sshd" "cronie" "dbus" "NetworkManager")

# Count active and inactive services
ACTIVES=0
INACTIVES=0

# Loop through each service and check its status
for SERVICE in "${SERVICES[@]}"; do
	# Check service activity
	if systemctl is-active --quiet "$SERVICE"; then
		echo -e "\033[1;32mService $SERVICE is ACTIVE\033[0m"
		((ACTIVES++))
	else
		echo -e "\033[1;31mService $SERVICE is INACTIVE\033[0m"
		((INACTIVES++))
	fi
	echo "-------------------------------------------------"
done

# Print summary
echo -e "\033[1;44mTotal active services: $ACTIVES\033[0m"
echo -e "\033[1;44mTotal inactive services: $INACTIVES\033[0m"

