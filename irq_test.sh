#!/bin/bash
dir=$1
nvme=$2
numjob=$3
core=$4

echo "testing ${nvme} on core $core"

#cat /proc/interrupts  > RR_Gen5_1C1T.begin
cat /proc/interrupts | grep "CPU0\|${nvme}q"  > RR_Gen5_1C1T_${nvme}.begin

grep "${nvme}q" RR_Gen5_1C1T_${nvme}.begin | awk '{for(i=2;i<=64;i++) {if ($i > 10000) {print "#Interrupts "$i " : Core#" i-2 "  NVMEq: "$68  }}}'
#grep "${nvme}q" RR_Gen5_1C1T.begin | awk '{for(i=2;i<=257;i++) {if ($i > 10000) {print "#Interrupts "$i " : Core#" i-2 "  NVMEq: "$256  }}}'
#grep "${nvme}q" RR_Gen5_1C1T.begin | awk '{for(i=2;i<=128;i++) {if ($i > 10000) {print "#Interrupts "$i " : Core#" i-2 "  NVMEq: "$260  }}}'
#grep "${nvme}q" RR_Gen5_1C1T.begin | awk '{for(i=2;i<=256;i++) {if ($i > 10000) {print "NVMEq: "$260 "  Core#" i-2 " #Interrupts "$i }}}'


#./fio_nvme_single.sh ${nvme} randread $numjob $core
#./mreport_single_drive.sh ${dir} ${nvme} $numjob $core

#cat /proc/interrupts > RR_Gen5_1C1T.end
cat /proc/interrupts | grep "CPU0\|${nvme}q" > RR_Gen5_1C1T_${nvme}.end
#grep "${nvme}q" RR_Gen5_1C1T.end | awk '{for(i=2;i<=256;i++) {if ($i > 10000) {print "NVMEq: " $260 "  Core#" i-2 " #Interrupts "$i }}}'
grep "${nvme}q" RR_Gen5_1C1T_${nvme}.end | awk '{for(i=2;i<=64;i++) {if ($i > 10000) {print "#Interrupts "($i+3) " : Core#" i-2"  NVME: " $68 }}}'
