#!/bin/bash
bootdrive=$(lsblk  -l | grep "part /" | head -1 | awk '{print $1}' | rev | cut -c5- | rev)
echo $bootdrive
while read -r line ; do
	(echo -n "$line      :"; nvme smart-log $line | grep "Temperature Sensor 1")
    # your code goes here
done < <( nvme list | awk '{print $1}' | tail -n +3 | sort -h | rev | cut -c3- | rev | sort --version-sort | grep -v ${bootdrive} )
