#!/bin/bash
set -eu

curl -L -O https://github.com/catatsuy/private-isu/releases/download/img/dump.sql.bz2
# apt install bzip2 -y
bunzip2 dump.sql.bz2
mysql -h 192.168.11.111 -u root -proot < dump.sql

# kubectl cp ./dump.sql private-isu/mycluster-0:/tmp/dump.sql
# kubectl exec -it -n private-isu mycluster-0 -- mysql -u root -proot < /tmp/dump.sql
# rm -f dump.sql
