#!/bin/bash

./ioprep -b 131072 -d nvme0n1 -q 128 > /dev/null &
./ioprep -b 131072 -d nvme1n1 -q 128 > /dev/null &
./ioprep -b 131072 -d nvme2n1 -q 128 > /dev/null &
./ioprep -b 131072 -d nvme3n1 -q 128 > /dev/null &
./ioprep -b 131072 -d nvme4n1 -q 128 > /dev/null &
./ioprep -b 131072 -d nvme5n1  -q 128 > /dev/null &
./ioprep -b 131072 -d nvme6n1  -q 128 > /dev/null &
./ioprep -b 131072 -d nvme7n1  -q 128 > /dev/null &
./ioprep -b 131072 -d nvme8n1  -q 128 > /dev/null &
./ioprep -b 131072 -d nvme9n1  -q 128 > /dev/null &
./ioprep -b 131072 -d nvme10n1 -q 128 > /dev/null &
./ioprep -b 131072 -d nvme11n1 -q 128 > /dev/null &
./ioprep -b 131072 -d nvme12n1 -q 128 > /dev/null &
./ioprep -b 131072 -d nvme13n1 -q 128 > /dev/null &
./ioprep -b 131072 -d nvme14n1 -q 128 > /dev/null &
./ioprep -b 131072 -d nvme15n1 -q 128 > /dev/null &
./ioprep -b 131072 -d nvme16n1 -q 128 > /dev/null &
./ioprep -b 131072 -d nvme17n1 -q 128 > /dev/null &
./ioprep -b 131072 -d nvme18n1 -q 128 > /dev/null &
./ioprep -b 131072 -d nvme19n1 -q 128 > /dev/null &
#./ioprep -b 131072 -d nvme20n1 -q 128 > /dev/null &
./ioprep -b 131072 -d nvme21n1 -q 128 > /dev/null &
./ioprep -b 131072 -d nvme22n1 -q 128 > /dev/null &
./ioprep -b 131072 -d nvme23n1 -q 128 > /dev/null &
./ioprep -b 131072 -d nvme24n1 -q 128 > /dev/null &

#watch 'ps aux | grep ioprep'
wait
reset

