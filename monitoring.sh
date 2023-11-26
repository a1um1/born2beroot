#! /bin/bash
mt_arc=$(uname -a)
mt_cpu=$(grep -i "physical id" | sort -u | wc -l)
mt_fram=$(free -m | awk '$1 == "Mem:" {print $2}')
mt_uram=$(free -m | awk '$1 == "Mem:" {print $3}')
mt_pram=$(free | awk '$1 == "Mem:" {printf("%.2f"), $3/$2*100}')

echo "  #Architecture: $mt_arc
        #CPU physical: $mt_cpu
        #vCPU: $mt_cpu
        #Memory Usage: $mt_uram/${mt_fram}MB ($mt_pram%)"