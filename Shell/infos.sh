#!/bin/bash
# Small information display in the terminal

# Get terminal width (fallback to 80 if tput fails)
term_width=$(tput cols 2>/dev/null)
term_width=${term_width:-80}

# Get system information
current_date=$(date)
battery_percentage=$(acpi -b | grep -P -o '[0-9]+(?=%)')
cpu_model=$(lscpu | grep "Model name" | awk -F ':' '{ print $2 }' | xargs)
cpu_arch=$(lscpu | grep "Architecture" | awk -F ':' '{ print $2 }' | xargs)
processes_running=$(ps -e --no-headers | wc -l)
processes_waiting=$(ps -eo stat | grep -c "^D")
username=$(whoami)

# Assemble the output text
output=$(
    cat <<EOF
Hello @$username!
$current_date
Battery: $battery_percentage%
CPU: $cpu_model ($cpu_arch)
Processes running: $processes_running
Processes waiting: $processes_waiting
EOF
)

# Build a border line that spans the terminal width (using underscores)
border=$(printf '%*s' "$term_width" '' | tr ' ' '_')

echo -e "\033[32m$border\033[0m\n"

# Process each line of output to center it
while IFS= read -r line; do
    len=${#line}

    pad=$(((term_width - len) / 2))

    printf "\033[1;37m%*s%s\033[0m\n" "$pad" "" "$line"
done <<<"$output"

echo -e "\033[32m$border\033[0m"
