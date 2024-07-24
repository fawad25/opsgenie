#!/bin/bash

# Function to check disk space
check_disk_space() {
    # Get total disk space and available disk space in human-readable format
    total_space=$(df -h / | awk 'NR==2 {print $2}')
    available_space=$(df -h / | awk 'NR==2 {print $4}')

    # Calculate percentage of available space
    used_space=$(df -h / | awk 'NR==2 {print $3}' | sed 's/%//')
    used_percent=$(df -h / | awk 'NR==2 {print $5}' | sed 's/%//')
    available_percent=$(expr 100 - $used_percent)

    # Check if available space is less than 10% of total space
    if (( $(echo "$used_space < 10" | bc -l) )); then
        echo "Space is available: $available_space ($available_percent% available)"
    else
        echo "Space is almost full: $used_space used ($used_percent% used)"
    fi
}

# Function to check server load
check_server_load() {
    # Get 1-minute load average
    load_average=$(uptime | awk -F'[a-z]:' '{print $2}' | awk -F',' '{print $1}' | tr -d ' ')

    # Define threshold for load average indicating a potential issue (adjust as needed)
    load_threshold=5.0

    # Check if load average exceeds threshold
    if (( $(echo "$load_average > $load_threshold" | bc -l) )); then
        echo "There is a load on the server (Load average: $load_average)"
    else
        echo "The load seems fine (Load average: $load_average)"
    fi
}

# Main script execution
echo "Checking disk space..."
check_disk_space

echo

echo "Checking server load..."
check_server_load
