#!/bin/bash

ioengine="libaio"
direct=1
iodepth=64
ramp_time=5
run_time=60

fio_version=$(/bench/fio/fio -version)

common_cmd="--ioengine ${ioengine} --time_based --norandommap --random_generator=lfsr --cpus_allowed_policy split --ramp_time ${ramp_time} --allrandrepeat 0 --output-format json --exitall --group_reporting"
#common_cmd="--ioengine io_uring --time_based --norandommap --random_generator=lfsr _policy split  --ramp_time 5 --allrandrepeat 0 --output-format json --exitall --group_reporting"
#


cpupower frequency-set -r -g performance > /dev/null
# runParm  [64,32,all]

# fio_type [randread,randwrite,read,write]

runParm=$1
fio_type=$2
numjobsToUse=$3
genType=$4
logfile=$5
logpath=/bench/fio/results/$(date +"%Y_%m_%d_%I_%M_%p")/
nvme_list_path="/bench/fio/nvme_list"
mkdir -p ${logpath}
date=$(date)
BIOS_VER=$(dmidecode -t 0 | grep Version | awk '{print $2}')

#gen Case only applyies for Randread/RandWrite
#	case $genType in
#		gen5)
#			numjob=4
#			;;	
#		gen4)
#			numjob=1
#			;;
#		*)
#			numjob=1
#		;;
#	esac
	numjob=${numjobsToUse}
    case $fio_type in
        randread)

		blocksize="4k"
        	fio_type_cmd="--description=FIO_Random_Read_Test --rw ${fio_type} --bs ${blocksize} --numjob=${numjob}"
        ;;
        randwrite)

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
	
#	case $genType in
#		gen5)
#		if ($(genType) == "gen5"
#			numjob=4
#			;;	
#		gen4)
#			numjob=1
#			;;
#		*)
#			numjob=1
#		;;
#	esac
	


#  this creates type type of structure 
        #   --name="disk_nvme0n1"  --filename /dev/nvme0n1 \
        #   --name="disk_nvme1n1"  --filename /dev/nvme1n1 \
        #   --name="disk_nvme2n1"  --filename /dev/nvme2n1 \
        #   --name="disk_nvme3n1"  --filename /dev/nvme3n1 \
        #   --name="disk_nvme4n1"  --filename /dev/nvme4n1 
function getDrives()
{
    numDrives=$1
   bootdrive=$(lsblk  -l | grep "part /" | head -1 | awk '{print $1}' | rev | cut -c5- | rev)
#    echo BOOT_Drive is $bootdrive
    MyDisk=""
        while read -r line ; do
                MyDisk="${MyDisk}  --name='disk_${line}' --filename ${line}n1 "    
		done < <(  grep "nvme" ${nvme_list_path} | head -${numDrives})
        #done < <( nvme list | awk '{print $1}' | tail -n +3 | sort -h | rev | cut -c3- | rev | sort --version-sort | grep -v ${bootdrive} | head -${numDrives})

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
    /bench/fio/fio  ${fio_type_cmd} --thread --size 100% --direct ${direct} --buffered 0 --iodepth ${iodepth} --invalidate 1 ${common_cmd} --runtime ${runtime} ${MyDisk} > ${logfile}_${drive}.out
    
#    echo $MyDisk # this is for debug to see if there is a problem
    iops_mean=$(grep "iops_mean"  ${logfile}_${drive}.out| grep  -v " 0.0000" | awk '{print $3}' | sed 's/,//g')
    iops_max=$(grep "iops_max"  ${logfile}_${drive}.out| grep -v ": 0," | awk '{print $3}' | sed 's/,//g')
    iops_min=$(grep "iops_min"  ${logfile}_${drive}.out| grep -v ": 0," | awk '{print $3}' | sed 's/,//g')
    bw_mean=$(grep "bw_mean"  ${logfile}_${drive}.out | grep  -v " 0.0000" | awk '{print $3}' | sed 's/,//g')
    bw_max=$(grep "bw_max"  ${logfile}_${drive}.out| grep -v ": 0," | awk '{print $3}'  | sed 's/,//g')
    bw_min=$(grep "bw_min"  ${logfile}_${drive}.out| grep -v ": 0," | awk '{print $3}' | sed 's/,//g')
        slat_mean=$(grep -A 3 "slat_ns"  ${logfile}_${drive}.out | grep "mean" | grep -v "0.000" | awk '{print $3}' | sed 's/,//g')
        clat_mean=$(grep -A 3 "clat_ns"  ${logfile}_${drive}.out| grep "mean" | grep -v "0.000" | awk '{print $3}' | sed 's/,//g')
        usr_cpu=$(grep "usr_cpu"  ${logfile}_${drive}.out| awk '{print $3}' | sed 's/,//g')
        sys_cpu=$(grep "sys_cpu"  ${logfile}_${drive}.out | awk '{print $3}' | sed 's/,//g')


    sleep 20
}

