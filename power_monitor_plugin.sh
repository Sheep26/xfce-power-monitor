#!/bin/bash

ICON=utilities-system-monitor

# Get the target powersupply
POWERSUPPLIES=$(ls '/sys/class/power_supply/' | tr " " "\n")
VOLTAGE=""
CURRENT=""

# Cycle though each powersupply to figure out which powersupply to use
for POWERSUPPLY in $POWERSUPPLIES; do
    # Find out which powersupply to use
    if [[ "$POWERSUPPLY" == AC* ]]; then
        # Check if plugged into mains
        for DATA in [[ $(cat "/sys/class/power_supply/$POWERSUPPLY/uevent") ]]
        do
            if DATA == "POWER_SUPPLY_ONLINE=1"; then
                VOLTAGE = 10000000000000
                CURRENT = 10000000000
                break
            fi
        done
    fi
    if [[ "$POWERSUPPLY" == BAT* ]]; then
        VOLTAGE=$(cat "/sys/class/power_supply/$POWERSUPPLY/voltage_now")
        CURRENT=$(cat "/sys/class/power_supply/$POWERSUPPLY/current_now")
        break
    fi
done

# Get wattage drawn
WATTAGE=$(((VOLTAGE * CURRENT) / 1000000000000))

# do the genmon
echo "<txt>$WATTAGE‎W</txt><txtclick>xfce4-power-manager</txtclick>"

exit 0
