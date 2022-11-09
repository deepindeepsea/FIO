#!/bin/bash

pc_type=$1
bootdrive=$(lsblk  -l | grep "part /" | head -1 | awk '{print $1}' | rev | cut -c5- | rev)
while read -r line ;
do
       	case $pc_type in
		purge|prg|Purge) 
			nvme format /dev/${line}n1 --ses=1 --f
			;;	
		prep|prp|Prep) 
			/bench/fio/ioprep -b 131072 -d ${line}n1 -q 128 > /dev/null &
			;;
	esac
done < <( cat /bench/fio/nvme_list | grep -v $bootdrive | cut -c6- )

wait
#reset
