

ARX write --namespace IOHC -r IOHC_SION_S1_CLIENT_REQ_BURSTTARGET_LOWER --value 0x8080808
sleep 10
./fio_nvme_scaled_auto.sh 5 seqread 1 gen5
grep "read_ios" fio_test_5.json
./fio_nvme_scaled_auto.sh 6 seqread 1 gen5
grep "read_ios" fio_test_6.json
./fio_nvme_scaled_auto.sh 7 seqread 1 gen5
grep "read_ios" fio_test_7.json
./fio_nvme_scaled_auto.sh 8 seqread 1 gen5
grep "read_ios" fio_test_8.json

ARX write --namespace IOHC -r IOHC_SION_S1_CLIENT_REQ_BURSTTARGET_LOWER --value 0x4020808
sleep 10
./fio_nvme_scaled_auto.sh 5 seqread 1 gen5
grep "read_ios" fio_test_5.json
./fio_nvme_scaled_auto.sh 6 seqread 1 gen5
grep "read_ios" fio_test_6.json
./fio_nvme_scaled_auto.sh 7 seqread 1 gen5
grep "read_ios" fio_test_7.json
./fio_nvme_scaled_auto.sh 8 seqread 1 gen5
grep "read_ios" fio_test_8.json

ARX write --namespace IOHC -r IOHC_SION_S1_CLIENT_REQ_BURSTTARGET_LOWER --value 0x8010808
sleep 10
./fio_nvme_scaled_auto.sh 5 seqread 1 gen5
grep "read_ios" fio_test_5.json
./fio_nvme_scaled_auto.sh 6 seqread 1 gen5
grep "read_ios" fio_test_6.json
./fio_nvme_scaled_auto.sh 7 seqread 1 gen5
grep "read_ios" fio_test_7.json
./fio_nvme_scaled_auto.sh 8 seqread 1 gen5
grep "read_ios" fio_test_8.json

ARX write --namespace IOHC -r IOHC_SION_S1_CLIENT_REQ_BURSTTARGET_LOWER --value 0x4040808
sleep 10
./fio_nvme_scaled_auto.sh 5 seqread 1 gen5
grep "read_ios" fio_test_5.json
./fio_nvme_scaled_auto.sh 6 seqread 1 gen5
grep "read_ios" fio_test_6.json
./fio_nvme_scaled_auto.sh 7 seqread 1 gen5
grep "read_ios" fio_test_7.json
./fio_nvme_scaled_auto.sh 8 seqread 1 gen5
grep "read_ios" fio_test_8.json

ARX write --namespace IOHC -r IOHC_SION_S1_CLIENT_REQ_BURSTTARGET_LOWER --value 0x4010808
sleep 10
./fio_nvme_scaled_auto.sh 5 seqread 1 gen5
grep "read_ios" fio_test_5.json
./fio_nvme_scaled_auto.sh 6 seqread 1 gen5
grep "read_ios" fio_test_6.json
./fio_nvme_scaled_auto.sh 7 seqread 1 gen5
grep "read_ios" fio_test_7.json
./fio_nvme_scaled_auto.sh 8 seqread 1 gen5
grep "read_ios" fio_test_8.json

ARX write --namespace IOHC -r IOHC_SION_S1_CLIENT_REQ_BURSTTARGET_LOWER --value 0x4020808
sleep 10
./fio_nvme_scaled_auto.sh 5 seqread 1 gen5
grep "read_ios" fio_test_5.json
./fio_nvme_scaled_auto.sh 6 seqread 1 gen5
grep "read_ios" fio_test_6.json
./fio_nvme_scaled_auto.sh 7 seqread 1 gen5
grep "read_ios" fio_test_7.json
./fio_nvme_scaled_auto.sh 8 seqread 1 gen5
grep "read_ios" fio_test_8.json

ARX write --namespace IOHC -r IOHC_SION_S1_CLIENT_REQ_BURSTTARGET_LOWER --value 0x0
sleep 10
./fio_nvme_scaled_auto.sh 5 seqread 1 gen5
grep "read_ios" fio_test_5.json
./fio_nvme_scaled_auto.sh 6 seqread 1 gen5
grep "read_ios" fio_test_6.json
./fio_nvme_scaled_auto.sh 7 seqread 1 gen5
grep "read_ios" fio_test_7.json
./fio_nvme_scaled_auto.sh 8 seqread 1 gen5
grep "read_ios" fio_test_8.json
