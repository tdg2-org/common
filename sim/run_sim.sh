#!/bin/bash

# Set ModelSim/QuestaSim installation path if not in default $PATH
export PATH=/mnt/Misc_512/installs/questa/questa_fse/bin:$PATH

# Simulation log file
LOG_FILE="sim_output.log"

# Remove old log file if it exists
if [ -f "$LOG_FILE" ]; then
    rm "$LOG_FILE"
fi

# Run the simulation in batch mode and save output to a log file
#vsim -batch -do 1_run.do
vsim -batch -do 1_run.do > "$LOG_FILE" 2>&1

# Check if simulation passed or failed
if grep -q "FAIL" "$LOG_FILE"; then
    echo "Simulation failed! Check $LOG_FILE for details."
    exit 1
else
    echo "Simulation completed successfully."
    exit 0
fi
