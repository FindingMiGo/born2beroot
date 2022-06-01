#!usr/bin/bash
arch=$(uname -a)
pcpu=$(grep "physical id" /proc/cpuinfo | sort -u |wc -l)
vcpu=$(grep "^processor" /proc/cpuinfo | wc -l)

mused=$(free -m | awk '$1 == "Mem:" {print $3}')
mtotal=$(free -m | awk '$1 == "Mem:" {print $4}')
mper=$(free -m | awk '$1 == "Mem:" {printf("%.2f", $3/$4*100)}')

dused=$(df -Bm | grep -v 'udev' | grep -v 'tmpfs' | grep -v '/boot' | grep '^/dev/' |awk '{a+=$3} END {print a}')
dtotal=$(df -Bg | grep -v 'udev' | grep -v 'tmpfs' | grep -v '/boot' | grep '^/dev/' |awk '{a+=$2} END {print a}')
dper=$(df -Bm | grep -v 'udev' | grep -v 'tmpfs' | grep -v '/boot' | grep '^/dev/' |awk '{a+=$2} {b+=$3} END {printf("%d", b/a*100)}')

cpul=$(mpstat | grep 'all' | awk '{printf("%.1f", 100-$12)}')

boot=$(uptime -s)

lvmc=$(lsblk | grep lvm | wc -l)
lvm=$(if [ $lvmc -gt 0 ]; then echo yes; else echo no; fi)

tcp=$(netstat -t | sed 1,2d | wc -l)

log=$(users | wc -w)

ip=$(hostname -I)
mac=$(ip link show | awk '$1=="link/ether" {print $2}')

scmd=$(ls /var/log/sudo/00/00/ | wc -w)

wall "  #Architecture: $arch
        #CPU physical : $pcpu
        #vCPU : $vcpu
        #Memory Usage: $mused/${mtotal}MB (${mper}%)
        #Disk Usage: $dused/${dtotal}Gb ($dper%)
        #CPU load: ${cpul}%
        #Last boot: $boot
        #LVM use: $lvm
        #Connexions TCP : $tcp ESTABLISHED
        #User log: $log
        #Network: IP $ip ($mac)
        #Sudo : $scmd cmd"