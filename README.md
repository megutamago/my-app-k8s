# my-app-k8s

default       alertmanager-kube-prometheus-stack-alertmanager-0           2/2     Running   0          5m53s
default       kube-prometheus-stack-grafana-8558c9db96-rdhnt              3/3     Running   0          6m6s
default       kube-prometheus-stack-kube-state-metrics-5c777c7bf5-55gbf   1/1     Running   0          6m6s
default       kube-prometheus-stack-operator-6755464458-sdm5g             1/1     Running   0          6m6s
default       kube-prometheus-stack-prometheus-node-exporter-hggzc        1/1     Running   0          6m6s
default       kube-prometheus-stack-prometheus-node-exporter-lm6vq        1/1     Running   0          6m6s
default       kube-prometheus-stack-prometheus-node-exporter-zww57        1/1     Running   0          6m6s
default       prometheus-kube-prometheus-stack-prometheus-0  


default       kube-prometheus-stack-kube-state-metrics-5c777c7bf5-sck7b   1/1     Running   0          3m3s
default       kube-prometheus-stack-operator-6755464458-sh5sr             1/1     Running   0          3m3s
default       kube-prometheus-stack-prometheus-node-exporter-5hvxc        1/1     Running   0          3m3s
default       kube-prometheus-stack-prometheus-node-exporter-5l96h        1/1     Running   0          3m3s
default       kube-prometheus-stack-prometheus-node-exporter-t6n64   


## 残りは、redisとprometheus。prometheusのcrdsはok。二つ検証


kubectl delete -f https://raw.githubusercontent.com/prometheus-community/helm-charts/kube-prometheus-stack-55.0.0/charts/kube-prometheus-stack/charts/crds/crds/crd-alertmanagerconfigs.yaml && \
kubectl delete -f https://raw.githubusercontent.com/prometheus-community/helm-charts/kube-prometheus-stack-55.0.0/charts/kube-prometheus-stack/charts/crds/crds/crd-alertmanagers.yaml && \
kubectl delete -f https://raw.githubusercontent.com/prometheus-community/helm-charts/kube-prometheus-stack-55.0.0/charts/kube-prometheus-stack/charts/crds/crds/crd-podmonitors.yaml && \
kubectl delete -f https://raw.githubusercontent.com/prometheus-community/helm-charts/kube-prometheus-stack-55.0.0/charts/kube-prometheus-stack/charts/crds/crds/crd-probes.yaml

kubectl apply -f https://raw.githubusercontent.com/prometheus-community/helm-charts/kube-prometheus-stack-55.0.0/charts/kube-prometheus-stack/charts/crds/crds/crd-prometheusagents.yaml && \
kubectl apply -f https://raw.githubusercontent.com/prometheus-community/helm-charts/kube-prometheus-stack-55.0.0/charts/kube-prometheus-stack/charts/crds/crds/crd-prometheuses.yaml && \
kubectl apply -f https://raw.githubusercontent.com/prometheus-community/helm-charts/kube-prometheus-stack-55.0.0/charts/kube-prometheus-stack/charts/crds/crds/crd-prometheusrules.yaml && \
kubectl apply -f https://raw.githubusercontent.com/prometheus-community/helm-charts/kube-prometheus-stack-55.0.0/charts/kube-prometheus-stack/charts/crds/crds/crd-scrapeconfigs.yaml && \
kubectl apply -f https://raw.githubusercontent.com/prometheus-community/helm-charts/kube-prometheus-stack-55.0.0/charts/kube-prometheus-stack/charts/crds/crds/crd-servicemonitors.yaml && \
kubectl apply -f https://raw.githubusercontent.com/prometheus-community/helm-charts/kube-prometheus-stack-55.0.0/charts/kube-prometheus-stack/charts/crds/crds/crd-thanosrulers.yaml


### Promethues CRDsは反映に時間かかった。

### 約20m経過して一気にコンテナ立ち上げが始まる

## CPU, Memory 共にたりない
### 全体的にリソース足りなくなってるので、全体的にレプリカは3->2にする

