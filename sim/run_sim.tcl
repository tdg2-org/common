# Define the simulation command
set questaDir "/mnt/Misc_512/installs/questa/questa_fse/bin"
set sim_cmd "$questaDir/vsim -batch -do 1_run.do"

# Define log file
set log_file "sim_output.log"

# Delete old log file if it exists
if {[file exists $log_file]} {
    file delete $log_file
}

# Run the simulation command and redirect output to log file
set log [open $log_file w]
set result [catch {exec sh -c "$sim_cmd"} output]

puts $log $output
close $log

# Check for simulation errors in the log
set log [open $log_file r]
set sim_failed 0

while {[gets $log line] >= 0} {
    if {[string match "*FAIL*" $line]} {
        puts "Simulation failed! Check $log_file for details."
        set sim_failed 1
        break
    }
}

close $log

# Exit with appropriate status code
if {$sim_failed} {
    exit 1
} else {
    puts "Simulation completed successfully."
    exit 0
}
