#!/bin/bash

# Define log file
LOG_FILE="hardware_errors.log"

# Define colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Clear the log file
> $LOG_FILE

# Check if a dmesg file is provided as an argument
if [ -n "$1" ] && [ -f "$1" ]; then
    DMESG_FILE="$1"
    echo -e "${GREEN}Using provided dmesg file: $DMESG_FILE${NC}"
else
    DMESG_FILE="/var/log/dmesg"
    echo -e "${GREEN}Using default dmesg file: $DMESG_FILE${NC}"
fi

# Print header
echo -e "${GREEN}Logging hardware, driver, and device errors...${NC}"

# Log errors and warnings from dmesg
echo -e "${YELLOW}Errors and warnings from dmesg:${NC}" >> $LOG_FILE
grep -i -E '(error|fail|fault).*?(hardware|hw|driver|device|firmware)' "$DMESG_FILE" >> $LOG_FILE

# Print summary
echo -e "${GREEN}Hardware error log saved to $LOG_FILE${NC}"

# Display log file contents
echo -e "${YELLOW}Log file contents:${NC}"
cat $LOG_FILE

# Prompt user for further action
read -p "$(echo -e "${GREEN}Do you want to send the log file for analysis? (y/n)${NC} ")" choice
case "$choice" in
  y|Y ) echo "Sending $LOG_FILE for analysis...";;
  n|N ) echo "Log file not sent.";;
  * ) echo "Invalid choice.";;
esac