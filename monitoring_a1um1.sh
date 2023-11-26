
#! /bin/bash

function progress_bar {
    local total=$1
    local current=$2
    local width=${3:-$(tput cols)} # Default width is 50

    # Calculate percentage
    local ratio=$(echo "$current/$total" | bc -l)
    local percent=$(echo "$ratio * 100" | bc -l | xargs printf "%.*f\n" 0)

    # Calculate how many characters should be in the progress bar
    local progress=$(echo "$ratio * $width" | bc -l | xargs printf "%.*f\n" 0)

    # Create the progress bar string
    local completed=$(printf "%0.s#" $(seq 1 $progress))
    local remaining=$(printf "%0.s-" $(seq 1 $(($width - $progress))))

    # Print the progress bar
    echo "[$completed$remaining] $percent%"
}

mt_arc=$(uname -a)
mt_cpu=$(awk -F: '/physical id/ {print $2}' /proc/cpuinfo | sort -u | wc -l)
mt_vcpu=$(awk '/^processor/ {print $1}' /proc/cpuinfo | wc -l)
mt_cpu_load=$(top -bn1 | awk '/^%Cpu/ {printf("%.1f%%"), $2 + $4}')

mt_mem_total=$(awk '$1 == "Mem:" {print $2}' <(free -m))
mt_mem_used=$(awk '$1 == "Mem:" {print $3}' <(free -m))
mt_mem_percent=$(awk '$1 == "Mem:" {printf("%.2f"), $3/$2*100}' <(free))

mt_disk_total=$(awk '/^\/dev\// && !/\/boot$/ {ft += $2} END {print ft}' <(df -BG))
mt_disk_used=$(awk '/^\/dev\// && !/\/boot$/ {ut += $3} END {print ut}' <(df -BM))
mt_disk_percent=$(awk '/^\/dev\// && !/\/boot$/ {ut += $3; ft += $2} END {printf("%d"), ut/ft*100}' <(df -BM))

mt_last_boot=$(awk '$1 == "system" {print $3 " " $4}' <(who -b))
mt_lvmt=$(awk '/lvm/ {print $1}' <(lsblk) | wc -l)
mt_lvmu=$(if [ $mt_lvmt -eq 0 ]; then echo no; else echo yes; fi)

mt_ctcp=$(awk '$1 == "TCP:" {print $3}' /proc/net/sockstat{,6})
mt_ulog=$(users | wc -w)
mt_ip=$(hostname -i)
mt_mac=$(ip link show | awk '/ether/ {print $2}' | tr '\n' ' ' | sed 's/ $//')
mt_cmds=$(journalctl _COMM=sudo | awk '/COMMAND/ {print $1}' | wc -l)

wall "	#Architecture: $mt_arc
	#CPU physical: $mt_cpu
	#vCPU: $mt_vcpu
	#Memory Usage: $mt_mem_used/${mt_mem_total}MB ${progress_bar 100 $mt_mem_percent}
	#Disk Usage: $mt_disk_used/${mt_disk_total}Gb ($mt_disk_percent%)
	#CPU load: $mt_cpu_load
	#Last boot: $mt_last_boot
	#LVM use: $mt_lvmu
	#Connections TCP: $mt_ctcp ESTABLISHED
	#User log: $mt_ulog
	#Network: IP $mt_ip ($mt_mac)
	#Sudo: $mt_cmds cmd"