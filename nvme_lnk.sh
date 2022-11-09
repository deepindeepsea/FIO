#!/bin/bash

while read -r line ; do
drive=$(nvme list-subsys | grep $line)
name=$(nvme list-subsys | grep ${line} | awk '{print $2}')
SN=$(nvme list | grep "${name}n1" | awk '{print $2}')
echo "$drive    $SN"
        (lspci -s $line -vv | grep -i LnkSta: )
    # your code goes here
done < <(nvme list-subsys | grep live | awk '{print $4}')
