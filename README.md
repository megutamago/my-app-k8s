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
$ helm install mysql-operator mysql-operator/mysql-operator --namespace mysql-operator --create-namespace

$ helm install mycluster mysql-operator/mysql-innodbcluster \
    --set credentials.root.user='root' \
    --set credentials.root.password='sakila' \
    --set credentials.root.host='%' \
    --set serverInstances=3 \
    --set routerInstances=1 \
    --set tls.useSelfSigned=true \
    --namespace mynamespace \
    --create-namespace
```