json_output="["


case $runParm in

        all) 
           if [ "$genType" = "gen5" ]; then 
                for drives in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 
                do
                    #getDrives $drives
                    #echo $MyDisk
                    runFIO $drives ${run_time} 
                    json_output="$json_output { 'bios' : \"$BIOS_VER\", fio_version:\"${fio_version}\", 'rw': \"$fio_type\", 'direct':${direct}, 'iodepth':${iodepth}, 'ioengine':\"${ioengine}\", ramp_time:${ramp_time}, runtime:${run_time},  'numjobs': ${numjob}, 'bs': \"${blocksize}\", 'numDisks': ${drives},  'date' : \"$date\", 'iops_min': $iops_min,  'iops_max': $iops_min,  'iops': $iops_mean, 'bw_min' : $bw_min, 'bw_max':$bw_max, 'bw' : $bw_mean, 'slat_ns_mean': ${slat_mean}, 'clat_ns_mean': ${clat_mean}, 'usr_cpu': ${usr_cpu}, 'sys_cpu':${sys_cpu} }"
                if [[ $drives != 10 ]]; then 
                    json_outpt="$json_output, "
                fi
                    echo -e "${fio_type}_${drives}  : iops_min : ${iops_min}\t iops_max : ${iops_max} \t iops_mean : \t$iops_mean  \t bw_min : $bw_min \t bw_max : $bw_max\t bw_mean : $bw_mean \t"
                done
            else 
                for drives in 1 2 4 8 16 24 32 40 48 56 64
                do
                    #getDrives $drives
                    #echo $MyDisk
                    runFIO $drives ${run_time} 
                    json_output="$json_output { 'bios' : \"$BIOS_VER\", fio_version:\"${fio_version}\", 'rw': \"$fio_type\", 'direct':${direct}, 'iodepth':${iodepth}, 'ioengine':\"${ioengine}\", ramp_time:${ramp_time}, runtime:${run_time},  'numjobs': ${numjob}, 'bs': \"${blocksize}\", 'numDisks': ${drives},  'date' : \"$date\", 'iops_min': $iops_min,  'iops_max': $iops_min,  'iops': $iops_mean, 'bw_min' : $bw_min, 'bw_max':$bw_max, 'bw' : $bw_mean, 'slat_ns_mean': ${slat_mean}, 'clat_ns_mean': ${clat_mean} 'usr_cpu': ${usr_cpu}, 'sys_cpu':${sys_cpu} }"
               
                if [[ $drives != 64 ]]; then 
                    json_outpt="$json_output, "
                fi
                    echo -e "${fio_type}_${drives}  : iops_min : ${iops_min}\t iops_max : ${iops_max} \t iops_mean : \t$iops_mean  \t bw_min : $bw_min \t bw_max : $bw_max\t bw_mean : $bw_mean \t"
                done
            fi

            json_output="$json_output ]"
            
            echo "**************************JSON DATA ****************"
            echo $json_output | tee ${logpath}/${fio_type}.log
        ;;
        $runParm)
                runFIO $runParm ${run_time} 
                if [ "$formatParm" == "json" ]; then
                        echo "fio: { 'bios' : \"$BIOS_VER\", fio_version:\"${fio_version}\", 'rw': \"$fio_type\", 'direct':${direct}, 'iodepth':${iodepth}, 'ioengine':\"${ioengine}\", ramp_time:${ramp_time}, runtime:${run_time},  'numjobs': ${numjob}, 'bs': \"${blocksize}\", 'numDisks': $runParm,  'date' : \"$date\", 'iops_min': $iops_min,  'iops_max': $iops_min,  'iops': $iops_mean, 'bw_min' : $bw_min, 'bw_max':$bw_max, 'bw' : $bw_mean, 'slat_ns_mean': ${slat_mean}, 'clat_ns_mean': ${clat_mean}, 'usr_cpu': ${usr_cpu}, 'sys_cpu':${sys_cpu} }" | tee ${logpath}/${fio_type}.json
                else
                        echo -e "$fio_type_${drive}  : iops_min : ${iops_min}\t iops_max : ${iops_max} \t iops_mean : \t$iops_mean  \t bw_min : $bw_min \t bw_max : $bw_max\t bw_mean : $bw_mean \t"                
                fi
                
        ;; 
esac
