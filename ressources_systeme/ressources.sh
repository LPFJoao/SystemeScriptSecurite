#!/bin/bash

DATE=$(date +%Y%m%d_%H%M%S)
CSV_FILE="ressources_$DATE.csv"

echo "=== CPU Usage ==="
CPU_LINE=$(top -b -n1 | grep "%Cpu(s)")
CPU_USER=$(echo $CPU_LINE | awk '{print $2}')
CPU_SYS=$(echo $CPU_LINE | awk '{print $4}')
CPU_IDLE=$(echo $CPU_LINE | awk '{print $8}')
echo "User: $CPU_USER% | System: $CPU_SYS% | Idle: $CPU_IDLE%" | column -t

echo "=== RAM ==="
MEM_LINE=$(top -b -n1 | grep "MiB Mem")
MEM_TOTAL=$(echo $MEM_LINE | awk '{print $4}')
MEM_USED=$(echo $MEM_LINE | awk '{print $8}')
MEM_FREE=$(echo $MEM_LINE | awk '{print $6}')
echo "Total: $MEM_TOTAL MiB | Used: $MEM_USED MiB | Free: $MEM_FREE MiB" | column -t

echo "=== Swap ==="
SWAP_LINE=$(top -b -n1 | grep "MiB Swap")
SWAP_TOTAL=$(echo $SWAP_LINE | awk '{print $3}')
SWAP_USED=$(echo $SWAP_LINE | awk '{print $7}')
SWAP_FREE=$(echo $SWAP_LINE | awk '{print $5}')
echo "Total: $SWAP_TOTAL MiB | Used: $SWAP_USED MiB | Free: $SWAP_FREE MiB" | column -t

echo
read -p "Do you want to save this data to a CSV file? (y/n): " SAVE_CHOICE

if [[ "$SAVE_CHOICE" =~ ^[Yy]$ ]]; then
    echo "timestamp,cpu_user,cpu_sys,cpu_idle,mem_total,mem_used,mem_free,swap_total,swap_used,swap_free" > "$CSV_FILE"
    echo "$DATE,$CPU_USER,$CPU_SYS,$CPU_IDLE,$MEM_TOTAL,$MEM_USED,$MEM_FREE,$SWAP_TOTAL,$SWAP_USED,$SWAP_FREE" >> "$CSV_FILE"
    echo "✅ CSV saved as: $CSV_FILE"
else
    echo "❌ CSV not saved."
fi

