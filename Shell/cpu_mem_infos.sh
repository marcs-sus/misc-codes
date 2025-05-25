#!/bin/bash
# Processes and memory information collection

# Make folder to store results
mkdir -p cpu-mem_results

# List all processes and sort by CPU and memory usage
ps aux --sort=-%cpu | head -n 15 >cpu-mem_results/processes_cpu.txt
ps aux --sort=-%mem | head -n 15 >cpu-mem_results/processes_mem.txt

# Capture top output
top -b -n 3 >cpu-mem_results/top.txt

# Capture free output
free -h >cpu-mem_results/memory.txt

# Create process in background and save its PID
sleep 300 &
echo $! >cpu-mem_results/sleep_pid.txt

echo "Information colected! Check dir /cpu-mem_results."
