#To compress and remove the old file after successfull comression

#!/bin/bash

# Log directory
log_dir="/Data_NAS_NEW/APP1_Tomcat/apacheTcat-logs/access_log"

# Get today's date in the format used by the log file
current_date=$(date +%Y-%m-%d)

# Log file for script output
log_script="/home/tomcat/script/compress_logs_app1.log"

echo "[$(date)] Script started" >> "$log_script"

# Find all log files except today's log file
find "$log_dir" -type f -name "localhost_access_log*.txt" ! -name "localhost_access_log${current_date}.txt" | while read log_file; do
    echo "[$(date)] Processing log file: $log_file" >> "$log_script"

    # Generate the corresponding tar.gz file name
    tar_file="${log_file%.txt}.tar.gz"

    # Compress the log file
    tar -czf "$tar_file" "$log_file"

    # Check if compression was successful
    if [ $? -eq 0 ]; then
        echo "[$(date)] Successfully compressed: $log_file to $tar_file" >> "$log_script"

        # Remove the original log file after compression
        rm -f "$log_file"
        if [ $? -eq 0 ]; then
            echo "[$(date)] Removed original log file: $log_file" >> "$log_script"
        else
            echo "[$(date)] Failed to remove log file: $log_file" >> "$log_script"
        fi
    else
        echo "[$(date)] Failed to compress: $log_file" >> "$log_script"
    fi
done

echo "[$(date)] Script finished" >> "$log_script"
