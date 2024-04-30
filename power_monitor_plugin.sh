#!/bin/bash

ICON=utilities-system-monitor

# Get the active powersupply
POWERSUPPLIES=$(ls '/sys/class/power_supply/' | tr " " "\n")
VOLTAGE=0
CURRENT=0
NODATA=true

# Cycle though each powersupply to figure out which powersupply to use
for POWERSUPPLY in $POWERSUPPLIES; do
    # Check if power supply online
    if [[ $(cat "/sys/class/power_supply/$POWERSUPPLY/online") == "0" ]]; then
        continue
    fi

    # Check if power supply sending voltage and current data to pc
    if [ ! -f "/sys/class/power_supply/$POWERSUPPLY/voltage_now" ] || [ ! -f "/sys/class/power_supply/$POWERSUPPLY/current_now" ]; then continue; fi

    # Read data from power supply
    VOLTAGE=$(cat "/sys/class/power_supply/$POWERSUPPLY/voltage_now")
    CURRENT=$(cat "/sys/class/power_supply/$POWERSUPPLY/current_now")
    NODATA=false
    break
done

if [[ $NODATA == true ]]; then
    echo "<txt>No data</txt>"
    exit 0
fi

# Get wattage drawn
WATTAGE=$(echo $(((VOLTAGE * CURRENT) / 10000000000)) | sed -e 's/..$/.&/;t' -e 's/.$/.0&/')

# do the genmon
echo "<txt>$WATTAGE‎W</txt>"
echo "<tool>Voltage | $(echo $((VOLTAGE / 10000)) | sed -e 's/..$/.&/;t' -e 's/.$/.0&/')V
Current | $(echo $((CURRENT / 10000)) | sed -e 's/..$/.&/;t' -e 's/.$/.0&/')A</tool>"

exit 0
