#!/bin/bash

# Log analysis script for specific log file with colored output and full error messages

# ANSI color codes
RED='\033[0;31m'  # Red color
NC='\033[0m'      # No color

# Check if log file argument is provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <log_file>"
    exit 1
fi

LOG_FILE="$1"

# Check if the file exists
if [ ! -f "$LOG_FILE" ]; then
    echo -e "${RED}Error: Log file '$LOG_FILE' not found.${NC}"
    exit 1
fi

# Example: Search for error patterns and display full lines in terminal with color
echo -e "${RED}Error messages in log file '$LOG_FILE':${NC}"
while IFS= read -r line; do
    echo "$line" | grep -q "ERROR"
    if [ $? -eq 0 ]; then
        echo -e "${RED}$line${NC}"
        # Keep reading until the next timestamp or end of file
        while IFS= read -r subline; do
            echo "$subline" | grep -qE '^[0-9]{2} [A-Za-z]{3} [0-9]{4} [0-9]{2}:[0-9]{2}:[0-9]{2},[0-9]{3}'
            if [ $? -eq 0 ]; then
                break
            else
                echo "$subline"
            fi
        done
    fi
done < "$LOG_FILE"

echo "Analysis completed."
