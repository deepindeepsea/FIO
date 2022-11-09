# FIO
 ./fio_nvme_scaled_gen5_numa_align.sh 1 randread 4 gen5
  lstopo-no-graphics
 nvme list
 numactl -H
./fio_nvme_scaled_gen5_numa_align.sh 4 randread 4 gen5
 
 Privision drives script
 provison_drive.sh
 hexdump -C /dev/nvme0n1 | head
