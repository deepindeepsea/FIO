#!/bin/bash

name=$1
nvme=$2
numjob=$3
core=$4

mkdir $name
#cpupower frequency-set -r -g performance > /dev/null

#MultEvent cpu \
#       core -s 85 --ini /home/amd/maryam/Multevent/workloads/iniFiles/RS/PS_DG/ps_core_all.ini \
#umc --ini /home/amd/maryam/Multevent/workloads/iniFiles/RS/UMC/RS_umc_v1.ini \
#       l3 --ini /home/amd/maryam/Multevent/workloads/iniFiles/RS/PS_DG/DG_L3_v1_SPGedit_ErrorsCommentedOut.ini \
#       df --ini /home/amd/meIniFiles/iniFiles/DF/v10/df_rs_all.ini \
#       -A "./RR_slot.sh slot1" -O FIO_slot1 report -f 5 -R


#MultEvent cpu df --ini /root/iniFiles/RS/DF/DF_ini_v10/df_rs_all.ini -s 0 \
MultEvent cpu df --ini /root/RS/DF/df_stones_multevent_files_v4/df_rs_all.ini -s 0 \
        core --ini /root/RS/PS_DG/ps_core_all.ini -s 0-63 \
        l3 --ini /root/RS/PS_DG/DG_L3_v1_SPGedit_ErrorsCommentedOut.ini -s 0-7 \
        ioagr --ini /root/RS/NBIO/RS_NBIO_IOAGR_v2.ini \
	iohc --ini /root/RS/NBIO/RS_NBIO_IOHC_all.ini \
        umc --ini /root/RS/UMC/RS_umc_v1.ini -s 0-11 -A "   ./fio_nvme_scaled_auto_thread.sh ${nvme} randread $numjob $core" -O $name report -f 5 -R
#        umc --ini /root/RS/UMC/RS_umc_v1.ini -s 0-11 -A " ./fio_nvme_single.sh ${nvme} randread ${numjob} ${core}" -O $name report -f 5 -R
#        umc --ini /root/RS/UMC/RS_umc_v1.ini -s 0-11 -A " ./fio_nvme_scaled_gen5_numa_align.sh 8 seqread 1 gen5" -O $1 report -f 5 -R

#./fio_nvme_single.sh ${nvme} randread $numjob $core
#./mreport_single_drive.sh ${dir} ${nvme} randread $numjob $core


# sleep 10
mv csv $name

