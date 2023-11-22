# my-app-k8s

```
# metallbが動かないとき、以下で解消した
systemctl stop kubelet
systemctl stop docker
iptables --flush
iptables -tnat --flush
systemctl start kubelet
systemctl start docker

# promtail: “error sending batch, will retry” status=-1 context deadline exceeded”
# When I change it to
Chain INPUT (policy ACCEPT)
# it works.
# 再起動で治った
```

```
# argocd password
# id: admin
# pw: admin

# grafana password
# id: grafana
# pw: grafana

# minio password
# id: minio
# pw: minio123

# IP
# 192.168.11.140 argocd
# 192.168.11.141 grafana
# 192.168.11.142 prometheus
# 192.168.11.143 minio
# 192.168.11.144 loki
# 192.168.11.145 tempo
```

```
update-alternatives --config iptables
update-alternatives --set iptables /usr/sbin/iptables-legacy
```

https://ot-redis-operator.netlify.app/docs/installation/installation/
https://qiita.com/kokohei39/items/f75a3ae2a0c97ae646c5
```
$ kubectl create namespace ot-operators
$ helm repo add ot-helm https://ot-container-kit.github.io/helm-charts/
$ helm install redis-operator ot-helm/redis-operator --namespace ot-operators
$ helm install redis-sentinel ot-helm/redis-sentinel \
  --set redissentinel.clusterSize=3  --namespace ot-operators \
  --set redisSentinelConfig.redisReplicationName="redis-replication"

kubectl -n ot-operators exec -it redis-sentinel-sentinel-0 /bin/bash
redis-cli -p 26379 info
```

https://github.com/mysql/mysql-operator
```
$ helm repo add mysql-operator https://mysql.github.io/mysql-operator/
$ helm repo update
$ helm install mysql-operator mysql-operator/mysql-operator \
    --namespace mysql \
    --create-namespace

$ helm install mysql-cluster mysql-operator/mysql-innodbcluster \
    -f values.yml

helm install mycluster mysql-operator/mysql-innodbcluster \
    --set credentials.root.user='root' \
    --set credentials.root.password='sakila' \
    --set credentials.root.host='%' \
    --set serverInstances=3 \
    --set routerInstances=1 \
    --set tls.useSelfSigned=true
```

```
credentials:
  root:
    user: root
    password: root
    host: "%"
tls:
  useSelfSigned: true
serverVersion: 8.0.31
serverInstances: 3
routerInstances: 1
#serverConfig:
#  mycnf: |
#    [mysqld]
#    core_file
#    local_infile=off
datadirVolumeClaimTemplate:
  accessModes:
    - ReadWriteMany
```

```
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: mysql-nfs-pvc-1
  namespace: mysql
spec:
  accessModes:
  - ReadWriteMany
  resources:
     requests:
       storage: 40Gi



apiVersion: v1
kind: PersistentVolume
metadata:
  name: mysql-nfs-pv-1
spec:
  capacity:
    storage: 40Gi
  accessModes:
    - ReadWriteMany
  persistentVolumeReclaimPolicy: Recycle
  nfs:
    path: /mnt/nfsshare/k8s/share
    server: 192.168.11.11
    readOnly: false
```


```
# About 2 minutes
kubectl -n mysql get innodbcluster --watch
kubectl -n mysql get pvc -w
kubectl --namespace mysql exec -it mycluster-0 -- bash
```


```
# 便利
helm show values mysql-operator/mysql-innodbcluster
helm get manifest mycluster
```


```
helm install nfs-provisioner \
nfs-subdir-external-provisioner/nfs-subdir-external-provisioner \
--version 4.0.17 \
-n kube-system \
-f hoge.yml
```