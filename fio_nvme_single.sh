#!/bin/bash

ioengine="libaio"
direct=1
iodepth=128
ramp_time=0
run_time=100

#cpu_use="66,68,70,72"
#cpu_use="1,3,5,7,9,11,13,15,17,19,21,23,25,27,29,31,33,35,37,39,41,43,45,47,49,51,53,55,57,59,61,63,65,67,69,71,73,75,77,79,81,83,85,87,89,91"
fio_version=$(/bench/fio/fio -version)

#echo $cpu_use
common_cmd="--ioengine ${ioengine} --time_based --norandommap --random_generator=lfsr --cpus_allowed_policy split --ramp_time ${ramp_time} --allrandrepeat 0 --output-format json --exitall --group_reporting"
#common_cmd="--ioengine ${ioengine} --time_based --norandommap --random_generator=lfsr --cpus_allowed_policy split --ramp_time ${ramp_time} --allrandrepeat 0 --output-format json --exitall --group_reporting"
#common_cmd="--ioengine io_uring --time_based --norandommap --random_generator=lfsr _policy split  --ramp_time 5 --allrandrepeat 0 --output-format json --exitall --group_reporting"
#


cpupower frequency-set -r -g performance > /dev/null
# runParm  [64,32,all]
# formatParm [json,*]
# fio_type [randread,randwrite,read,write]

runParm=$1
fio_type=$2
numjob=$3
CoreTo_use=$4
ID=$5
logpath=/bench/fio/results/$(date +"%Y_%m_%d_%I_%M_%p")_${ID}/
mkdir -p ${logpath}
date=$(date)
BIOS_VER=$(dmidecode -t 0 | grep Version | awk '{print $2}')

    case $fio_type in
        randread)
		fio_type="randread"
		blocksize="4k"
		if [ -z "$CoreTo_use" ]
		then
	        	fio_type_cmd="--description=FIO_Random_Read_Test --rw ${fio_type} --bs ${blocksize} --numjob=${numjob}"

		else
	#		echo "use core ${CoreTo_use}"
        		fio_type_cmd="--description=FIO_Random_Read_Test --rw ${fio_type} --bs ${blocksize} --numjob=${numjob} --cpus_allowed=${CoreTo_use}"
		fi
        ;;
        randwrite)
		fio_type="randwrite"
		blocksize="4k"
		fio_type_cmd="--description=FIO_Random_Write_Test --rw ${fio_type} --bs ${blocksize} --numjob=${numjob}"
			;;
        seqwrite|write)
		blocksize="128k"
		fio_type="write"
		fio_type_cmd="--description=FIO_Seq_Write_Test --rw ${fio_type} --bs ${blocksize} --numjob=${numjob}"
			;;
		seqread|read)
		fio_type="read"
		blocksize="128k"
        	fio_type_cmd="--description=FIO_Seq_Read_Test --rw ${fio_type} --bs ${blocksize} --numjob=${numjob}"
        ;; 
        *)
		blocksize="128k"
        	fio_type_cmd="--description=FIO_Seq_Read_Test --rw ${fio_type} --bs ${blocksize} --numjob=${numjob}"
	        fio_type="read"
        ;;
	esac
	

#  this creates type type of structure 
        #   --name="disk_nvme0n1"  --filename /dev/nvme0n1 \
        #   --name="disk_nvme1n1"  --filename /dev/nvme1n1 \
        #   --name="disk_nvme2n1"  --filename /dev/nvme2n1 \
        #   --name="disk_nvme3n1"  --filename /dev/nvme3n1 \
        #   --name="disk_nvme4n1"  --filename /dev/nvme4n1 
function getDrives()
{
    disk=$1
#     numDrives=$1
#    bootdrive=$(lsblk  -l | grep "part /" | head -1 | awk '{print $1}' | rev | cut -c5- | rev)
# #    echo BOOT_Drive is $bootdrive
#     MyDisk=""
#         while read -r line ; do
                MyDisk=" --name='disk_${disk}' --filename /dev/${disk}n1 "    
        # done < <( nvme list | awk '{print $1}' | tail -n +3 | sort -h | rev | cut -c3- | rev | sort --version-sort | grep -v "${bootdrive} " | head -${numDrives})
#echo $MyDisk
}


function runFIO(){
drive=$1 # 
getDrives ${drive}
runtime=$2 
Cores_to_use=$4

#numjob=1     

if [ "$getDrives" == "1" ]; then
     echo "********************** Test ${fio_type} $drive to run $runtime num Drives $drive iodepth ${iodepth} numjobs ${numjob} *******************************"
fi 
#	echo "/bench/fio/fio  ${fio_type_cmd} --thread --size 100% --direct ${direct} --buffered 0 --iodepth ${iodepth} --invalidate 1 ${common_cmd} --runtime ${runtime} ${MyDisk} "
    	cpu_alloc=$(sleep 20 | ps -Fae | grep /bench/fio/fio | tail -2 | grep -v grep | awk '{print $7}' )
	/bench/fio/fio  ${fio_type_cmd} --thread --size 100% --direct ${direct} --buffered 0 --iodepth ${iodepth} --invalidate 1 ${common_cmd} --runtime ${runtime} ${MyDisk} > fio_test_${drive}.json
    
#    echo $MyDisk # this is for debug to see if there is a problem

    iops_mean=$(grep "iops_mean"  fio_test_${drive}.json| grep  -v " 0.0000" | awk '{print $3}' | sed 's/,//g')
    iops_max=$(grep "iops_max"  fio_test_${drive}.json| grep -v ": 0," | awk '{print $3}' | sed 's/,//g')
    iops_min=$(grep "iops_min"  fio_test_${drive}.json| grep -v ": 0," | awk '{print $3}' | sed 's/,//g')
    bw_mean=$(grep "bw_mean"  fio_test_${drive}.json| grep  -v " 0.0000" | awk '{print $3}' | sed 's/,//g')
    bw_max=$(grep "bw_max"  fio_test_${drive}.json| grep -v ": 0," | awk '{print $3}'  | sed 's/,//g')
    bw_min=$(grep "bw_min"  fio_test_${drive}.json| grep -v ": 0," | awk '{print $3}' | sed 's/,//g')
	slat_mean=$(grep -A 3 "slat_ns"  fio_test_${drive}.json | grep "mean" | grep -v "0.000" | awk '{print $3}' | sed 's/,//g') 
	clat_mean=$(grep -A 3 "clat_ns"  fio_test_${drive}.json | grep "mean" | grep -v "0.000" | awk '{print $3}' | sed 's/,//g')
	usr_cpu=$(grep "usr_cpu"  fio_test_${drive}.json | awk '{print $3}' | sed 's/,//g')
	sys_cpu=$(grep "sys_cpu"  fio_test_${drive}.json | awk '{print $3}' | sed 's/,//g')

}

json_output="["


 #echo -e "${fio_type}_${drives}  : iops_min : \t iops_max : \t iops_mean : \t  bw_min : \t bw_max :\t bw_mean : \t"
runFIO $runParm ${run_time} 
echo -e "${fio_type}_${runParm}  :  ${iops_min}  \t : ${iops_max}: \t$iops_mean  \t : $bw_min \t : $bw_max\t : $bw_mean \t ${cpu_alloc}"