### redis
```
$ helm repo add ot-helm https://ot-container-kit.github.io/helm-charts/
$ helm install redis-operator ot-helm/redis-operator --namespace ot-operators --create-namespace
```

### https://kubernetes.io/ja/docs/tasks/run-application/run-replicated-stateful-application/

#
printf "foo;bar 100\n foo;baz 200" | curl \
-X POST \
--data-binary @- \
'http://pyroscope-querier.pyroscope.svc.cluster.local.:4040/ingest?name=curl-test-app&from=1615709120&until=1615709130'
10.96.8.48

### pyroscopeのmicro版はリソース不足で立ち上がらなかったため、request値修正

### podが立ち上がらない時、"kd pod -n xxx xxx"

---
### gitignoreに入れてても、venvがリポジトリにあるとシンボリックリンクどうこうのエラーになる

# k9s
### portforward: :pf , 0.0.0.0
### venvがgitにあるとエラーになる

# kubectl port-forward svc/argocd-server -n argocd 8080:443

# L2 Announce
その名の通り、MACアドレスで挙動が変わる。
一度接続した後、L2AnnouncementPolicy.yaml削除でも繋がる。
別端末だと繋がらない。再び作成すると繋がる。

以下の設定がフィルターの役割であることもしっかり確認。
  serviceSelector:
    matchLabels:
      color: blue

今回のargocdが上手くデプロイされない件も最悪、LBは管理外にしたら使える
てか、その方がいんじゃね

```
# metallbが動かないとき、以下で解消した

systemctl stop docker

systemctl stop kubelet && \
iptables --flush && \
iptables -tnat --flush && \
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
  --set redissentinel.clusterSize=3 \
  --namespace ot-operators \
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

### yamlがymlだと動かない

### cilium.yamlの設定を修正していなかった

### metallb-system の名前空間は固定で変えれない
k apply -k ./
resource mapping not found for name: "config" namespace: "metallb-system" from "./": no matches for kind "IPAddressPool" in version "metallb.io/v1beta1"
ensure CRDs are installed first
resource mapping not found for name: "config" namespace: "metallb-system" from "./": no matches for kind "L2Advertisement" in version "metallb.io/v1beta1"
ensure CRDs are installed first

#
apt install -y golang-go
git clone https://github.com/metallb/metallb-operator.git
cd metallb-operator
go get sigs.k8s.io/controller-tools/cmd/controller-gen@v0.11.1
kubectl apply -f bin/metallb-operator.yaml
apt install make
make deploy
kubectl apply -f config/samples/metallb.yaml

#
helm install cilium cilium/cilium --namespace=kube-system -f values.yaml

helm install cilium cilium/cilium \
    --version 1.15.0-pre.2 \
    --namespace kube-system \
    -f values.yaml

    --set k8sServiceHost=192.168.11.30 \
    --set k8sServicePort=8443

helm upgrade cilium cilium/cilium \
   --version 1.15.0-pre.2 \
   --namespace kube-system \
   --reuse-values \
   --set l2announcements.enabled=true \
   --set kubeProxyReplacement=true \
   --set k8sServiceHost=192.168.11.30 \
   --set k8sServicePort=8443



      
apiVersion: "cilium.io/v2alpha1"
kind: CiliumLoadBalancerIPPool
metadata:
  name: "blue-pool"
spec:
  cidrs:
  - cidr: "192.168.11.128/26"

kubectl get ippools

apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
spec:
  selector:
    matchLabels:
      app: nginx
  replicas: 2
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.25.3
        ports:
        - containerPort: 80
---
apiVersion: v1
kind: Service
metadata:
  name: nginx-service
  labels:
    app: nginx
  annotations:
    "io.cilium/lb-ipam-ips": "192.168.11.151"
spec:
  type: LoadBalancer
  ports:
  - name: http-web
    port: 8081
    protocol: TCP
    targetPort: 80
  selector:
    app: nginx




helm install prometheus prometheus-community/kube-prometheus-stack --version 54.2.2 -n monitoring -f p.yaml


# わんちゃんホスト(base)の再起動で動く。
