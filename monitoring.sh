#! /bin/bash
mt_arc=$(uname -a)
mt_cpu=$(grep -i "physical id" /proc/cpuinfo | sort -u | wc -l)
mt_vcpu=$(grep -c "^processor" /proc/cpuinfo)
mt_cpu_load=$(top -bn1 | grep '^%Cpu' | cut -c 9- | xargs | awk '{printf("%.1f%%"), $1 + $3}')

mt_mem_total=$(free -m | awk '$1 == "Mem:" {print $2}')
mt_mem_used=$(free -m | awk '$1 == "Mem:" {print $3}')
mt_mem_percent=$(free | awk '$1 == "Mem:" {printf("%.2f"), $3/$2*100}')

mt_disk_total=$(df -Bg | grep '^/dev/' | grep -v '/boot$' | awk '{ft += $2} END {print ft}')
mt_disk_used=$(df -Bm | grep '^/dev/' | grep -v '/boot$' | awk '{ut += $3} END {print ut}')
mt_disk_percent=$(df -Bm | grep '^/dev/' | grep -v '/boot$' | awk '{ut += $3} {ft+= $2} END {printf("%d"), ut/ft*100}')

mt_last_boot=$(who -b | awk '$1 == "system" {print $3 " " $4}')
mt_lvmt=$(lsblk | grep "lvm" | wc -l)
mt_lvmu=$(if [ $mt_lvmt -eq 0 ]; then echo no; else echo yes; fi)

mt_ctcp=$(cat /proc/net/sockstat{,6} | awk '$1 == "TCP:" {print $3}')
mt_ulog=$(users | wc -w)
mt_ip=$(hostname -I | sed 's/ *$//')
mt_mac=$(ip link show | awk '$1 == "link/ether" {print $2}' | tr '\n' ' ' | sed 's/ *$//')
mt_cmds=$(journalctl _COMM=sudo | grep COMMAND | wc -l)

echo "#Architecture: $mt_arc
#CPU physical: $mt_cpu
#vCPU: $mt_vcpu
#Memory Usage: $mt_mem_used/${mt_mem_total}MB ($mt_mem_percent%)
#Disk Usage: $mt_disk_used/${mt_disk_total}Gb ($mt_disk_percent%)
#CPU load: $mt_cpu_load
#Last boot: $mt_last_boot
#LVM use: $mt_lvmu
#Connections TCP: $mt_ctcp ESTABLISHED
#User log: $mt_ulog
#Network: IP $mt_ip ($mt_mac)
#Sudo: $mt_cmds cmd"