#!/bin/bash

Log_file=$1

function getInfo()
{
Log_file=$1

   numDrives=$(grep '"name" : ' $Log_file | awk '{print $3}' |  sed 's/,//g' | sed 's/\"//g' | grep -v disk_ | wc| awk '{print $1}')
   bsSetting=$(grep '"bs" : ' $Log_file | awk '{print $3}' |  sed 's/,//g' | sed 's/\"//g')
   rwSetting=$(grep '"rw" : ' $Log_file | awk '{print $3}' |  sed 's/,//g' | sed 's/\"//g')
   iodepthSetting=$(grep '"iodepth" : ' $Log_file | awk '{print $3}' |  sed 's/,//g' | sed 's/\"//g')
   numjobSetting=$(grep '"numjobs" : ' $Log_file | awk '{print $3}' |  sed 's/,//g' | sed 's/\"//g')



    iops_mean=$(grep "iops_mean" $Log_file | grep  -v " 0.0000" | awk '{print $3}' | sed 's/,//g')
    iops_max=$(grep "iops_max"  $Log_file| grep -v ": 0," | awk '{print $3}' | sed 's/,//g')
    iops_min=$(grep "iops_min"  $Log_file| grep -v ": 0," | awk '{print $3}' | sed 's/,//g')
    bw_mean=$(grep "bw_mean"  $Log_file| grep  -v " 0.0000" | awk '{print $3}' | sed 's/,//g')
    bw_max=$(grep "bw_max"  $Log_file| grep -v ": 0," | awk '{print $3}'  | sed 's/,//g')
    bw_min=$(grep "bw_min"  $Log_file| grep -v ": 0," | awk '{print $3}' | sed 's/,//g')
    slat_mean=$(grep -A 3 "slat_ns"  $Log_file | grep "mean" | grep -v "0.000" | awk '{print $3}' | sed 's/,//g')
    clat_mean=$(grep -A 3 "clat_ns"  $Log_file | grep "mean" | grep -v "0.000" | awk '{print $3}' | sed 's/,//g')
    usr_cpu=$(grep "usr_cpu"  $Log_file | awk '{print $3}' | sed 's/,//g')
    sys_cpu=$(grep "sys_cpu"  $Log_file | awk '{print $3}' | sed 's/,//g')

    echo -e "${numDrives}_${bsSetting}_${rwSetting}_${iodepthSetting}_${numjobSetting}  :  ${iops_min}  \t : ${iops_max}: \t$iops_mean  \t : $bw_min \t : $bw_max\t : $bw_mean \t"
}
#    echo -e "${fio_type}_${drives}  : iops_min : ${iops_min}\t iops_max : ${iops_max} \t iops_mean : \t$iops_mean  \t bw_min : $bw_min \t bw_max : $bw_max\t bw_mean : $bw_mean \t"
#    echo -e " ${numDrives}_${bsSetting}_${rwSetting}_${iodepthSetting}_${numjobSetting} : iops_min : ${iops_min}\t iops_max : ${iops_max} \t iops_mean : \t$iops_mean  \t bw_min : $bw_min \t bw_max : $bw_max\t bw_mean : $bw_mean \t"

        while read -r line ; do
                getInfo $line
        done < <( ls -rtl ${Log_file}* | awk '{print $9}')
