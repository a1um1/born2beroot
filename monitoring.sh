#! /bin/bash
mt_arc=$(uname -a)
mt_cpu=$(lscpu | grep 'Socket(s):' | awk '{print $2}')
mt_vcpu=$(nproc)
mt_cpu_load=$(top -bn1 | awk '/^%Cpu/ {printf("%.1f%%"), $2 + $4}')

mt_mem_total=$(awk '$1 == "Mem:" {print $2}' <(free -m))
mt_mem_used=$(awk '$1 == "Mem:" {print $3}' <(free -m))
mt_mem_percent=$(awk '$1 == "Mem:" {printf("%.2f"), $3/$2*100}' <(free -m))

mt_disk_total=$(df -h --total | awk 'END{print $(NF-4)}')
mt_disk_used=$(df --total | awk 'END{print $(NF-3)}')
mt_disk_percent=$(df --total | awk 'END{printf("%d"), $(NF-1)}')

mt_last_boot=$(awk '$1 == "system" {print $3 " " $4}' <(who -b))
mt_lvmt=$(awk '/lvm/ {print $1}' <(lsblk) | wc -l)
mt_lvmu=$(if [ $mt_lvmt -eq 0 ]; then echo no; else echo yes; fi)

mt_ctcp=$(awk '$1 == "TCP:" {print $3}' /proc/net/sockstat{,6})
mt_ulog=$(users | wc -w)
mt_ip=$(hostname -I)
mt_mac=$(ip link show | awk '$1 == "link/ether" {print $2}')
mt_cmds=$(journalctl _COMM=sudo | awk '/COMMAND/ {print $1}' | wc -l)

wall "	#Architecture: $mt_arc
	#CPU physical : $mt_cpu
	#vCPU : $mt_vcpu
	#Memory Usage: $mt_mem_used/${mt_mem_total}MB ($mt_mem_percent%)
	#Disk Usage: $mt_disk_used/${mt_disk_total}Gb ($mt_disk_percent%)
	#CPU load: $mt_cpu_load
	#Last boot: $mt_last_boot
	#LVM use: $mt_lvmu
	#Connections TCP : $mt_ctcp ESTABLISHED
	#User log: $mt_ulog
	#Network: IP $mt_ip ($mt_mac)
	#Sudo : $mt_cmds cmd"
