#!/bin/bash

ICON=utilities-system-monitor

# Get the target powersupply
POWERSUPPLIES=$(ls '/sys/class/power_supply/' | tr " " "\n")
VOLTAGE=""
CURRENT=""
#USINGAC=false

# Cycle though each powersupply to figure out which powersupply to use
for POWERSUPPLY in $POWERSUPPLIES; do
    # Find out which powersupply to use
    #if [[ "$POWERSUPPLY" == AC* ]]; then
        # Check if plugged into mains
        #for DATA in $(cat "/sys/class/power_supply/$POWERSUPPLY/uevent"); do
            #if [[ "$DATA" == POWER_SUPPLY_ONLINE=1 ]]; then
                #VOLTAGE=10000000000000
                #CURRENT=10000000000
                #USINGAC=true
                #break
            #fi
        #done
        #if "$USINGAC"; then
            #break
        #fi
    #fi
    if [[ "$POWERSUPPLY" == BAT* ]]; then
        VOLTAGE=$(cat "/sys/class/power_supply/$POWERSUPPLY/voltage_now")
        CURRENT=$(cat "/sys/class/power_supply/$POWERSUPPLY/current_now")
        break
    fi
done

# Get wattage drawn
WATTAGE=$(echo $(((VOLTAGE * CURRENT) / 10000000000)) | sed -e 's/..$/.&/;t' -e 's/.$/.0&/')

# do the genmon
echo "<txt>$WATTAGE‎W</txt>"
echo "<tool>Voltage | $(echo $((VOLTAGE / 10000)) | sed -e 's/..$/.&/;t' -e 's/.$/.0&/')V
Current | $(echo $((CURRENT / 10000)) | sed -e 's/..$/.&/;t' -e 's/.$/.0&/')A</tool>"

exit 0
