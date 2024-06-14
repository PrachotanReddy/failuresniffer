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

# Print header
echo -e "${GREEN}Logging hardware, driver, and device errors...${NC}"

# Log errors and warnings from dmesg
echo -e "${YELLOW}Errors and warnings from dmesg:${NC}" >> $LOG_FILE
dmesg | grep -i 'error\|warn' >> $LOG_FILE

# Log messages related to specific devices or drivers
echo -e "\n${YELLOW}Messages related to GPU drivers:${NC}" >> $LOG_FILE
dmesg | grep -i 'nvidia\|radeon' >> $LOG_FILE

echo -e "\n${YELLOW}Messages related to USB devices:${NC}" >> $LOG_FILE
dmesg | grep -i 'usb' >> $LOG_FILE

# Add any other device or driver-specific filters as needed
# ...

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