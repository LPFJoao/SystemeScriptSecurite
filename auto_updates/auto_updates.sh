#!/bin/bash

sudo apt update

UPDATES=$(apt list --upgradable 2>/dev/null | grep -v "Listing..." | wc -l)

if [ "$UPDATES" -eq 0 ]; then
    echo " No updates available."

else
    echo "$UPDATES Updates are available."
    apt list --upgradable 2>/dev/null | grep -v "Listing..."
    
    echo
    read -p "Do you want to install the $UPDATES updates available? (y/n): " ANSWER
    
    if [[ "$ANSWER" =~ ^[Yy]$ ]]; then
        echo "Updates installing..."
        sudo apt upgrade -y
        echo "Updates installed with success"
    else
        echo "Updates installation stoped"
    fi
fi


