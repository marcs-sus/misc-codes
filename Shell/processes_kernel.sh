#!/bin/bash
# Quick processes information on the kernel

echo "Current processes on the kernel:"
ps -eo pid,comm,state | grep R

echo "Processes in the waiting line:"
ps -eo pid,comm,state | grep D

echo "Number of running processes:"
ps -eo state | grep -c R

echo "Number of waiting processes:"
ps -eo state | grep -c S
