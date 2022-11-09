#!/bin/bash 

#This script will read all files from nvme_list file and provision drives according 
# this is due to mistakes in provisioning boot drives instead 

#currently this is not working yet. 





#   bootdrive=$(lsblk  -l | grep "part /" | head -1 | awk '{print $1}' | rev | cut -c5- | rev)
#    echo BOOT_Drive is $bootdrive will skip it
#    read
    MyDisk=""
#        while read -r line ; do
#                MyDisk="${MyDisk}  --name='disk_${line}' --filename ${line}n1 "
#	 echo "./ioprep -b 131072 -d ${line}n1 -q 128 "# > /dev/null & 
#  	done < <(  cat nvme_list| cut -c6- )
        #done < <( nvme list | awk '{print $1}' | tail -n +3 | sort -h | rev | cut -c3- | rev | sort --version-sort | grep -v ${bootdrive} | head -${numDrives})


# LIQID 1
./ioprep -b 131072 -d nvme0n1 -q 128 > /dev/null &
./ioprep -b 131072 -d nvme1n1 -q 128 > /dev/null &
./ioprep -b 131072 -d nvme2n1 -q 128 > /dev/null &
./ioprep -b 131072 -d nvme3n1 -q 128 > /dev/null &
./ioprep -b 131072 -d nvme4n1 -q 128 > /dev/null &
./ioprep -b 131072 -d nvme5n1  -q 128 > /dev/null &
#./ioprep -b 131072 -d nvme6n1  -q 128 > /dev/null &
#./ioprep -b 131072 -d nvme7n1  -q 128 > /dev/null &
#./ioprep -b 131072 -d nvme8n1  -q 128 > /dev/null &
#./ioprep -b 131072 -d nvme9n1  -q 128 > /dev/null &
#./ioprep -b 131072 -d nvme10n1 -q 128 > /dev/null &
#./ioprep -b 131072 -d nvme11n1 -q 128 > /dev/null &
#./ioprep -b 131072 -d nvme12n1 -q 128 > /dev/null &
#./ioprep -b 131072 -d nvme13n1 -q 128 > /dev/null &
#./ioprep -b 131072 -d nvme14n1 -q 128 > /dev/null &
#./ioprep -b 131072 -d nvme15n1 -q 128 > /dev/null &
#./ioprep -b 131072 -d nvme16n1 -q 128 > /dev/null &
#./ioprep -b 131072 -d nvme17n1 -q 128 > /dev/null &
#./ioprep -b 131072 -d nvme18n1 -q 128 > /dev/null &
#./ioprep -b 131072 -d nvme19n1 -q 128 > /dev/null &
#./ioprep -b 131072 -d nvme20n1 -q 128 > /dev/null &
#./ioprep -b 131072 -d nvme21n1 -q 128 > /dev/null &
#./ioprep -b 131072 -d nvme22n1 -q 128 > /dev/null &
#./ioprep -b 131072 -d nvme23n1 -q 128 > /dev/null &
#./ioprep -b 131072 -d nvme24n1 -q 128 > /dev/null &


#watch 'ps aux | grep ioprep'
